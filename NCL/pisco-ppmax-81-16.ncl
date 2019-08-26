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
;dir     = "/mnt/j/Tesis/Maestria Geofisica/PISCOpd.nc"
;dir     = "/data/users/jticse/data/PISCOpd.nc"
dir     = "/data/users/jticse/data/PISCOpd21.nc"
f_pisco = addfile(dir,"r")
time    = f_pisco->z


;----- Pre procesamiento de data Chirp -----;
year_i  = 1981  ;--->año inicial
year_f  = 2016  ;--->año final
mes_i   = 01    ;--->mes inicial
dia_i   = 01    ;--->dia inicial
mes_f   = 03    ;--->mes final
dia_f   = 31    ;--->dia final
n_years = ispan(year_i,year_f,1)


;----- seleccionando verano austral 1981-2018 en chirp, excluyendo 83,98,17 -----;
t_pi_e  = 0
t_pi_t  = 0
do y=0,dimsizes(n_years)-1
    if (((n_years(y).ne.1983).xor.(n_years(y).ne.1998)).xor.(n_years(y).ne.2017)) then 
        time_i := cd_inv_calendar(n_years(y),mes_i,dia_i,0,0,0,time@units, 0)
        time_f := cd_inv_calendar(n_years(y),mes_f,dia_f,0,0,0,time@units, 0)
        time_p := ispan(toint(time_i),toint(time_f),1)
        t_pi_e := array_append_record(t_pi_e,time_p,0)
    end if
    time_i := cd_inv_calendar(n_years(y),mes_i,dia_i,0,0,0,time@units, 0)
    time_f := cd_inv_calendar(n_years(y),mes_f,dia_f,0,0,0,time@units, 0)
    time_p := ispan(toint(time_i),toint(time_f),1)
    t_pi_t := array_append_record(t_pi_t,time_p,0)
end do
t_pi_e     := tofloat(t_pi_e(1:))
id_t_pi_e   = get1Dindex(time,t_pi_e)
ppd_pi_e    = f_pisco->variable(id_t_pi_e,:,:)
t_pi_t     := tofloat(t_pi_t(1:))
id_t_pi_t   = get1Dindex(time,t_pi_t)
ppd_pi_t    = f_pisco->variable(id_t_pi_t,:,:)


;----- ordenando en forma decreciente ppd 1981-2018 en chirp -----;
id_t_pi_t  := dim_pqsort_n(ppd_pi_t,-2,0)
id_t_pi_e  := dim_pqsort_n(ppd_pi_e,-2,0)


;----- eliminando los valores mas altos de ppd y menores a 0.1 -----;
;n_ppd_chirp_p   = dimsizes(ppd_chirp_p)
;ppd_chirp_p    := ppd_chirp_p(:n_ppd_chirp_p-1)
ppd_pi_t       := ppd_pi_t(1:,:,:)
ppd_pi_t        = where(ppd_pi_t.ge.0.1,ppd_pi_t,ppd_pi_t@_FillValue)
ppd_pi_e       := ppd_pi_e(1:,:,:)
ppd_pi_e        = where(ppd_pi_e.ge.0.1,ppd_pi_e,ppd_pi_e@_FillValue)


;----- contando valores -----;
nlat            = dimsizes(ppd_pi_t&latitude)
nlon            = dimsizes(ppd_pi_t&longitude)
ppd_count_t     = ppd_pi_t(0,:,:)
ppd_count_e     = ppd_count_t

do nx=0,nlat-1
    do ny=0,nlon-1
        ppd_count_t(nx,ny) = num(.not.ismissing(ppd_pi_t(:,nx,ny)))
        ppd_count_e(nx,ny) = num(.not.ismissing(ppd_pi_e(:,nx,ny)))
    end do 
end do


;----- percentil 99,95,90,75 del 81 al 18 -----;
id_ppd_pi_t_per99   = toint(ppd_count_t)-round(ppd_count_t*0.99,3)
id_ppd_pi_t_per95   = toint(ppd_count_t)-round(ppd_count_t*0.95,3)
id_ppd_pi_t_per90   = toint(ppd_count_t)-round(ppd_count_t*0.90,3)
id_ppd_pi_t_per75   = toint(ppd_count_t)-round(ppd_count_t*0.75,3)
id_ppd_pi_t_per = (/id_ppd_pi_t_per99,id_ppd_pi_t_per95,id_ppd_pi_t_per90,id_ppd_pi_t_per75/)
;----- percentil 99,95,90,75 del 81 al 18 excluyendo 83,98,17 -----;
id_ppd_pi_e_per99   = toint(ppd_count_e)-round(ppd_count_e*0.99,3)
id_ppd_pi_e_per95   = toint(ppd_count_e)-round(ppd_count_e*0.95,3)
id_ppd_pi_e_per90   = toint(ppd_count_e)-round(ppd_count_e*0.90,3)
id_ppd_pi_e_per75   = toint(ppd_count_e)-round(ppd_count_e*0.75,3)
id_ppd_pi_e_per = (/id_ppd_pi_e_per99,id_ppd_pi_e_per95,id_ppd_pi_e_per90,id_ppd_pi_e_per75/)

