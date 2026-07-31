# Guía de lectura de LISTCAT

## Campos analizados

- `KEYLEN`: longitud de la clave.
- `RKP`: posición relativa de la clave.
- `AVGLRECL`: longitud media del registro.
- `MAXLRECL`: longitud máxima.
- `REC-TOTAL`: registros existentes.
- `HI-A-RBA`: límite del espacio asignado.
- `HI-U-RBA`: límite del espacio utilizado.
- `SPACE-PRI` / `SPACE-SEC`: asignación primaria y secundaria.
- `VOLSER`: volumen físico del componente.
- `SPLITS-CI` / `SPLITS-CA`: divisiones acumuladas.
- `FREESPACE-%CI` / `FREESPACE-%CA`: espacio libre reservado.

## Lectura del estado vacío

En los clusters recién creados:

- `REC-TOTAL=0`.
- `HI-U-RBA=0`.
- `HI-A-RBA` es mayor que cero.

Esto significa que existe espacio físico asignado, pero todavía no se han cargado registros.
