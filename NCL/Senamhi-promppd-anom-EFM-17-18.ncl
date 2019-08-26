undef("add_labelbar")
procedure add_labelbar(wks,plot,levels,colors)
local lbres, labels
begin
  nlevels = dimsizes(levels)
;----------------------------------------------------------------------
; Draw a labelbar
;----------------------------------------------------------------------
  lbres                    = True
  lbres@vpWidthF           = 0.80             ; width
  lbres@vpHeightF          = 0.10             ; height
  lbres@lbPerimOn          = False            ; Turn off perimeter.
  lbres@lbOrientation      = "Horizontal"     ; Default is vertical.
  lbres@lbLabelAlignment   = "InteriorEdges"  ; Default is "BoxCenters"
  lbres@lbFillColors       = colors           ; Colors for boxes.
  lbres@lbMonoFillPattern  = True             ; Fill them all solid.
  lbres@lbLabelFontHeightF = 0.012            ; label font height

  labels = sprintf("%4.2f",levels)

  lbid = gsn_create_labelbar(wks,nlevels+1,labels,lbres)
   
;
; Now, create some annotation resources indicating how we want to
; attach the labelbar to the plot. Here, we are using the top right
; corner of the labelbar as the point which we are going to position
; it, and then we use amParallelPosF and amOrthogonalPosF to indicate
; where we want to place it.
;
; amParallelPosF/amOrthogonalPosF                                       ;
;    0.0/ 0.0  -  annotation in dead center of plot
;    0.5/ 0.5  -  annotation at bottom right of plot
;    0.5/-0.5  -  annotation at top right of plot
;   -0.5/-0.5  -  annotation at top left of plot
;   -0.5/ 0.5  -  annotation at bottom left of plot
;                                                                 
  amres                  = True
  amres@amJust           = "TopCenter"
  amres@amParallelPosF   =  0.0   ; keep labelbar centered
  amres@amOrthogonalPosF =  0.6   ; move down and outside of plot

;
; Give both annotation id and labelbar id unique names.
;
; Attaching them to plot with unique names ensures that
; labelbar "lives" outside this procedure.
;
  tmpid1 = "anno"+unique_string("id")
  tmpid2 = "lbar"+unique_string("id")

  plot@$tmpid1$ = gsn_add_annotation(plot,lbid,amres)
  plot@$tmpid2$ = lbid
end


;------- PLOT DE PRECIPITACION PROMEDIO Y ANOMALIA 2017 Y 2018 EST. SENAMHI --------;

