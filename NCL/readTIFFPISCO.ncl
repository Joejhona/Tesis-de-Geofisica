begin

dir     = "/home/usuario/Documentos/ticse/Tesis/Data/PISCO-EFM-17-18/"
f_tiff  = "2017-01-12.asc"

;dir2    = "/home/usuario/Documentos/ticse/Tesis/Data/PISCOpd.nc"
dir2    = "/data/users/jticse/data/PISCOpd21.nc"
x3      = addfile(dir2,"r")
ppd     = x3->variable



x1 = asciiread(dir+f_tiff, -1,"float")

nlon    = toint(x1(0))
nlat    = toint(x1(1))
ilon    = x1(2)
ilat    = x1(3)
cell    = x1(4)

lon     = (ispan(0,nlon-1,1)*cell)+ilon
lat     = (ispan(0,nlat-1,1)*cell)+ilat
lat     = lat(::-1)

x2  = onedtond(x1(6:),(/nlat,nlon/))
x2  = where(x2.ge.0,x2,x2@_FillValue)

x2!0                = "latitude"
x2&latitude         = lat
x2&latitude@units   = "degrees_north"
x2!1                = "longitude"
x2&longitude        = lon
x2&longitude@units  = "degrees_east"

end
