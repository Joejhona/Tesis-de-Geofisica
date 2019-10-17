;¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬
;--- Cargando extensiones ncl
load "$NCARG_ROOT/lib/ncarg/nclscripts/contrib/cd_string.ncl"
;¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬
;--- Cargando extensiones propias
root = systemfunc("pwd")    ; ¿¿¿ only linux ???
load "/data/users/jticse/aldo/gpcp-ppd/colores.ncl"
;¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬
;--- Helpers
s="-"
begin
    ;¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬
    ;---dimension tiempo
    ;---NOMBRE = (AÑO,MES,DIA)
    dia1 = (/2009,04,08/)
    dia2 = (/2010,03,15/)
    dia3 = (/2011,12,25/)
    dia  = dia3
    ;¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬
    ;--- VALORES DEL PRIMER DOMINIO
    ;-----dimension lat y lon
    lat_max_D1 = 1.292385
    lat_min_D1 = -20.91429
    lon_max_D1 = -65.7114
    lon_min_D1 = -84.2886
    ;¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬
    ;-----redimesionamiento
    x_D1 = 114
    y_D1 = 139
    ;¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬
    ;--- VALORES DEL SEGUNDO DOMINIO
    ;-----dimension lat y lon
    lat_max_D2 = -8.485573
    lat_min_D2 = -15.97761
    lon_max_D2 = -71.7394
    lon_min_D2 = -77.9318
    ;¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬
    ;-----redimesionamiento
    x_D2 = 114
    y_D2 = 141
    ;¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬
    ;----- LATITUD GPCP-201112 [+90:-90]-->[MAX:MIN]
    lat_max = lat_max_D2
    lat_min = lat_min_D2
    ;----- LONGITUD GPCP-201112 [0:360]-->[Min:Max]
    lon_max = lon_max_D2
    lon_min = lon_min_D2
    ;¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬
    ;-----redimesionamiento
    x = x_D2
    y = y_D2
    lon_D = fspan(lon_min,lon_max,x)
    lat_D = fspan(lat_min,lat_max,y)
    ;¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬
    ;-----Extraendo datos gpcp
    ;dir_gpcp    = "/data/users/jticse/data/aldo/GPCP_1degree_GlobalDaily/"
    dir_gpcp    = "/data/users/jticse/data/aldo/netcdf/"
    gpcp1       = "gpcp_1dd_v1.2_p1d.200904.nc"
    gpcp2       = "gpcp_1dd_v1.2_p1d.201003.nc"
    gpcp3       = "GPCP.1DD.201112.nc"; ---> convertido a netcdf por mi ---> revisar
    ;f_gpcp     := (/dir_gpcp+gpcp1,dir_gpcp+gpcp2/);,dir_gpcp+gpcp2/)
    f_gpcp     := (/dir_gpcp+gpcp3/)
    f_gpcp     := addfiles(f_gpcp, "r")
    ListSetType (f_gpcp, "cat")         ;---> concatena(cat=default o join)
    time_gpcp   = f_gpcp[:]->time       ;---> extrae tiempo de los archivos
    ;ppd_gpcp    = f_gpcp[:]->precip     ;---> para los otros
    ppd_gpcp    = f_gpcp[:]->PREC      ;---> para gpcp3
    lon_gpcp    = f_gpcp[0]->lon
    lat_gpcp    = f_gpcp[0]->lat
    ;¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬
    ;-----Extraendo datos chirp
    dir_chirp   = "/data/datos/CHIRPS/"                                                 ;--->ruta 
    f_chirp     = systemfunc("ls "+dir_chirp+"ATrop.chirps-v2.0.20*.nc")                     ;--->llama archivos   
    f_chirp    := addfiles(f_chirp, "r")
    ppd_chirp   = f_chirp[:]->precip        ;--->extrae precipitacion de los archivos
    lat_chirp   = f_chirp[0]->latitude
    lon_chirp   = f_chirp[0]->longitude
    time_chirp  = f_chirp[:]->time    
    ;¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬
    ;-----Extraendo indices chirp
    time_search:= cd_inv_calendar(dia(0),dia(1),dia(2),0,0,0,time_chirp@units,0) ;---> solo para el netcdf convertido por mi
    id_time_c   = get1Dindex(time_chirp,time_search)
    id_lamin_c  = ind_nearest_coord(lat_min,lat_chirp,0)-2 
    id_lamax_c  = ind_nearest_coord(lat_max,lat_chirp,0)+2
    id_lomax_c  = ind_nearest_coord(lon_max,lon_chirp,0)+2
    id_lomin_c  = ind_nearest_coord(lon_min,lon_chirp,0)-2
    print("=== Verificar si esta dentro o fuera CHIRP ===")
    print("Latitud ==> "+lat_chirp(id_lamin_c)+" ¿es mayor que? "+lat_min)
    print("Latitud ==> "+lat_chirp(id_lamax_c)+" ¿es mayor que? "+lat_max)
    print("Longitud ==> "+lon_chirp(id_lomin_c)+" ¿es mayor que? "+lon_min)
    print("Longitud ==> "+lon_chirp(id_lomax_c)+" ¿es mayor que? "+lon_max)
    ;¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬
    ;-----Extraendo indices gpcp
    ;time_search = cd_inv_calendar(dia(0),dia(1),dia(2),0,0,0,time_gpcp@units,0)
    time_search:= cd_inv_calendar(dia(0),dia(1),dia(2),12,0,0,time_gpcp@units,0) ;---> solo para el netcdf convertido por mi
    id_time_g   = get1Dindex(time_gpcp,time_search)
    id_lamin_g  = ind_nearest_coord(lat_min,lat_gpcp,0)-1 
    id_lamax_g  = ind_nearest_coord(lat_max,lat_gpcp,0)+1
    id_lomax_g  = ind_nearest_coord(lon_max+360,lon_gpcp,0)+1 ;--> +360 solo para gpcp3
    id_lomin_g  = ind_nearest_coord(lon_min+360,lon_gpcp,0)-1 ;--> +360 solo para gpcp3
    print("=== Verificar si esta dentro o fuera GPCP ===")
    print("Latitud ==> "+lat_gpcp(id_lamin_g)+" ¿es mayor que? "+lat_min)
    print("Latitud ==> "+lat_gpcp(id_lamax_g)+" ¿es mayor que? "+lat_max)
    print("Longitud ==> "+lon_gpcp(id_lomin_g)+" ¿es mayor que? "+lon_min)
    print("Longitud ==> "+lon_gpcp(id_lomax_g)+" ¿es mayor que? "+lon_max)
    ;¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬
    ;-----Precipitacion de dominios chirp
    ppd_chirp  := ppd_chirp(id_time_c,id_lamin_c:id_lamax_c,id_lomin_c:id_lomax_c)
    lon_D      := fspan(lon_min,lon_max,x)
    ppd_chirp_D = linint2(ppd_chirp&longitude,ppd_chirp&latitude,ppd_chirp,False,lon_D,lat_D,0)
    ppd_chirp_D!0                = "latitude"        ;--->rotulo lat
    ppd_chirp_D!1                = "longitude"       ;--->rotulo lon 
    ppd_chirp_D&latitude         = lat_D            
    ppd_chirp_D&longitude        = lon_D
    ppd_chirp_D&latitude@units   = "degrees_north"   ;--->und lat
    ppd_chirp_D&longitude@units  = "degrees_east"    ;--->und lon
    ;¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬
    ;-----Precipitacion de dominios gpcp
    ;ppd_gpcp   := ppd_gpcp(id_time_g,id_lamin_g:id_lamax_g,id_lomin_g:id_lomax_g)
    ppd_gpcp   := ppd_gpcp(id_time_g,id_lamax_g-2:id_lamin_g+2,id_lomin_g:id_lomax_g) 
    ppd_gpcp   := ppd_gpcp(::-1,:)                 ;---> invirtiendo la latitud para que este en forma creciente
    lon_D      := fspan(lon_min+360,lon_max+360,x)  ;---> solo para gpcp3
    ppd_gpcp_D  = linint2(ppd_gpcp&lon,ppd_gpcp&lat,ppd_gpcp,False,lon_D,lat_D,0)
    ppd_gpcp_D!0                = "latitude"        ;--->rotulo lat
    ppd_gpcp_D!1                = "longitude"       ;--->rotulo lon 
    ppd_gpcp_D&latitude         = lat_D            
    ppd_gpcp_D&longitude        = lon_D
    ppd_gpcp_D&latitude@units   = "degrees_north"   ;--->und lat
    ppd_gpcp_D&longitude@units  = "degrees_east"    ;--->und lon
    ;¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬
    ;-----Preparando plot gpcp
    type        = "png"
    ;type        = "x11"
    titulo1     = "precip-"+tostring(x)+"x"+tostring(y)
    form_time   = "%D-%N-%Y"
    time_str   := cd_string(time_gpcp(id_time_g),form_time)
    wks         = gsn_open_wks(type,titulo1+s+time_str)
    plot        = new(4,graphic)
    ;¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬
    ;-----Creando NetCDF GPCP y CHIRP
    dir_out      = "/data/users/jticse/aldo/"
    ;netcdf         := addfile(dir_out+titulo1+s+time_str+"-GPCP.nc","c")
    ;netcdf->precip  = ppd_gpcp_D
    ;netcdf         := addfile(dir_out+titulo1+s+time_str+"-CHIRP.nc","c")
    ;netcdf->precip  = ppd_chirp_D
    ;¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬
    ;-----Creando ASCII GPCP
    dimx  = dimsizes(ppd_gpcp_D)
    nlat  = dimx(0)
    mlon  = dimx(1)
    npts  = nlat*mlon        ; total number of grid points
    data  = new(npts,string)
    npt   = -1
    do nl=0,nlat-1          
      do ml=0,mlon-1
        npt  = npt + 1     
        data(npt) = sprintf("%7.5f ",ppd_gpcp_D&latitude(nl))
        data(npt) = data(npt) + sprintf("%7.5f ",ppd_gpcp_D&longitude(ml))
        if (ismissing(ppd_gpcp_D(nl,ml))) then
          data(npt) = data(npt) + "-999.0"
        else
          data(npt) = data(npt) + sprintf("%10.7f",ppd_gpcp_D(nl,ml))
        end if
      end do
    end do
    asciiwrite(dir_out+titulo1+s+time_str+"-GPCP", data)
    ;-----Creando ASCII CHIRP
    data := new(npts,string)
    npt  := -1
    do nl=0,nlat-1          
      do ml=0,mlon-1
        npt  = npt + 1     
        data(npt) = sprintf("%7.5f ",ppd_chirp_D&latitude(nl))
        data(npt) = data(npt) + sprintf("%7.5f ",ppd_chirp_D&longitude(ml))
        if (ismissing(ppd_chirp_D(nl,ml))) then
          data(npt) = data(npt) + "-999.0"
        else
          data(npt) = data(npt) + sprintf("%10.7f",ppd_chirp_D(nl,ml))
        end if
      end do
    end do
    asciiwrite(dir_out+titulo1+s+time_str+"-CHIRP", data)
    ;¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬
    ;-----Alistando los detalles
    ;¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬
    ;-----Extraendo y ploteando datos wrf
    res                     = True      ;--> activa los detalles
    res@gsnDraw             = False     ;True     ;---> Para no superponer
    res@gsnFrame            = False     ;True     ;---> Para ver una por una 
    res@gsnMaximize         = True
    ;res@tiMainString        = "GPCP 1DD V1.2 Combined Data Sets"
    res@gsnLeftString       = ""        ;time_str
    res@gsnAddCyclic        = False     ;--> Necesario datos ciclicos
    ;---Grid Text--Grilla---;
    res@gsnMajorLatSpacing  = 2
    res@gsnMajorLonSpacing  = 2
    res@tmYLLabelStride     = 1
    res@tmXBLabelStride     = 1
    ;-------Limites del Mapa--------;     
    res@mpLimitMode         = "Corners" ;--> Activa limites modo corners
    res@mpLeftCornerLatF    = lat_min   ;--> limites.ncl r=rimac p=Perú   
    res@mpRightCornerLatF   = lat_max   ;--> n=Norte
    res@mpLeftCornerLonF    = lon_min
    res@mpRightCornerLonF   = lon_max
    ;---Limites Nacionales---;
    res@mpOutlineBoundarySets       = "National"    ;---> Limite de Paises
    res@mpNationalLineThicknessF    = 2             ;---> Grosor de linea nacional
    res@mpGeophysicalLineThicknessF = 2             ;---> Grosor de linea continental
    ;---Grid--Grilla---;
    res@mpGridAndLimbOn     = True
    res@mpGridLatSpacingF   = 0.5
    res@mpGridLonSpacingF   = 0.5
    res@mpGridLineColor     = "Gray30"
    ;---Estilo de los datos---;
    res@cnFillOn            = True
    res@cnFillPalette       = color_paleta
    res@cnLinesOn           = False             ;---> Contorno de linea (falso = no)
    res@cnLineLabelsOn      = False
    res@lbLabelBarOn        = False     ;True   ;---> desactiva la paleta individual
    res@cnLevelSelectionMode= "ExplicitLevels"  ;---> Solo usa los indicados en levels
    res@cnLevels            = levels
    ;¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬
    
    plot(0) = gsn_csm_contour_map(wks,ppd_gpcp,res)
    plot(1) = gsn_csm_contour_map(wks,ppd_gpcp_D,res)
    plot(2) = gsn_csm_contour_map(wks,ppd_chirp,res)
    plot(3) = gsn_csm_contour_map(wks,ppd_chirp_D,res)
    ;¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬
    ;-----Detalles del plot general
    plotres                        = True
    plotres@gsnPanelRowSpec        = True                   ; tell panel what order to plot
    plotres@gsnPanelLabelBar       = True                               ;---> barra comun
    plotres@gsnPanelMainString     = "GPCPvsCHIRPS-"+titulo1+s+time_str ;---> titulo
    plotres@lbOrientation          = "vertical"                         ;---> Barra vertical
    plotres@gsnPanelFigureStrings  = (/"GPCP","GPCP-"+tostring(x)+"x"+tostring(y)\
                                    ,"CHIRP","CHIRP-"+tostring(x)+"x"+tostring(y)/)
    plotres@amJust                 = "BottomLeft"
    gsn_panel(wks,plot,(/2,2/),plotres)
end
