load "./panel_two_sets.ncl"

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
;---Limites del Perú---;
min_lat_p = -19.5
max_lat_p = 0.5
min_lon_p = -82.
max_lon_p = -67.

;============== %%%% COLORES %%%% ==============
levels = (/0.1,0.2,0.3,0.4,0.5,0.6,0.7,\
    0.8,0.9,1.,1.5,2.,2.5,3.,3.5,\
    4.,4.5,5.,6.,7.,8.,\
    9.,10.,15.,20.,25.,30.,35.,40.,\
    45.,50.,55.,60.,65.,70.,75.,\
    80.,85.,90.,95.,100./)
color_paleta = "WhBlGrYeRe"

;============== %%%% HERRAMIENTAS %%%% ==============
load "$NCARG_ROOT/lib/ncarg/nclscripts/contrib/cd_inv_string.ncl"   ;---> para fechas 
load "$NCARG_ROOT/lib/ncarg/nclscripts/contrib/cd_string.ncl"       ;---> para fechas

begin
    ;¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬
    periodos = (/"2017-01-14","2017-01-21","2017-01-24","2017-01-30","2017-02-02",\
        "2017-02-25","2017-03-08","2017-03-13","2017-03-21","2017-03-25",\
        "2018-01-10","2018-01-16","2018-01-21","2018-02-14","2018-02-17",\
        "2018-03-05","2018-03-17","2018-03-22"/)
    horas = (/"24 hrs","48 hrs","72 hrs"/)
    dom = (/"-d01","_d01_","d01"/)
    ;dom = (/"-d02","_d02_"/)
    ;----------- WRF
    dirWRF  = "/data/users/jticse/Tesis-Maestria/SALIDAS/netcdf/wrf/primera_corrida/"
    f_wrf  := addfile(dirWRF+"wrfout"+dom(1)+periodos(0)+"_00:00:00.nc", "r")
    dim_wrf = wrf_user_getvar(f_wrf,"RAINC",-1)
    dim_wrf = dimsizes(dim_wrf)
    lat_w  := wrf_user_getvar(f_wrf,"XLAT",0)
    lat_w  := lat_w(:,0)
    lon_w  := wrf_user_getvar(f_wrf,"XLONG",0)
    lon_w  := lon_w(0,:)
    ;----------- PISCO
    dirPI   = "/data/users/jticse/Tesis-Maestria/PREDATA/piscopd-17-18/"
    fnc_pi  = addfile("/data/users/jticse/Tesis-Maestria/SALIDAS/netcdf/percentiles/pisco21ppd_perc_e_MAR.nc","r")  
    nc_pi   = fnc_pi->ppd_pi_e_per
    ;----------- BIAS
    bias    = new((/dimsizes(periodos),dim_wrf(1),dim_wrf(2),dimsizes(horas),2/),float)
    
    do j=0,dimsizes(periodos)-1
        periodo = periodos(j)
        year    = stringtoint(str_get_cols(periodo,0,3))
        mes     = stringtoint(str_get_cols(periodo,5,6))
        dia     = stringtoint(str_get_cols(periodo,8,9))
        ;¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬
        ;-----Extraendo y procesando datos wrf
        f_wrf  := addfile(dirWRF+"wrfout"+dom(1)+periodo+"_00:00:00.nc", "r")
        t_wrf  := wrf_user_list_times(f_wrf)
        format  = "%Y-%N-%D_%H:%M:%S"
        t_wrf  := cd_inv_string(t_wrf, format)
        un_wrf  = t_wrf@units  
        rcv     = wrf_user_getvar(f_wrf,"RAINC",-1)
        rncv    = wrf_user_getvar(f_wrf,"RAINNC",-1)
        do i=0,2
            ;----------- WRF
            it_wrf := cd_inv_calendar(year,mes,dia+i,12,0,0,un_wrf,0)   ;---->> hora de inicio de lluvia
            ft_wrf := cd_inv_calendar(year,mes,dia+1+i,12,0,0,un_wrf,0) ;---->> hora de inicio de lluvia
            id_tiw := get1Dindex(t_wrf,it_wrf)
            id_tfw := get1Dindex(t_wrf,ft_wrf)
            rcvi   := rcv(id_tiw,:,:)
            rcvf   := rcv(id_tfw,:,:)
            rncvi  := rncv(id_tiw,:,:)
            rncvf  := rncv(id_tfw,:,:)
            pd_wrf := (rcvf-rcvi)+(rncvf-rncvi)
            ;pd_wrf@lat2d := lat_w
            ;pd_wrf@lon2d := lon_w  
            bias(j,:,:,i,0) = (/pd_wrf/)
            printVarSummary(pd_wrf)
            ;----------- PISCO
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
            pd_pi_ip = linint2(pd_pi&longitude,pd_pi&latitude,pd_pi,False,lon_w,lat_w,0)
            bias(j,:,:,i,1) = (/pd_pi_ip/)
        end do
    end do

    ;---Open a new NetCDF file to write to
    dir_fout    = "/data/users/jticse/Tesis-Maestria/SALIDAS/netcdf/"
    fout_name   = "bias-wrf"+dom(2)+"-pisco.nc"
    system("rm -f "+dir_fout+fout_name)
    fout        = addfile(dir_fout+fout_name,"c")

    format := "%Y-%N-%D"
    time   := cd_inv_string(periodos, format)
    time!0  = "time"

    lat    := (/lat_w/)
    lat!0   = "lat"
    lat@long_name = "latitude"
    lat@units     = "degrees_north"

    lon    := (/lon_w/)
    lon!0   = "lon"
    lon@long_name = "longitude"
    lon@units     = "degrees_east"

    hrs     = (/24,48,72/)
    hrs!0   = "hrs"
    hrs@long_name = "horas"

    var01   = bias(:,:,:,:,0)
    var01!0 = time!0
    var01!1 = lat!0
    var01!2 = lon!0
    var01!3 = hrs!0
    var01&time  = time
    var01&lat   = lat
    var01&lon   = lon
    var01&hrs   = hrs
    var01@long_name = "WRF"+dom(0)
    var01@units = "mm/dia"

    var02   = bias(:,:,:,:,1)
    var02!0 = time!0
    var02!1 = lat!0
    var02!2 = lon!0
    var02!3 = hrs!0
    var02&time  = time
    var02&lat   = lat
    var02&lon   = lon
    var02&hrs   = hrs
    var02@long_name = "WRF"+dom(0)
    var02@units = "mm/dia"

    dims        = dimsizes(var01)
    dim_names   = getvardims(var01)
    dim_unlimited = (/False,False,False,False/)
    filedimdef(fout,dim_names,dims,dim_unlimited)

    filevardef(fout,"time",typeof(var01&time),"time")
    filevardef(fout,"lat",typeof(var01&lat),"lat")
    filevardef(fout,"lon",typeof(var01&lon),"lon")
    filevardef(fout,"hrs",typeof(var01&hrs),"hrs")
    filevardef(fout,"var01",typeof(var01),dim_names)
    filevardef(fout,"var02",typeof(var02),dim_names)

    filevarattdef(fout,"time",var01&time)
    filevarattdef(fout,"lat",var01&lat)
    filevarattdef(fout,"lon",var01&lon)
    filevarattdef(fout,"hrs",var01&hrs)
    filevarattdef(fout,"var01",var01)
    filevarattdef(fout,"var02",var02)

    fout->time  = (/var01&time/)
    fout->lat   = (/var01&lat/)
    fout->lon   = (/var01&lon/)
    fout->hrs   = (/var01&hrs/)
    fout->wrf   = (/var01/)
    fout->pisco = (/var02/)

end do