;============== %%%% SHAPES %%%% ==============
dirP    = "/data/users/jticse/Tesis-Maestria/SALIDAS/scripts/Tesis-de-Geofisica/" ;--> ruta principal
shp1    = "shapes/cuencas/VertientePacificoCentroNorte.shp" 
shp1    = dirP+shp1     ;--> shape Vertiente Pacifico
;---Detalles del shape---;
shpres                  = True
;shpres@gsLineColor      = "red" ;--> color de linea
shpres@gsLineColor      = "black" ;--> color de linea
shpres@gsLineThicknessF = 1.5     ;3.0   ;--> grosor de linea

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

;============== %%%% HERRAMIENTAS %%%% ==============
load "$NCARG_ROOT/lib/ncarg/nclscripts/contrib/cd_inv_string.ncl"   ;---> para fechas 
load "$NCARG_ROOT/lib/ncarg/nclscripts/contrib/cd_string.ncl"       ;---> para fechas

;============== %%%% CODIGO %%%% ==============
begin
    ;¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬
    ;---periodo
    periodo = "2017-01-14"
    year    = stringtoint(str_get_cols(periodo,0,3))
    mes     = stringtoint(str_get_cols(periodo,5,6))
    dia     = stringtoint(str_get_cols(periodo,8,9))
    ;¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬
    ;-----dimension lat y lon
    lat_max = max_lat_p
    lat_min = min_lat_p
    lon_max = max_lon_p
    lon_min = min_lon_p
    ;¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬
    ;-----Extraendo y procesando datos wrf
    dirWRF  = "/data/users/jticse/WRFV4/wrfout/periodos/"
    f_wrf   = addfile(dirWRF+"wrfout_d02_"+periodo+"_00:00:00.nc", "r")
    t_wrf   = wrf_user_list_times(f_wrf)
    format  = "%Y-%N-%D_%H:%M:%S"
    t_wrf  := cd_inv_string(t_wrf, format)
    un_wrf  = t_wrf@units  
    rcv     = wrf_user_getvar(f_wrf,"RAINC",-1)
    rncv    = wrf_user_getvar(f_wrf,"RAINNC",-1)
    it_wrf  = cd_inv_calendar(year,mes,dia,5,0,0,un_wrf,0)
    ft_wrf  = cd_inv_calendar(year,mes,dia+1,5,0,0,un_wrf,0)
    id_tiw  = get1Dindex(t_wrf,it_wrf)
    id_tfw  = get1Dindex(t_wrf,ft_wrf)
    rcvi    = rcv(id_tiw,:,:)
    rcvf    = rcv(id_tfw,:,:)
    rncvi   = rncv(id_tiw,:,:)
    rncvf   = rncv(id_tfw,:,:)
    pd_wrf  = (rcvf-rcvi)+(rncvf-rncvi)  
    ;print(it_wrf+"==="+id_tiw)
    printVarSummary(pd_wrf)
    ;¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬
    ;-----Extraendo y procesando datos pisco
    dirPI   = "/data/users/jticse/data/piscopd-17-18/"  
    fnc_pi  = addfile("/data/users/jticse/data/pisco21ppd_perc_e_MAR.nc","r")  
    nc_pi   = fnc_pi->ppd_pi_e_per
    x1      = asciiread(dirPI+periodo+".asc",-1,"float")
    nlon    = toint(x1(0))
    nlat    = toint(x1(1))
    pd_pi  := onedtond(x1(6:),(/nlat,nlon/))
    pd_pi   = where(pd_pi.ge.0,pd_pi,pd_pi@_FillValue)
    pd_pi!0               = "latitude"
    pd_pi&latitude        = nc_pi&latitude
    pd_pi&latitude@units  = nc_pi&latitude@units
    pd_pi!1               = "longitude"
    pd_pi&longitude       = nc_pi&longitude
    pd_pi&longitude@units = nc_pi&longitude@units
    printVarSummary(pd_pi)
    ;¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬
    ;-----Extraendo y procesando datos senamhi
    f_est_se  = "/data/users/jticse/data/estaciones_senamhi/*.csv"
    f_est_se := systemfunc("ls "+f_est_se)
    ;f_data_se = "/data/users/jticse/data/senamhi_vertpac_cn.csv"
    f_data_se = "/data/users/jticse/data/senamhi-17-18.csv"
    fc_sen   := asciiread(f_data_se,-1,"string")
    fc_sen   := str_split_csv(fc_sen(1:),",",0)
    dim_fc    = dimsizes(fc_sen(:,0))
    fecha_s   = cd_string(it_wrf,"%D-%N-%Y")   
    print("Fecha Senamhi "fecha_s) 
    do j=0,dim_fc-1
        cod_est    := fc_sen(j,0)
        id_est     := str_match_ind(f_est_se,cod_est)
        print("Fecha "+periodo+" Estacion "+cod_est+" Id "+tostring(id_est))
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
                    print("lluvia anterior "+tostring(ppd_s))
                    str        := unique_string("poly")
                    coord_x    := tofloat(fc_sen(j,1)) ;--> lat
                    coord_y    := tofloat(fc_sen(j,2)) ;--> lon
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
                            ;ppd_s := where(ppd_s.ge.levels(m-1).and.ppd_s.lt.levels(m),ppd_s,levels(m))
                        end if
                        end if
                    end do
                    print("lluvia nueva "+tostring(ppd_s))
                    color_id               := get1Dindex(levels,ppd_s)
                    ;pmres@gsMarkerColor    := colors(color_id,:) 
                end if
            end if
        end if
end