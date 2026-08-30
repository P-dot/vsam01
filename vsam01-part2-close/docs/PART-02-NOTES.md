# Parte 2 — notas técnicas

Esta parte cierra exclusivamente la definición e inspección de ESDS, KSDS, RRDS y LDS. No incluye REPRO ni carga de datos.

## Conceptos consolidados

- Cluster lógico frente a componentes DATA/INDEX.
- ESDS: NONINDEXED.
- KSDS: INDEXED y clave.
- RRDS: NUMBERED y RRN.
- LDS: LINEAR y almacenamiento lineal.
- Control Interval (CI) y relación con el espacio asignado/utilizado.
- LISTCAT ALL como mecanismo de verificación posterior a DEFINE.

## Punto de reanudación

Comenzar con teoría de IDCAMS REPRO y diseño de registros de prueba. Después crear el dataset secuencial fuente y cargar/observar ESDS, KSDS y RRDS para estudiar RBA, KEY y RRN con datos reales.
