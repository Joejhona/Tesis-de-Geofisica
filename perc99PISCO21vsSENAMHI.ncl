
load "$NCARG_ROOT/lib/ncarg/nclscripts/contrib/cd_string.ncl"

begin

;----- Limites de Peru -----;
min_lat_p = -19. 
max_lat_p = 0.5
min_lon_p = -82.
max_lon_p = -68.
;----- Colores de la paleta -----;
levels  = (/0.1,0.2,0.3,0.4,0.5,0.6,0.7,\
            0.8,0.9,1.,1.5,2.,2.5,3.,3.5,\
            4.,4.5,5.,6.,7.,8.,\
            9.,10.,15.,20.,25.,30.,35.,40.,\
            45.,50.,55.,60.,65.,70.,75.,\
            80.,85.,90.,95.,100./)
color_paleta  = "WhBlGrYeRe"
nlevels_color = dimsizes(levels) ;--> Cantidad de colores 
colors        = span_color_rgba(color_paleta,nlevels_color+1)


;----- Pre procesamiento de data Chirp -----;
year    = 2017  ;--->año final
mes     = 01    ;--->mes inicial
dia_i   = 01    ;--->dia inicial
dia_f   = 31    ;--->dia final


;----- Percentiles y data PISCO -----;
f_perc_e  = addfile("/data/users/jticse/data/pisco21ppd_perc_e_ENE.nc","r")
;f_perc_e  = addfile("/data/users/jticse/data/pisco21ppd_perc_e_FEB.nc","r")
;f_perc_e  = addfile("/data/users/jticse/data/pisco21ppd_perc_e_MAR.nc","r")
dir_pi    = "/data/users/jticse/data/piscopd-17-18/"

;----- Estaciones SENAMHI -----;
f_est_se  = "/data/users/jticse/data/estaciones_senamhi/*.csv"
f_est_se := systemfunc("ls "+f_est_se)
;f_data_se = "/data/users/jticse/data/senamhi_vertpac_cn.csv"
f_data_se = "/data/users/jticse/data/senamhi-17-18.csv"
fc_sen   := asciiread(f_data_se,-1,"string")
fc_sen   := str_split_csv(fc_sen(1:),",",0)
dim_fc    = dimsizes(fc_sen(:,0))

;----- Shape Cuencas -----;
f_shape   = "/data/users/jticse/data/cuencas_shp/VertientePacificoCentroNorte.shp"            ;--> ruta
;---Detalles del shape---;
shpres                  = True
shpres@gsLineColor      = "gray50"   ;--> color de linea
shpres@gsLineThicknessF = 0.9       ;--> grosor de linea

;----- Excel de est-sen -----;
;f_csv     = "/data/users/jticse/data/est-sen-perc95.csv"
f_csv     = "est-sen-perc99-"+tostring(year)+"-"+tostring(mes)+".csv"
system("rm -rf " + f_csv)
fields    = (/"COD-EST","FECHA","PPD-SEN","PPD-PIS"/)
header    = [/str_join(fields,",")/]
write_table(f_csv,"w",header,"%s")

;----- Excel de errores -----;
;f_csv     = "/data/users/jticse/data/est-sen-perc95.csv"
f_err     = "error-est-sen-perc99-"+tostring(year)+"-"+tostring(mes)+".csv"
system("rm -rf " + f_err)
fields_err=[/"Por alguna razon a veces no encuentra el id"/]
write_table(f_err,"w",fields_err,"%s")


ppd_pi_e_per    = f_perc_e->ppd_pi_e_per
ppd_pi_e_per99  = ppd_pi_e_per(0,:,:)
;ppd_pi_e_per95  = ppd_pi_e_per(1,:,:)
;ppd_pi_e_per90  = ppd_pi_e_per(2,:,:)
;ppd_pi_e_per75  = ppd_pi_e_per(3,:,:)

coord_x     = tofloat(fc_sen(:,1)) ;--> lat
coord_y     = tofloat(fc_sen(:,2)) ;--> lon
id_lat      = ind_nearest_coord(coord_x,ppd_pi_e_per&latitude,0)
id_lon      = ind_nearest_coord(coord_y,ppd_pi_e_per&longitude,0)
ppd_pi_se   = ppd_pi_e_per99(id_lat,id_lon)
;ppd_pi_se   = ppd_pi_e_per95(id_lat,id_lon)
;ppd_pi_se   = ppd_pi_e_per90(id_lat,id_lon)
;ppd_pi_se   = ppd_pi_e_per75(id_lat,id_lon)


