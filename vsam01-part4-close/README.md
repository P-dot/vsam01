# VSAM01 – Part 4: RRDS RRN vs KSDS KEY vs ESDS RBA

## Objective
Demonstrate three VSAM record-selection mechanisms on z/OS with IDCAMS, using the same logical record: `00000003CHARLIE`.

- RRDS: Relative Record Number (RRN)
- KSDS: KEY
- ESDS: Relative Byte Address (RBA)

## Results
### RRDS
`REPRRDS` loaded 5 records into `IBMUSER.VSAM.LAB01.RRDS` with CC=0000. `LSTRRDS` confirmed the loaded NUMBERED RRDS. `GETRRN3` used `FROMNUMBER(3)` and `TONUMBER(3)`: one record was processed and `IBMUSER.VSAM.RRN3` contained `00000003CHARLIE`.

### KSDS
`GETKEY3` used `FROMKEY(00000003)` and `TOKEY(00000003)`: one record was processed with CC=0000 and `IBMUSER.VSAM.KEY3` contained `00000003CHARLIE`.

### ESDS
`PRTESDS` used IDCAMS PRINT CHARACTER and showed the observed addresses:
- RBA 0: `00000001ALPHA`
- RBA 80: `00000002BRAVO`
- RBA 160: `00000003CHARLIE`
- RBA 240: `00000004DELTA`
- RBA 320: `00000005ECHO`

`GETRBA3` then used `FROMADDRESS(160)` and `TOADDRESS(160)`: one record was processed with CC=0000 and `IBMUSER.VSAM.RBA3` contained `00000003CHARLIE`.

## Final comparison
| Organization | Addressing concept | IDCAMS selector | Verified output |
|---|---|---|---|
| RRDS | RRN | `FROMNUMBER(3)` | `00000003CHARLIE` |
| KSDS | KEY | `FROMKEY(00000003)` | `00000003CHARLIE` |
| ESDS | RBA | `FROMADDRESS(160)` | `00000003CHARLIE` |

The same record was reached through three different VSAM addressing models. The ESDS RBA was observed with IDCAMS PRINT before being used; it was not assumed.

## Scope
Part 4 ends here. Updates, deletes, duplicate-key tests and CI/CA split experiments are intentionally outside this part.
