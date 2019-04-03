begin

dir_est = "/data/users/jticse/data/estaciones/"
est_sen = systemfunc("ls "+dir_est)
len_est = dimsizes(est_sen)

csv_filename = "/data/users/jticse/resultados/github/Tesis-de-Geofisica/salidas/percentiles.csv"
dq = str_get_dq()

fields = (/"Estacion","Mes","Data","Tot-ppd","Ex-83-98","Ex->0.1","p99","p95","p90","p75"/)
fields = dq + fields + dq
header = [/str_join(fields,",")/]
system("rm -rf " + csv_filename)
write_table(csv_filename, "w", header, "%s")

;----- asignando time a la data -----;
data            = readAsciiTable(dir_est+est_sen(0), 6, "float",0)
data@_FillValue = -99.9
est             = str_sub_str(est_sen(0),".txt","")

;----- asignando time a la data -----;
yyyy    = data(:,0)
mm      = data(:,1)
dd      = data(:,2)
hh      = dd
mn      = dd
sc      = dd
hh      = 0
mn      = 0
sc      = 0

mm1     = mm
;mm1     = 1
yyyy1   = yyyy
yyyy1   = 1983
yyyy2   = yyyy
yyyy2   = 1998

;mm2     = mm
;mm2     = 2
;mm3     = mm
;mm3     = 3

units   = "days since 1900-01-01 00:00:00"
time    = cd_inv_calendar(yyyy,mm,dd,hh,mn,sc,units,0)
data!0  = "time"
data&time = time
data&time@units = time@units


;----- Extrayendo los datos de cada mes -----;
;aqui iria el do para los meses de enero, febrero y marzo, 1,2,3
do j=1,3
    mm1     = j
    time1  := cd_inv_calendar(yyyy,mm1,dd,hh,mn,sc,units,0)
    time1  := get_unique_values(time1)
    idate1 := get1Dindex(time,time1)
    idate1 := get_unique_values(idate1)
    data1  := data(idate1,:)
    precip := data1(:,3)
    N1    = dimsizes(precip)
    print("Datos Brutos "+N1)
    N2 = num(.not.ismissing(precip))
    print("Dias total de lluvia registrada "+N)

    ;----- excluyendo 1983 y 1998 -----;
    time2  := cd_inv_calendar(yyyy1,mm1,dd,hh,mn,sc,units,0)
    time3  := cd_inv_calendar(yyyy2,mm1,dd,hh,mn,sc,units,0)
    time2  := get_unique_values(time2)
    time3  := get_unique_values(time3)
    idate2 := get1Dindex(precip&time,time2)
    idate2 := get_unique_values(idate2)
    idate3 := get1Dindex(precip&time,time3)
    idate3 := get_unique_values(idate3)
    if (.not.all(ismissing(idate2)))
        precip(idate2) = precip@_FillValue
    end if
    if (.not.all(ismissing(idate3)))
        precip(idate3) = precip@_FillValue
    end if
    N3 = num(.not.ismissing(precip))
    print("Dias total de lluvia registrada excluyendo 1983 y 1998"+N2)

    ;----- ordenando en forma decreciente precip -----;
    vector := dim_pqsort_n(precip,-2,0)

    ;----- eliminando los valores mas altos de ppd y menores a 0.1 -----;
    precip := precip(1:)
    precip  = where(precip.ge.0.1,precip,precip@_FillValue)
    N4 = num(.not.ismissing(precip))
    print("Dias lluvia mayores a 0.1 y eliminando el valor mas alto "+N3)

    ;----- index del percentil 99,95,90,75 -----;
    id_p99  = N3-round(N3*0.99,3)
    p99     = precip(id_p99)
    id_p95  = N3-round(N3*0.95,3)
    p95     = precip(id_p95)
    id_p90  = N3-round(N3*0.90,3)
    p90     = precip(id_p90)
    id_p75  = N3-round(N3*0.75,3)
    p75     = precip(id_p75)

    alist  = [/est,j,N1,N2,N3,N4,p99,p95,p90,p75/]
    format = "%s,%1d,%4d,%4d,%4d,%4d,%4.2f,%4.2f,%4.2f,%4.2f"
    write_table(csv_filename, "a", alist, format)

end do

end