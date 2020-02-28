;============== %%%% AYUDA %%%% ==============
;===>> t=24, 48, 72 hrs #####
;===>> file_wrf=archivo wrf con +/- de sst   #####
;===>> stat=bias, mae, nmae, rmse   #####

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
shpres@gsLineThicknessF = 4.     ;3.0   ;--> grosor de linea
shpres2                 = shpres
shpres2@gsLineThicknessF= 5.     ;3.0   ;--> grosor de linea

;============== %%%% LIMITES %%%% ==============
;---activar corners---;
;---Limites del Perú---;
min_lat_p = -19.5
max_lat_p = 0.5
min_lon_p = -82.
max_lon_p = -67.
;---Limites del Rímac---;
min_lat_r = -12.5
max_lat_r = -11.2
min_lon_r = -77.5
max_lon_r = -75.7
;---Limites norte---;
min_lat_n = -13.
max_lat_n = -1.
min_lon_n = -84.
max_lon_n = -75.

;============== %%%% HERRAMIENTAS %%%% ==============
load "$NCARG_ROOT/lib/ncarg/nclscripts/contrib/cd_inv_string.ncl"   ;---> para fechas 
load "$NCARG_ROOT/lib/ncarg/nclscripts/contrib/cd_string.ncl"       ;---> para fechas

;============== %%%% COLORES %%%% ==============
levels = (/0.1,0.2,0.3,0.4,0.5,0.6,0.7,\
    0.8,0.9,1.,1.5,2.,2.5,3.,3.5,\
    4.,4.5,5.,6.,7.,8.,\
    9.,10.,15.,20.,25.,30.,35.,40.,\
    45.,50.,55.,60.,65.,70.,75.,\
    80.,85.,90.,95.,100./)
color1  = read_colormap_file("GMT_drywet")
color2  = read_colormap_file("perc2_9lev")
color1(0,:)     = color2(9,:)
color1(1,:)     = color2(6,:)
color_paleta    = color1

levels2 := (/-50.,-40.,-30.,-25.,-20.,-18.,-16.,-14.,-12.,-10.,\
        -9.,-8.,-7.,-6,-5,-4.,-3.,-2.,-1.,-0.9,-0.8,-0.7,-0.6,\
        -0.5,-0.4,-0.3,-0.2,-0.1,0,0.1,0.2,0.3,0.4,0.5,0.6,0.7,\
        0.8,0.9,1.,2.,3.,4.,5.,6.,7.,8.,9.,10.,12.,14.,16.,18,\
        20.,25.,30.,40.,50/) 
color3  = read_colormap_file("MPL_BrBG")
color4  = read_colormap_file("MPL_autumn")
color3(0:31,:)  = color4(64:95,:)
color_paleta2   = color3

levels_rmse = (/1.,2.,3.,4.,5.,6.,7.,\
    8.,9.,10.,11.,12.,13.,14.,\
    15.,16.,17.,18.,19.,20.,\
    25.,30.,35.,40.,45.,50.,55.,60.,65.,\
    70.,75.,80.,85.,90.,95.,100.,125.,\
    150.,175.,200.,225.,250.,300.,400.,\
    500.,600.,700./)
paleta_rmse = "MPL_rainbow"

levels_bias := levels2
paleta_bias = "MPL_sstanom"

levels_mae = levels_rmse
paleta_mae = paleta_rmse

levels_nmae = levels
paleta_nmae = "MPL_YlGnBu"