;----- agregando detalles al mapa -----;
res                     = True      ;--> activa los detalles
res@gsnDraw             = False     ;--> don't draw the plot yet
res@gsnFrame            = False     ;--> 
res@gsnMaximize         = True
;res@gsnLeftString       = "mm/dia"
res@gsnLeftString      = ""
res@mpLimitMode         = "Corners" ;--> Activa limites modo corners
res@mpLeftCornerLatF    = min_lat_p ;--> limites.ncl r=rimac p=Perú   
res@mpRightCornerLatF   = max_lat_p ;--> n=Norte
res@mpLeftCornerLonF    = min_lon_p
res@mpRightCornerLonF   = max_lon_p
;res@tiMainString        = "Prueba"

;res@lbOrientation       = "Vertical"

;---Limites Nacionales---;
res@mpOutlineBoundarySets       = "National"    ;---> Limite de Paises
res@mpNationalLineThicknessF    = 1.5           ;---> Grosor de linea nacional
res@mpGeophysicalLineThicknessF = 1.5           ;---> Grosor de linea continental
res@tmYLLabelsOn                = False         ; turn off lat labels
res@tmXBLabelsOn                = False         ; turn off lon labels
res@tmYROn                      = False
res@tmYLOn                      = False
res@tmXTOn                      = False
res@tmXBOn                      = False

;---- detalles del plot grande ----;
resP                    = True                ; modify the panel plot
resP@gsnMaximize        = True
;resP@gsnFrame           = False
resP@gsnPanelLabelBar   = True                ; add common colorbar
;resP@lbOrientation      = "vertical"
;resP@vpHeightF          = 0.6
resP@lbLabelFontHeightF = 0.01               ; make labels smaller
;resP@gsnPanelLeft       = 0.04
;resP@gsnPanelBottom     = 0.08
;resP@gsnPanelSave       = True
resP@lbTitleOn          = True                  ; turn on title
resP@lbTitlePosition    = "Bottom"
resP@lbTitleString      = "mm/dia"
resP@lbBoxEndCapStyle   = "TriangleHighEnd"
resP@lbTitleFontHeightF = 0.015
resP@pmLabelBarWidthF   = 0.9


pmres                   = True
pmres@gsMarkerSizeF     = 0.015       ;-- set size of marker
pmres@gsLineThicknessF  = 3.          ;-- marker line thickness
pmres@gsMarkerIndex     = 1
pmres@gsMarkerColor     = "blue"

