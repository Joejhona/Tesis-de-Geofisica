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

levels2 = (/-2.,-1.5,-1.,-0.75,\
        -0.5,-0.25,0,0.25,0.5,\
        0.75,1.,1.5,2./) 
color_paleta2 = "precip_diff_12lev";--> paleta 12 colores
nlevels_color2= dimsizes(levels2) ;--> Cantidad de colores 
colors2       = span_color_rgba(color_paleta2,nlevels_color2+1)

;============== %%%% HERRAMIENTAS %%%% ==============
load "$NCARG_ROOT/lib/ncarg/nclscripts/contrib/cd_inv_string.ncl"   ;---> para fechas 
load "$NCARG_ROOT/lib/ncarg/nclscripts/contrib/cd_string.ncl"       ;---> para fechas

;============== %%%% CODIGO %%%% ==============
begin
    ;¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬
    ;---periodo
    ;periodo = "2017-01-14"
    ;periodo = "2017-01-21"
    ;periodo = "2017-01-24"
    ;periodo = "2017-01-30"
    ;periodo = "2017-02-02"
    ;periodo = "2017-02-25"
    ;periodo = "2017-03-08"
    ;periodo = "2017-03-13"
    ;periodo = "2017-03-21"
    ;periodo = "2017-03-25"
    ;periodo = "2018-01-10"
    ;periodo = "2018-01-16"
    ;periodo = "2018-01-21"
    ;periodo = "2018-02-14"
    ;periodo = "2018-02-17"
    ;periodo = "2018-03-05"
    ;periodo = "2018-03-17"
    periodo = "2018-03-22"
    year    = stringtoint(str_get_cols(periodo,0,3))
    mes     = stringtoint(str_get_cols(periodo,5,6))
    dia     = stringtoint(str_get_cols(periodo,8,9))
    ;¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬
    ;----- creando mapa ------;
    type    = "png"
    ;type    = "x11"
    dirS    = "/data/users/jticse/Tesis-Maestria/SALIDAS/figuras/"
    type@wkWidth     = 7000
    type@wkHeight    = 7000             
    wks     = gsn_open_wks(type,dirS+periodo+"-d02")   
    plot    = new(6,graphic)
    plot2   = new(3,graphic)
    ;¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬
    ;----- agregando detalles al mapa -----;
    res                     = True      ;--> activa los detalles
    res@gsnDraw             = False     ;--> don't draw the plot yet
    res@gsnFrame            = False     ;--> 
    res@gsnMaximize         = True
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
    res@cnFillOn            = False ;True
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
    ;-----Extraendo y procesando datos wrf
    dirWRF  = "/data/users/jticse/WRFV4/wrfout/periodos/"
    f_wrf   = addfile(dirWRF+"wrfout_d02_"+periodo+"_00:00:00.nc", "r")
    ;f_wrf   = addfile(dirWRF+"wrfout_d01_"+periodo+"_00:00:00.nc", "r")
    lat_w   = wrf_user_getvar(f_wrf,"XLAT",0)
    lat_w  := lat_w(:,0)
    lon_w   = wrf_user_getvar(f_wrf,"XLONG",0)
    lon_w  := lon_w(0,:)
    t_wrf   = wrf_user_list_times(f_wrf)
    format  = "%Y-%N-%D_%H:%M:%S"
    t_wrf  := cd_inv_string(t_wrf, format)
    un_wrf  = t_wrf@units  
    rcv     = wrf_user_getvar(f_wrf,"RAINC",-1)
    rncv    = wrf_user_getvar(f_wrf,"RAINNC",-1)
    do i=0,2
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
        printVarSummary(pd_wrf)
        res1                   := res
        res1@gsnCenterString   := cd_string(it_wrf,"%D-%N-%Y") 
        res1@gsnCenterStringFontHeightF = 0.04
        ;plot(0) = gsn_csm_contour_map(wks,ppd_pi_e_per99,res1)
        if (i.eq.0) then
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
        ;end do
        ;¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬
        ;-----Extraendo y procesando datos pisco
        dirPI   = "/data/users/jticse/data/piscopd-17-18/"  
        fnc_pi  = addfile("/data/users/jticse/data/pisco21ppd_perc_e_MAR.nc","r")  
        nc_pi   = fnc_pi->ppd_pi_e_per
        ;delete(res@tiYAxisString)
        ;delete(res@tiYAxisFontHeightF)
        ;delete(res@tiYAxisSide)
        ;delete(res@tiYAxisAngleF)
        ;do l=0,2
        t_pi    = cd_inv_calendar(year,mes,dia+i,0,0,0,"days since 1971-1-1",0)
        x1     := asciiread(dirPI+cd_string(t_pi,"%Y-%N-%D")+".asc",-1,"float")
        nlon   := toint(x1(0))
        nlat   := toint(x1(1))
        pd_pi  := onedtond(x1(6:),(/nlat,nlon/))
        pd_pi   = where(pd_pi.ge.0,pd_pi,pd_pi@_FillValue)
        pd_pi!0               = "latitude"
        pd_pi&latitude        = nc_pi&latitude
        pd_pi&latitude@units  = nc_pi&latitude@units
        pd_pi!1               = "longitude"
        pd_pi&longitude       = nc_pi&longitude
        pd_pi&longitude@units = nc_pi&longitude@units
        pd_pi := pd_pi(::-1,:)                 ;---> invirtiendo la latitud para que este en forma creciente
        printVarSummary(pd_pi)
        res2                 := res
        ;res1@gsnCenterString   := cd_string(it_wrf,"%D-%N-%Y") 
        ;plot(0) = gsn_csm_contour_map(wks,ppd_pi_e_per99,res1)
        if (i.eq.0) then
            res2@tmYLLabelsOn        = True         ; turn off lat labels
        else if (i.eq.2) then
            res2@tiYAxisString       = "PISCO"
            res2@tiYAxisFontHeightF  = 0.04
            ;res@tiYAxisFontColor    = "navy"
            res2@tiYAxisSide         = "right"
            res2@tiYAxisAngleF       = 270
        end if
        end if
        plot(i+3) = gsn_csm_contour_map(wks,pd_pi,res2)
        ;¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬
        ;-----procesando la anomalia
        ;pd_pi_ip = linint2(pd_pi&longitude,pd_pi&latitude,pd_pi,False,lon_w(0,:),lat_w(:,0),0)
        pd_pi_ip  := linint2(pd_pi&longitude,pd_pi&latitude,pd_pi,False,lon_w,lat_w,0)
        pd_pi_ip!0                = "latitude"        ;--->rotulo lat
        pd_pi_ip!1                = "longitude"       ;--->rotulo lon 
        pd_pi_ip&latitude         = lat_w            
        pd_pi_ip&longitude        = lon_w
        pd_pi_ip&latitude@units   = "degrees_north"   ;--->und lat
        pd_pi_ip&longitude@units  = "degrees_east"    ;--->und lon
        printVarSummary(pd_wrf)
        printVarSummary(pd_pi_ip)
        anom  := pd_wrf-pd_pi_ip
        anom!0                = "latitude"        ;--->rotulo lat
        anom!1                = "longitude"       ;--->rotulo lon 
        anom&latitude         = lat_w            
        anom&longitude        = lon_w
        anom&latitude@units   = "degrees_north"   ;--->und lat
        anom&longitude@units  = "degrees_east"    ;--->und lon
        printVarSummary(anom)
        res3                 := res
        ;res2@cnLevelSelectionMode= "ExplicitLevels"   ; manual set levels
        res3@cnFillPalette      := color_paleta2
        res3@cnLevels           := levels2
        plot2(i) = gsn_csm_contour_map(wks,anom,res3)
    end do
    ;delete(res@tiYAxisString)
    ;delete(res@tiYAxisFontHeightF)
    ;delete(res@tiYAxisSide)
    ;delete(res@tiYAxisAngleF)
    dims1 = (/2,3/)
    dims2 = (/1,3/)

    pres1 = True
    pres2 = True
    pres  = True

    pres1@lbLabelFontHeightF = 0.01     ; make labels slightly larger
    pres2@lbLabelFontHeightF = 0.01
    pres1@gsnPanelMainString = "Analisis de lluvia WRF - PISCO"
    panel_two_sets(wks,plot,plot2,dims1,dims2,pres1,pres2,pres)
end
