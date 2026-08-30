# VSAM01 — Part 2: Definition of the Four VSAM Types

## Objective

Complete the structural phase of VSAM01 by defining, inspecting, and comparing the four VSAM types covered in the lesson: ESDS, KSDS, RRDS, and LDS.

This second part resumes the previous work and completes the definition and inspection of the RRDS, followed by the definition and inspection of the LDS.

## Status at the Beginning of This Part

ESDS and KSDS had already been completed, while the RRDS had been defined but still required detailed inspection using LISTCAT ALL.

## Work Performed

1. A dedicated JCL library was created to continue the laboratory: IBMUSER.VSAM.JCL.
2. LSTRRDS was executed to inspect the RRDS cluster and its DATA component.
3. LSTRRDS completed with CC 0000.
4. LISTCAT confirmed the NUMBERED organization, 80-byte records, DATA component, absence of an INDEX component, 4096-byte CI, volume SBWAS1, and an empty initial state.
5. IBMUSER.VSAM.LAB01.LDS was defined using IDCAMS with the LINEAR organization.
6. DEFLDS completed with CC 0000.
7. ISPF confirmed the creation of the LDS cluster and its DATA component.
8. LSTLDS was executed to inspect the LDS cluster and its DATA component.
9. LSTLDS completed with CC 0000 and confirmed the LINEAR organization.

## Completed Structural Comparison

| Type | IDCAMS Organization | Characteristic Identification / Access | Components |
|---|---|---|---|
| ESDS | NONINDEXED | Entry sequence / RBA | DATA |
| KSDS | INDEXED | Key | DATA + INDEX |
| RRDS | NUMBERED | RRN | DATA |
| LDS | LINEAR | Linear space / bytes and CI | DATA |

Having only a DATA component does not make ESDS, RRDS, and LDS equivalent. Their logical organization and the way their contents are interpreted and accessed are different.

## RRDS Observations

The LISTCAT performed during this session confirmed:

- NUMBERED.
- AVGLRECL=80 and MAXLRECL=80.
- REC-TOTAL=0 before loading data.
- HI-A-RBA=49152 and HI-U-RBA=0.
- Physical CI size of 4096 bytes.
- SPLITS-CI=0 and SPLITS-CA=0.
- DATA component with no INDEX component.
- Volume SBWAS1.

This establishes a useful baseline for comparing the state of the cluster before and after records are loaded.

## LDS Observations

The LDS was defined as LINEAR, without RECORDSIZE, KEYS, NUMBERED, or an INDEX component.

The subsequent LISTCAT confirmed the cluster and its DATA component. The LDS therefore completes the structural comparison of the four VSAM organizations covered in this phase.

## JCL Used in This Part

- jcl/LSTRRDS.jcl
- jcl/DEFLDS.jcl
- jcl/LSTLDS.jcl

## Evidence

The SDSF, IDCAMS, and ISPF screenshots collected during execution are stored under evidence/screenshots/.

They include evidence of the RRDS validation, LDS creation, LISTCAT execution, successful condition codes, and the combined ISPF view of the VSAM components.

## Result

Part 2 completed.

The definition and inspection phase for all four VSAM types is now complete, with successful executions and real system evidence.

## Next Part — Not Yet Executed

The next session will move to a new phase: from empty VSAM clusters to real data.

Sequential input dataset
        |
        v
   IDCAMS REPRO
        |
        v
    VSAM clusters
        |
        +--> ESDS: observe RBA
        +--> KSDS: KEY-based access
        +--> RRDS: RRN-based access

Before executing REPRO, the test records will be designed and their lengths verified.

For the KSDS in particular, the record structure must comply with the previously defined KEYS(8 0).

The JCL will be reviewed preventively before each SUBMIT.

## Primary Reference

The practical sequence follows the video material used during the session.

As a complementary technical reference, IBM Redbooks, VSAM Demystified, SG24-6105, is retained.
