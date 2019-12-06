;============== %%%% SHAPES %%%% ==============
dirP    = "/data/users/jticse/Tesis-Maestria/PREDATA/shapes/" ;--> ruta principal
shp1    = "cuencas/VertientePacificoCentroNorte.shp" 
shp2    = "Peru/Peru.shp" 
shp1    = dirP+shp1     ;--> shape Vertiente Pacifico
shp2    = dirP+shp2     ;--> shape Vertiente Pacifico
;---Detalles del shape---;
shpres                  = True
;shpres@gsLineColor      = "red" ;--> color de linea
shpres@gsLineColor      = "black" ;--> color de linea
shpres@gsLineThicknessF = 2.     ;3.0   ;--> grosor de linea
shpres2                 = shpres
shpres2@gsLineThicknessF= 3.     ;3.0   ;--> grosor de linea
;============== %%%% LIMITES %%%% ==============
;---activar corners---;
;---Limites norte---;
min_lat_n = -13.
max_lat_n = -1.
min_lon_n = -84.
max_lon_n = -75.
;============== %%%% COLORES %%%% ==============
levels2 = ispan(10,40,1)
color_paleta2 = "MPL_YlOrRd"
begin
    dirBIAS = "/data/users/jticse/Tesis-Maestria/SALIDAS/netcdf/"
    f_sst_1 = "sst-wrfd01.nc"
    f_sst_2 = "sts-wrfd02.nc"
    
    f_sst_1:= addfile(dirBIAS+f_sst_1,"r")
    f_sst_2:= addfile(dirBIAS+f_sst_2,"r")

    sst_1   = f_sst_1->var01
    hrs_1   = f_sst_1->hrs
    lat_1   = f_sst_1->lat
    lon_1   = f_sst_1->lon
    time_1  = f_sst_1->time
    limite_1= cd_inv_calendar(2017,12,31,0,0,0,time_1@units,0)   ;---->> limite 2017-2018

    sst_2   = f_sst_2->var01
    hrs_2   = f_sst_2->hrs
    lat_2   = f_sst_2->lat
    lon_2   = f_sst_2->lon
    time_2  = f_sst_2->time
    limite_2= cd_inv_calendar(2017,12,31,0,0,0,time_2@units,0)   ;---->> limite 2017-2018
    ;----- creando mapa ------;
    type    = "png"
    ;type    = "x11"
    dirS    = "/data/users/jticse/Tesis-Maestria/SALIDAS/figuras/"
    type@wkWidth     = 1750
    type@wkHeight    = 2100             
    wks     = gsn_open_wks(type,dirS+"prom-"+sst@long_name+"-year")   
    plot    = new(6,graphic)
    ;----- agregando detalles al mapa -----;
    res                     = True      ;--> activa los detalles
    res@gsnDraw             = False     ;--> don't draw the plot yet
    res@gsnFrame            = False     ;--> 
    res@mpFillOn            = False
    ;res@gsnMaximize         = True
    ;res@gsnLeftString       = "mm/dia"
    res@gsnLeftString       = ""
    res@mpLimitMode         = "Corners" ;--> Activa limites modo corners
    res@mpLeftCornerLatF    = min_lat_n ;--> limites.ncl r=rimac p=Perú   
    res@mpRightCornerLatF   = max_lat_n ;--> n=Norte
    res@mpLeftCornerLonF    = min_lon_n
    res@mpRightCornerLonF   = max_lon_n
    ;res@gsnMajorLonSpacing  = 2. ;-- change major lon tickmark spacing
    ;res@gsnMinorLonSpacing  = 1.
    ;res@tmXBLabelStride     = 4 ;-- write only every 4th label
    res@tmYLLabelFontHeightF = 0.02 ;-- change major lat tickmark spacing
    res@tmXBLabelFontHeightF = 0.02
    res@tmYLLabelsOn        = False         ; turn off lat labels
    res@tmXBLabelsOn        = True         ; turn off lon labels
    ;res@tmYROn              = False
    ;res@tmYLOn              = False
    ;res@tmXTOn              = False
    ;res@tmXBOn              = False
    res@gsnAddCyclic        = False
    res@lbLabelBarOn        = False             ;---> turn off individual cb's
    res@cnFillOn            = True
    res@cnFillPalette       = color_paleta2
    res@cnLinesOn           = False             ;---> Contorno de linea (falso = no)
    res@cnLineLabelsOn      = False
    res@cnLevelSelectionMode= "ExplicitLevels"  ;---> Solo usa los indicados en levels
    res@cnLevels            = levels2

    ;do i=0,dimsizes(hrs)-1
    ;¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬
    ;----- agregando detalles especificos al mapa -----;
    res1    = res
    res1@gsnCenterString   := hrs(i)+" hrs"
    res1@gsnCenterStringFontHeightF = 0.04
    res1@tmYLLabelsOn        = True
    ;res1@tmXBLabelsOn   = False
    res2    = res
    res2@tmYLLabelsOn        = True
    ;res2@tmXBLabelsOn   = False
    res3    = res
    res3@tmYLLabelsOn        = True
    ;res3@tmXBLabelsOn     = True
    res4    = res
    res4@tiYAxisString       = "2017"
    res4@tiYAxisFontHeightF  = 0.04
    res4@tiYAxisSide         = "right"
    res4@tiYAxisAngleF       = 270
    
    res5    = res
    res5@tiYAxisString       = "2018"
    res5@tiYAxisFontHeightF  = 0.04
    res5@tiYAxisSide         = "right"
    res5@tiYAxisAngleF       = 270
    
    res6    = res
    res6@tiYAxisString       = "Total"
    res6@tiYAxisFontHeightF  = 0.04
    res6@tiYAxisSide         = "right"
    res6@tiYAxisAngleF       = 270
    
    ;----- plot 2017 -----;    
    sst1_2017 := sst_1({:limite_1},:,:,{hrs_1(i)})-273.15
    sst1_2017 := dim_avg_n(sst1_2017,0)
    sst1_2017!0 = lat_1@long_name
    sst1_2017&latitude  = lat_1
    sst1_2017&latitude@units = lat_1@units
    sst1_2017!1 = lon_1@long_name
    sst1_2017&longitude = lon_1
    sst1_2017&longitude@units = lon_1@units
    plot(0) = gsn_csm_contour_map(wks,sst1_2017,res1)

    sst1_2018  := sst_1({limite_1:},:,:,{hrs_1(i)})-273.15
    sst1_2018  := dim_avg_n(sst1_2018,0)
    sst1_2018!0 = lat_1@long_name
    sst1_2018&latitude  = lat_1
    sst1_2018&latitude@units = lat_1@units
    sst1_2018!1 = lon_1@long_name
    sst1_2018&longitude = lon_1
    sst1_2018&longitude@units = lon_1@units
    plot(2) = gsn_csm_contour_map(wks,sst1_2018,res2)

    sst1_tot    := sst_1(:,:,:,{hrs_1(i)})-273.15
    sst1_tot    := dim_avg_n(sst1_tot,0)
    sst1_tot!0   = lat_1@long_name
    sst1_tot&latitude  = lat_1
    sst1_tot&latitude@units = lat_1@units
    sst1_tot!1   = lon_1@long_name
    sst1_tot&longitude = lon_1
    sst1_tot&longitude@units = lon_1@units
    plot(4) = gsn_csm_contour_map(wks,sst1_tot,res3)

    ;----- plot 2017 -----;    
    sst2_2017 := sst_2({:limite_2},:,:,{hrs_2(i)})-273.15
    sst2_2017 := dim_avg_n(sst2_2017,0)
    sst2_2017!0 = lat_2@long_name
    sst2_2017&latitude  = lat_2
    sst2_2017&latitude@units = lat_2@units
    sst2_2017!1 = lon_2@long_name
    sst2_2017&longitude = lon_2
    sst2_2017&longitude@units = lon_2@units
    plot(1) = gsn_csm_contour_map(wks,sst2_2017,res4)

    sst2_2018  := sst_2({limite_2:},:,:,{hrs_2(i)})-273.15
    sst2_2018  := dim_avg_n(sst2_2018,0)
    sst2_2018!0 = lat_2@long_name
    sst2_2018&latitude  = lat_2
    sst2_2018&latitude@units = lat_2@units
    sst2_2018!1 = lon_2@long_name
    sst2_2018&longitude = lon_2
    sst2_2018&longitude@units = lon_2@units
    plot(3) = gsn_csm_contour_map(wks,sst2_2018,res5)

    sst2_tot    := sst_2(:,:,:,{hrs_2(i)})-273.15
    sst2_tot    := dim_avg_n(sst2_tot,0)
    sst2_tot!0   = lat_2@long_name
    sst2_tot&latitude  = lat_2
    sst2_tot&latitude@units = lat_2@units
    sst2_tot!1   = lon_2@long_name
    sst2_tot&longitude = lon_2
    sst2_tot&longitude@units = lon_2@units
    plot(5) = gsn_csm_contour_map(wks,sst2_tot,res6)

    ;end do
    resP                    = True                ; modify the panel plot
    resP@gsnMaximize        = True
    resP@gsnPanelLabelBar   = True                ; add common colorbar
    resP@lbOrientation      = "Vertical"

    resP@lbTitleOn          = True                  ; turn on title
    resP@lbTitleString      = "C"
    resP@lbBoxEndCapStyle   = "TriangleHighEnd"
    resP@lbTitleFontHeightF = 0.015
    ;resP@pmLabelBarHeightF  = 0.6

    resP@pmLabelBarHeightF  = 0.9
    resP@gsnPanelMainString = "Promedio "+sst@long_name
    resP@gsnPanelRowSpec    = True
    resP@lbLabelFontHeightF = 0.012
    resP@pmLabelBarOrthogonalPosF = 0.035
    agregando_shapefile1    = gsn_add_shapefile_polylines(wks,plot,shp1,shpres)
    agregando_shapefile2    = gsn_add_shapefile_polylines(wks,plot,shp2,shpres2)
    gsn_panel(wks,plot,(/2,2,2/),resP)
end
