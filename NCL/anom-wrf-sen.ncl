load "./panel_two_sets.ncl"

;============== %%%% SHAPES %%%% ==============
dirP    = "/data/users/jticse/Tesis-Maestria/SALIDAS/scripts/Tesis-de-Geofisica/" ;--> ruta principal
shp1    = "shapes/cuencas/VertientePacificoCentroNorte.shp" 
shp1    = dirP+shp1     ;--> shape Vertiente Pacifico
;---Detalles del shape---;
shpres                  = True
;shpres@gsLineColor      = "red" ;--> color de linea
shpres@gsLineColor      = "black" ;--> color de linea
shpres@gsLineThicknessF = 3.     ;3.0   ;--> grosor de linea

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

;============== %%%% COLORES %%%% ==============
levels = (/0.1,0.2,0.3,0.4,0.5,0.6,0.7,\
    0.8,0.9,1.,1.5,2.,2.5,3.,3.5,\
    4.,4.5,5.,6.,7.,8.,\
    9.,10.,15.,20.,25.,30.,35.,40.,\
    45.,50.,55.,60.,65.,70.,75.,\
    80.,85.,90.,95.,100./)
color_paleta = "WhBlGrYeRe"

nlevels_color = dimsizes(levels) ;--> Cantidad de colores 
colors        = span_color_rgba(color_paleta,nlevels_color+1)

;levels2 = (/-1.,-0.5,-0.25,-0.15,\
;        -0.1,-0.05,0,0.05,0.1,\
;        0.15,0.25,0.5,1./) 
;levels2 = (/-5.,-0.5,-0.25,-0.15,\
;        -0.1,-0.05,0,0.05,0.1,\
;        0.15,0.25,0.5,1./) 
;color_paleta2 = "precip_diff_12lev";--> paleta 12 colores
color_paleta2 = "WhBlReWh"
nlevels_color2= dimsizes(levels2) ;--> Cantidad de colores 
colors2       = span_color_rgba(color_paleta2,nlevels_color2+1)

;============== %%%% HERRAMIENTAS %%%% ==============
load "$NCARG_ROOT/lib/ncarg/nclscripts/contrib/cd_inv_string.ncl"   ;---> para fechas 
load "$NCARG_ROOT/lib/ncarg/nclscripts/contrib/cd_string.ncl"       ;---> para fechas

