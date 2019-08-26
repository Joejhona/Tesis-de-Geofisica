;------- PLOT DE UBICACION DE LAS ESTACIONES --------;

begin
    color1  = "blue"
    color2  = "red"
    tipo1   = "Est. Convencional"
    tipo2   = "Est. Automatica"

    ;---Limites del Perú---;
    lat_min_p = -19.5 
    lat_max_p = 0.5
    lon_min_p = -82.
    lon_max_p = -67.

    ;-----Extraendo datos senamhi
    f_data_se = "/home/usuario/Documentos/ticse/senamhi/ppython/senamhi-17-18.csv"
    f_dir_est = "/home/usuario/Documentos/ticse/senamhi/ppython/sen-17-18/*.csv"
    fc_sen   := asciiread(f_data_se,-1,"string")
    fc_sen   := str_split_csv(fc_sen(1:),",",0)
    dim_fc    = dimsizes(fc_sen(:,0))
    ;f_sen     = systemfunc(ls+f_dir_est)

    ;-----Alistando el mapa
    type    = "png"
    ;type    = "x11"
    titulo  = "Estaciones SENAMHI"  
    wks     = gsn_open_wks(type,titulo)

    ;-----Detalles del mapa
    res                     = True      ;--> activa los detalles
    res@gsnDraw             = False     ;-- don't draw the plot yet
    res@gsnFrame            = False     ;--> 
    res@gsnMaximize         = True
    res@gsnCenterString     = titulo
    ;---Grid Text--Grilla---;
    res@gsnMajorLatSpacing  = 2
    res@gsnMajorLonSpacing =  2
    res@tmYLLabelStride     = 1
    res@tmXBLabelStride     = 1
    ;-------Limites del Mapa--------;     
    res@mpLimitMode         = "Corners"     ;--> Activa limites modo corners
    res@mpLeftCornerLatF    = lat_min_p     ;--> limites.ncl r=rimac p=Perú   
    res@mpRightCornerLatF   = lat_max_p     ;--> n=Norte
    res@mpLeftCornerLonF    = lon_min_p
    res@mpRightCornerLonF   = lon_max_p
    ;---Limites Nacionales---;
    res@mpFillOn                    = False 
    res@mpOutlineBoundarySets       = "National"    ;---> Limite de Paises
    res@mpNationalLineThicknessF    = 2             ;---> Grosor de linea nacional
    res@mpGeophysicalLineThicknessF = 2             ;---> Grosor de linea continental
    ;---Grid--Grilla---;
    res@mpGridAndLimbOn     = True
    res@mpGridLatSpacingF   = 1.0
    res@mpGridLonSpacingF   = 1.0
    res@mpGridLineColor     = "Gray30"

    map     = gsn_csm_map(wks,res)

    ;-----Dibujando los puntos
    pmres                   =  True
    pmres@gsMarkerSizeF     =  0.015       ;-- set size of marker
    pmres@gsLineThicknessF  =  3.          ;-- marker line thickness
    pmres@gsMarkerIndex     = 1
    do k=0,dim_fc-1
        str        := unique_string("poly")
        coord_x     = tofloat(fc_sen(k,1)) ;--> lat
        coord_y     = tofloat(fc_sen(k,2)) ;--> lon
        tipo        = fc_sen(k,6)
        est_conv    = "CON"
        if (tipo.eq.est_conv) then 
            pmres@gsMarkerColor     = color1      ;-- marker color
        else
            pmres@gsMarkerColor     = color2       ;-- marker color
        end if
        map@$str$   = gsn_add_polymarker(wks,map,coord_y,coord_x,pmres)
    end do

    lgres                    = True
    lgres@lgItemType         = "Markers"        ; show lines only (default)
    lgres@lgMarkerColors     = (/color1,color2/)
    lgres@lgMarkerSizeF      = 0.07
    lgres@lgLabelFontHeightF = .15            ; set the legend label font thickness
    lgres@lgMarkerIndexes    = (/1,1/)
    lgres@vpWidthF           = 0.15           ; width of legend (NDC)
    lgres@vpHeightF          = 0.1            ; height of legend (NDC)
    lgres@lgPerimColor       = "black"       ; draw the box perimeter in orange
    lgres@lgPerimThicknessF  = 4.0            ; thicken the box perimeter
    lbid = gsn_create_legend(wks,2,(/tipo1,tipo2/),lgres)         ; create legend

    amres = True
    amres@amParallelPosF   = -0.3   ; del centro a la izquierda
    amres@amOrthogonalPosF = 0.42    ; del centro a abajo
    annoid1 = gsn_add_annotation(map,lbid,amres)   ; add legend to plot

    gsn_panel(wks,map,(/1,1/),False)   

end