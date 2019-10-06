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
    ;-----Extraendo datos wrf
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
    printVarSummary(rcv)
    printVarSummary(rncv)
    printVarSummary(t_wrf)
    rcvi    = rcv(id_tiw,:,:)
    rcvf    = rcv(id_tiw,:,:)
    printVarSummary(rcvi)
    printVarSummary(rcvf) 
end