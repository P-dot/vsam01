# VSAM Ecosystem Integration

## Role

This repository provides the VSAM data-set organization, access and scoped lifecycle-recovery layer of the broader z/OS Engineering Laboratory.

Its purpose is to validate how VSAM clusters are defined, inspected, loaded, addressed and recovered using real z/OS tooling and evidence.

The repository currently validates:

- ESDS — Entry-Sequenced Data Set
- KSDS — Key-Sequenced Data Set
- RRDS — Relative Record Data Set
- LDS — Linear Data Set
- IDCAMS definition and catalog inspection
- sequential-data loading with REPRO
- RBA, KEY and RRN record selection
- controlled KSDS deletion, reconstruction, data restore and functional recovery validation

The repository owns VSAM structure, catalog interpretation, IDCAMS operations, record loading, organization-specific addressing behavior and the scoped recovery mechanics demonstrated by Part 5.

It does not own general JCL fundamentals, COBOL language mechanics, scheduler orchestration, RACF policy, Db2, CICS, or platform-wide storage administration and disaster recovery.

```text
MVS_TSO_ISPF
      |
      v
   JCL_LABS
      |
      v
    VSAM
      |
      +--> COBOL
      |
      +--> scheduler-controlled batch
      |
      v
 application data flows
```

The integration principle is:

```text
Define and validate VSAM behavior here.
Use JCL_LABS for generic batch mechanics.
Use COBOL and other application repositories to consume VSAM later.
Use the scheduler repository to orchestrate the workload later.
```

## Repository Structure

This repository does not use a `labs/` directory.

The root is the domain landing page. Validated execution phases remain separate publication units:

```text
README.md
docs/

vsam01-part1-close/
vsam01-part2-close/
vsam01-part3-close/
vsam01-part4-close/
vsam01-part5-close/
```

Part 1 was historically documented in the root README. During the Portfolio Navigation V2 documentation change, that original README was preserved as `vsam01-part1-close/README.md` so the execution history remains available while the root becomes the repository landing page.

## Upstream Dependencies

### MVS_TSO_ISPF

Provides the interactive environment used to edit JCL, inspect cataloged data sets, review output, and work with SDSF and ISPF data-set services.

Relationship:

```text
MVS_TSO_ISPF -> VSAM operations
```

Status: **Foundational dependency**

### JCL_LABS

Provides reusable JCL and JES2 fundamentals.

VSAM-specific JCL remains here because it directly expresses IDCAMS operations against VSAM clusters. Generic JOB/EXEC/DD mechanics belong in `JCL_LABS`.

Relationship:

```text
JCL_LABS -> IDCAMS jobs -> VSAM
```

Status: **Validated foundation**

### z/OS Engineering Laboratory

Provides the common ADCD/Hercules environment, JES2 context, catalog/storage platform, engineering methodology and cross-repository architecture.

Status: **Active architectural dependency**

## Current Validated VSAM Progression

### Part 1 — ESDS, KSDS and initial RRDS

Part 1 establishes the VSAM structural baseline.

Validated areas include:

- catalog baseline with `LISTCAT`;
- ESDS definition and inspection;
- KSDS definition and inspection;
- RRDS definition and initial verification;
- differentiation of cluster, DATA and INDEX components;
- interpretation of attributes such as `KEYLEN`, `RKP`, `HI-A-RBA` and `HI-U-RBA`;
- real IDCAMS syntax troubleshooting.

A real error was retained and corrected:

```text
IDC3211I KEYWORD 'INDEX' IS IMPROPER
```

After correction, the KSDS definition completed successfully.

Status: **Validated**

### Part 2 — Four VSAM organizations

Part 2 completes the structural comparison by:

- completing detailed RRDS inspection;
- validating `NUMBERED`;
- defining and inspecting an LDS;
- validating `LINEAR`;
- confirming that ESDS, RRDS and LDS can all have only a DATA component while remaining logically different organizations.

| Type | IDCAMS organization | Characteristic access / interpretation | Components |
|---|---|---|---|
| ESDS | NONINDEXED | RBA | DATA |
| KSDS | INDEXED | KEY | DATA + INDEX |
| RRDS | NUMBERED | RRN | DATA |
| LDS | LINEAR | linear byte/CI space | DATA |

Status: **Validated**

### Part 3 — Loading ESDS and KSDS

Part 3 moves from empty-cluster inspection to data-bearing tests.

```text
sequential FB input
      |
      v
IDCAMS REPRO
      |
      +--> ESDS
      |
      +--> KSDS
```

Validated results include:

- sequential FB input creation;
- five 80-byte test records;
- `REPRO` into ESDS;
- ESDS `REC-TOTAL=5`;
- `REPRO` into KSDS;
- KSDS `REC-TOTAL=5`;
- `KEYLEN=8`;
- `RKP=0`;
- separate DATA and INDEX inspection;
- successful IDCAMS completion.

