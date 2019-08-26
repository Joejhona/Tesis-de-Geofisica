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


;f_perc_t  = addfile("/data/users/jticse/data/ppd_ch_t_percENE.nc","r")
;f_perc_e  = addfile("/data/users/jticse/data/ppd_ch_e_percENE.nc","r")
;f_perc_t  = addfile("/data/users/jticse/data/ppd_ch_t_percFEB.nc","r")
;f_perc_e  = addfile("/data/users/jticse/data/ppd_ch_e_percFEB.nc","r")
f_perc_t  = addfile("/data/users/jticse/data/ppd_ch_t_percMAR.nc","r")
f_perc_e  = addfile("/data/users/jticse/data/ppd_ch_e_percMAR.nc","r")


diri_chirp  = (/"/data/users/jticse/data/chirps-v2.0.2017.days_p05.nc", "/data/users/jticse/data/chirps-v2.0.2018.days_p05.nc"/)
f_chirp    := addfiles(diri_chirp, "r")
ListSetType(f_chirp,"cat")
 
ppd_ch_t_per    = f_perc_t->ppd_ch_t_per
ppd_ch_e_per    = f_perc_e->ppd_ch_e_per
ppd_ch_t_per99  = ppd_ch_t_per(0,:,:)
ppd_ch_t_per95  = ppd_ch_t_per(1,:,:)
ppd_ch_t_per90  = ppd_ch_t_per(2,:,:)
ppd_ch_t_per75  = ppd_ch_t_per(3,:,:)
ppd_ch_e_per99  = ppd_ch_e_per(0,:,:)
ppd_ch_e_per95  = ppd_ch_e_per(1,:,:)
ppd_ch_e_per90  = ppd_ch_e_per(2,:,:)
ppd_ch_e_per75  = ppd_ch_e_per(3,:,:)

ppd_chirps  = f_chirp[:]->precip(:,{min(ppd_ch_t_per&latitude):max(ppd_ch_t_per&latitude)},{min(ppd_ch_t_per&longitude):max(ppd_ch_t_per&longitude)})
time        = f_chirp[:]->time  

;ppd_imerg  := ppd_imerg(ncl_join|:,lat|:,lon|:)
;----- Pre procesamiento de data Chirp -----;
year    = 2017  ;--->año inicial
mes_i   = 03    ;--->mes inicial
dia_i   = 01    ;--->dia inicial
mes_f   = 03    ;--->mes final
dia_f   = 31    ;--->dia final
time_i := cd_inv_calendar(year,mes_i,dia_i,0,0,0,time@units,0)
time_f := cd_inv_calendar(year,mes_f,dia_f,0,0,0,time@units,0)
time_p := ispan(toint(time_i),toint(time_f),1)

;----- agregando detalles al mapa -----;
res                     = True      ;--> activa los detalles
res@gsnDraw             = False     ;-- don't draw the plot yet
res@gsnFrame            = False     ;--> 
res@gsnMaximize         = True
res@gsnAddCyclic        = False
res@gsnLeftString       = "mm/dia"
;res@gsnRightString      = ""
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

;---- detalles del plot grande ----;
resP                    = True                ; modify the panel plot
resP@gsnMaximize        = True
resP@gsnFrame           = False
resP@gsnPanelLabelBar   = True                ; add common colorbar
resP@lbOrientation      = "vertical"
resP@vpHeightF          = 0.6
resP@lbLabelFontHeightF = 0.01               ; make labels smaller
resP@gsnPanelLeft       = 0.04
resP@gsnPanelBottom     = 0.08
resP@gsnPanelSave       = True



