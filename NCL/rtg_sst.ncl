begin
    ;============== %%%% SHAPES %%%% ==============
    dirP    = "/data/users/jticse/Tesis-Maestria/PREDATA/shapes/" ;--> ruta principal
    shp3    = "sudamerica/Sudamerica.shp" 
    shp3    = dirP+shp3

    shpres3                  = True
    shpres3@gsColor          = "black" ;--> color de linea
    shpres3@gsLineThicknessF = 4.     ;3.0   ;--> grosor de linea

    dirNCL  = "/data/users/jticse/Tesis-Maestria/SALIDAS/scripts/Tesis-de-Geofisica/NCL/"
    ;load dirNCL+"shapefile_utils.ncl"

    opt             = True
    opt@return_mask = True

    

    ;---Limites norte---;
    min_lat_n = -13.
    max_lat_n = -1.
    min_lon_n = -84.
    max_lon_n = -75.

    type    = "png"
    ;type    = "x11"
    dirS    = "/data/users/jticse/Tesis-Maestria/SALIDAS/figuras/"
    type@wkWidth     = 7000
    type@wkHeight    = 5000
    title1  = dirS+"rtg_sst_joel"
    wks     = gsn_open_wks(type,title1)   
    plot    = new(1,graphic)

    res                      = True     ; plot mods desired
    res@cnFillOn             = True     ; turn on color fill
    res@cnLinesOn            = False    ; turn off contour lines
    res@lbLabelStride        = 4        ; every 4th label
    ;res@cnFillPalette        = cmap(10:96,:)

    res@cnLevelSpacingF      = 3        ; interval

    res@tiMainString         = "Draw land ON TOP of contours"      ; title

    res@cnFillDrawOrder      = "Predraw"  ; draw contours first


    ;res                     = True      ;--> activa los detalles
    res@gsnDraw             = False     ;--> don't draw the plot yet
    res@gsnFrame            = False     ;--> 
    ;res@mpFillOn            = False
    ;;res@gsnMaximize         = True
    ;;res@gsnLeftString       = "mm/dia"
    ;res@gsnLeftString      = ""
    res@mpLimitMode         = "Corners" ;--> Activa limites modo corners
    res@mpLeftCornerLatF    = min_lat_n ;--> limites.ncl r=rimac p=Perú   
    res@mpRightCornerLatF   = max_lat_n ;--> n=Norte
    res@mpLeftCornerLonF    = min_lon_n
    res@mpRightCornerLonF   = max_lon_n
    ;res@cnFillDrawOrder      = "Predraw"
    ;;res@mpFillDrawOrder     = "PostDraw"
    ;;res@tiMainString        = "Prueba"
    ;;res@lbOrientation       = "Vertical"
;
    ;;---Limites Nacionales---;
    ;;res@tmYLLabelsOn                = False         ; turn off lat labels
    ;;res@tmXBLabelsOn                = False         ; turn off lon labels
    ;;res@tmYROn                      = False
    ;;res@tmYLOn                      = False
    ;;res@tmXTOn                      = False
    ;;res@tmXBOn                      = False
;
    res@gsnAddCyclic        = False
    res@lbLabelBarOn        = False             ;---> turn off individual cb's
    ;res@cnFillOn            = True
    res@cnFillPalette       = "NCV_bright"
    ;res@cnLinesOn           = False             ;---> Contorno de linea (falso = no)
    ;res@cnLineLabelsOn      = False
    res@cnLevelSelectionMode= "ExplicitLevels"  ;---> Solo usa los indicados en levels
    res@cnLevels            = ispan(13,31,1)

    file_3   := addfile(file_rtg,"r")
    rtg_sst   = file_3->TMP_P0_L1_GLL0
    lat       = file_3->lat_0
    lon       = file_3->lon_0
    rtg_sst!0 = "lat"               ; name dimensions
    rtg_sst!1 = "lon"
    rtg_sst&lat   = lat                 ; assign lat cv
    rtg_sst&lon   = lon
    rtg_sst  := rtg_sst({min_lat_n:max_lat_n},{min_lon_n+360.:max_lon_n+360.})
    rtg_sst   = rtg_sst-273.15  
    
    ;land_mask = shapefile_mask_data(rtg_sst,shp3,opt)

    ;rtg_sst_land_mask  = where(land_mask.eq.1,rtg_sst,rtg_sst@_FillValue)
    ;copy_VarMeta(rtg_sst,rtg_sst_land_mask)
    
    plot(0) = gsn_csm_contour_map(wks,rtg_sst,res)

    pres1 = True
    pres1@gsnMaximize        = True
    pres1@gsnPanelRowSpec    = True  ;====================
    pres1@gsnPanelLabelBar   = True                ; add common colorbar
    ;pres1@vpHeightF          = 0.6
    pres1@lbLabelFontHeightF = 0.01               ; make labels smaller
    ;pres1@gsnPanelLeft       = 0.1
    pres1@gsnPanelBottom     = 0.08
    pres1@gsnPanelSave       = True
    pres1@lbTitleOn          = True                  ; turn on title
    ;pres1@lbTitleString      = "mm/dia"
    pres1@lbBoxEndCapStyle   = "TriangleHighEnd"
    pres1@lbTitleFontHeightF = 0.01
    pres1@pmLabelBarHeightF  = 0.06
    pres1@gsnPanelMainString = "RTG SST JOEL"
    ;agregando_shapefile3     = gsn_add_shapefile_polygons(wks,plot,shp3,shpres3)
    gsn_panel(wks,plot,(/1/),pres1)
end