Status: **Validated**

### Part 4 — RRN vs KEY vs RBA

Part 4 validates three different addressing models using the same logical record:

```text
00000003CHARLIE
```

```text
RRDS -> RRN -> FROMNUMBER(3)
KSDS -> KEY -> FROMKEY(00000003)
ESDS -> RBA -> FROMADDRESS(160)
```

The ESDS RBA was observed using IDCAMS `PRINT` before being used. It was not assumed.

Status: **Validated**

### Part 5 — Controlled KSDS lifecycle recovery

Part 5 closes a resilience capability gap rather than simply extending the numbering sequence.

Validated lifecycle:

```text
Baseline-A
    |
    v
Controlled DELETE
    |
    v
Validate absence
    |
    v
Recover structure
    |
    v
Validate empty structure
    |
    v
Recover data
    |
    v
Baseline-B
    |
    v
Functional KEY validation
    |
    v
RECOVERY VALIDATED
```

Validated results include:

- healthy pre-change KSDS baseline with DATA + INDEX and five expected records;
- explicitly scoped cluster deletion with IDCAMS CC 0000;
- independent absence validation;
- expected `CC=0004` / not-found result retained as successful negative validation;
- recreation of the historical KSDS definition;
- validation of the empty reconstructed structure;
- restore of five records from `IBMUSER.VSAM.INPUT`;
- Baseline-B acceptance comparison;
- independent KEY `00000003` functional validation;
- final Browse result `00000003CHARLIE`.

Architecture V2 / Engineering Control classification for this scoped capability:

| Dimension | Classification |
|---|---|
| Domain | Application and Data Engineering |
| Capability | VSAM dataset lifecycle management and validated recovery |
| Lifecycle | Baseline → Controlled Change → Validate → Recover → Validate |
| Maturity | M2 Operational → M3 Resilient, scoped capability |
| Integration level | I1 |
| Recovery | Defined before change and executed successfully |

Status: **Validated**

## Validated Capability Progression

```text
STRUCTURE
Parts 1-2
DEFINE / LISTCAT
      |
      v
DATA
Part 3
REPRO / validate
      |
      v
ACCESS
Part 4
RBA / KEY / RRN
      |
      v
RESILIENCE
Part 5
controlled loss / recover / validate
```

## Consumes

This repository consumes:

- TSO/E and ISPF;
- JES2 and SDSF;
- JCL execution;
- IDCAMS;
- system catalog services;
- VSAM allocation and catalog metadata;
- sequential test input data;
- the shared ADCD laboratory environment.

## Produces

This repository produces:

- VSAM clusters;
- DATA and INDEX components where applicable;
- IDCAMS definition JCL;
- inspection JCL;
- REPRO load JCL;
- addressing demonstrations;
- LISTCAT evidence;
- SDSF and ISPF evidence;
- controlled-change and recovery JCL;
- reusable VSAM structures for later application integration;
- recovery evidence and acceptance criteria for the scoped KSDS lifecycle.

## Validated Integration Paths

### JCL to IDCAMS to VSAM

```text
JCL
 |
 v
IDCAMS
 |
 v
VSAM cluster
```

Status: **Validated**

### Catalog inspection

```text
VSAM cluster
     |
     v
 LISTCAT ALL
     |
     v
cluster / DATA / INDEX metadata
```

Status: **Validated**

### Sequential input to VSAM

```text
PS / FB input
     |
     v
 IDCAMS REPRO
     |
     +--> ESDS
     +--> KSDS
     +--> RRDS
```

Status: **Validated across Parts 3 and 4**

### Characteristic access

```text
ESDS -> RBA -> FROMADDRESS
KSDS -> KEY -> FROMKEY
RRDS -> RRN -> FROMNUMBER
```

Status: **Validated in Part 4**

### Controlled KSDS recovery

```text
known-good KSDS
      |
      v
controlled deletion
      |
      v
recreate structure
      |
      v
restore data
      |
      v
baseline + KEY validation
```

Status: **Validated in Part 5**

## Planned Cross-Repository Paths

The following are architectural targets. They must not be described as completed integrations until validated in the appropriate repositories.

### COBOL and VSAM

```text
JCL
 |
 v
COBOL
 |
 v
VSAM
```

Target capabilities include:

- sequential VSAM access from COBOL;
- keyed KSDS access;
- record insertion and update;
- deletion;
- file-status handling;
- error handling;
- batch application workflows.

Status: **Planned integration**

### Scheduler-controlled VSAM batch

```text
zos-batch-scheduler
        |
        v
       JCL
        |
        v
      JES2
        |
        v
     IDCAMS
        |
        v
      VSAM
```

Target capabilities include scheduled preparation, dependency control, return-code classification, rerun/restart behavior and production-day orchestration.

Status: **Planned integration**

### Secure VSAM application flow

```text
RACF
 |
 v
JCL / COBOL
 |
 v
VSAM
 |
 v
SMF / audit
```

