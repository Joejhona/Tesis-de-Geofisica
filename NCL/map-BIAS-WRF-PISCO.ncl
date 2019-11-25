;============== %%%% HERRAMIENTAS %%%% ==============
load "./panel_two_sets.ncl"                                         ;---> para 

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
levels = (/0.1,0.2,0.3,0.4,0.5,0.6,0.7,\
    0.8,0.9,1.,1.5,2.,2.5,3.,3.5,\
    4.,4.5,5.,6.,7.,8.,\
    9.,10.,15.,20.,25.,30.,35.,40.,\
    45.,50.,55.,60.,65.,70.,75.,\
    80.,85.,90.,95.,100./)
color_paleta = "WhBlGrYeRe"

levels2 := (/-50.,-40.,-30.,-25.,-20.,-18.,-16.,-14.,-12.,-10.,\
        -9.,-8.,-7.,-6,-5,-4.,-3.,-2.,-1.,-0.9,-0.8,-0.7,-0.6,\
        -0.5,-0.4,-0.3,-0.2,-0.1,0,0.1,0.2,0.3,0.4,0.5,0.6,0.7,\
        0.8,0.9,1.,2.,3.,4.,5.,6.,7.,8.,9.,10.,12.,14.,16.,18,\
        20.,25.,30.,40.,50/) 