do i=0,dimsizes(time_p)-1
    time_d          = time_p(i)
    time_d@units    = time@units
    fecha           = tostring(cd_calendar(time_d,-2))
    ppd_chirps_d    = ppd_chirps({time_d},:,:)
    ppd_chirps_t_p99 = ppd_chirps_d
    ppd_chirps_t_p95 = ppd_chirps_d
    ppd_chirps_t_p90 = ppd_chirps_d
    ppd_chirps_t_p75 = ppd_chirps_d
    ppd_chirps_e_p99 = ppd_chirps_d
    ppd_chirps_e_p95 = ppd_chirps_d
    ppd_chirps_e_p90 = ppd_chirps_d
    ppd_chirps_e_p75 = ppd_chirps_d
    ppd_chirps_t_p99 = where(ppd_chirps_t_p99.ge.ppd_ch_t_per99,ppd_chirps_t_p99,ppd_chirps_t_p99@_FillValue)
    ppd_chirps_t_p95 = where(ppd_chirps_t_p95.ge.ppd_ch_t_per95,ppd_chirps_t_p95,ppd_chirps_t_p95@_FillValue)
    ppd_chirps_t_p90 = where(ppd_chirps_t_p90.ge.ppd_ch_t_per90,ppd_chirps_t_p90,ppd_chirps_t_p90@_FillValue)
    ppd_chirps_t_p75 = where(ppd_chirps_t_p75.ge.ppd_ch_t_per75,ppd_chirps_t_p75,ppd_chirps_t_p75@_FillValue)
    ppd_chirps_e_p99 = where(ppd_chirps_e_p99.ge.ppd_ch_e_per99,ppd_chirps_e_p99,ppd_chirps_e_p99@_FillValue)
    ppd_chirps_e_p95 = where(ppd_chirps_e_p95.ge.ppd_ch_e_per95,ppd_chirps_e_p95,ppd_chirps_e_p95@_FillValue)
    ppd_chirps_e_p90 = where(ppd_chirps_e_p90.ge.ppd_ch_e_per90,ppd_chirps_e_p90,ppd_chirps_e_p90@_FillValue)
    ppd_chirps_e_p75 = where(ppd_chirps_e_p75.ge.ppd_ch_e_per75,ppd_chirps_e_p75,ppd_chirps_e_p75@_FillValue)

    ;----- creando mapa ------;
    type    = "png"
    ;type    = "x11"
    titulo1 = "percCHIRPSvsppdCHIRPS-MAR-17-"
    wks     = gsn_open_wks(type,titulo1+fecha)
    nrow    = 2
    ncol    = 4                           
    plot    = new(nrow*ncol,graphic)

    ;---- plot - percentil99 ----;
    res1                    = res
    res1@gsnCenterString    = "PERCENTIL-99"
    plot(0) = gsn_csm_contour_map(wks,ppd_chirps_t_p99,res1)
    res1@gsnCenterString    = ""
    plot(4) = gsn_csm_contour_map(wks,ppd_chirps_e_p99,res1)
    ;---- plot - percentil95 ----;
    res2                    = res
    res2@gsnCenterString    = "PERCENTIL-95"
    plot(1) = gsn_csm_contour_map(wks,ppd_chirps_t_p95,res2)
    res2@gsnCenterString    = ""
    plot(5) = gsn_csm_contour_map(wks,ppd_chirps_t_p95,res2)
    ;---- plot - percentil90 ----;
    res3                    = res
    res3@gsnCenterString    = "PERCENTIL-90"
    plot(2) = gsn_csm_contour_map(wks,ppd_chirps_t_p90,res3)
    res3@gsnCenterString    = ""
    plot(6) = gsn_csm_contour_map(wks,ppd_chirps_t_p90,res3)
    ;---- plot - percentil75 ----;
    res4                    = res
    res4@gsnCenterString    = "PERCENTIL-75"
    plot(3) = gsn_csm_contour_map(wks,ppd_chirps_t_p75,res4)
    res4@gsnCenterString    = ""
    plot(7) = gsn_csm_contour_map(wks,ppd_chirps_t_p75,res4)

    ;---- detalles del plot grande ----;
    resPP                   = resP                ; modify the panel plot
    resPP@gsnPanelMainString= "Percentiles CHIRPS con data IMERG "+fecha

    gsn_panel(wks, plot, (/nrow,ncol/), resPP)

    pos1 = get_title_position(plot(0))         ; 1st row leftmost plot
    pos2 = get_title_position(plot(4))         ; 2nd row leftmost plot
    txres               = True
    txres@txFontHeightF = 0.012
    txres@txAngleF      = 90.
    gsn_text_ndc(wks, "TOTAL 1981-2018",   pos1(0), pos1(1), txres)
    gsn_text_ndc(wks, "EXCLUYENDO 1983,1998,2017",   pos2(0), pos2(1), txres)
        
    frame(wks)
end do
    orden1  = "convert -delay "
    tiempo  = tostring(100)     ;---> 100 = 1 seg
    cmd     = orden1+tiempo+" "+titulo1+"*.png "+titulo1+"anim.gif"
    system(cmd)
end