do i=0,dia_f-1
    res@gsnAddCyclic        = False
    res@lbLabelBarOn        = False             ;---> turn off individual cb's
    res@cnFillOn            = True
    res@cnFillPalette       = color_paleta
    res@cnLinesOn           = False             ;---> Contorno de linea (falso = no)
    res@cnLineLabelsOn      = False
    res@cnLevelSelectionMode= "ExplicitLevels"  ;---> Solo usa los indicados en levels
    res@cnLevels            = levels

    fecha_i = cd_inv_calendar(year,mes,i+1,00,00,00,"days since 1800-01-01 00:00",0)
    fecha  := cd_string(fecha_i,"%Y-%N-%D")

    x1      = asciiread(dir_pi+fecha+".asc",-1,"float")
    nlon    = toint(x1(0))
    nlat    = toint(x1(1))
    ppd_pi_d                := onedtond(x1(6:),(/nlat,nlon/))
    ppd_pi_d                 = where(ppd_pi_d.ge.0,ppd_pi_d,ppd_pi_d@_FillValue)
    ppd_pi_d!0               = "latitude"
    ppd_pi_d&latitude        = ppd_pi_e_per&latitude
    ppd_pi_d&latitude@units  = ppd_pi_e_per&latitude@units
    ppd_pi_d!1               = "longitude"
    ppd_pi_d&longitude       = ppd_pi_e_per&longitude
    ppd_pi_d&longitude@units = ppd_pi_e_per&longitude@units
    ppd_pi_e_p99 = ppd_pi_d
    ;ppd_pi_e_p95 = ppd_pi_d
    ;ppd_pi_e_p90 = ppd_pi_d
    ;ppd_pi_e_p75 = ppd_pi_d
    ppd_pi_e_p99 = where(ppd_pi_e_p99.ge.ppd_pi_e_per99,ppd_pi_e_p99,ppd_pi_e_p99@_FillValue)
    ;ppd_pi_e_p95 = where(ppd_pi_e_p95.ge.ppd_pi_e_per95,ppd_pi_e_p95,ppd_pi_e_p95@_FillValue)
    ;ppd_pi_e_p90 = where(ppd_pi_e_p90.ge.ppd_pi_e_per90,ppd_pi_e_p90,ppd_pi_e_p90@_FillValue)
    ;ppd_pi_e_p75 = where(ppd_pi_e_p75.ge.ppd_pi_e_per75,ppd_pi_e_p75,ppd_pi_e_p75@_FillValue)

    ;----- creando mapa ------;
    type    = "png"
    ;type    = "x11"
    titulo1 = "perc99PISCOv21-vs-SENAMHI-"
    wks     = gsn_open_wks(type,titulo1+fecha)                
    plot    = new(3,graphic)

    ;---- plot - percentil95 ----;
    res1                    = res
    res1@gsnCenterString    = "PISCOv21-ST-1981-2016"
    plot(0) = gsn_csm_contour_map(wks,ppd_pi_e_per99,res1)
    ;---- plot - percentil95 ----;
    res2                    = res
    res2@gsnCenterString    = "PISCOv21-UN"
    plot(1) = gsn_csm_contour_map(wks,ppd_pi_e_p99,res2)
    ;---- plot - percentil90 ----;
    delete([/res@cnLevels,res@cnFillOn,res@gsnAddCyclic,res@cnLineLabelsOn,\
                res@cnLevelSelectionMode,res@lbLabelBarOn,res@cnLinesOn,\
                res@cnFillPalette/])
    res3                    = res
    res3@gsnCenterString    = "SENAMHI"
    plot(2) = gsn_csm_map(wks,res3)
    map     = plot(2)
    fecha_s = cd_string(fecha_i,"%D-%N-%Y")
    
    do j=0,dim_fc-1
        cod_est    := fc_sen(j,0)
        id_est     := str_match_ind(f_est_se,cod_est)
        print("Fecha "+fecha_s+" Estacion "+cod_est+" Id "+tostring(id_est))
        if (.not.all(ismissing(id_est))) then
            fe_sen     := asciiread(f_est_se(id_est),-1,"string")
            fe_sen     := str_sub_str(fe_sen,"Ene","01")
            fe_sen     := str_sub_str(fe_sen,"Feb","02")
            fe_sen     := str_sub_str(fe_sen,"Mar","03")
            fe_sen     := str_split_csv(fe_sen,",",0)
            id_dia     := str_match_ind(fe_sen(:,0),fecha_s)
            if (.not.all(ismissing(id_dia))) then
                id_pp  := str_match_ind(fe_sen(0,:),"mm")
                ppd_s  := tofloat(fe_sen(id_dia,id_pp))
                ppd_s@_FillValue = -999.0  
                ppd_s  := where(ppd_s.ge.0,ppd_s,ppd_s@_FillValue)
                ppd_s  := dim_sum(ppd_s)
                ppd_p  := ppd_pi_se(j,j)
                ppd_s  := where(ppd_s.ge.ppd_p,ppd_s,ppd_s@_FillValue)
                if (.not.all(ismissing(ppd_s))) then
                    print(tostring(ppd_s))
                    str        := unique_string("poly")
                    coord_x    := tofloat(fc_sen(j,1)) ;--> lat
                    coord_y    := tofloat(fc_sen(j,2)) ;--> lon
                    alist      := [/cod_est,fecha_s,ppd_s,ppd_p/]
                    format      = "%s,%s,%7.2f,%7.2f"
                    write_table(f_csv,"a",alist,format)
                    do k=0,nlevels_color-1
                        if (k.eq.nlevels_color-1) then
                            ;--> si: ppd >= max -> ppd = max
                            ppd_s := where(ppd_s.ge.max(levels),max(levels),ppd_s)   
                        else if (k.eq.0) then
                            ;--> si: ppd < min -> ppd = min
                            ppd_s := where(ppd_s.lt.levels(0),levels(0),ppd_s)       
                        else 
                            cond_3:= ppd_s.le.levels(k+1)   ;---> si ppd =< val_2
                            cond_4:= ppd_s.gt.levels(k)     ;---> si ppd > val_1
                            ;--> si: val_1 < ppd =< val_2 -> ppd = val_2
                            ppd_s := where(cond_3.and.cond_4,levels(k),ppd_s)
                            ;ppd_s := where(ppd_s.ge.levels(m-1).and.ppd_s.lt.levels(m),ppd_s,levels(m))
                        end if
                        end if
                    end do
                    color_id               := get1Dindex(levels,ppd_s)
                    pmres@gsMarkerColor    := colors(color_id,:) 
                    map@$str$   = gsn_add_polymarker(wks,map,coord_y,coord_x,pmres)
                end if           
            end if
        else
            error := "Fecha "+fecha_s+" Estacion "+cod_est+" Id "+tostring(id_est)
            error := [/error/]
            write_table(f_err,"a",error,"%s")
        end if
    end do

    ;---- detalles del plot grande ----;
    resPP                   = resP                ; modify the panel plot
    resPP@gsnPanelMainString= "Percentil 99 "+fecha

    agregando_shapefile2    = gsn_add_shapefile_polylines(wks,plot,f_shape,shpres)
    gsn_panel(wks,plot,(/1,3/),resPP)

end do
    orden1  = "convert -delay "
    tiempo  = "200"             ;---> 100 = 1 seg
    fecha  := str_get_cols(fecha,0,6)
    cmd     = orden1+tiempo+" "+titulo1+fecha+"*.png anim-"+titulo1+fecha+".gif"
    system(cmd)
end