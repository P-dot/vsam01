//DEFKSDS JOB (ACCT),'DEFINE VSAM KSDS',CLASS=A,MSGCLASS=X
//*
//* CLAVE   : 8 BYTES DESDE EL DESPLAZAMIENTO 0
//* VOLUMEN : SBWAS1
//*
//STEP01  EXEC PGM=IDCAMS
//SYSPRINT DD SYSOUT=*
//SYSIN    DD *
  DEFINE CLUSTER                            -
        (NAME(IBMUSER.VSAM.LAB01.KSDS)      -
         INDEXED                            -
         KEYS(8 0)                          -
         RECORDSIZE(80 80)                  -
         TRACKS(1 1)                        -
         VOLUMES(SBWAS1)                    -
         CONTROLINTERVALSIZE(4096))          -
        DATA                                -
        (NAME(IBMUSER.VSAM.LAB01.KSDS.DATA))-
        INDEX                               -
        (NAME(IBMUSER.VSAM.LAB01.KSDS.INDEX))
/*
//