ppd_pi_t_per    = ppd_pi_t(:3,:,:)
ppd_pi_e_per    = ppd_pi_t_per

do nx=0,nlat-1
    do ny=0,nlon-1
        ppd_pi_t_per(:,nx,ny) = ppd_pi_t(id_ppd_pi_t_per(:,nx,ny),nx,ny)
        ppd_pi_e_per(:,nx,ny) = ppd_pi_e(id_ppd_pi_e_per(:,nx,ny),nx,ny)
    end do
end do 

ppd_pi_t_per!1              = "latitude"
ppd_pi_t_per&latitude       = ppd_pi_t&latitude
ppd_pi_t_per&latitude@units = ppd_pi_t&latitude@units
ppd_pi_t_per!2              = "longitude"
ppd_pi_t_per&longitude      = ppd_pi_t&longitude
ppd_pi_t_per&longitude@units= ppd_pi_t&longitude@units

ppd_pi_e_per!1              = "latitude"
ppd_pi_e_per&latitude       = ppd_pi_t&latitude
ppd_pi_e_per&latitude@units = ppd_pi_t&latitude@units
ppd_pi_e_per!2              = "longitude"
ppd_pi_e_per&longitude      = ppd_pi_t&longitude
ppd_pi_e_per&longitude@units= ppd_pi_t&longitude@units

printVarSummary(ppd_pi_t_per)
printVarSummary(ppd_pi_e_per)


;----- Grabando data ------;
fout1               = addfile("/data/users/jticse/data/pisco21ppd_perc_t_EFM.nc","c")
fout1->ppd_pi_t_per = ppd_pi_t_per
fout2               = addfile("/data/users/jticse/data/pisco21ppd_perc_e_EFM.nc","c")
fout2->ppd_pi_e_per = ppd_pi_e_per

;----- creando mapa ------;
type    = "png"
;type    = "x11"
titulo  = "PISCOv21-EFM-81-16"
wks     = gsn_open_wks(type,"perc-"+titulo)
nrow    = 2
ncol    = 4                           
plot    = new(nrow*ncol,graphic)
;---Detalles de mapa---;
res                     = True      ;--> activa los detalles
res@gsnDraw             = False     ;--> don't draw the plot yet
res@gsnFrame            = False     ;--> 
res@gsnMaximize         = True
res@gsnAddCyclic        = False
res@gsnLeftString       = "mm/dia"
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
ppd_pi_t_per99 = ppd_pi_t_per(0,:,:)
ppd_pi_e_per99 = ppd_pi_e_per(0,:,:)
res1                    = res
res1@gsnCenterString    = "Percentil-99"
plot(0) = gsn_csm_contour_map(wks,ppd_pi_t_per99,res1)
res1@gsnCenterString    = ""
plot(4) = gsn_csm_contour_map(wks,ppd_pi_e_per99,res1)
;---- plot - percentil95 ----;
ppd_pi_t_per95 = ppd_pi_t_per(1,:,:)
ppd_pi_e_per95 = ppd_pi_e_per(1,:,:)
res2                    = res
res2@gsnCenterString    = "Percentil-95"
plot(1) = gsn_csm_contour_map(wks,ppd_pi_t_per95,res2)
res2@gsnCenterString    = ""
plot(5) = gsn_csm_contour_map(wks,ppd_pi_e_per95,res2)
;---- plot - percentil90 ----;
ppd_pi_t_per90 = ppd_pi_t_per(2,:,:)
ppd_pi_e_per90 = ppd_pi_e_per(2,:,:)
res3                    = res
res3@gsnCenterString    = "Percentil-90"
plot(2) = gsn_csm_contour_map(wks,ppd_pi_t_per90,res3)
res3@gsnCenterString    = ""
plot(6) = gsn_csm_contour_map(wks,ppd_pi_e_per90,res3)
;---- plot - percentil75 ----;
ppd_pi_t_per75 = ppd_pi_t_per(3,:,:)
ppd_pi_e_per75 = ppd_pi_e_per(3,:,:)
res4                    = res
res4@gsnCenterString    = "Percentil-75"
plot(3) = gsn_csm_contour_map(wks,ppd_pi_t_per75,res4)
res4@gsnCenterString    = ""
plot(7) = gsn_csm_contour_map(wks,ppd_pi_e_per75,res4)

;---- detalles del plot grande ----;
resP                    = True                ; modify the panel plot
resP@gsnMaximize        = True
resP@gsnPanelMainString = "Percentiles "+titulo
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
gsn_text_ndc(wks, "TOTAL 1981-2016",   pos1(0), pos1(1), txres)
gsn_text_ndc(wks, "EXCLUYENDO 1983,1998",   pos2(0), pos2(1), txres)
    
frame(wks)

end