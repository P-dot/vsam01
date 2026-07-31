//DEFESDS JOB (ACCT),'DEFINE VSAM ESDS',CLASS=A,MSGCLASS=X
//*
//* CLUSTER : IBMUSER.VSAM.LAB01.ESDS
//* VOLUMEN : SBWAS1
//*
//STEP01  EXEC PGM=IDCAMS
//SYSPRINT DD SYSOUT=*
//SYSIN    DD *
  DEFINE CLUSTER                           -
        (NAME(IBMUSER.VSAM.LAB01.ESDS)     -
         NONINDEXED                        -
         RECORDSIZE(80 80)                 -
         TRACKS(1 1)                       -
         VOLUMES(SBWAS1)                   -
         CONTROLINTERVALSIZE(4096))         -
        DATA                               -
        (NAME(IBMUSER.VSAM.LAB01.ESDS.DATA))
/*
//
