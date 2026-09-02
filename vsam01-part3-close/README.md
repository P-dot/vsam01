# VSAM01 - Part 3: Loading ESDS and KSDS with IDCAMS REPRO

## Status
**Completed and validated**

## Scope
This part converts the VSAM01 exercise from structural inspection of empty clusters into a data-bearing test. A sequential FB source dataset is created, populated with five 80-byte records, copied into ESDS and KSDS clusters with IDCAMS REPRO, and verified with LISTCAT ALL.

## Lab flow
1. Allocate `IBMUSER.VSAM.INPUT` as PS / FB / LRECL 80.
2. Enter five records whose first eight bytes are unique numeric identifiers.
3. REPRO the source into `IBMUSER.VSAM.LAB01.ESDS`.
4. Verify the ESDS with LISTCAT ALL.
5. REPRO the same source into `IBMUSER.VSAM.LAB01.KSDS`.
6. Verify cluster, DATA and INDEX components with LISTCAT ALL.

## Validated results
- `CRTINPUT`: source dataset created and cataloged; job completed with CC 0000.
- `REPESDS`: IDCAMS processed 5 records; maximum condition code 0.
- ESDS post-load inspection: `REC-TOTAL=5` observed.
- `REPKSDS`: IDCAMS processed 5 records; maximum condition code 0.
- KSDS post-load inspection: `REC-TOTAL=5`, `KEYLEN=8`, `RKP=0` observed.
- KSDS DATA and INDEX components were inspected separately.

## Key lesson
The same input bytes have different meaning depending on VSAM organization. In ESDS the leading identifier is ordinary data. In this KSDS, `KEYS(8 0)` makes bytes 1-8 the record key and the cluster has DATA + INDEX components.

## Repository contents
- `jcl/` - reviewed JCL used in Part 3.
- `docs/` - source records and technical explanation.
- `evidence/screenshots/` - screenshots extracted from the submitted lab evidence.
- `commands/` - Git Bash installation/publish commands.
- `COMPLETED.txt` - closure marker and validated outcomes.

## Next part
Part 4 starts with RRDS and RRN, then loads and validates the RRDS without mixing that work into this part.