;color_paleta2 = "precip_diff_12lev";--> paleta 12 colores
;color_paleta2 = "WhBlReWh"
;color_paleta2 = "ViBlGrWhYeOrRe"
color_paleta2 = "MPL_BrBG"

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

    ;----- creando mapa ------;
    type    = "png"
    ;type    = "x11"
    dirS    = "/data/users/jticse/Tesis-Maestria/SALIDAS/figuras/"
    type@wkWidth     = 3500
    type@wkHeight    = 4000             
    wks     = gsn_open_wks(type,dirS+"bias-"+wrf@long_name+"-PISCO")   
    plot    = new(6,graphic)
    plot2   = new(3,graphic)

    ;¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬
    ;----- agregando detalles al mapa -----;
    res                     = True      ;--> activa los detalles
    res@gsnDraw             = False     ;--> don't draw the plot yet
    res@gsnFrame            = False     ;--> 
    res@mpFillOn            = False
    ;res@gsnMaximize         = True
    ;res@gsnLeftString       = "mm/dia"
    res@gsnLeftString      = ""
    res@mpLimitMode         = "Corners" ;--> Activa limites modo corners
    res@mpLeftCornerLatF    = min_lat_n ;--> limites.ncl r=rimac p=Perú   
    res@mpRightCornerLatF   = max_lat_n ;--> n=Norte
    res@mpLeftCornerLonF    = min_lon_n
    res@mpRightCornerLonF   = max_lon_n

    res@tmYLLabelsOn                = False         ; turn off lat labels
    res@tmXBLabelsOn                = False         ; turn off lon labels
    ;res@tmYROn                      = False
    ;res@tmYLOn                      = False
    ;res@tmXTOn                      = False
    ;res@tmXBOn                      = False
    res@gsnAddCyclic        = False
    res@lbLabelBarOn        = False             ;---> turn off individual cb's
    res@cnFillOn            = True
    res@cnFillPalette       = color_paleta
    res@cnLinesOn           = False             ;---> Contorno de linea (falso = no)
    res@cnLineLabelsOn      = False
    res@cnLevelSelectionMode= "ExplicitLevels"  ;---> Solo usa los indicados en levels
    res@cnLevels            = levels

    do i=0,dimsizes(hrs)-1
        ;¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬
        ;----- agregando detalles especificos al mapa -----;
        res1    = res
        res1@gsnCenterString   := hrs(i)+" hrs"
        res1@gsnCenterStringFontHeightF = 0.04
        res2    = res
        res3    = res
        res3@tmXBLabelsOn     = True
        res3@cnFillPalette   := color_paleta2
        res3@cnLevels        := levels2
        if (i.eq.0) then
            res1@tmYLLabelsOn        = True         ; turn off lat labels
            res2@tmYLLabelsOn        = True         ; turn off lat labels
            res3@tmYLLabelsOn        = True         ; turn off lat labels
        else if (i.eq.2) then
            res1@tiYAxisString       = wrf@long_name
            res1@tiYAxisFontHeightF  = 0.04
            res1@tiYAxisSide         = "right"
            res1@tiYAxisAngleF       = 270
            res2@tiYAxisString       = pisco@long_name
            res2@tiYAxisFontHeightF  = 0.04
            res2@tiYAxisSide         = "right"
            res2@tiYAxisAngleF       = 270
            res3@tiYAxisString       = "BIAS"
            res3@tiYAxisFontHeightF  = 0.04
            res3@tiYAxisSide         = "right"
            res3@tiYAxisAngleF       = 270
        end if
        end if
        ;----- plot WRF y PISCO -----;        
        pp_wrf      = dim_avg_n(wrf(:,:,:,{hrs(i)}),0)
        pp_wrf!0    = lat@long_name
        pp_wrf&latitude  = lat
        pp_wrf&latitude@units = lat@units
        pp_wrf!1    = lon@long_name
        pp_wrf&longitude  = lon
        pp_wrf&longitude@units = lon@units
        pp_pi       = dim_avg_n(pisco(:,:,:,{hrs(i)}),0)
        pp_pi!0    = lat@long_name
        pp_pi&latitude  = lat
        pp_pi&latitude@units = lat@units
        pp_pi!1    = lon@long_name
        pp_pi&longitude  = lon
        pp_pi&longitude@units = lon@units
        plot(i)     = gsn_csm_contour_map(wks,pp_wrf,res1)
        plot(i+3)   = gsn_csm_contour_map(wks,pp_pi,res2)
        ;----- plot BIAS -----;        
        bias       := (wrf(:,:,:,{hrs(i)})-pisco(:,:,:,{hrs(i)}))
        bias       := dim_avg_n(bias,0)
        bias!0    = lat@long_name
        bias&latitude  = lat
        bias&latitude@units = lat@units
        bias!1    = lon@long_name
        bias&longitude  = lon
        bias&longitude@units = lon@units
        plot2(i)    = gsn_csm_contour_map(wks,bias,res3)
    end do
    dims1 = (/2,3/)
    dims2 = (/1,3/)

    pres1 = True
    pres1@gsnMaximize        = True
    pres1@gsnPanelLabelBar   = True                ; add common colorbar
    pres1@lbOrientation      = "vertical"
    pres1@vpHeightF          = 0.6
    pres1@lbLabelFontHeightF = 0.01               ; make labels smaller
    pres1@gsnPanelLeft       = 0.04
    pres1@gsnPanelBottom     = 0.08
    pres1@gsnPanelSave       = True
    pres1@lbTitleOn          = True                  ; turn on title
    pres1@lbTitleString      = "mm/dia"
    pres1@lbBoxEndCapStyle   = "TriangleHighEnd"
    pres1@lbTitleFontHeightF = 0.01
    pres1@pmLabelBarHeightF  = 0.6
    pres1@gsnPanelMainString = "BIAS "+wrf@long_name+"-PISCO"
    pres2 = True
    pres2@gsnMaximize        = True
    pres2@gsnPanelLabelBar   = True                ; add common colorbar
    pres2@lbOrientation      = "vertical"
    pres2@vpHeightF          = 0.6
    pres2@lbLabelFontHeightF = 0.01               ; make labels smaller
    pres2@gsnPanelLeft       = 0.04
    pres2@gsnPanelBottom     = 0.08
    pres2@gsnPanelSave       = True
    ;pres2@lbTitleOn          = True                  ; turn on title
    ;pres2@lbTitleString      = "mm/dia"
    pres2@lbBoxEndCapStyle   = "TriangleBothEnds"
    pres2@lbTitleFontHeightF = 0.01
    pres2@pmLabelBarHeightF  = 0.3
	;pres2@gsnPanelMainString = "Anomalia lluvia WRF - PISCO"
    pres  = True
    pres@gsnPanelTop         = 0.95
    agregando_shapefile1     = gsn_add_shapefile_polylines(wks,plot,shp1,shpres)
    agregando_shapefile2     = gsn_add_shapefile_polylines(wks,plot2,shp1,shpres)
    agregando_shapefile3     = gsn_add_shapefile_polylines(wks,plot,shp2,shpres2)
    agregando_shapefile4     = gsn_add_shapefile_polylines(wks,plot2,shp2,shpres2)
    panel_two_sets(wks,plot,plot2,dims1,dims2,pres1,pres2,pres)
end