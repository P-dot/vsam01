# VSAM Data Engineering Labs on z/OS

> **VSAM structure, catalog analysis, data loading, characteristic access, lifecycle control, and validated recovery on IBM z/OS.**

This repository is the **VSAM data-engineering domain** of the [IBM z/OS Mainframe Engineering Portfolio](https://github.com/P-dot).

It validates VSAM behavior through real IDCAMS execution and system evidence, progressing from cluster definition and catalog inspection to data loading, organization-specific access and controlled KSDS recovery.

General JCL, COBOL application logic, RACF policy, scheduler orchestration and platform-wide storage engineering remain owned by their specialized repositories.

---

## Navigate

| Destination | Engineering focus |
|---|---|
| [Part 1 — VSAM Foundations](vsam01-part1-close/README.md) | ESDS, KSDS, initial RRDS, `DEFINE`, `LISTCAT` and IDCAMS troubleshooting |
| [Part 2 — Four VSAM Organizations](vsam01-part2-close/README.md) | ESDS, KSDS, RRDS and LDS structural comparison |
| [Part 3 — Loading ESDS and KSDS](vsam01-part3-close/README.md) | Sequential FB input, `REPRO`, data-bearing clusters and catalog validation |
| [Part 4 — RRN vs KEY vs RBA](vsam01-part4-close/README.md) | Characteristic record selection across RRDS, KSDS and ESDS |
| [Part 5 — Controlled KSDS Recovery](vsam01-part5-close/README.md) | Baseline, controlled deletion, reconstruction, data restore and functional validation |
| [Ecosystem Integration](docs/ECOSYSTEM-INTEGRATION.md) | Ownership, dependencies, validated paths, boundaries and roadmap |

> Part 1 was originally documented in the repository root. Its original README has been preserved as a dedicated publication unit so that the root can serve as the domain landing page without losing the historical lab record.

---

## Repository Role

| Attribute | Scope |
|---|---|
| Engineering domain | Application and Data Engineering / VSAM |
| Platform | IBM z/OS |
| Primary tooling | IDCAMS, JCL, LISTCAT, PRINT, REPRO |
| Interactive environment | TSO/E / ISPF |
| Execution environment | JES2 / SDSF |
| Organizations validated | ESDS, KSDS, RRDS, LDS |
| Characteristic access validated | RBA, KEY, RRN |
| Recovery capability | Controlled KSDS reconstruction and data restore |
| Engineering workflow | Build → Execute → Observe → Diagnose → Correct → Validate → Document |

This repository owns **VSAM-specific structure, catalog interpretation, IDCAMS operations, loading, addressing behavior and scoped lifecycle recovery**.

It does not replace `JCL_LABS` for generic JCL, `COBOL` for application-language mechanics, `mainframe-racf-security-evidence` for RACF policy, `zos-batch-scheduler` for workload orchestration, or the core z/OS engineering repository for platform-wide storage and recovery engineering.

---

## Capability Progression

The validated sequence now forms a complete engineering story rather than a collection of unrelated exercises:

```text
STRUCTURE
Parts 1–2
DEFINE / LISTCAT
ESDS / KSDS / RRDS / LDS
        |
        v
DATA
Part 3
PS FB input
REPRO -> ESDS / KSDS
        |
        v
ACCESS
Part 4
RRDS -> RRN
KSDS -> KEY
ESDS -> RBA
        |
        v
RESILIENCE
Part 5
baseline
controlled loss
reconstruct
restore
validate
```

---

## Validated Lab Progression

| Phase | Capability | Key evidence | State |
|---|---|---|---|
| [Part 1](vsam01-part1-close/README.md) | Structural baseline | ESDS/KSDS definition, initial RRDS, `LISTCAT`, DATA/INDEX distinction and real IDCAMS syntax diagnosis | Validated |
| [Part 2](vsam01-part2-close/README.md) | Four organization models | `NONINDEXED`, `INDEXED`, `NUMBERED`, `LINEAR`; ESDS/KSDS/RRDS/LDS comparison | Validated |
| [Part 3](vsam01-part3-close/README.md) | Data loading | Five 80-byte records, `REPRO` to ESDS/KSDS, `REC-TOTAL=5`, KSDS key metadata | Validated |
| [Part 4](vsam01-part4-close/README.md) | Characteristic access | Same logical record selected through RRN, KEY and observed RBA | Validated |
| [Part 5](vsam01-part5-close/README.md) | Controlled recovery | Baseline-A → DELETE → absence → recreate → reload → Baseline-B → KEY validation | Validated |

---

## Four VSAM Organizations

| Organization | IDCAMS model | Characteristic access / interpretation | Components demonstrated |
|---|---|---|---|
| ESDS | `NONINDEXED` | Entry sequence / RBA | DATA |
| KSDS | `INDEXED` | KEY | DATA + INDEX |
| RRDS | `NUMBERED` | RRN | DATA |
| LDS | `LINEAR` | Linear byte / CI space | DATA |

A DATA-only component model does not make ESDS, RRDS and LDS equivalent. Their logical organizations and access semantics remain different.

---

## Same Record, Different Access Model

Part 4 deliberately validates three addressing mechanisms against the same logical record:

```text
00000003CHARLIE
```

```text
RRDS
  |
  +--> RRN 3
       FROMNUMBER(3)

KSDS
  |
  +--> KEY 00000003
       FROMKEY(00000003)

ESDS
  |
  +--> observed RBA 160
       FROMADDRESS(160)
```

The ESDS address was first observed with IDCAMS `PRINT`; it was not assumed.

This separates the **logical record** from the **organization-specific method used to locate it**.

---

## Recovery as an Engineered Lifecycle

Part 5 advances the repository beyond successful creation and access.

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
Recreate KSDS structure
    |
    v
Validate empty structure
    |
    v
Restore five records
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

The acceptance result is stronger than a successful IDCAMS condition code. The state was measured before the destructive change, absence was independently confirmed, structure and data were recovered separately, and the restored KSDS passed structural, content and KEY-access validation.

The `CC=0004` produced by the deliberate post-delete `LISTCAT` check is retained as an **expected validation outcome**, not incorrectly treated as a failed recovery.

---

## Architecture V2 / Engineering Control

Part 5 explicitly introduces Architecture V2 engineering-control concepts for the scoped KSDS capability:

| Dimension | Validated interpretation |
|---|---|
| Lifecycle | Baseline → Controlled Change → Validate → Recover → Validate |
| Capability gap addressed | Controlled loss + reconstruction + data restore + functional validation |
| Maturity movement | M2 Operational → M3 Resilient, scoped to the demonstrated capability |
| Integration level | I1 |
| Recovery | Defined before change and successfully executed |
| Acceptance | Baseline comparison plus functional KEY validation |

This classification applies to the demonstrated KSDS recovery capability; it is not a claim that every VSAM recovery scenario or the entire repository has reached the same maturity.

---

## Evidence and Troubleshooting

The repository follows the portfolio evidence workflow:

```text
BUILD
  ↓
EXECUTE
  ↓
OBSERVE
  ↓
DIAGNOSE
  ↓
CORRECT
  ↓
VALIDATE
  ↓
DOCUMENT
```

Examples retained as engineering evidence include:

- the Part 1 IDCAMS error `IDC3211I KEYWORD 'INDEX' IS IMPROPER`, followed by correction and successful KSDS definition;
- catalog state before and after loading;
- independently observed ESDS RBA before address-based selection;
- expected `NOT FOUND` validation after controlled KSDS deletion;
- separate structure and data recovery stages;
- post-recovery KEY-based functional validation.

A return code is evidence about an operation. It is not, by itself, proof that the complete intended state has been restored.

---

## Validation Scope: Local vs Ecosystem

| Capability / relationship | VSAM repository | Portfolio status |
|---|---|---|
| JCL → IDCAMS → VSAM | **VALIDATED LOCALLY** | Parts 1–5 |
| ESDS / KSDS / RRDS / LDS definition and inspection | **VALIDATED LOCALLY** | Parts 1–2 |
| Sequential input → `REPRO` → VSAM | **VALIDATED LOCALLY** | Parts 3–4 |
| ESDS RBA / KSDS KEY / RRDS RRN selection | **VALIDATED LOCALLY** | Part 4 |
| Controlled KSDS recovery | **VALIDATED LOCALLY** | Part 5 |
| COBOL → VSAM application access | **PLANNED** | Not claimed as completed |
| Scheduler → VSAM workflow | **PLANNED** | Not claimed as completed |
| RACF-controlled application access to VSAM | **PLANNED** | Not claimed as completed |
| End-to-end production application cycle | **PLANNED** | Not claimed as completed |

A cross-repository architecture diagram expresses intended relationships; it does not automatically prove that the integration has been implemented.

---

## Repository Boundaries

```text
MVS_TSO_ISPF
      |
      v
   JCL_LABS
      |
      v
    VSAM
    / | \
   /  |  \
COBOL | Scheduler
      |
   Security
```

| Domain | Owner |
|---|---|
| VSAM organization, IDCAMS, access and scoped recovery | This repository |
| General JCL and JES2 fundamentals | [JCL_LABS](https://github.com/P-dot/JCL_LABS) |
| COBOL language and application logic | [COBOL](https://github.com/P-dot/COBOL) |
| RACF policy and authorization engineering | [mainframe-racf-security-evidence](https://github.com/P-dot/mainframe-racf-security-evidence) |
| Batch orchestration | [zos-batch-scheduler](https://github.com/P-dot/zos-batch-scheduler) |
| Core platform/storage engineering | [zos-adcd-hercules-engineering-lab](https://github.com/P-dot/zos-adcd-hercules-engineering-lab) |
| Db2 relational data management | [DB2-](https://github.com/P-dot/DB2-) |
| CICS transaction processing | [CICS](https://github.com/P-dot/CICS) |

---

## Publication Structure

```text
vsam01/
├── README.md
├── docs/
│   └── ECOSYSTEM-INTEGRATION.md
├── vsam01-part1-close/
│   └── README.md
├── vsam01-part2-close/
├── vsam01-part3-close/
├── vsam01-part4-close/
└── vsam01-part5-close/
```

The five phases remain separate because each captures a controlled expansion of capability and its own evidence boundary.

The root README is now the **domain landing page**. Detailed implementation and execution history remain in the phase-specific documentation.

---

## Next Engineering Direction

The current validated boundary is recovery of the scoped KSDS lifecycle demonstrated in Part 5.

Future VSAM-specific work can extend into capabilities not yet demonstrated by the current evidence, such as broader update/delete semantics, duplicate-key/error paths, CI/CA behavior and additional recovery cases.

Cross-domain progression remains separate:

```text
validated VSAM mechanics
        |
        +--> COBOL file access
        |
        +--> RACF-controlled application access
        |
        +--> scheduler-controlled batch
        |
        v
integrated production workflow
```

These integrations remain **planned until validated evidence exists in the appropriate owning repositories**.

---

## Security and Publication Standard

Before publication, JCL, command output, catalog listings, screenshots and configuration fragments should be reviewed for credentials, tokens, private IP addresses, MAC addresses, host adapter identifiers, unnecessary terminal/session identifiers and other host-specific information that does not need to be public.

Destructive operations must remain explicitly scoped to lab-owned resources, and recovery artifacts should be validated before controlled change whenever the scenario depends on them.

---

## Continue Through the Portfolio

[Portfolio Home](https://github.com/P-dot) ·
[Core z/OS Engineering](https://github.com/P-dot/zos-adcd-hercules-engineering-lab) ·
[JCL](https://github.com/P-dot/JCL_LABS) ·
[COBOL](https://github.com/P-dot/COBOL) ·
[CICS](https://github.com/P-dot/CICS) ·
[Db2](https://github.com/P-dot/DB2-) ·
[RACF Security](https://github.com/P-dot/mainframe-racf-security-evidence)

> Part of the **IBM z/OS Mainframe Engineering Portfolio** — an independent hands-on environment focused on systems, operations, development, security, automation, diagnostics, recovery and integration.