Target capabilities include least-privilege data-set access, application identity control and auditable batch access.

Status: **Planned cross-repository integration**

## Integration Status

| Capability | Status | Evidence |
|---|---|---|
| Catalog baseline | Validated | Part 1 |
| ESDS definition | Validated | Part 1 |
| KSDS definition | Validated | Part 1 |
| RRDS definition | Validated | Parts 1–2 |
| LDS definition | Validated | Part 2 |
| Four-organization structural comparison | Validated | Part 2 |
| Sequential input creation | Validated | Part 3 |
| REPRO to ESDS | Validated | Part 3 |
| REPRO to KSDS | Validated | Part 3 |
| REPRO to RRDS | Validated | Part 4 |
| ESDS RBA access | Validated | Part 4 |
| KSDS KEY access | Validated | Part 4 |
| RRDS RRN access | Validated | Part 4 |
| Controlled KSDS deletion | Validated | Part 5 |
| KSDS structure reconstruction | Validated | Part 5 |
| KSDS data restore | Validated | Part 5 |
| Post-recovery KEY validation | Validated | Part 5 |
| COBOL → VSAM | Planned | Application integration track |
| Scheduler → VSAM | Planned | Scheduler integration track |
| RACF-protected application access | Planned | Security integration track |
| End-to-end production cycle | Planned | Ecosystem roadmap |

## Scope Boundaries

This repository owns VSAM-specific behavior.

It does **not** replace:

- `JCL_LABS` for general JCL syntax and batch fundamentals;
- `COBOL` for COBOL language mechanics;
- `mainframe-racf-security-evidence` for RACF authorization design;
- `zos-batch-scheduler` for ordering, dependencies, resources, calendars and orchestration;
- `DB2-` for relational data management;
- `CICS` for online transaction management;
- the core z/OS Engineering Laboratory for system-wide storage, catalog, DFSMS, backup and disaster-recovery engineering.

```text
VSAM organization/access/recovery -> here
JCL fundamentals                  -> JCL_LABS
COBOL application logic           -> COBOL
RACF policy                       -> mainframe-racf-security-evidence
scheduler orchestration           -> zos-batch-scheduler
system-wide storage/recovery      -> core z/OS Engineering Laboratory
```

## Publication Structure Rule

The validated units must remain distinct:

```text
Part 1 -> structural baseline
Part 2 -> all four VSAM organizations
Part 3 -> real data in ESDS and KSDS
Part 4 -> RRDS load and RRN / KEY / RBA comparison
Part 5 -> controlled KSDS lifecycle recovery
```

They should not be collapsed in a way that loses execution chronology or evidence boundaries.

## Current Validated Boundary

The current sequence ends with **controlled recovery of the scoped KSDS capability in Part 5**.

Part 5 demonstrates deletion and recovery only for the explicitly controlled KSDS scenario. It does not establish that every VSAM deletion, update, failure mode, organization or disaster-recovery scenario has been validated.

Capabilities not established by the current evidence remain future work, including:

- broader update/delete behavior outside the scoped Part 5 recovery scenario;
- duplicate-key/error-path experiments;
- CI split experiments;
- CA split experiments;
- COBOL file access;
- RACF-controlled application access;
- scheduler-controlled VSAM application workflows.

## Development Direction

```text
validated KSDS recovery
      |
      v
additional update / delete semantics
      |
      v
duplicate-key and error paths
      |
      v
CI / CA behavior
      |
      v
COBOL file access
      |
      v
RACF-controlled application access
      |
      v
scheduler-controlled batch
      |
      v
integrated production workflows
```

The repository remains the canonical location for VSAM-specific mechanics. Application, security and orchestration logic remain in their owning repositories.

## Engineering and Publication Rules

Each new VSAM phase should record:

- objective and scope;
- preventive JCL review before SUBMIT;
- cluster definitions;
- catalog state before and after;
- condition codes;
- LISTCAT evidence;
- data used for tests;
- exact addressing method;
- troubleshooting and root cause;
- rollback/recovery where destructive changes are possible;
- evidence and screenshots;
- explicit separation between validated and planned behavior.

Cross-repository work should continue to follow:

```text
Build -> Execute -> Observe -> Diagnose -> Correct -> Validate -> Document
```

Before publication:

- verify expected condition codes in context rather than assuming every non-zero result is a failure;
- preserve real failure evidence when it contributes technical value;
- do not publish credentials, private IP addresses, MAC addresses, terminal/network identifiers or host-side network details;
- keep destructive operations and rollback limited to lab-owned resources;
- validate recovery artifacts before destructive change when the scenario depends on them;
- preserve phase boundaries;
- use short-lived branches and merge completed work into `main`.

## Master Architecture

The broader ecosystem architecture is maintained in the [z/OS ADCD Hercules Engineering Lab](https://github.com/P-dot/zos-adcd-hercules-engineering-lab).
