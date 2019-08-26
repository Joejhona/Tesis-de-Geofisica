function get_title_position(plot)
local vpy, vpx, vph
begin
  getvalues plot
      "vpYF"       : vpy
      "vpXF"       : vpx
      "vpHeightF"  : vph
  end getvalues
  pos = (/vpx*0.75,vpy-(vph/2.)/)
  return(pos)
end

begin

;----- Limites de Peru -----;
min_lat_p = -19. 
max_lat_p = 0.5
min_lon_p = -82.
max_lon_p = -68.


;----- Data Chirp -----;
;diri    = (/"/data/users/jticse/data/chirps-v2.0.1991.days_p05.nc", "/data/users/jticse/data/chirps-v2.0.1992.days_p05.nc", "/data/users/jticse/data/chirps-v2.0.1993.days_p05.nc"/)
;f_chirp:= addfiles(diri, "r")
;diri    = "/data/users/jticse/data/chirps-v2.0.198*.days_p05.nc"
diri    = "/data/users/jticse/data/chirps-v2.0.*.days_p05.nc"
ls      = "ls "
f_chirp = systemfunc(ls+diri)
n_data  = dimsizes(f_chirp)
f_chirp:= addfiles(f_chirp, "r")
ListSetType(f_chirp,"cat")
time    = f_chirp[:]->time  


;----- Pre procesamiento de data Chirp -----;
year_i  = 1981  ;--->año inicial
year_f  = 2018  ;--->año final
mes_i   = 03    ;--->mes inicial
dia_i   = 01    ;--->dia inicial
mes_f   = 03    ;--->mes final
dia_f   = 31    ;--->dia final
n_years = ispan(year_i,year_f,1)


;----- seleccionando verano austral 1981-2018 en chirp, excluyendo 83,98,17 -----;
t_ch_t  = 0
t_ch_e  = 0
do y=0,dimsizes(n_years)-1
    if (((n_years(y).ne.1983).xor.(n_years(y).ne.1998)).xor.(n_years(y).ne.2017)) then 
        time_i := cd_inv_calendar(n_years(y),mes_i,dia_i,0,0,0,time@units, 0)
        time_f := cd_inv_calendar(n_years(y),mes_f,dia_f,0,0,0,time@units, 0)
        time_p := ispan(toint(time_i),toint(time_f),1)
        t_ch_e := array_append_record(t_ch_e,time_p,0)
    end if
    time_i := cd_inv_calendar(n_years(y),mes_i,dia_i,0,0,0,time@units, 0)
    time_f := cd_inv_calendar(n_years(y),mes_f,dia_f,0,0,0,time@units, 0)
    time_p := ispan(toint(time_i),toint(time_f),1)
    t_ch_t := array_append_record(t_ch_t,time_p,0)
end do
t_ch_e     := tofloat(t_ch_e(1:))
id_t_ch_e   = get1Dindex(time,t_ch_e)
ppd_ch_e    = f_chirp[:]->precip(id_t_ch_e,{min_lat_p:max_lat_p},{min_lon_p:max_lon_p})
t_ch_t     := tofloat(t_ch_t(1:))
id_t_ch_t   = get1Dindex(time,t_ch_t)
ppd_ch_t    = f_chirp[:]->precip(id_t_ch_t,{min_lat_p:max_lat_p},{min_lon_p:max_lon_p})


;----- ordenando en forma decreciente ppd 1981-2018 en chirp -----;
id_t_ch_t  := dim_pqsort_n(ppd_ch_t,-2,0)
id_t_ch_e  := dim_pqsort_n(ppd_ch_e,-2,0)


;----- eliminando los valores mas altos de ppd y menores a 0.1 -----;
;n_ppd_chirp_p   = dimsizes(ppd_chirp_p)
;ppd_chirp_p    := ppd_chirp_p(:n_ppd_chirp_p-1)
ppd_ch_t    := ppd_ch_t(1:,:,:)
ppd_ch_t     = where(ppd_ch_t.ge.0.1,ppd_ch_t,ppd_ch_t@_FillValue)
ppd_ch_e    := ppd_ch_e(1:,:,:)
ppd_ch_e    := where(ppd_ch_e.ge.0.1,ppd_ch_e,ppd_ch_e@_FillValue)


;----- contando valores -----;
nlat            = dimsizes(ppd_ch_t&latitude)
nlon            = dimsizes(ppd_ch_t&longitude)
ppd_count_t     = ppd_ch_t(0,:,:)
ppd_count_e     = ppd_count_t

