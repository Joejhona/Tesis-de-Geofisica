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
    ;dom = (/"-d01","_d01_","d01"/)
    dom = (/"-d02","_d02_","d02"/)
    ;----------- WRF
    dirWRF  = "/data/users/jticse/Tesis-Maestria/SALIDAS/netcdf/wrf/primera_corrida/"
    f_wrf  := addfile(dirWRF+"wrfout"+dom(1)+periodos(0)+"_00:00:00.nc", "r")
    dim_wrf = wrf_user_getvar(f_wrf,"SST",-1)
    dim_wrf:= dimsizes(dim_wrf)
    lat_w  := wrf_user_getvar(f_wrf,"XLAT",0)
    lat_w  := lat_w(:,0)
    lon_w  := wrf_user_getvar(f_wrf,"XLONG",0)
    lon_w  := lon_w(0,:)
    ;----------- SST
    sst_new = new((/dimsizes(periodos),dim_wrf(1),dim_wrf(2),dimsizes(horas)/),float)
    
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
        sst     = wrf_user_getvar(f_wrf,"SST",-1)
        do i=0,2
            ;----------- WRF
            it_wrf := cd_inv_calendar(year,mes,dia+i,12,0,0,un_wrf,0)   ;---->> hora de inicio de lluvia
            ;ft_wrf := cd_inv_calendar(year,mes,dia+1+i,12,0,0,un_wrf,0) ;---->> hora de inicio de lluvia
            id_tiw := get1Dindex(t_wrf,it_wrf)
            ;id_tfw := get1Dindex(t_wrf,ft_wrf)
            ;ssti   := sst(id_tiw,:,:)
            ;sstf   := sst(id_tfw,:,:)
            sst_wrf := sst(id_tiw,:,:)
            ;sst_wrf:= sstf-ssti
            ;pd_wrf@lat2d := lat_w
            ;pd_wrf@lon2d := lon_w  
            sst_new(j,:,:,i) = (/sst_wrf/)
            printVarSummary(sst_wrf)
        end do
    end do

    ;---Open a new NetCDF file to write to
    dir_fout    = "/data/users/jticse/Tesis-Maestria/SALIDAS/netcdf/"
    fout_name   = "sst-wrf"+dom(2)+".nc"
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

    var01   = sst_new
    var01!0 = time!0
    var01!1 = lat!0
    var01!2 = lon!0
    var01!3 = hrs!0
    var01&time  = time
    var01&lat   = lat
    var01&lon   = lon
    var01&hrs   = hrs
    var01@long_name = "SST"+dom(0)
    var01@units = "K"

    dims        = dimsizes(var01)
    dim_names   = getvardims(var01)
    dim_unlimited = (/False,False,False,False/)
    filedimdef(fout,dim_names,dims,dim_unlimited)

    filevardef(fout,"time",typeof(var01&time),"time")
    filevardef(fout,"lat",typeof(var01&lat),"lat")
    filevardef(fout,"lon",typeof(var01&lon),"lon")
    filevardef(fout,"hrs",typeof(var01&hrs),"hrs")
    filevardef(fout,"var01",typeof(var01),dim_names)

    filevarattdef(fout,"time",var01&time)
    filevarattdef(fout,"lat",var01&lat)
    filevarattdef(fout,"lon",var01&lon)
    filevarattdef(fout,"hrs",var01&hrs)
    filevarattdef(fout,"var01",var01)

    fout->time  = (/var01&time/)
    fout->lat   = (/var01&lat/)
    fout->lon   = (/var01&lon/)
    fout->hrs   = (/var01&hrs/)
    fout->var01 = (/var01/)

end
