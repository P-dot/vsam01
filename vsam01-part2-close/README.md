# VSAM01 — Parte 2: definición de los cuatro tipos VSAM

## Objetivo

Cerrar la fase estructural de VSAM01 dejando definidos, observados y comparados los cuatro tipos tratados en la lección: ESDS, KSDS, RRDS y LDS. Esta segunda parte retoma el trabajo previo y completa la definición/inspección del RRDS y la definición/inspección del LDS.

## Estado al comenzar esta parte

Ya estaban completados ESDS y KSDS, y el RRDS había sido definido pero faltaba su inspección detallada mediante LISTCAT ALL.

## Trabajo realizado

1. Se creó una librería JCL dedicada para continuar el laboratorio: `IBMUSER.VSAM.JCL`.
2. Se ejecutó `LSTRRDS` para consultar el cluster RRDS y su componente DATA.
3. `LSTRRDS` finalizó con `CC 0000`.
4. LISTCAT confirmó la organización `NUMBERED`, registros de 80 bytes, componente DATA, ausencia de INDEX, CI de 4096 bytes, volumen `SBWAS1` y estado vacío.
5. Se definió `IBMUSER.VSAM.LAB01.LDS` mediante IDCAMS con organización `LINEAR`.
6. `DEFLDS` finalizó con `CC 0000`.
7. ISPF confirmó la aparición del cluster LDS y su componente DATA.
8. Se ejecutó `LSTLDS` para inspeccionar el cluster LDS y su componente DATA.
9. `LSTLDS` finalizó con `CC 0000` y confirmó la organización LINEAR.

## Comparación estructural cerrada

| Tipo | Organización IDCAMS | Identificación/acceso característico | Componentes |
|---|---|---|---|
| ESDS | NONINDEXED | orden de entrada / RBA | DATA |
| KSDS | INDEXED | clave | DATA + INDEX |
| RRDS | NUMBERED | RRN | DATA |
| LDS | LINEAR | espacio lineal / bytes y CI | DATA |

Tener únicamente componente DATA no hace equivalentes a ESDS, RRDS y LDS: la organización lógica y el modo de interpretar/acceder al contenido son diferentes.

## RRDS observado

El LISTCAT de esta sesión confirmó, entre otros atributos:

- `NUMBERED`.
- `AVGLRECL=80` y `MAXLRECL=80`.
- `REC-TOTAL=0` antes de cargar datos.
- `HI-A-RBA=49152` y `HI-U-RBA=0`.
- CI físico de 4096 bytes.
- `SPLITS-CI=0` y `SPLITS-CA=0`.
- componente DATA sin INDEX.
- volumen `SBWAS1`.

Esto deja un baseline útil para comparar el estado antes y después de cargar registros.

## LDS observado

El LDS se definió como `LINEAR`, sin `RECORDSIZE`, `KEYS`, `NUMBERED` ni componente INDEX. El LISTCAT posterior confirmó el cluster y su componente DATA. El LDS completa la comparación de las cuatro organizaciones tratadas en esta fase.

## JCL de esta parte

- `jcl/LSTRRDS.jcl`
- `jcl/DEFLDS.jcl`
- `jcl/LSTLDS.jcl`

## Evidencias

Las capturas de SDSF, IDCAMS e ISPF usadas durante la ejecución se conservan en `evidence/screenshots/`. Incluyen la validación del RRDS, creación del LDS, LISTCAT y la vista conjunta de los componentes VSAM.

## Resultado

**Parte 2 completada.** La fase de definición e inspección de los cuatro tipos VSAM queda cerrada con ejecuciones correctas y evidencia real.

## Próxima parte — no ejecutada todavía

La siguiente sesión cambia de fase: pasaremos de clusters vacíos a datos reales.

```text
Dataset secuencial de entrada
        |
        v
   IDCAMS REPRO
        |
        v
   clusters VSAM
        |
        +--> ESDS: observar RBA
        +--> KSDS: acceso por KEY
        +--> RRDS: acceso por RRN
```

Antes de ejecutar REPRO se diseñarán los registros de prueba, se comprobarán las longitudes y, para el KSDS, la clave definida como `KEYS(8 0)`. El JCL se revisará preventivamente antes de cada SUBMIT.

## Referencia principal

La secuencia práctica sigue el material de vídeo utilizado en la sesión. Como complemento técnico se mantiene IBM Redbooks, *VSAM Demystified*, SG24-6105.