;============== %%%% CODIGO %%%% ==============
begin
    ;¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬
    ;-----Extraendo datos senamhi
    f_est_se  = "/data/users/jticse/data/estaciones_senamhi/*.csv"
    f_est_se := systemfunc("ls "+f_est_se)
    ;f_data_se = "/data/users/jticse/data/senamhi_vertpac_cn.csv"
    f_data_se = "/data/users/jticse/data/senamhi-17-18.csv"
    fc_sen   := asciiread(f_data_se,-1,"string")
    fc_sen   := str_split_csv(fc_sen(1:),",",0)
    dim_fc    = dimsizes(fc_sen(:,0))
    ;¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬
    periodos = (/"2017-01-14","2017-01-21","2017-01-24","2017-01-30","2017-02-02",\
        "2017-02-25","2017-03-08","2017-03-13","2017-03-21","2017-03-25",\
        "2018-01-10","2018-01-16","2018-01-21","2018-02-14","2018-02-17",\
        "2018-03-05","2018-03-17","2018-03-22"/)
    ;do l=0,dimsizes(periodos)-1
    do l=0,1
        periodo = periodos(l)
        year    = stringtoint(str_get_cols(periodo,0,3))
        mes     = stringtoint(str_get_cols(periodo,5,6))
        dia     = stringtoint(str_get_cols(periodo,8,9))
        ;¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬
        ;----- creando mapa ------;
        type    = "png"
        ;type    = "x11"
        dirS    = "/data/users/jticse/Tesis-Maestria/SALIDAS/figuras/"
        type@wkWidth     = 7000
        type@wkHeight    = 8000             
        wks     = gsn_open_wks(type,dirS+"anom-WRF-SE-"+periodo+"-d02")   
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
        ;res@tiMainString        = "Prueba"
        ;res@lbOrientation       = "Vertical"

        ;---Limites Nacionales---;
        res@mpOutlineBoundarySets       = "National"    ;---> Limite de Paises
        res@mpNationalLineThicknessF    = 4           ;---> Grosor de linea nacional
        res@mpGeophysicalLineThicknessF = 5           ;---> Grosor de linea continental
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

        ;res@gsnMajorLatSpacing  = 2 ;-- change major lat tickmark spacing
        ;res@gsnMinorLatSpacing  = 0.5
        ;res@tmYLLabelStride     = 2
        ;res@gsnMajorLonSpacing  = 2 ;-- change major lon tickmark spacing
        ;res@gsnMinorLonSpacing  = 0.5 
        ;res@tmXBLabelStride     = 2
        ;¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬
        ;-----Extraendo datos wrf
        dirWRF  = "/data/users/jticse/WRFV4/wrfout/periodos/"
        f_wrf   = addfile(dirWRF+"wrfout_d02_"+periodo+"_00:00:00.nc", "r")
        ;f_wrf  := addfile(dirWRF+"wrfout_d01_"+periodo+"_00:00:00.nc", "r")
        lat_w  := wrf_user_getvar(f_wrf,"XLAT",0)
        ;lat_w  := lat_w(:,0)
        lon_w  := wrf_user_getvar(f_wrf,"XLONG",0)
        ;lon_w  := lon_w(0,:)
        t_wrf  := wrf_user_list_times(f_wrf)
        format  = "%Y-%N-%D_%H:%M:%S"
        t_wrf  := cd_inv_string(t_wrf, format)
        un_wrf  = t_wrf@units  
        rcv     = wrf_user_getvar(f_wrf,"RAINC",-1)
        rncv    = wrf_user_getvar(f_wrf,"RAINNC",-1)
        do i=0,2
            ;¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬
            ;----- Procesando datos wrf
            ;it_wrf := cd_inv_calendar(year,mes,dia+i,5,0,0,un_wrf,0)
            ;ft_wrf := cd_inv_calendar(year,mes,dia+1+i,5,0,0,un_wrf,0)
            it_wrf := cd_inv_calendar(year,mes,dia+i,12,0,0,un_wrf,0)   ;---->> hora de inicio de lluvia
            ft_wrf := cd_inv_calendar(year,mes,dia+1+i,12,0,0,un_wrf,0) ;---->> hora de inicio de lluvia
            id_tiw := get1Dindex(t_wrf,it_wrf)
            id_tfw := get1Dindex(t_wrf,ft_wrf)
            rcvi   := rcv(id_tiw,:,:)
            rcvf   := rcv(id_tfw,:,:)
            rncvi  := rncv(id_tiw,:,:)
            rncvf  := rncv(id_tfw,:,:)
            pd_wrf := (rcvf-rcvi)+(rncvf-rncvi)
            pd_wrf@lat2d := lat_w
            pd_wrf@lon2d := lon_w  
            ;print(it_wrf+"==="+id_tiw)
            ;printVarSummary(pd_wrf)
            res1                   := res
            res1@gsnCenterString   := cd_string(it_wrf,"%D-%N-%Y") 
            res1@gsnCenterStringFontHeightF = 0.04
            ;plot(0) = gsn_csm_contour_map(wks,ppd_pi_e_per99,res1)
            if (i.eq.0) then
                delete([/res1@tiYAxisString,res1@tiYAxisFontHeightF,\
                res1@tiYAxisSide,res1@tiYAxisAngleF/])                
                res1@tmYLLabelsOn        = True         ; turn off lat labels
            else if (i.eq.2) then
                res1@tiYAxisString       = "WRF-AWR-d02"
                res1@tiYAxisFontHeightF  = 0.04
                ;res@tiYAxisFontColor    = "navy"
                res1@tiYAxisSide         = "right"
                res1@tiYAxisAngleF       = 270
            end if
            end if
            plot(i) = gsn_csm_contour_map(wks,pd_wrf,res1)
            ;¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬
            ;----- Procesando datos senamhi
            pmres                   = True
            pmres@gsMarkerSizeF     = 0.015       ;-- set size of marker
            pmres@gsLineThicknessF  = 3.          ;-- marker line thickness
            pmres@gsMarkerIndex     = 1
            ;pmres@gsMarkerColor     = "blue"
            ;do m=0,2
            res2        = res
            res2@tmXBLabelsOn = True
            ;res3@gsnCenterString    = "SENAMHI"
            t_se        = cd_inv_calendar(year,mes,dia+i,0,0,0,"days since 1971-1-1",0)
            fecha_s     = cd_string(t_se,"%D-%N-%Y")   
            ;plot(i+3)   = gsn_csm_map(wks,res3)
            
            ;pd_se      := pd_wrf
            ;pd_se       = pd_se@missing_value
            pd_se   := new((/1,dimsizes(pd_wrf(:,0)),dimsizes(pd_wrf(0,:))/),typeof(pd_wrf),default_fillvalue("float"))
            pd_se!0                = "time"
            pd_se!1                = "latitude"        ;--->rotulo lat
            pd_se!2                = "longitude"       ;--->rotulo lon 
            pd_se&latitude         = lat_w(:,0)            
            pd_se&longitude        = lon_w(0,:)
            pd_se&latitude@units   = "degrees_north"   ;--->und lat
            pd_se&longitude@units  = "degrees_east"    ;--->und lon
            pd_se2  = pd_se
            if (i.eq.0) then
                ;map1 = map
                res2@tmYLLabelsOn   = True         ; turn off lat labels
                plot(i+3)   = gsn_csm_map(wks,res2)
                map1        = plot(i+3)
            else if (i.eq.1) then
                plot(i+3)   = gsn_csm_map(wks,res2)
                map2        = plot(i+3)
            else
                res2@tiYAxisString       = "SENAMHI"
                res2@tiYAxisFontHeightF  = 0.04
                ;res2@tiYAxisFontColor    = "navy"
                res2@tiYAxisSide         = "right"
                res2@tiYAxisAngleF       = 270
                plot(i+3)   = gsn_csm_map(wks,res2)
                map3        = plot(i+3)
            end if
            end if
            do j=0,dim_fc-1
                cod_est    := fc_sen(j,0)
                id_est     := str_match_ind(f_est_se,cod_est)
                ;print("Fecha "+periodo+" Estacion "+cod_est+" Id "+tostring(id_est))
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
                        ppd_s  := where(ppd_s.ge.200,ppd_s@_FillValue,ppd_s)
                        ppd_s  := dim_sum(ppd_s)
                        if (.not.all(ismissing(ppd_s))) then
                            ;print("lluvia anterior "+tostring(ppd_s))
                            str        := unique_string("poly")
                            coord_x    := tofloat(fc_sen(j,1)) ;--> lat
                            coord_y    := tofloat(fc_sen(j,2)) ;--> lon
                            ;¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬
                            ;----- guardando lluvia para anomalia
                            cond_1      = coord_x.le.max(lat_w(:,0)).and.coord_x.ge.min(lat_w(:,0))
                            cond_2      = coord_y.le.max(lon_w(0,:)).and.coord_y.ge.min(lon_w(0,:))
                            if cond_1.and.cond_2 then
                                ;print("paso")
                                if all(ismissing(pd_se(:,{coord_x},{coord_y}))) then
                                    pd_se(:,{coord_x},{coord_y}) = ppd_s
                                else
                                    pd_se3 := pd_se2
                                    pd_se3(:,{coord_x},{coord_y}) = ppd_s
                                    pd_se  := array_append_record(pd_se,pd_se3,0)
                                end if
                            end if
                            ;¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬
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
                                end if
                                end if
                            end do
                            ;print("lluvia nueva "+tostring(ppd_s))
                            color_id               := get1Dindex(levels,ppd_s)
                            pmres@gsMarkerColor    := colors(color_id,:) 
                            ;map@$str$   = gsn_add_polymarker(wks,map,coord_y,coord_x,pmres)
                            if (i.eq.0) then
                                map1@$str$  = gsn_add_polymarker(wks,map1,coord_y,coord_x,pmres)
                            else if (i.eq.1) then
                                map2@$str$  = gsn_add_polymarker(wks,map2,coord_y,coord_x,pmres)
                            else
                                map3@$str$  = gsn_add_polymarker(wks,map3,coord_y,coord_x,pmres)
                            end if
                            end if
                        end if
                    end if
                end if
            end do
            print(max(pd_se)+"//"+min(pd_se))
            printVarSummary(pd_se)
            printVarSummary(pd_wrf)
            ;¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬
            ;-----procesando la anomalia
            pd_se_p = dim_avg_n(pd_se,0)
            pd_se_p!0                = "latitude"        ;--->rotulo lat
            pd_se_p!1                = "longitude"       ;--->rotulo lon 
            pd_se_p&latitude         = lat_w(:,0)            
            pd_se_p&longitude        = lon_w(0,:)
            pd_se_p&latitude@units   = "degrees_north"   ;--->und lat
            pd_se_p&longitude@units  = "degrees_east"    ;--->und lon
            anom  = pd_wrf-pd_se_p
            ;anom@lat2d := lat_w
            ;anom@lon2d := lon_w
            anom!0                = "latitude"        ;--->rotulo lat
            anom!1                = "longitude"       ;--->rotulo lon 
            anom&latitude         = lat_w(:,0)            
            anom&longitude        = lon_w(0,:)
            anom&latitude@units   = "degrees_north"   ;--->und lat
            anom&longitude@units  = "degrees_east"    ;--->und lon
            printVarSummary(pd_se_p)
            printVarSummary(anom)
            res3                 := res
            res3@tmXBLabelsOn     = True
            ;res3@cnLevelSelectionMode= "ManualLevels"   ; manual set levels
            res3@cnFillPalette   := color_paleta2
            ;res3@cnMinLevelValF   = -20;-5.			; set the minimum contour level
            ;res3@cnMaxLevelValF   = 20;5.			; set the maximum contour level
            ;res3@cnLevelSpacingF  = 2;0.5
            ;res3@cnLevels      := levels2
            if (i.eq.0) then
                delete([/res3@tiYAxisString,res3@tiYAxisFontHeightF,\
                res3@tiYAxisSide,res3@tiYAxisAngleF/])
                res3@tmYLLabelsOn        = True         ; turn off lat labels
            else if (i.eq.2) then
                res3@tiYAxisString       = "ANOM"
                res3@tiYAxisFontHeightF  = 0.04
                ;res@tiYAxisFontColor    = "navy"
                res3@tiYAxisSide         = "right"
                res3@tiYAxisAngleF       = 270
            end if
            end if
            plot2(i) = gsn_csm_contour_map(wks,anom,res3)
        end do
        ;delete(res@tiYAxisString)
        ;delete(res@tiYAxisFontHeightF)
        ;delete(res@tiYAxisSide)
        ;delete(res@tiYAxisAngleF)
        dims1 = (/2,3/)
        dims2 = (/1,3/)
        pres1 = True
        ;resP                    = True                ; modify the panel plot
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
        pres1@pmLabelBarHeightF   = 0.6
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
        pres2@pmLabelBarHeightF   = 0.3
        pres  = True
        ;pres1@lbLabelFontHeightF = 0.01     ; make labels slightly larger
        ;pres2@lbLabelFontHeightF = 0.01
        ;pres1@gsnPanelMainString = "Analisis de lluvia WRF - PISCO"
        agregando_shapefile1    = gsn_add_shapefile_polylines(wks,plot,shp1,shpres)
        agregando_shapefile2    = gsn_add_shapefile_polylines(wks,plot2,shp1,shpres)
        panel_two_sets(wks,plot,plot2,dims1,dims2,pres1,pres2,pres)
    end do
end
