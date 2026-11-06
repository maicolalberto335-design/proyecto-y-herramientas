import zipfile,xml.etree.ElementTree as ET,re,csv,collections,os
from pathlib import Path
root=Path(__file__).resolve().parents[1]
src=str(root/'datos'/'ECV_2024_original.xlsx');out=str(root/'datos'/'indicadores_ecv_2024_recalculados.csv')
ns='{http://schemas.openxmlformats.org/spreadsheetml/2006/main}'
z=zipfile.ZipFile(src); strings=[]
if 'xl/sharedStrings.xml' in z.namelist():
 with z.open('xl/sharedStrings.xml') as f:
  for _,e in ET.iterparse(f,events=('end',)):
   if e.tag==ns+'si':strings.append(''.join(e.itertext()));e.clear()
headers={};counts=collections.Counter();acc=collections.defaultdict(lambda:[0.,0.,0])
with z.open('xl/worksheets/sheet1.xml') as f:
 for _,row in ET.iterparse(f,events=('end',)):
  if row.tag!=ns+'row':continue
  data={}
  for c in row.findall(ns+'c'):
   v=c.find(ns+'v');t=c.get('t');
   if v is None and t!='inlineStr':continue
   val=''.join(c.itertext()) if t=='inlineStr' else (strings[int(v.text)] if t=='s' else v.text)
   data[re.match(r'[A-Z]+',c.get('r')).group()]=val
  if row.get('r')=='1':
   headers={v:k for k,v in data.items()};print('Selected header locations:',{k:headers.get(k) for k in ['A.7','B.6','E.1','E.2','E.6','FEP']})
  else:
   def val(k):return data.get(headers.get(k,''),'')
   commune=val('A.7')
   if commune in ('13','14'):
    counts[commune]+=1
    try:age=float(val('B.6'));weight=float(val('FEP'))
    except:continue
    if weight<=0:continue
    for name,elig,yes,valid in [
     ('Alfabetismo de personas de 15 años o más',age>=15,val('E.1')=='1',val('E.1') in ('1','2')),
     ('Asistencia educativa de personas de 5 a 24 años',5<=age<=24,val('E.2')=='1',val('E.2') in ('1','2')),
     ('Título tecnológico o universitario o posgrado, 25 años o más',age>=25,val('E.6') in ('6','7','8','9','10'),val('E.6') in tuple(str(i) for i in range(12)))]:
     if elig and valid:
      a=acc[(commune,name)];a[0]+=weight*yes;a[1]+=weight;a[2]+=1
  row.clear()
with open(out,'w',newline='',encoding='utf-8-sig') as f:
 w=csv.writer(f);w.writerow(['anio','comuna','indicador','porcentaje_ponderado','n_no_ponderado','factor_expansion','fuente','nota'])
 for (commune,name), (num,den,n) in sorted(acc.items()):
  w.writerow([2024,'San Javier (13)' if commune=='13' else 'El Poblado (14)',name,round(100*num/den,2),n,'FEP','Encuesta de Calidad de Vida 2024, Alcaldía de Medellín','Estimación exploratoria; no corresponde al puntaje dimensional oficial IMCV'])
print('counts',counts,'output',out)
for k,v in sorted(acc.items()):print(k,round(100*v[0]/v[1],2),v[2])
