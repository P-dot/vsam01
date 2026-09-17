# VSAM01 Part 5 — Controlled KSDS Lifecycle Recovery

This closure package documents a controlled recovery scenario for `IBMUSER.VSAM.LAB01.KSDS`. The work was selected to close a **capability gap** rather than simply continue lab numbering: earlier VSAM01 work already demonstrated definition, loading, catalog inspection and characteristic access; this scenario demonstrates recovery as an engineered lifecycle.

## Architecture V2 / Engineering Control classification

| Field | Classification |
|---|---|
| Domain | Application and Data Engineering |
| Capability | VSAM dataset lifecycle management and validated recovery |
| Capability Gap | Controlled loss + reconstruction + data restore + functional validation |
| Lifecycle Stage | Baseline -> Controlled Change -> Validate -> Recover -> Validate |
| Maturity | M2 Operational -> M3 Resilient (scoped capability) |
| Integration Level | I1 |
| Dependencies | VSAM01 prior parts, known-good KSDS, `IBMUSER.VSAM.INPUT`, historical KSDS definition |
| Recovery | Defined before change and executed successfully |
| Evidence | JCL, JES/IDCAMS output, LISTCAT, PRINT, final Browse |

## Scenario

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
A <-> B acceptance comparison
    |
    v
Functional KEY validation
    |
    v
RECOVERY VALIDATED
```

## Validated outcome

- Baseline-A: healthy INDEXED KSDS with DATA + INDEX and five expected records.
- Controlled DELETE: only the authorized KSDS cluster was removed; IDCAMS reported DATA, INDEX and CLUSTER deleted with CC 0000.
- Post-change validation: LISTCAT reported the KSDS not found. `CC=0004` is retained as the **expected validation outcome**, not misclassified as a recovery failure.
- Structure recovery: `RECKSDS` recreated the validated definition; subsequent LISTCAT showed the reconstructed cluster and `REC-TOTAL=0` before data load.
- Data recovery: `REPKSDS` processed five records from `IBMUSER.VSAM.INPUT` with CC 0000.
- Baseline-B: the acceptance criteria from Baseline-A were satisfied again, including five expected records.
- Functional validation: KEY `00000003` processed exactly one record and final Browse showed `00000003CHARLIE`.

## JCL artifacts

- `BASEKSA.jcl` — common Baseline-A/B measurement instrument.
- `DELKSDS.jcl` — explicitly scoped destructive change.
- `CHKDEL.jcl` — read-only post-delete absence validation.
- `RECKSDS.jcl` — recovery artifact for KSDS structure.
- `LSTKSDS.jcl` — read-only structure validation.
- `REPKSDS.jcl` — restore source records into the empty KSDS.
- `KEYVAL3.jcl` — post-recovery functional KEY validation using an independent output dataset.

## Evidence

`evidence/screenshots/` contains the raw screenshots embedded in the cumulative execution document. They preserve the execution trail, including the initial read-only qualification mistake, the controlled deletion, the expected `NOT FOUND` validation, recovery phases, Baseline-B and final KEY Browse.

## Engineering result

**Recovery validated for the scoped KSDS capability.** The result is stronger than a successful IDCAMS return code: state was measured before change, destructive scope was reviewed, intermediate states were independently validated, recovery was executed from pre-validated artifacts, and the restored object passed both structural/content checks and characteristic KEY access.

See `docs/technical-notes.md` for gates, dependencies, stop conditions and acceptance criteria.