do nx=0,nlat-1
    do ny=0,nlon-1
        ppd_count_t(nx,ny) = num(.not.ismissing(ppd_ch_t(:,nx,ny)))
        ppd_count_e(nx,ny) = num(.not.ismissing(ppd_ch_e(:,nx,ny)))
    end do 
end do


;----- percentil 99,95,90,75 del 81 al 18 -----;
id_ppd_ch_t_per99   = toint(ppd_count_t)-round(ppd_count_t*0.99,3)
id_ppd_ch_t_per95   = toint(ppd_count_t)-round(ppd_count_t*0.95,3)
id_ppd_ch_t_per90   = toint(ppd_count_t)-round(ppd_count_t*0.90,3)
id_ppd_ch_t_per75   = toint(ppd_count_t)-round(ppd_count_t*0.75,3)
id_ppd_ch_t_per = (/id_ppd_ch_t_per99,id_ppd_ch_t_per95,id_ppd_ch_t_per90,id_ppd_ch_t_per75/)
;----- percentil 99,95,90,75 del 81 al 18 excluyendo 83,98,17 -----;
id_ppd_ch_e_per99   = toint(ppd_count_e)-round(ppd_count_e*0.99,3)
id_ppd_ch_e_per95   = toint(ppd_count_e)-round(ppd_count_e*0.95,3)
id_ppd_ch_e_per90   = toint(ppd_count_e)-round(ppd_count_e*0.90,3)
id_ppd_ch_e_per75   = toint(ppd_count_e)-round(ppd_count_e*0.75,3)
id_ppd_ch_e_per = (/id_ppd_ch_e_per99,id_ppd_ch_e_per95,id_ppd_ch_e_per90,id_ppd_ch_e_per75/)

ppd_ch_t_per    = ppd_ch_t(:3,:,:)
ppd_ch_e_per    = ppd_ch_t_per

do nx=0,nlat-1
    do ny=0,nlon-1
        ppd_ch_t_per(:,nx,ny) = ppd_ch_t(id_ppd_ch_t_per(:,nx,ny),nx,ny)
        ppd_ch_e_per(:,nx,ny) = ppd_ch_e(id_ppd_ch_e_per(:,nx,ny),nx,ny)
    end do
end do 

;----- Asignando coordenadas a la matriz de percentiles -----;
ppd_ch_t_per!1              = "latitude"
ppd_ch_t_per&latitude       = ppd_ch_t&latitude
ppd_ch_t_per&latitude@units = ppd_ch_t&latitude@units
ppd_ch_t_per!2              = "longitude"
ppd_ch_t_per&longitude      = ppd_ch_t&longitude
ppd_ch_t_per&longitude@units= ppd_ch_t&longitude@units

ppd_ch_e_per!1              = "latitude"
ppd_ch_e_per&latitude       = ppd_ch_t&latitude
ppd_ch_e_per&latitude@units = ppd_ch_t&latitude@units
ppd_ch_e_per!2              = "longitude"
ppd_ch_e_per&longitude      = ppd_ch_t&longitude
ppd_ch_e_per&longitude@units= ppd_ch_t&longitude@units

printVarSummary(ppd_ch_t_per)
printVarSummary(ppd_ch_e_per)


;----- Grabando data ------;
fout1               = addfile("/data/users/jticse/data/ppd_ch_t_percMAR.nc","c")
fout1->ppd_ch_t_per = ppd_ch_t_per
fout2               = addfile("/data/users/jticse/data/ppd_ch_e_percMAR.nc","c")
fout2->ppd_ch_e_per = ppd_ch_e_per


;----- creando mapa ------;
type    = "png"
;type    = "x11"
wks  = gsn_open_wks(type,"perc-CHIRP-MAR-81-18")
nrow = 2
ncol = 4                           
plot = new(nrow*ncol,graphic)
;----- agregando detalles al mapa -----;
res                     = True      ;--> activa los detalles
res@gsnDraw             = False     ;-- don't draw the plot yet
res@gsnFrame            = False     ;--> 
res@gsnMaximize         = True
res@gsnAddCyclic        = False
res@gsnLeftString       = "mm/dia"
res@gsnRightString      = ""
res@mpLimitMode         = "Corners" ;--> Activa limites modo corners
res@mpLeftCornerLatF    = min_lat_p ;--> limites.ncl r=rimac p=Perú   
res@mpRightCornerLatF   = max_lat_p ;--> n=Norte
res@mpLeftCornerLonF    = min_lon_p
res@mpRightCornerLonF   = max_lon_p
;res@tiMainString        = "Prueba"
res@lbLabelBarOn        = False           ; turn off individual cb's
res@cnFillOn            = True
res@cnFillPalette       = "WhBlGrYeRe"
res@cnLinesOn           = False             ;---> Contorno de linea (falso = no)
res@cnLineLabelsOn      = False
;res@lbOrientation       = "Vertical"
res@cnLevelSelectionMode    = "ExplicitLevels"  ;---> Solo usa los indicados en levels
res@cnLevels                = (/0.1,0.2,0.3,0.4,0.5,0.6,0.7,\
                            0.8,0.9,1.,1.5,2.,2.5,3.,3.5,\
                            4.,4.5,5.,6.,7.,8.,\
                            9.,10.,15.,20.,25.,30.,35.,40.,\
                            45.,50.,55.,60.,65.,70.,75.,\
                            80.,85.,90.,95.,100./)
