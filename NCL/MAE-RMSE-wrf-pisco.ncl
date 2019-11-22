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
;---Limites norte---;
min_lat_n = -13.
max_lat_n = -1.
min_lon_n = -84.
max_lon_n = -75.
;============== %%%% COLORES %%%% ==============    
levels = (/1.,2.,3.,4.,5.,6.,7.,\
    8.,9.,10.,11.,12.,13.,14.,\
    15.,16.,17.,18.,19.,20.,\
    25.,30.,35.,40.,45.,50.,55.,60.,65.,\
    70.,75.,80.,85.,90.,95.,100.,125.,\
    150.,175.,200.,225.,250.,300.,400.,\
    500.,600.,700./)
levels2 = (/0.1,0.2,0.3,0.4,0.5,0.6,0.7,\
    0.8,0.9,1.,1.5,2.,2.5,3.,3.5,\
    4.,4.5,5.,6.,7.,8.,\
    9.,10.,15.,20.,25.,30.,35.,40.,\
    45.,50.,55.,60.,65.,70.,75.,\
    80.,85.,90.,95.,100./)
color_paleta = "MPL_cool"
color_paleta2 = "MPL_rainbow"
color_paleta3 = "MPL_YlGnBu"

begin
    dirBIAS = "/data/users/jticse/Tesis-Maestria/SALIDAS/netcdf/"
    f_bias  = "bias-wrfd01-pisco.nc"
    ;f_bias  = "bias-wrfd02-pisco.nc"
    f_bias := addfile(dirBIAS+f_bias,"r")

    wrf     = f_bias->var01
    pisco   = f_bias->var02
    hrs     = f_bias->hrs
    lat     = f_bias->lat
    lon     = f_bias->lon
    
    ;----- creando mapa ------;
    type    = "png"
    ;type    = "x11"
    dirS    = "/data/users/jticse/Tesis-Maestria/SALIDAS/figuras/"
    type@wkWidth     = 3500
    type@wkHeight    = 4000             
    wks     = gsn_open_wks(type,dirS+"rmse-mae-nmae"+wrf@long_name+"&PISCO")   
    plot    = new(9,graphic)
    ;¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬
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
    res@tmYLLabelsOn        = False         ; turn off lat labels
    res@tmXBLabelsOn        = False         ; turn off lon labels
    ;res@tmYROn              = False
    ;res@tmYLOn              = False
    ;res@tmXTOn              = False
    ;res@tmXBOn              = False
    res@gsnAddCyclic        = False
    res@lbLabelBarOn        = False             ;---> turn off individual cb's
    res@cnFillOn            = True
    res@cnFillPalette       = color_paleta3
    res@cnLinesOn           = False             ;---> Contorno de linea (falso = no)
    res@cnLineLabelsOn      = False
    res@cnLevelSelectionMode= "ExplicitLevels"  ;---> Solo usa los indicados en levels
    res@cnLevels            = levels
    do i=0,dimsizes(hrs)-1
        ;----- agregando detalles especificos al mapa -----;
        res1    = res
        res1@gsnCenterString   := hrs(i)+" hrs"
        res1@gsnCenterStringFontHeightF = 0.04
        res1@cnFillPalette  = color_paleta
        res2    = res
        res2@cnFillPalette  = color_paleta2
        res3    = res
        res3@tmXBLabelsOn   = True
        res3@cnFillPalette  = color_paleta3
        res3@cnLevels       = levels2
        if (i.eq.0) then
            res1@tmYLLabelsOn        = True         ; turn off lat labels
            res2@tmYLLabelsOn        = True         ; turn off lat labels
            res3@tmYLLabelsOn        = True         ; turn off lat labels
        else if (i.eq.2) then
            res1@tiYAxisString       = "RMSE"
            res1@tiYAxisFontHeightF  = 0.04
            res1@tiYAxisSide         = "right"
            res1@tiYAxisAngleF       = 270
            res1@lbLabelBarOn        = True
            res1@lbOrientation       = "vertical"
            res2@tiYAxisString       = "MAE"
            res2@tiYAxisFontHeightF  = 0.04
            res2@tiYAxisSide         = "right"
            res2@tiYAxisAngleF       = 270
            res2@lbLabelBarOn        = True
            res2@lbOrientation       = "vertical"
            res3@tiYAxisString       = "NMAE"
            res3@tiYAxisFontHeightF  = 0.04
            res3@tiYAxisSide         = "right"
            res3@tiYAxisAngleF       = 270
            res3@lbLabelBarOn        = True
            res3@lbOrientation       = "vertical"
        end if
        end if
        ;----- plot RMSE, MAE y NMAE -----;        
        rmse   := (wrf(:,:,:,{hrs(i)})-pisco(:,:,:,{hrs(i)}))^2
        rmse   := dim_avg_n(rmse,0)
        rmse   := sqrt(rmse)
        rmse!0  = lat@long_name
        rmse&latitude       = lat
        rmse&latitude@units = lat@units
        rmse!1  = lon@long_name
        rmse&longitude      = lon
        rmse&longitude@units= lon@units

        mae    := abs(wrf(:,:,:,{hrs(i)})-pisco(:,:,:,{hrs(i)}))
        mae    := dim_avg_n(mae,0)
        mae!0   = lat@long_name
        mae&latitude       = lat
        mae&latitude@units = lat@units
        mae!1   = lon@long_name
        mae&longitude      = lon
        mae&longitude@units= lon@units

        nmae   := (abs(wrf(:,:,:,{hrs(i)})-pisco(:,:,:,{hrs(i)})))/pisco(:,:,:,{hrs(i)})
        nmae   := dim_avg_n(nmae,0)
        nmae!0  = lat@long_name
        nmae&latitude       = lat
        nmae&latitude@units = lat@units
        nmae!1  = lon@long_name
        nmae&longitude      = lon
        nmae&longitude@units= lon@units

        plot(i)     = gsn_csm_contour_map(wks,rmse,res1)
        plot(i+3)   = gsn_csm_contour_map(wks,mae,res2)
        plot(i+6)   = gsn_csm_contour_map(wks,nmae,res3)
    end do
    resP                    = True                ; modify the panel plot
    resP@gsnMaximize        = True
    resP@gsnPanelMainString = "RMSE-MAE-NMAE "+wrf@long_name+"&PISCO"
    resP@gsnPanelRowSpec    = True
    agregando_shapefile1    = gsn_add_shapefile_polylines(wks,plot,shp1,shpres)
    agregando_shapefile2    = gsn_add_shapefile_polylines(wks,plot,shp2,shpres2)
    gsn_panel(wks,plot,(/3,3,3/),resP)
end