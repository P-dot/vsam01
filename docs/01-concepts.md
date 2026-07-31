# Conceptos fundamentales

## VSAM

VSAM es un método de acceso de z/OS para datos almacenados en DASD. Combina administración de catálogo y administración de registros.

## Cluster

El cluster es la entidad lógica normalmente referenciada desde JCL y utilidades. Puede agrupar uno o dos componentes:

- DATA.
- INDEX, cuando la organización lo requiere.

## ESDS

- Se define con `NONINDEXED`.
- Mantiene el orden de inserción.
- Tiene componente DATA.
- Puede utilizar RBA para acceso directo.

## KSDS

- Se define con `INDEXED`.
- Requiere `KEYS(longitud desplazamiento)`.
- Tiene DATA e INDEX.
- La clave primaria es única, fija y está embebida en el registro.

## RRDS

- Se define con `NUMBERED`.
- Utiliza slots de longitud fija.
- Cada registro se identifica mediante RRN.
- Tiene únicamente componente DATA.
