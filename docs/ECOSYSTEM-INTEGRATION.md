# VSAM Ecosystem Integration

## Role

This repository provides the VSAM data-set organization and access layer of the broader z/OS Engineering Laboratory.

Its purpose is to validate how VSAM clusters are defined, inspected, loaded, addressed, and recovered using real z/OS tooling and evidence. The repository currently covers the four principal organizations used in the lab sequence:

- ESDS — Entry-Sequenced Data Set
- KSDS — Key-Sequenced Data Set
- RRDS — Relative Record Data Set
- LDS — Linear Data Set

The repository owns VSAM structure, catalog interpretation, IDCAMS operations, record loading and addressing behavior.

It does not own general JCL fundamentals, COBOL language mechanics, scheduler orchestration, RACF policy, Db2, CICS, or platform-wide storage administration.

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

Its validated work is organized as:

```text
README.md
docs/
evidence/
jcl/
ops/
references/
rollback/

vsam01-part2-close/
vsam01-part3-close/
vsam01-part4-close/
```

The root repository contains the first structural phase. Later validated phases are preserved as separate publication units.

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

VSAM-specific JCL is kept in this repository because it directly expresses IDCAMS operations against VSAM clusters, but generic JOB/EXEC/DD mechanics belong in `JCL_LABS`.

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

The root phase establishes the VSAM structural baseline.

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

Validated structural comparison:

| Type | IDCAMS organization | Characteristic addressing | Components |
| --- | --- | --- | --- |
| ESDS | NONINDEXED | RBA | DATA |
| KSDS | INDEXED | KEY | DATA + INDEX |
| RRDS | NUMBERED | RRN | DATA |
| LDS | LINEAR | linear byte/CI space | DATA |

Status: **Validated**

### Part 3 — Loading ESDS and KSDS

Part 3 moves from empty-cluster inspection to data-bearing tests.

Validated flow:

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

The test source contains five 80-byte records.

Validated results include:

- sequential FB input creation;
- `REPRO` into ESDS;
- `REC-TOTAL=5` observed;
- `REPRO` into KSDS;
- `REC-TOTAL=5` observed;
- `KEYLEN=8`;
- `RKP=0`;
- DATA and INDEX inspected separately;
- successful IDCAMS completion with condition code 0.

Status: **Validated**

### Part 4 — RRN vs KEY vs RBA

Part 4 validates three different addressing models using the same logical record:

```text
00000003CHARLIE
```

Validated access paths:

```text
RRDS -> RRN -> FROMNUMBER(3)
KSDS -> KEY -> FROMKEY(00000003)
ESDS -> RBA -> FROMADDRESS(160)
```

The ESDS RBA was observed using IDCAMS PRINT before being used. It was not assumed.

The same record was successfully selected through three different VSAM addressing mechanisms.

Status: **Validated**

## Validated Capability Progression

```text
catalog baseline
      |
      v
DEFINE ESDS
      |
      v
DEFINE KSDS
      |
      v
DEFINE RRDS
      |
      v
DEFINE LDS
      |
      v
LISTCAT structural inspection
      |
      v
REPRO data load
      |
      +--> ESDS
      |
      +--> KSDS
      |
      +--> RRDS
      |
      v
record selection
      |
      +--> RBA
      +--> KEY
      +--> RRN
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
- rollback JCL;
- reusable VSAM data structures for later COBOL and scheduler integration.

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
     |
     +--> KSDS
     |
     +--> RRDS
```

Status: **Validated across Parts 3 and 4**

### ESDS addressing

```text
ESDS
 |
 v
RBA
 |
 v
FROMADDRESS
```

Status: **Validated**

### KSDS addressing

```text
KSDS
 |
 v
KEY
 |
 v
FROMKEY
```

Status: **Validated**

### RRDS addressing

```text
RRDS
 |
 v
RRN
 |
 v
FROMNUMBER
```

Status: **Validated**

## Planned Cross-Repository Paths

The following are architectural targets. They must not be described as completed integrations until validated in the relevant repositories.

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

Target capabilities:

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
        |
        v
     RC / result
