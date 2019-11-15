begin

diri        = "/data/users/jticse/Tesis-Maestria/PREDATA/TRMM_3B42_3H_25_FEB_2019/"                             ; input directory
fili        = "3B42.20190225.03.7.HDF"            ; binary uncompressed
f           = addfile (diri+fili,"r")
work        = f->precipitation                   ; (scan, longitude, latitude)
prc         = work(nlat|:,nlon|:)
nlat        = 400
mlon        = 1440
lat         = ispan(0,nlat-1,1)*0.25 -  49.875
lon         = ispan(0,mlon-1,1)*0.25 - 179.875
lat@long_name = "latitude"
lat@units   = "degrees_north"
lat!0       = "lat"
lat&lat     =  lat
lon@long_name = "longitude"
lon@units   = "degrees_east"
lon!0       = "lon"
lon&lon     =  lon
prc!0       = "lat"                   ; 1st ... name the dimensions
prc!1       = "lon"
prc&lat     =  lat                    ; create coordinate variable
prc&lon     =  lon   
;----- Limites de Peru -----;
min_lat_p   = -19. 
max_lat_p   = 0.5
min_lon_p   = -82.
max_lon_p   = -68.
precip      = prc({min_lat_p:max_lat_p},{min_lon_p:max_lon_p})
size        = dimsizes(precip)

dirCSV      = "/data/users/jticse/Tesis-Maestria/SALIDAS/csv/"
file       := str_sub_str(fili,".","-")
csv_file    = file+".csv"
dq          = str_get_dq()
fields      = (/"lat","lon","precip"/)
fields      = dq + fields + dq
header      = [/str_join(fields,",")/]
system("rm -rf " + csv_file)
write_table(dirCSV+csv_file,"w",header,"%s")

do i=0,size(0)-1
    do j=0,size(1)-1
        precip_1 := precip(i,j)
        lat      := precip_1@lat
        lon      := precip_1@lon
        alist    = [/lat,lon,precip_1/]
        format   = "%4.3f,%4.3f,%3.7f"
        write_table(dirCSV+csv_file,"a",alist,format)
    end do
end do

end