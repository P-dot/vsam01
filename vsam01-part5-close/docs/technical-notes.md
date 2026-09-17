# Technical notes — Controlled KSDS recovery

## Architecture classification

- **Domain:** Application and Data Engineering, with a dependency on Storage/DFSMS behavior.
- **Capability:** VSAM dataset lifecycle management and validated recovery.
- **Capability gap:** previous work proved creation, catalog inspection, loading and access; this scenario proves controlled loss, reconstruction, data restoration and functional validation.
- **Lifecycle:** Baseline -> Controlled Change -> Validate -> Recover -> Validate.
- **Maturity:** M2 Operational -> M3 Resilient for this scoped capability.
- **Integration level:** I1. The scenario consumes prior VSAM artifacts and data but does not claim cross-domain production integration.

## Dependencies

- Existing `IBMUSER.VSAM.LAB01.KSDS` known-good cluster.
- `IBMUSER.VSAM.INPUT` as recovery source data.
- Prior VSAM01 work proving KSDS definition and KEY access.
- Historical KSDS definition preserved in the repository and checked against Baseline-A before destructive execution.

## Recovery design

Recovery was designed before deletion:

1. Capture Baseline-A with LISTCAT ALL + PRINT CHARACTER.
2. Delete only `IBMUSER.VSAM.LAB01.KSDS` with an explicitly scoped IDCAMS DELETE CLUSTER.
3. Independently verify absence with LISTCAT.
4. Recreate structure with `RECKSDS`.
5. Verify empty reconstructed structure with `LSTKSDS` (`REC-TOTAL=0` expected).
6. Restore five source records with `REPKSDS`.
7. Re-run the same baseline instrument as Baseline-B.
8. Validate characteristic KSDS access by KEY with `KEYVAL3`.

## Stop conditions

- Do not execute a destructive command if the target contains a wildcard or differs from `IBMUSER.VSAM.LAB01.KSDS`.
- Preserve the first unexpected output before retrying or changing state.
- Do not continue automatically from DELETE to recovery; validate the post-change state first.
- Do not load data until the recreated structure is independently validated.

## Observed results

- Baseline-A: KSDS present, INDEXED, DATA + INDEX present, KEYLEN 8, RKP 0, record length 80, `REC-TOTAL=5`; five expected records printed.
- `DELKSDS`: CC 0000; DATA, INDEX and CLUSTER entries deleted.
- `CHKDEL`: CC 0004 with `ENTRY ... NOT FOUND`; this was the pre-defined expected validation outcome.
- `RECKSDS`: CC 0000; DATA and INDEX allocation successful.
- Post-structure `LSTKSDS`: CC 0000; reconstructed KSDS present with `REC-TOTAL=0`.
- `REPKSDS`: CC 0000; five records processed.
- Baseline-B: structural recovery criteria satisfied and `REC-TOTAL=5`; five expected records printed.
- `KEYVAL3`: CC 0000; one record processed for KEY `00000003`.
- Final Browse: `IBMUSER.VSAM.KEYVAL3` contains `00000003CHARLIE`.

## Baseline comparison rule

Recovery did not require byte-for-byte identity of every derived catalog statistic. The acceptance criteria were the pre-defined functional and structural properties: organization, components, key definition, record length, record count, content and successful KEY access.

## Diagnostic evidence retained

An earlier read-only LISTCAT attempt was run from the wrong TSO execution context and produced double qualification (`IBMUSER.IBMUSER...`). No state changed. The evidence is retained as a diagnostic example rather than hidden.

## Recovery conclusion

The scoped KSDS recovery capability is validated: the cluster was deliberately removed after a known-good baseline, its absence was verified, structure and data were restored in separate gated phases, Baseline-B satisfied the recovery criteria, and post-recovery KEY access returned the expected record.
