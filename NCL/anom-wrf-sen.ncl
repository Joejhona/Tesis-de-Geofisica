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
levels2 := (/-50.,-40.,-30.,-25.,-20.,-18.,-16.,-14.,-12.,-10.,\
        -9.,-8.,-7.,-6,-5,-4.,-3.,-2.,-1.,-0.9,-0.8,-0.7,-0.6,\
        -0.5,-0.4,-0.3,-0.2,-0.1,0,0.1,0.2,0.3,0.4,0.5,0.6,0.7,\
        0.8,0.9,1.,2.,3.,4.,5.,6.,7.,8.,9.,10.,12.,14.,16.,18,\
        20.,25.,30.,40.,50/) 
;color_paleta2 = "precip_diff_12lev";--> paleta 12 colores
color_paleta2 = "ViBlGrWhYeOrRe"
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
    horas = (/"24 hrs","48 hrs","72 hrs"/)
    dom = (/"-d01","_d01_"/)
    ;dom = (/"-d02","_d02_"/)
    do l=0,dimsizes(periodos)-1
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
        type@wkHeight    = 8500             
        wks     = gsn_open_wks(type,dirS+"anom-WRF-SE-"+periodo+dom(0))   
        plot    = new(9,graphic)
        ;plot2   = new(3,graphic)
        ;¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬
        ;----- agregando detalles al mapa -----;
        res                     = True      ;--> activa los detalles
        res@gsnDraw             = False     ;--> don't draw the plot yet
        res@gsnFrame            = False     ;--> 
        ;res@mpFillOn            = False
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
        f_wrf   = addfile(dirWRF+"wrfout"+dom(1)+periodo+"_00:00:00.nc", "r")
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
            res1@tmXBLabelsOn       = True
            res1@gsnCenterString   := horas(i);cd_string(it_wrf,"%D-%N-%Y") 
            res1@gsnCenterStringFontHeightF = 0.04
            ;plot(0) = gsn_csm_contour_map(wks,ppd_pi_e_per99,res1)
            if (i.eq.0) then
                delete([/res1@tiYAxisString,res1@tiYAxisFontHeightF,\
                res1@tiYAxisSide,res1@tiYAxisAngleF/])                
                res1@tmYLLabelsOn        = True         ; turn off lat labels
            else if (i.eq.2) then
                res1@tiYAxisString       = "WRF-AWR"+dom(0)
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
            ;res2@tmXBLabelsOn = True
            ;res3@gsnCenterString    = "SENAMHI"
            t_se        = cd_inv_calendar(year,mes,dia+i,0,0,0,"days since 1971-1-1",0)
            fecha_s     = cd_string(t_se,"%D-%N-%Y")   
            ;plot(i+3)   = gsn_csm_map(wks,res3)
            
            ;pd_se      := pd_wrf
            ;pd_se       = pd_se@missing_value
            ;pd_se   := new((/1,dimsizes(pd_wrf(:,0)),dimsizes(pd_wrf(0,:))/),typeof(pd_wrf),default_fillvalue("float"))
            ;pd_se!0                = "time"
            ;pd_se!1                = "latitude"        ;--->rotulo lat
            ;pd_se!2                = "longitude"       ;--->rotulo lon 
            ;pd_se&latitude         = lat_w(:,0)            
            ;pd_se&longitude        = lon_w(0,:)
            ;pd_se&latitude@units   = "degrees_north"   ;--->und lat
            ;pd_se&longitude@units  = "degrees_east"    ;--->und lon
            ;pd_se2  = pd_se
            pd_wrf!0                = "latitude"        ;--->rotulo lat
            pd_wrf!1                = "longitude"       ;--->rotulo lon 
            pd_wrf&latitude         = lat_w(:,0)            
            pd_wrf&longitude        = lon_w(0,:)
            pd_wrf&latitude@units   = "degrees_north"   ;--->und lat
            pd_wrf&longitude@units  = "degrees_east"    ;--->und lon
            pd_se   := new((/1,3/),float)
            pd_se2   = pd_se
            pd_wrf_p:= new((/1,3/),float)
            pd_wrf_p2= pd_wrf_p
            if (i.eq.0) then
                ;map1 = map
                res2@tiYAxisString  = ""
                res2@tmXBLabelsOn   = True
                res2@tmYLLabelsOn   = True         ; turn off lat labels
                plot(i+3)   = gsn_csm_map(wks,res2)
                map1        = plot(i+3)
            else if (i.eq.1) then
                res2@tiYAxisString       = ""
                res2@tmXBLabelsOn   = True
                plot(i+3)   = gsn_csm_map(wks,res2)
                map2        = plot(i+3)
            else
                res2@tiYAxisString       = "SENAMHI"
                res2@tmXBLabelsOn   = True
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
                                ;if all(ismissing(pd_se(:,{coord_x},{coord_y}))) then
                                ;    pd_se(:,{coord_x},{coord_y}) = ppd_s
                                ;else
                                ;    pd_se3 := pd_se2
                                ;    pd_se3(:,{coord_x},{coord_y}) = ppd_s
                                ;    pd_se  := array_append_record(pd_se,pd_se3,0)
                                ;end if
                                if all(ismissing(pd_se)) then
                                    pd_se(0,0)      = ppd_s
                                    pd_se(0,1)      = coord_x
                                    pd_se(0,2)      = coord_y
                                    pd_wrf_p(0,0)   = (/pd_wrf({coord_x},{coord_y})/)
                                    pd_wrf_p(0,1)   = coord_x
                                    pd_wrf_p(0,2)   = coord_y
                                else
                                    pd_se3         := pd_se2
                                    pd_se3(0,0)     = ppd_s
                                    pd_se3(0,1)     = coord_x
                                    pd_se3(0,2)     = coord_y
                                    pd_se  := array_append_record(pd_se,pd_se3,0)
                                    pd_wrf_p3      := pd_wrf_p2
                                    pd_wrf_p3(0,0)  = (/pd_wrf({coord_x},{coord_y})/)
                                    pd_wrf_p3(0,1)  = coord_x
                                    pd_wrf_p3(0,2)  = coord_y
                                    pd_wrf_p  := array_append_record(pd_wrf_p,pd_wrf_p3,0)
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
            ;print(max(pd_se)+"//"+min(pd_se))
            ;printVarSummary(pd_se)
            ;printVarSummary(pd_wrf)
            ;¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬
            ;-----procesando la anomalia
            pd_se(:,1) = 0
            pd_se(:,2) = 0
            anom   := pd_wrf_p-pd_se
            ;anom2  := anom
            res3       = res
            ;res3@mpFillOn := False
            res3@tmXBLabelsOn = True
            pmres2                   = True
            pmres2@gsMarkerSizeF     = 0.015       ;-- set size of marker
            pmres2@gsLineThicknessF  = 3.          ;-- marker line thickness
            pmres2@gsMarkerIndex     = 1
            if (i.eq.0) then
                ;map1 = map
                res3@tmXBLabelsOn = True
                res3@tiYAxisString       = ""
                res3@tmYLLabelsOn   = True         ; turn off lat labels
                plot(i+6)   = gsn_csm_map(wks,res3)
                map4        = plot(i+6)
            else if (i.eq.1) then
                res3@tmXBLabelsOn = True
                res3@tiYAxisString       = ""
                plot(i+6)   = gsn_csm_map(wks,res3)
                map5        = plot(i+6)
            else
                res3@tmXBLabelsOn = True
                res3@tiYAxisString       = "ANOM"
                res3@tiYAxisFontHeightF  = 0.04
                ;res2@tiYAxisFontColor    = "navy"
                res3@tiYAxisSide         = "right"
                res3@tiYAxisAngleF       = 270
                plot(i+6)   = gsn_csm_map(wks,res3)
                map6        = plot(i+6)
            end if
            end if
            do m=0,dimsizes(anom(:,0))-1
                str1  := unique_string("poly1")
                anom2 := anom(m,0) 
                ;print("lluvia antes---->> "+anom2)
                do n=0,nlevels_color2-1
                    if (n.eq.nlevels_color2-1) then
                        ;--> si: ppd >= max -> ppd = max
                        anom2 := where(anom2.ge.max(levels2),max(levels2),anom2)   
                    else if (n.eq.0) then
                        ;--> si: ppd < min -> ppd = min
                        ;if anom2.ge.0 then
                        anom2 := where(anom2.lt.levels2(0),levels2(0),anom2)       
                        ;else
                        ;anom2 := where(anom2.gt.levels2(0),levels2(0),anom2)       
                        ;-45.lt.-50
                        ;-45.ge.-50
                        ;end if
                    else 
                        cond_5:= anom2.le.levels2(n+1)   ;---> si ppd =< val_2
                        ;print(anom2+"//"+levels2(n+1)+"///"+cond_5)
                        cond_6:= anom2.gt.levels2(n)     ;---> si ppd > val_1
                        ;print(anom2+"//"+levels2(n)+"///"+cond_6)
                        ;--> si: val_1 < ppd =< val_2 -> ppd = val_2
                        anom2 := where(cond_5.and.cond_6,levels2(n),anom2)
                        ;ppd_s := where(ppd_s.ge.levels(m-1).and.ppd_s.lt.levels(m),ppd_s,levels(m))
                    end if
                    end if
                    ;print(color_id)
                end do
                color_id               := get1Dindex(levels2,anom2)
                if ismissing(color_id) then
                    print("lluvia antes---->> "+anom2)
                    anom2       := where(anom2.gt.levels2(0),levels2(0),anom2)
                    color_id    := get1Dindex(levels2,anom2)
                    print("lluvia despues---->> "+anom2)
                end if
                ;print("lluvia despues---->> "+anom2)
                pmres2@gsMarkerColor   := colors2(color_id,:) 
                if (i.eq.0) then
                    map4@$str1$ := gsn_add_polymarker(wks,map4,anom(m,2),anom(m,1),pmres2)
                else if (i.eq.1) then
                    map5@$str1$ := gsn_add_polymarker(wks,map5,anom(m,2),anom(m,1),pmres2)
                else
                    map6@$str1$ := gsn_add_polymarker(wks,map6,anom(m,2),anom(m,1),pmres2)
                end if
                end if
            end do
        end do
        resP                    = True                ; modify the panel plot
        resP@gsnMaximize        = True
        ;resP@gsnFrame           = False
        ;resP@gsnDraw            = False
        ;resP@gsnPanelLabelBar   = True                ; add common colorbar
        ;resP@gsnPanelLabelBarScalePlotIndex = 9
        ;resP@lbLabelPosition    = "Top"
        ;resP@lbOrientation      = "Vertical"
        resP@vpHeightF          = 0.6
        ;resP@lbLabelFontHeightF = 0.01               ; make labels smaller
        ;resP@gsnPanelLeft       = 0.04
        ;resP@gsnPanelBottom     = 0.08
        resP@gsnPanelSave       = True
        ;resP@gsnPanelRight      = 0.90
        ;resP@lbTitleOn          = True                  ; turn on title
        ;resP@lbTitlePosition    = "Bottom"
        ;resP@lbTitleString      = "mm/dia"
        ;resP@lbBoxEndCapStyle   = "TriangleHighEnd"
        ;resP@lbTitleFontHeightF = 0.02
        ;resP@lbLabelPosition    = "Top"
        ;resP@pmLabelBarWidthF   = 0.9
        ;resP@pmLabelBarHeightF  = 0.4
        ;resP@pmLabelBarSide     = "Top"
        resP@gsnPanelMainString = "Analisis de lluvia WRF-SENAMHI "+periodo
        resP@gsnPanelRowSpec    = True
        agregando_shapefile1    = gsn_add_shapefile_polylines(wks,plot,shp1,shpres)
        gsn_panel(wks,plot,(/3,3,3/),resP)

        ;lbid := labelbar(wks,shadeplots)
        ;draw(lbid)
        ;frame(wks)
        ;delete([draw,frame])
    end do
end
