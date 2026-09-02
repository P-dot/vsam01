# Technical Notes - VSAM01 Part 3

## Objective
Move from empty VSAM clusters to real records using IDCAMS REPRO and verify the resulting catalog state with LISTCAT ALL.

## Source sequential dataset
`IBMUSER.VSAM.INPUT` is a PS dataset with `RECFM=FB` and `LRECL=80`. Five records were entered. The first eight bytes are unique, ascending numeric identifiers.

## ESDS load
`REPESDS` copied the five records from the PS source to `IBMUSER.VSAM.LAB01.ESDS`. IDCAMS reported `NUMBER OF RECORDS PROCESSED WAS 5` and maximum condition code 0. The subsequent LISTCAT confirmed `REC-TOTAL=5`.

In an ESDS, the leading eight digits remain ordinary record data; they are not defined as a key.

## KSDS load
`REPKSDS` copied the same five records to `IBMUSER.VSAM.LAB01.KSDS`. IDCAMS reported five records processed and condition code 0. The subsequent LISTCAT confirmed `REC-TOTAL=5`, `KEYLEN=8`, and `RKP=0`.

`KEYLEN=8` and `RKP=0` directly correspond to `KEYS(8 0)`: an eight-byte key beginning at zero-based displacement 0, i.e. human positions 1-8.

## Structural result
- ESDS: NONINDEXED, DATA component, entry-sequenced organization.
- KSDS: INDEXED, DATA + INDEX components, key-based organization.

## Safety / rerun note
Do not blindly rerun the ESDS load against an already populated target. A rerun can append another copy of the source records. A repeatable rerun procedure should first establish an explicit reset/recovery strategy; that is outside Part 3.

## Boundary
Part 3 ends after loading and validating ESDS and KSDS. RRDS/RRN loading is deliberately deferred to Part 4.
