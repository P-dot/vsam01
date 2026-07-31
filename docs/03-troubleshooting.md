# Troubleshooting

## IDC3211I KEYWORD 'INDEX' IS IMPROPER

### Síntoma

El primer intento de definir el KSDS finalizó con `CC 0012`.

### Causa

Se escribió:

```text
INDEX
  (INDEX(IBMUSER.VSAM.LAB01.KSDS.INDEX))
```

`INDEX` ya era la palabra que introducía el componente. Dentro del bloque debía utilizarse `NAME`.

### Corrección

```text
INDEX
  (NAME(IBMUSER.VSAM.LAB01.KSDS.INDEX))
```

### Resultado

El siguiente envío terminó con `CC 0000` y fueron creados:

- cluster;
- DATA;
- INDEX.

### Evidencia

`evidence/screenshots/22-defksds-idc3211i-index-improper.png`
