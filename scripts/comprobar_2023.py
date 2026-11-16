from pathlib import Path
import openpyxl
p=Path(__file__).resolve().parents[1]/"datos"
for f,s,cols in [("imcv_resultados_2023.xlsx","IMCV2023",[1]),("imcv_dimensiones_2023.xlsx","dim4Educación",[3]),("imcv_dimensiones_2023.xlsx","dim8Entornoymedioamb",[6,7])]:
 w=openpyxl.load_workbook(p/f,read_only=True,data_only=True)
 rows=list(w[s].values); idx=0 if s=="IMCV2023" else 1
 for name in ["SAN JAVIER","EL POBLADO"]:
  r=next(r for r in rows if r[idx]==name); print(s,name,[r[c] for c in cols])