begin
    color1  = "blue"
    color2  = "red"
    tipo1   = "Est. Convencional"
    tipo2   = "Est. Automatica"

    levels = (/0,0.1,0.2,0.3,0.4,0.5,0.6,0.7,\
        0.8,0.9,1.,1.5,2.,2.5,3.,3.5,\
        4.,4.5,5.,6.,7.,8.,\
        9.,10.,15.,20.,25.,30.,35.,40.,\
        45.,50.,55.,60.,65.,70.,75.,\
        80.,85.,90.,95.,100./)
    color_paleta  = "WhBlGrYeRe"
    nlevels_color = dimsizes(levels) ;--> Cantidad de colores 
    colors        = span_color_rgba(color_paleta,nlevels_color+1)

    levels2 = (/-2.,-1.5,-1.,-0.75,\
            -0.5,-0.25,0,0.25,0.5,\
            0.75,1.,1.5,2./) 
    color_paleta2 = "precip_diff_12lev";--> paleta 12 colores
    nlevels_color2= dimsizes(levels2) ;--> Cantidad de colores 
    colors2       = span_color_rgba(color_paleta2,nlevels_color2+1)
    
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
    f_sen     = systemfunc("ls "+f_dir_est)

    ;-----Alistando el mapa
    ;type    = "png"
    type    = "x11"
    titulo  = "Estaciones SENAMHI"  
    wks     = gsn_open_wks(type,titulo)

    ;-----Detalles del mapa
    res                     = True      ;--> activa los detalles
    res@gsnDraw             = False     ;--> don't draw the plot yet
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
    ;---Estilo de los datos---;
    res@cnFillOn            = True
    ;res@cnFillPalette       = color_paleta
    res@cnLinesOn           = False             ;---> Contorno de linea (falso = no)
    res@cnLineLabelsOn      = False
    res@lbLabelBarOn        = False
    ;res@cnLevelSelectionMode= "ExplicitLevels"  ;---> Solo usa los indicados en levels
    ;res@cnLevels            = levels

    ;---Paleta de la primera columna---;
    res1                        = res
    res1@cnFillPalette          = color_paleta
    res1@cnLevelSelectionMode   = "ExplicitLevels"  ; manually specify contour levels
    res1@cnLevels               = levels
    res1@lbLabelBarOn           = True

    ;---Paleta de la segunda columna---;
    res2                        = res
    res2@cnFillPalette          = color_paleta2
    res2@cnLevelSelectionMode   = "ExplicitLevels"  ; manually specify contour levels
    res2@cnLevels               = levels2
    res2@lbLabelBarOn           = True

    ;---alistando mapas---;
    nrow = 3
    ncol = 3                           
    plot = new(1*3,graphic)
    ;ene-prom -- ene-2017 -- ene-2018
    ;feb-prom -- feb-2018 -- feb-2018
    ;mar-prom -- mar-2018 -- mar-2018
    ;plot    = new(3,graphic)

    plot(0)     = gsn_csm_map(wks,res1)
    map         = plot(0)

    plot(1)     = gsn_csm_map(wks,res2)
    map2        = plot(1)

    plot(2)     = gsn_csm_map(wks,res2)
    map3        = plot(2)

    ;-----Dibujando los puntos
    pmres                   =  True
    pmres@gsMarkerSizeF     =  0.03       ;-- set size of marker
    pmres@gsLineThicknessF  =  3.          ;-- marker line thickness
    pmres@gsMarkerIndex     =  1
    print("SENAMHI")
    do k=0,dim_fc-1
        str        := unique_string("poly")
        coord_x     = tofloat(fc_sen(k,1)) ;--> lat
        coord_y     = tofloat(fc_sen(k,2)) ;--> lon
        cod_est    := fc_sen(k,0)
        id_est     := str_match_ind(f_sen,cod_est)
        print("$$$$$$$$$$$$$$$$$$$$$$$")
        data1 = "Estacion--> "+cod_est
        fe_sen     := asciiread(f_sen(id_est),-1,"string")
        delete([/cod_est,id_est/])
        fe_sen     := str_sub_str(fe_sen,"Ene","01")
        fe_sen     := str_sub_str(fe_sen,"Feb","02")
        fe_sen     := str_sub_str(fe_sen,"Mar","03")
        fe_sen     := str_split_csv(fe_sen,",",0)
        id_tot     := str_match_ind(fe_sen(:,0),"-01-")
        id_pp      := str_match_ind(fe_sen(0,:),"mm")
        dim_id      = dimsizes(id_pp)
        ;ppd_s      := tofloat(fe_sen(1:,id_pp))
        if (.not.all(ismissing(id_tot))) then
            ppd_s      := tofloat(fe_sen(id_tot,id_pp))
            ;ppd_s@_FillValue := -999.0
            ppd_s      := where(ppd_s.ge.0,ppd_s,ppd_s@_FillValue)
            if (.not.all(ismissing(ppd_s))) then
                if (dim_id.eq.2) then
                    ppd_s := dim_sum(ppd_s)
                    ;print("SENAMHI: Estacion Convencional")
                else
                    ;print("SENAMHI: Estacion Automatica")
                end if
                ppd_s      := dim_avg(ppd_s)
                data2       = "AvgTot--> "+tostring(ppd_s)
                ppd_s_pro   = ppd_s
                print(tostring(ppd_s))
                do m=0,nlevels_color-1
                    if (m.eq.nlevels_color-1) then
                        ;--> si: ppd >= max -> ppd = max
                        ppd_s := where(ppd_s.ge.max(levels),max(levels),ppd_s)   
                    else if (m.eq.0) then
                        ;--> si: ppd < min -> ppd = min
                        ppd_s := where(ppd_s.lt.levels(0),levels(0),ppd_s)       
                    else 
                        cond_3:= ppd_s.le.levels(m+1)   ;---> si ppd =< val_2
                        cond_4:= ppd_s.gt.levels(m)     ;---> si ppd > val_1
                        ;--> si: val_1 < ppd =< val_2 -> ppd = val_2
                        ppd_s := where(cond_3.and.cond_4,levels(m),ppd_s)
                        ;ppd_s := where(ppd_s.ge.levels(m-1).and.ppd_s.lt.levels(m),ppd_s,levels(m))
                    end if
                    end if
                end do
                print(tostring(ppd_s))
                color_id               := get1Dindex(levels,ppd_s) 
                joel                    = colors(color_id+2,:)
                print(tostring(color_id))
                ;pmres1                  = pmres
                ;pmres1@gsMarkerColor   := colors(color_id+2,:)
                ;map@$str$               = gsn_add_polymarker(wks,map,coord_y,coord_x,pmres1)
                ;add_labelbar(wks,map,levels,colors)
            else 
                data2 = "No ahi"
            end if
        else 
            data2 = "No ahi"
        end if
        id_17    := str_match_ind(fe_sen(:,0),"-01-2017")
        if (.not.all(ismissing(id_17))) then
            ppd_s      := tofloat(fe_sen(id_17,id_pp))
            ;ppd_s@_FillValue := -999.0
            ppd_s      := where(ppd_s.ge.0,ppd_s,ppd_s@_FillValue)
            if (.not.all(ismissing(ppd_s))) then
                if (dim_id.eq.2) then
                    ppd_s := dim_sum(ppd_s)
                    ;print("SENAMHI: Estacion Convencional")
                else
                    ;print("SENAMHI: Estacion Automatica")
                end if
                ppd_s    := dim_avg(ppd_s)
                data3 = "Avg2017--> "+tostring(ppd_s)
                ppd_s    := ppd_s-ppd_s_pro
                data4 = "Dif2017--> "+tostring(ppd_s)
                do m=0,nlevels_color2-1
                    if (m.eq.nlevels_color2-1) then
                        ;--> si: ppd >= max -> ppd = max
                        ppd_s := where(ppd_s.ge.max(levels2),max(levels2),ppd_s)   
                    else if (m.eq.0) then
                        ;--> si: ppd < min -> ppd = min
                        ppd_s := where(ppd_s.lt.levels2(0),levels2(0),ppd_s)       
                    else 
                        cond_3:= ppd_s.le.levels2(m+1)   ;---> si ppd =< val_2
                        cond_4:= ppd_s.gt.levels2(m)     ;---> si ppd > val_1
                        ;--> si: val_1 < ppd =< val_2 -> ppd = val_2
                        ppd_s := where(cond_3.and.cond_4,levels2(m),ppd_s)
                        ;ppd_s := where(ppd_s.ge.levels(m-1).and.ppd_s.lt.levels(m),ppd_s,levels(m))
                    end if
                    end if
                end do
                color_id               := get1Dindex(levels2,ppd_s) 
                pmres2                  = pmres
                pmres2@gsMarkerColor   := colors2(color_id+2,:)
                map2@$str$              = gsn_add_polymarker(wks,map2,coord_y,coord_x,pmres2)
            else 
                data3 = "No ahi"
                data4 = "No ahi"
            end if
        else 
            data3 = "No ahi"
            data4 = "No ahi"
        end if
        id_18    := str_match_ind(fe_sen(:,0),"-01-2018")
        if (.not.all(ismissing(id_18))) then
            ppd_s      := tofloat(fe_sen(id_18,id_pp))
            ;ppd_s@_FillValue := -999.0
            ppd_s      := where(ppd_s.ge.0,ppd_s,ppd_s@_FillValue)
            if (.not.all(ismissing(ppd_s))) then
                if (dim_id.eq.2) then
                    ppd_s := dim_sum(ppd_s)
                    ;print("SENAMHI: Estacion Convencional")
                else
                    ;print("SENAMHI: Estacion Automatica")
                end if
                ppd_s    := dim_avg(ppd_s)
                data5 = "Avg2018--> "+tostring(ppd_s)
                ppd_s    := ppd_s-ppd_s_pro
                data6 = "Dif2018--> "+tostring(ppd_s)
                do m=0,nlevels_color2-1
                    if (m.eq.nlevels_color2-1) then
                        ;--> si: ppd >= max -> ppd = max
                        ppd_s := where(ppd_s.ge.max(levels2),max(levels2),ppd_s)   
                    else if (m.eq.0) then
                        ;--> si: ppd < min -> ppd = min
                        ppd_s := where(ppd_s.lt.levels2(0),levels2(0),ppd_s)       
                    else 
                        cond_3:= ppd_s.le.levels2(m+1)   ;---> si ppd =< val_2
                        cond_4:= ppd_s.gt.levels2(m)     ;---> si ppd > val_1
                        ;--> si: val_1 < ppd =< val_2 -> ppd = val_2
                        ppd_s := where(cond_3.and.cond_4,levels2(m),ppd_s)
                        ;ppd_s := where(ppd_s.ge.levels(m-1).and.ppd_s.lt.levels(m),ppd_s,levels(m))
                    end if
                    end if
                end do
                color_id               := get1Dindex(levels2,ppd_s) 
                pmres2                  = pmres
                pmres2@gsMarkerColor   := colors2(color_id+2,:)
                map3@$str$              = gsn_add_polymarker(wks,map3,coord_y,coord_x,pmres2)
                add_labelbar(wks,map3,levels2,colors2)
            else 
                data5 = "No ahi"
                data6 = "No ahi"
            end if   
        else 
            data5 = "No ahi"
            data6 = "No ahi"         
        end if
        print(data1+"/"+data2+"/"+data3+"/"+data4+"/"+data5+"/"+data6)
    end do
    resP                = True
    resP@gsnMaximize    = True
    resP@gsnFrame       = False
    resP@gsnPanelLeft   = 0.005
    resP@gsnPanelBottom = 0.08 
    resP@gsnPanelSave   = True
    gsn_panel(wks,plot,(/1,3/),resP)   
    ;gsn_panel(wks, plot, (/nrow,ncol/), resP)  ; plots
    frame(wks)
end