```

Target capabilities:

- scheduled cluster preparation;
- scheduled load/refresh;
- dependency-controlled execution;
- return-code classification;
- rerun/restart behavior;
- production-day orchestration.

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

Target capabilities:

- least-privilege data-set access;
- application identity control;
- auditable batch access;
- controlled update and recovery.

Status: **Planned cross-repository integration**

## Cross-Repository Production Tracks

### Secure Batch Application

```text
Scheduler / JCL
      |
      v
     RACF
      |
      v
     VSAM
      |
      v
    COBOL
      |
      v
     SMF
```

VSAM acts as the persistent application data layer.

### Enterprise Batch Operations

```text
Scheduler
   |
   v
JCL / JES2
   |
   v
IDCAMS / COBOL
   |
   v
VSAM
   |
   v
RC / recovery
```

### End-to-End Production Cycle

```text
Scheduler
   |
   v
JCL / JES2
   |
   v
VSAM preparation
   |
   v
COBOL workload
   |
   v
result validation
   |
   v
backup / housekeeping
   |
   v
scheduler history
```

## Integration Status

| Capability | Status | Evidence |
| --- | --- | --- |
| Catalog baseline | Validated | Root phase |
| ESDS definition | Validated | Root phase |
| KSDS definition | Validated | Root phase |
| RRDS definition | Validated | Root phase |
| LDS definition | Validated | Part 2 |
| ESDS LISTCAT analysis | Validated | Root phase |
| KSDS DATA/INDEX analysis | Validated | Root phase |
| RRDS LISTCAT analysis | Validated | Part 2 |
| LDS LISTCAT analysis | Validated | Part 2 |
| IDCAMS syntax troubleshooting | Validated | Root phase |
| Sequential input creation | Validated | Part 3 |
| REPRO to ESDS | Validated | Part 3 |
| REPRO to KSDS | Validated | Part 3 |
| REPRO to RRDS | Validated | Part 4 |
| ESDS RBA access | Validated | Part 4 |
| KSDS KEY access | Validated | Part 4 |
| RRDS RRN access | Validated | Part 4 |
| COBOL -> VSAM | Planned | Application integration track |
| Scheduler -> VSAM | Planned | Scheduler integration track |
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
- the core z/OS Engineering Laboratory for system-wide storage, catalog, DFSMS, backup and recovery engineering.

```text
VSAM organization/access       -> here
JCL fundamentals               -> JCL_LABS
COBOL application logic        -> COBOL
RACF policy                    -> mainframe-racf-security-evidence
scheduler orchestration        -> zos-batch-scheduler
system storage/recovery        -> core z/OS Engineering Laboratory
```

## Publication Structure Rule

The validated continuation units must remain distinct:

```text
root phase
vsam01-part2-close
vsam01-part3-close
vsam01-part4-close
```

Each phase represents a controlled expansion of scope:

```text
Part 1 -> structures
Part 2 -> all four VSAM organizations
Part 3 -> real data in ESDS and KSDS
Part 4 -> RRDS load and RRN / KEY / RBA comparison
```

They should not be collapsed in a way that loses execution chronology or evidence boundaries.

## Current Boundary

The current validated sequence ends after the Part 4 addressing comparison.

Part 4 explicitly leaves the following outside its scope:

- updates;
- deletes;
- duplicate-key tests;
- CI split experiments;
- CA split experiments.

These should be treated as future VSAM work, not as already completed capabilities.

## Development Direction

A sensible progression from the current state is:

```text
validated addressing
      |
      v
update / delete operations
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
production recovery workflows
```

The repository should remain the canonical location for VSAM-specific mechanics while application and orchestration logic remain in their owning repositories.

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
- rollback where destructive changes are possible;
- evidence and screenshots;
- explicit separation between validated and planned behavior.

Cross-repository work should continue to follow:

```text
Build -> Execute -> Observe -> Diagnose -> Correct -> Validate -> Document
```

Before publication:

- verify that successful IDCAMS paths show the expected condition code;
- preserve real failure evidence when it contributes technical value;
- do not publish credentials, IP addresses, MAC addresses, terminal/network identifiers or host-side network details;
- keep rollback limited to lab-owned resources;
- preserve the phase boundaries of Parts 1-4;
- use short-lived branches and merge completed work into `main`.

## Master Architecture

The broader ecosystem architecture is maintained in:

https://github.com/P-dot/zos-adcd-hercules-engineering-lab
