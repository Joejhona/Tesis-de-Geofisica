load "$NCARG_ROOT/lib/ncarg/nclscripts/contrib/cd_inv_string.ncl"

begin

csv_filename = "/data/users/jticse/resultados/github/Tesis-de-Geofisica/salidas/percentiles.csv"
dq = str_get_dq()

fields = (/"Estacion","Mes","Data","Tot-ppd","Ex-83-98","Ex->0.1","p99","p95","p90","p75"/)
fields = dq + fields + dq
header = [/str_join(fields,",")/]
system("rm -rf " + csv_filename)
write_table(csv_filename, "w", header, "%s")

s17_18 = "/data/users/jticse/resultados/github/Tesis-de-Geofisica/estaciones-17-18/*.csv"
s17_18:= systemfunc("ls "+s17_18)

dir_est = "/data/users/jticse/data/estaciones/"
est_sen = systemfunc("ls "+dir_est)
len_est = dimsizes(est_sen)

time_t  = yyyymmdd_time(2017,2018,"integer")

do i=0, len_est-1
    ;----- leendo cada data -----;
    data           := readAsciiTable(dir_est+est_sen(i), 6, "float",0)
    data@_FillValue = -99.9
    est             = str_sub_str(est_sen(i),".txt","")
    est             = str_sub_str(est,"qc00","")
    print("==================")
    print("Estacion "+est)

    ;----- asignando time a la data -----;
    yyyy   := data(:,0)
    mm     := data(:,1)
    dd     := data(:,2)
    hh     := dd
    mn     := dd
    sc     := dd
    hh      = 0
    mn      = 0
    sc      = 0

    mm1    := mm
    yyyy1  := yyyy
    yyyy1   = 1983
    yyyy2  := yyyy
    yyyy2   = 1998


    units   = "days since 1900-01-01 00:00:00"
    time   := cd_inv_calendar(yyyy,mm,dd,hh,mn,sc,units,0)
    data!0  = "time"
    data&time = time
    data&time@units = time@units

    ;----- Extrayendo los datos de cada mes -----;
    do j=1,3
        mm1     = j
        print("Mes "+j)
        time1  := cd_inv_calendar(yyyy,mm1,dd,hh,mn,sc,units,0)
        time1  := get_unique_values(time1)
        idate1 := get1Dindex(time,time1)
        idate1 := get_unique_values(idate1)
        data1  := data(idate1,:)
        precip := data1(:,3)
        N1    = dimsizes(precip)
        print(N1+" --> Datos Brutos")
        N2 = num(.not.ismissing(precip))
        print(N2+" --> Dias total de lluvia registrada")

        ;----- excluyendo 1983 y 1998 -----;
        time2  := cd_inv_calendar(yyyy1,mm1,dd,hh,mn,sc,units,0)
        time3  := cd_inv_calendar(yyyy2,mm1,dd,hh,mn,sc,units,0)
        time2  := get_unique_values(time2)
        time3  := get_unique_values(time3)
        idate2 := get1Dindex(precip&time,time2)
        idate2 := get_unique_values(idate2)
        idate3 := get1Dindex(precip&time,time3)
        idate3 := get_unique_values(idate3)
        if (.not.all(ismissing(idate2))) then
            precip(idate2) = precip@_FillValue
        end if
        if (.not.all(ismissing(idate3))) then
            precip(idate3) = precip@_FillValue
        end if
        N3 = num(.not.ismissing(precip))
        print(N3+" --> Dias total de lluvia registrada excluyendo 1983 y 1998")

        ;----- ordenando en forma decreciente precip -----;
        vector := dim_pqsort_n(precip,-2,0)

        ;----- eliminando los valores mas altos de ppd y menores a 0.1 -----;
        precip := precip(1:)
        precip  = where(precip.ge.0.1,precip,precip@_FillValue)
        N4 = num(.not.ismissing(precip))
        print(N4+" --> Dias lluvia mayores a 0.1 y eliminando el valor mas alto")

        ;----- index del percentil 99,95,90,75 -----;
        id_p99  = N4-round(N4*0.99,3)
        p99     = precip(id_p99)
        id_p95  = N4-round(N4*0.95,3)
        p95     = precip(id_p95)
        id_p90  = N4-round(N4*0.90,3)
        p90     = precip(id_p90)
        id_p75  = N4-round(N4*0.75,3)
        p75     = precip(id_p75)

        ;----- Escribiendo en la tabla -----;
        alist  = [/est,j,N1,N2,N3,N4,p99,p95,p90,p75/]
        format = "%s,%1d,%4d,%4d,%4d,%4d,%4.2f,%4.2f,%4.2f,%4.2f"
        write_table(csv_filename, "a", alist, format)

        senamhi:= str_match(s17_18,est)
        if (.not.all(ismissing(senamhi))) then
            senamhi:= asciiread(senamhi,-1,"string")
            senamhi = str_sub_str(senamhi,"Ene","01")
            senamhi = str_sub_str(senamhi,"ene","01")
            senamhi = str_sub_str(senamhi,"Feb","02")
            senamhi = str_sub_str(senamhi,"feb","02")
            senamhi = str_sub_str(senamhi,"Mar","03")
            senamhi = str_sub_str(senamhi,"mar","03")
            senamhi = str_sub_str(senamhi,"-2017","-17")
            senamhi = str_sub_str(senamhi,"-2018","-18")
            senamhi:= str_split_csv(senamhi,",",0)
            id_pp  := str_match_ind(senamhi(0,:),"mm")
            senamhi:= senamhi(1:,:)
            format1 = "%D-%N-%y"
            time_s := senamhi(:,0)
            time_s := cd_inv_string(time_s, format1)
            time_s := cd_calendar(time_s,-2)
            senamhi!0 = "time"
            senamhi&time = time_s
            ;if j.eq.1 then
            ;    s17 = senamhi({20170101:20170131},:)
            ;    s18 = senamhi({20180101:20180131},:)
            ;else if j.eq.2 then
            ;    s17 = senamhi({20170201:20170228},:)
            ;    s18 = senamhi({20180201:20180228},:)
            ;else if j.eq.2 then
            ;    s17 = senamhi({20170301:20170331},:)
            ;    s18 = senamhi({20180301:20180331},:)
            ;end if
            ;end if
            ;end if
            ;TIME = yyyymmdd_time(1901, 2001, "integer")
            do k=2017,2018
                if j.eq.2 then
                    dia = "28"
                else
                    dia = "31"
                end if
                time_i  = toint(tostring(k)+"0"+tostring(j)+"01")
                time_f  = toint(tostring(k)+"0"+tostring(j)+dia)
                id_sen := time_t({time_i:time_f})
                print(tostring(time_i)+"-"+tostring(time_f))
                id_sen := get1Dindex(senamhi&time,id_sen)
                if (.not.all(ismissing(id_sen))) then
                    id_sen := get_unique_values(id_sen)
                    sen_1  := senamhi(id_sen,id_pp)
                    sen    := tofloat(sen_1)
                    sen@_FillValue = -999.0
                    sen     = where(sen.ge.0,sen,sen@_FillValue)
                    sen    := dim_sum(sen)
                    sen!0  = "time"
                    sen&time = sen_1&time
                    x_sen := sen&time
                    x_sen := ispan(1,dimsizes(x_sen),1)
                    xrange = max(x_sen)-min(x_sen)
                    deltax = xrange/10.
                    y_sen := sen
                    ;y2_sen:= y_sen
                    ;y2_sen = 0

                    ;type = "x11"
                    type = "png"
                    ;wks = gsn_open_wks(sal,"/data/users/jticse/resultados/github/Tesis-de-Geofisica/salidas/Estacion "+est+"-"+k+"-"-j)
                    dir  = "/data/users/jticse/resultados/github/Tesis-de-Geofisica/salidas/Estacion"
                    wks  = gsn_open_wks(type,dir+"-"+tostring(est)+"-"+tostring(k)+"-"+tostring(j))

                    res             = True                 ; plot mods desired         
                    res@gsnFrame    = False
                    res@gsnDraw     = False
                    res@trXMinF     = min(x_sen)-deltax
                    res@trXMaxF     = max(x_sen)+deltax
                    res@trYMinF     = 0.0

                    xyres                     = res
                    xyres@xyLineThicknessF    = 0.1               ; default is 1.0
                    xyres@xyLineColor         = "white"

                    xyres@tmXBOn              = False
                    xyres@tmXTOn              = False
                    xyres@tmYLOn              = False
                    xyres@tmYROn              = True
                    xyres@tmYRLabelsOn        = True

                    xyres@tiYAxisString       = "Percentiles"
                    xyres@tiYAxisSide         = "Right"
                    xyres@tiYAxisAngleF       = 270              ; Rotate the Y-axis title 270 degrees

                    xyres@gsnYRefLine           = (/p99,p95,p90,p75/)               ; Draw horiz line at y=20
                    xyres@gsnYRefLineColors     = "NavyBlue"
                    xyres@gsnYRefLineThicknesses = 2.0

                    bres                       = res
                    bres@gsnXYBarChart         = True            ; Turn on bar chart
                    bres@gsnXYBarChartBarWidth = 0.75            ; Change bar widths
                    bres@gsnXYBarChartColors   = "yellow"        ; Color for bars
                    bres@tmYROn                = False
                    
                    ;bres@gsnYRefLine           = 20
                    ;bres@gsnYRefLineColor      = "NavyBlue"
                    ;bres@gsnYRefLineThicknessF = 2.0

                    bres@trYMinF               = 0.              ; Make sure Y axis starts at 0.

                    bres@tiMainString          = "Estacion "+tostring(est)+"-"+tostring(k)+"-"+tostring(j)
                    bres@tiYAxisString         = "mm"

                    bar_plot = gsn_csm_xy(wks,x_sen,y_sen,bres)

                    getvalues bar_plot
                        "vpXF"      : vpx
                        "vpYF"      : vpy
                        "vpWidthF"  : vpw
                        "vpHeightF" : vph
                    end getvalues

                    xyres@vpXF      = vpx
                    xyres@vpYF      = vpy
                    xyres@vpWidthF  = vpw
                    xyres@vpHeightF = vph
                    xyres@tmYRMode  = "Explicit"
                    xyres@tmYRValues = (/p99,p95,p90,p75/)
                    xyres@tmYRLabels = (/"p99","p95","p90","p75"/)


                    xy_plot  = gsn_csm_xy(wks,x_sen,y_sen,xyres)
                    
                    anno_id  = gsn_add_annotation(bar_plot, xy_plot, False)

                    pres             = True
                    pres@gsnMaximize = True
                    maximize_output(wks,pres)

                end if
            end do
        end if
    end do
end do

end