begin 
    sst     = (/"-3sst","-2sst","-1sst","+1sst","+2sst","+3sst"/)
    ;hora    = (/"24 hrs","48 hrs","72 hrs"/)
    ;horas   = hora
    ;----- creando mapa ------;
    type    = "png"
    ;type    = "x11"
    dirS    = "/data/users/jticse/Tesis-Maestria/SALIDAS/figuras/"
    type@wkWidth     = 7000
    type@wkHeight    = 5000
    title1  = dirS+stat+"_rain_"+t
    wks     = gsn_open_wks(type,title1)   
    plot    = new(dimsizes(sst)+2,graphic)
    title2  = dirS+stat+"_dif_"+t
    wks2    = gsn_open_wks(type,title2)   
    plot2   = new(dimsizes(sst),graphic)
    
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
    res@mpFillDrawOrder     = "PostDraw"
    ;res@tiMainString        = "Prueba"
    ;res@lbOrientation       = "Vertical"

    ;---Limites Nacionales---;
    ;res@tmYLLabelsOn                = False         ; turn off lat labels
    ;res@tmXBLabelsOn                = False         ; turn off lon labels
    ;res@tmYROn                      = False
    ;res@tmYLOn                      = False
    ;res@tmXTOn                      = False
    ;res@tmXBOn                      = False

    res@gsnAddCyclic        = False
    res@lbLabelBarOn        = False             ;---> turn off individual cb's
    res@cnFillOn            = True
    ;res@cnFillPalette       = color_paleta
    res@cnLinesOn           = False             ;---> Contorno de linea (falso = no)
    res@cnLineLabelsOn      = False
    res@cnLevelSelectionMode= "ExplicitLevels"  ;---> Solo usa los indicados en levels
    ;res@cnLevels            = levels

    res@gsnCenterStringFontHeightF = 0.04

    file_1  = addfile(file_wrf,"r")

    wrf    := file_1->var01
    pisco  := file_1->var02
    lat    := file_1->lat
    lon    := file_1->lon
    time   := file_1->time
    limite := cd_inv_calendar(2017,12,31,0,0,0,time@units,0)

    if stat.eq."bias" then
        stat_wp_1    = (wrf({:limite},:,:,{t})-pisco({:limite},:,:,{t}))
        stat_wp_1   := dim_sum_n(stat_wp_1,0)/dimsizes(time({:limite}))
    else if stat.eq."mae" then
        stat_wp_1   := abs(wrf({:limite},:,:,{t})-pisco({:limite},:,:,{t}))
        stat_wp_1   := dim_sum_n(stat_wp_1,0)/dimsizes(time({:limite}))
    else if stat.eq."nmae" then
        stat_wp_1   := (abs(wrf({:limite},:,:,{t})-pisco({:limite},:,:,{t})))/pisco({:limite},:,:,{t})
        stat_wp_1   := dim_sum_n(stat_wp_1,0)/dimsizes(time({:limite}))
    else if stat.eq."rmse" then
        stat_wp_1   := (wrf({:limite},:,:,{t})-pisco({:limite},:,:,{t}))^2
        stat_wp_1   := dim_sum_n(stat_wp_1,0)/dimsizes(time({:limite}))
        stat_wp_1   := sqrt(stat_wp_1)
    end if
    end if
    end if
    end if
    stat_wp_1!0    = lat@long_name
    stat_wp_1&latitude  = lat
    stat_wp_1&latitude@units = lat@units
    stat_wp_1!1    = lon@long_name
    stat_wp_1&longitude  = lon
    stat_wp_1&longitude@units = lon@units

    printVarSummary(stat_wp_1)
    res1                   := res
    if stat.eq."bias" then
        res1@cnFillPalette   = paleta_bias
        res1@cnLevels        = levels_bias
    else if stat.eq."mae" then
        res1@cnFillPalette   = paleta_mae
        res1@cnLevels        = levels_mae
    else if stat.eq."nmae" then
        res1@cnFillPalette   = paleta_nmae
        res1@cnLevels        = levels_nmae
    else if stat.eq."rmse" then
        res1@cnFillPalette   = paleta_rmse
        res1@cnLevels        = levels_rmse
    end if
    end if
    end if
    end if
    res1@gsnCenterString   := str_upper(stat)+" "+t+" hrs Normal" 
    plot(0) = gsn_csm_contour_map(wks,stat_wp_1,res1)

    file_2   := addfile(file_wrf+"_sst","r")

    wrf    := file_2->var01
    pisco  := file_2->var02
    lat    := file_2->lat
    lon    := file_2->lon
    time   := file_2->time

    if stat.eq."bias" then
        stat_wp_2    = (wrf(:,:,:,{t})-pisco(:,:,:,{t}))
        stat_wp_2   := dim_sum_n(stat_wp_2,0)/dimsizes(time)
    else if stat.eq."mae" then
        stat_wp_2   := abs(wrf(:,:,:,{t})-pisco(:,:,:,{t}))
        stat_wp_2   := dim_sum_n(stat_wp_2,0)/dimsizes(time)
    else if stat.eq."nmae" then
        stat_wp_2   := (abs(wrf(:,:,:,{t})-pisco(:,:,:,{t})))/pisco(:,:,:,{t})
        stat_wp_2   := dim_sum_n(stat_wp_2,0)/dimsizes(time)
    else if stat.eq."rmse" then
        stat_wp_2   := (wrf(:,:,:,{t})-pisco(:,:,:,{t}))^2
        stat_wp_2   := dim_sum_n(stat_wp_2,0)/dimsizes(time)
        stat_wp_2   := sqrt(stat_wp_2)
    end if
    end if
    end if
    end if
    stat_wp_2!0    = lat@long_name
    stat_wp_2&latitude  = lat
    stat_wp_2&latitude@units = lat@units
    stat_wp_2!1    = lon@long_name
    stat_wp_2&longitude  = lon
    stat_wp_2&longitude@units = lon@units

    printVarSummary(stat_wp_2)
    res2                   := res1
    res2@gsnCenterString   := str_upper(stat)+" "+t+" hrs add RTG SST" 
    plot(1) = gsn_csm_contour_map(wks,stat_wp_2,res2)

    do i=0,dimsizes(sst)-1
        file_i   := addfile(file_wrf+sst(i),"r")
        wrf      := file_i->var01
        pisco    := file_i->var02
        lat      := file_i->lat
        lon      := file_i->lon
        time     := file_i->time

        if stat.eq."bias" then
            stat_wp_i   := (wrf(:,:,:,{t})-pisco(:,:,:,{t}))
            stat_wp_i   := dim_sum_n(stat_wp_i,0)/dimsizes(time)
        else if stat.eq."mae" then
            stat_wp_i   := abs(wrf(:,:,:,{t})-pisco(:,:,:,{t}))
            stat_wp_i   := dim_sum_n(stat_wp_i,0)/dimsizes(time)
        else if stat.eq."nmae" then
            stat_wp_i   := (abs(wrf(:,:,:,{t})-pisco(:,:,:,{t})))/pisco(:,:,:,{t})
            stat_wp_i   := dim_sum_n(stat_wp_i,0)/dimsizes(time)
        else if stat.eq."rmse" then
            stat_wp_i   := (wrf(:,:,:,{t})-pisco(:,:,:,{t}))^2
            stat_wp_i   := dim_sum_n(stat_wp_i,0)/dimsizes(time)
            stat_wp_i   := sqrt(stat_wp_i)
        end if
        end if
        end if
        end if
        stat_wp_i!0    = lat@long_name
        stat_wp_i&latitude  = lat
        stat_wp_i&latitude@units = lat@units
        stat_wp_i!1    = lon@long_name
        stat_wp_i&longitude  = lon
        stat_wp_i&longitude@units = lon@units
        printVarSummary(stat_wp_i)
        resi1                   := res1
        resi1@gsnCenterString   := sst(i) 
        plot(i+2) = gsn_csm_contour_map(wks,stat_wp_i,resi1)

        dif_i    := stat_wp_i-stat_wp_2
	    dif_i!0   = lat@long_name
	    dif_i&latitude  = lat
        dif_i&latitude@units = lat@units
        dif_i!1   = lon@long_name
        dif_i&longitude  = lon
        dif_i&longitude@units = lon@units
 
        printVarSummary(dif_i)
        resi2                   := res
        resi2@gsnCenterString   := "dif "+sst(i) 
        resi2@cnFillPalette     := color_paleta2
        resi2@cnLevels          := levels2
        plot2(i) = gsn_csm_contour_map(wks2,dif_i,resi2)
    end do

    pres1 = True
    pres1@gsnMaximize        = True
    pres1@gsnPanelRowSpec    = True  ;====================
    pres1@gsnPanelLabelBar   = True                ; add common colorbar
    ;pres1@vpHeightF          = 0.6
    pres1@lbLabelFontHeightF = 0.01               ; make labels smaller
    ;pres1@gsnPanelLeft       = 0.1
    pres1@gsnPanelBottom     = 0.2
    pres1@gsnPanelSave       = True
    pres1@lbTitleOn          = True                  ; turn on title
    pres1@lbTitlePosition    = "Bottom"
    pres1@lbTitleString      = "mm/dia"
    ;pres1@lbBoxEndCapStyle   = "TriangleHighEnd"
    pres1@lbTitleFontHeightF = 0.01
    pres1@pmLabelBarHeightF  = 0.06
    pres1@gsnPanelMainString = str_upper(stat)+" de la influencia SST en la lluvia 2017, WRF "+t+" hrs vs PISCO"

    agregando_shapefile1      = gsn_add_shapefile_polylines(wks,plot,shp1,shpres)
    agregando_shapefile2      = gsn_add_shapefile_polylines(wks,plot,shp2,shpres2)

    gsn_panel(wks,plot,(/2,6/),pres1)

    pres2 = True
    pres2@lbTitleOn          = False                  ; turn on title
    ;pres2@gsnPanelMainString = "Diferencia"
    pres2@gsnPanelLabelBar   = True
    pres2@lbLabelFontHeightF = 0.007
    
    agregando_shapefile3      = gsn_add_shapefile_polylines(wks2,plot2,shp1,shpres)
    agregando_shapefile4      = gsn_add_shapefile_polylines(wks2,plot2,shp2,shpres2)

    gsn_panel(wks2,plot2,(/1,6/),pres2)

    cmd1 = "convert "+title1+".png -crop `convert "+title1+".png -virtual-pixel edge -blur 0x15 -fuzz -15% -trim -format '%wx%h%O' info:` +repage "+title1+".png"
    system(cmd1)
    cmd2 = "convert "+title2+".png -crop `convert "+title2+".png -virtual-pixel edge -blur 0x15 -fuzz -15% -trim -format '%wx%h%O' info:` +repage "+title2+".png"
    system(cmd2)
    cmd4 = "convert "+title1+".png "+title2+".png -append "+dirS+stat+"_rain_dif_sst_wp_"+t+"_hrs.png"
    system(cmd4)

end
