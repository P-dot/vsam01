//DEFRRDS JOB (ACCT),'DEFINE VSAM RRDS',CLASS=A,MSGCLASS=X
//*
//* CLUSTER : IBMUSER.VSAM.LAB01.RRDS
//* VOLUMEN : SBWAS1
//*
//STEP01  EXEC PGM=IDCAMS
//SYSPRINT DD SYSOUT=*
//SYSIN    DD *
  DEFINE CLUSTER                            -
        (NAME(IBMUSER.VSAM.LAB01.RRDS)      -
         NUMBERED                           -
         RECORDSIZE(80 80)                  -
         TRACKS(1 1)                        -
         VOLUMES(SBWAS1)                    -
         CONTROLINTERVALSIZE(4096))          -
        DATA                                -
        (NAME(IBMUSER.VSAM.LAB01.RRDS.DATA))
/*
//
