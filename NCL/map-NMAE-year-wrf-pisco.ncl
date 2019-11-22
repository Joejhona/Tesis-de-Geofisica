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
levels2 = (/0.1,0.2,0.3,0.4,0.5,0.6,0.7,\
    0.8,0.9,1.,1.5,2.,2.5,3.,3.5,\
    4.,4.5,5.,6.,7.,8.,\
    9.,10.,15.,20.,25.,30.,35.,40.,\
    45.,50.,55.,60.,65.,70.,75.,\
    80.,85.,90.,95.,100./)
;color_paleta2 = "precip_diff_12lev";--> paleta 12 colores
;color_paleta2 = "WhBlReWh"
;color_paleta2 = "ViBlGrWhYeOrRe"
color_paleta2 = "MPL_YlGnBu"

begin
    dirBIAS = "/data/users/jticse/Tesis-Maestria/SALIDAS/netcdf/"
    ;f_bias  = "bias-wrfd01-pisco.nc"
    f_bias  = "bias-wrfd02-pisco.nc"

    f_bias := addfile(dirBIAS+f_bias,"r")

    wrf     = f_bias->var01
    pisco   = f_bias->var02
    hrs     = f_bias->hrs
    lat     = f_bias->lat
    lon     = f_bias->lon
    time    = f_bias->time
    limite  = cd_inv_calendar(2017,12,31,0,0,0,time@units,0)   ;---->> limite 2017-2018
    ;----- creando mapa ------;
    type    = "png"
    ;type    = "x11"
    dirS    = "/data/users/jticse/Tesis-Maestria/SALIDAS/figuras/"
    type@wkWidth     = 1750
    type@wkHeight    = 2100             
    wks     = gsn_open_wks(type,dirS+"nmae-year-"+wrf@long_name+"vsPISCO")   
    plot    = new(9,graphic)
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

    do i=0,dimsizes(hrs)-1
        ;¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬
        ;----- agregando detalles especificos al mapa -----;
        res1    = res
        res1@gsnCenterString   := hrs(i)+" hrs"
        res1@gsnCenterStringFontHeightF = 0.04
        ;res1@tmXBLabelsOn   = False
        res2    = res
        ;res2@tmXBLabelsOn   = False
        res3    = res
        ;res3@tmXBLabelsOn     = True
        if (i.eq.0) then
            res1@tmYLLabelsOn        = True         ; turn off lat labels
            res2@tmYLLabelsOn        = True         ; turn off lat labels
            res3@tmYLLabelsOn        = True         ; turn off lat labels
        else if (i.eq.2) then
            res1@tiYAxisString       = "2017"
            res1@tiYAxisFontHeightF  = 0.04
            res1@tiYAxisSide         = "right"
            res1@tiYAxisAngleF       = 270
            res2@tiYAxisString       = "2018"
            res2@tiYAxisFontHeightF  = 0.04
            res2@tiYAxisSide         = "right"
            res2@tiYAxisAngleF       = 270
            res3@tiYAxisString       = "Total"
            res3@tiYAxisFontHeightF  = 0.04
            res3@tiYAxisSide         = "right"
            res3@tiYAxisAngleF       = 270
        end if
        end if
        ;----- plot 2017 -----;    
        nmae_2017   := (abs(wrf({:limite},:,:,{hrs(i)})-pisco({:limite},:,:,{hrs(i)})))/pisco({:limite},:,:,{hrs(i)})
        nmae_2017   := dim_sum_n(nmae_2017,0)/dimsizes(time({:limite}))
        nmae_2017!0  = lat@long_name
        nmae_2017&latitude       = lat
        nmae_2017&latitude@units = lat@units
        nmae_2017!1  = lon@long_name
        nmae_2017&longitude      = lon
        nmae_2017&longitude@units= lon@units
        plot(i)   = gsn_csm_contour_map(wks,nmae_2017,res1)
        ;----- plot 2018 -----;    
        nmae_2018   := (abs(wrf({limite:},:,:,{hrs(i)})-pisco({limite:},:,:,{hrs(i)})))/pisco({limite:},:,:,{hrs(i)})
        nmae_2018   := dim_sum_n(nmae_2018,0)/dimsizes(time({limite:}))
        nmae_2018!0  = lat@long_name
        nmae_2018&latitude       = lat
        nmae_2018&latitude@units = lat@units
        nmae_2018!1  = lon@long_name
        nmae_2018&longitude      = lon
        nmae_2018&longitude@units= lon@units
        plot(i+3)   = gsn_csm_contour_map(wks,nmae_2018,res2)
        ;----- plot TOTAL -----;    
        nmae   := (abs(wrf(:,:,:,{hrs(i)})-pisco(:,:,:,{hrs(i)})))/pisco(:,:,:,{hrs(i)})
        nmae   := dim_sum_n(nmae,0)/dimsizes(time)
        nmae!0  = lat@long_name
        nmae&latitude       = lat
        nmae&latitude@units = lat@units
        nmae!1  = lon@long_name
        nmae&longitude      = lon
        nmae&longitude@units= lon@units
        plot(i+6)   = gsn_csm_contour_map(wks,nmae,res3)

    end do
    resP                    = True                ; modify the panel plot
    resP@gsnMaximize        = True
    resP@gsnPanelLabelBar   = True                ; add common colorbar
    resP@lbOrientation      = "Vertical"
    resP@pmLabelBarHeightF  = 0.9
    resP@gsnPanelMainString = "NMAE "+wrf@long_name+"&PISCO"
    resP@gsnPanelRowSpec    = True
    resP@lbLabelFontHeightF = 0.012
    resP@pmLabelBarOrthogonalPosF = 0.035
    agregando_shapefile1    = gsn_add_shapefile_polylines(wks,plot,shp1,shpres)
    agregando_shapefile2    = gsn_add_shapefile_polylines(wks,plot,shp2,shpres2)
    gsn_panel(wks,plot,(/3,3,3/),resP)
end
