//DEFLDS  JOB (ACCT),'DEFINE VSAM LDS',CLASS=A,MSGCLASS=X
//*
//* CLUSTER : IBMUSER.VSAM.LAB01.LDS
//* VOLUME  : SBWAS1
//*
//STEP01  EXEC PGM=IDCAMS
//SYSPRINT DD SYSOUT=*
//SYSIN    DD *
  DEFINE CLUSTER                            -
        (NAME(IBMUSER.VSAM.LAB01.LDS)       -
         LINEAR                             -
         TRACKS(1 1)                        -
         VOLUMES(SBWAS1)                    -
         CONTROLINTERVALSIZE(4096))         -
        DATA                                -
        (NAME(IBMUSER.VSAM.LAB01.LDS.DATA))
/*
//