;---Limites Nacionales---;
res@mpOutlineBoundarySets       = "National"    ;---> Limite de Paises
res@mpNationalLineThicknessF    = 2             ;---> Grosor de linea nacional
res@mpGeophysicalLineThicknessF = 2             ;---> Grosor de linea continental
res@tmYLLabelsOn                = False            ; turn off lat labels
res@tmXBLabelsOn                = False            ; turn off lon labels
res@tmYROn                      = False
res@tmYLOn                      = False
res@tmXTOn                      = False
res@tmXBOn                      = False

;---- plot - percentil99 ----;
ppd_ch_t_per99 = ppd_ch_t_per(0,:,:)
ppd_ch_e_per99 = ppd_ch_e_per(0,:,:)
res1                    = res
res1@gsnCenterString    = "PERCENTIL-99"
plot(0) = gsn_csm_contour_map(wks,ppd_ch_t_per99,res1)
res1@gsnCenterString    = ""
plot(4) = gsn_csm_contour_map(wks,ppd_ch_e_per99,res1)
;---- plot - percentil95 ----;
ppd_ch_t_per95 = ppd_ch_t_per(1,:,:)
ppd_ch_e_per95 = ppd_ch_e_per(1,:,:)
res2                    = res
res2@gsnCenterString    = "PERCENTIL-95"
plot(1) = gsn_csm_contour_map(wks,ppd_ch_t_per95,res2)
res2@gsnCenterString    = ""
plot(5) = gsn_csm_contour_map(wks,ppd_ch_e_per95,res2)
;---- plot - percentil90 ----;
ppd_ch_t_per90 = ppd_ch_t_per(2,:,:)
ppd_ch_e_per90 = ppd_ch_e_per(2,:,:)
res3                    = res
res3@gsnCenterString    = "PERCENTIL-90"
plot(2) = gsn_csm_contour_map(wks,ppd_ch_t_per90,res3)
res3@gsnCenterString    = ""
plot(6) = gsn_csm_contour_map(wks,ppd_ch_e_per90,res3)
;---- plot - percentil75 ----;
ppd_ch_t_per75 = ppd_ch_t_per(3,:,:)
ppd_ch_e_per75 = ppd_ch_e_per(3,:,:)
res4                    = res
res4@gsnCenterString    = "PERCENTIL-75"
plot(3) = gsn_csm_contour_map(wks,ppd_ch_t_per75,res4)
res4@gsnCenterString    = ""
plot(7) = gsn_csm_contour_map(wks,ppd_ch_e_per75,res4)

;---- detalles del plot grande ----;
resP                    = True                ; modify the panel plot
resP@gsnMaximize        = True
resP@gsnPanelMainString = "Percentiles con data CHIRP MAR-81-18"
resP@gsnFrame           = False
resP@gsnPanelLabelBar   = True                ; add common colorbar
resP@lbOrientation      = "vertical"
resP@vpHeightF          = 0.6
resP@lbLabelFontHeightF = 0.01               ; make labels smaller
resP@gsnPanelLeft       = 0.04
resP@gsnPanelBottom     = 0.08
resP@gsnPanelSave       = True

gsn_panel(wks, plot, (/nrow,ncol/), resP)

pos1 = get_title_position(plot(0))         ; 1st row leftmost plot
pos2 = get_title_position(plot(4))         ; 2nd row leftmost plot
txres               = True
txres@txFontHeightF = 0.012
txres@txAngleF      = 90.
gsn_text_ndc(wks, "TOTAL 1981-2018",   pos1(0), pos1(1), txres)
gsn_text_ndc(wks, "EXCLUYENDO 1983,1998,2017",   pos2(0), pos2(1), txres)
    
frame(wks)

end
