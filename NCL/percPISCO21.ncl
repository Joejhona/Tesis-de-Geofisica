
load "$NCARG_ROOT/lib/ncarg/nclscripts/contrib/cd_string.ncl"

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
;f_perc_t  = addfile("/data/users/jticse/data/ppd_ch_t_percMAR.nc","r")
;f_perc_e  = addfile("/data/users/jticse/data/ppd_ch_e_percMAR.nc","r")
;f_perc_t  = addfile("/data/users/jticse/data/pisco21ppd_perc_t_ENE.nc","r")
;f_perc_e  = addfile("/data/users/jticse/data/pisco21ppd_perc_e_ENE.nc","r")
;f_perc_t  = addfile("/data/users/jticse/data/pisco21ppd_perc_t_FEB.nc","r")
;f_perc_e  = addfile("/data/users/jticse/data/pisco21ppd_perc_e_FEB.nc","r")
f_perc_t  = addfile("/data/users/jticse/data/pisco21ppd_perc_t_MAR.nc","r")
f_perc_e  = addfile("/data/users/jticse/data/pisco21ppd_perc_e_MAR.nc","r")
dir_pi    = "/data/users/jticse/data/piscopd-17-18/"

ppd_pi_t_per    = f_perc_t->ppd_pi_t_per
ppd_pi_e_per    = f_perc_e->ppd_pi_e_per
ppd_pi_t_per99  = ppd_pi_t_per(0,:,:)
ppd_pi_t_per95  = ppd_pi_t_per(1,:,:)
ppd_pi_t_per90  = ppd_pi_t_per(2,:,:)
ppd_pi_t_per75  = ppd_pi_t_per(3,:,:)
ppd_pi_e_per99  = ppd_pi_e_per(0,:,:)
ppd_pi_e_per95  = ppd_pi_e_per(1,:,:)
ppd_pi_e_per90  = ppd_pi_e_per(2,:,:)
ppd_pi_e_per75  = ppd_pi_e_per(3,:,:)


;----- Pre procesamiento de data Chirp -----;
year    = 2018  ;--->año final
mes     = 03    ;--->mes inicial
dia_i   = 01    ;--->dia inicial
dia_f   = 31    ;--->dia final


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


do i=0,dia_f-1
    fecha  := cd_inv_calendar(year,mes,i+1,00,00,00,"days since 1800-01-01 00:00",0)
    fecha  := cd_string(fecha,"%Y-%N-%D")
    asc     = ".asc"

    x1      = asciiread(dir_pi+fecha+asc,-1,"float")
    nlon    = toint(x1(0))
    nlat    = toint(x1(1))
    ppd_pi_d                := onedtond(x1(6:),(/nlat,nlon/))
    ppd_pi_d                 = where(ppd_pi_d.ge.0,ppd_pi_d,ppd_pi_d@_FillValue)
    ppd_pi_d!0               = "latitude"
    ppd_pi_d&latitude        = ppd_pi_t_per&latitude
    ppd_pi_d&latitude@units  = ppd_pi_t_per&latitude@units
    ppd_pi_d!1               = "longitude"
    ppd_pi_d&longitude       = ppd_pi_t_per&longitude
    ppd_pi_d&longitude@units = ppd_pi_t_per&longitude@units
    ppd_pi_t_p99 = ppd_pi_d
    ppd_pi_t_p95 = ppd_pi_d
    ppd_pi_t_p90 = ppd_pi_d
    ppd_pi_t_p75 = ppd_pi_d
    ppd_pi_e_p99 = ppd_pi_d
    ppd_pi_e_p95 = ppd_pi_d
    ppd_pi_e_p90 = ppd_pi_d
    ppd_pi_e_p75 = ppd_pi_d
    ppd_pi_t_p99 = where(ppd_pi_t_p99.ge.ppd_pi_t_per99,ppd_pi_t_p99,ppd_pi_t_p99@_FillValue)
    ppd_pi_t_p95 = where(ppd_pi_t_p95.ge.ppd_pi_t_per95,ppd_pi_t_p95,ppd_pi_t_p95@_FillValue)
    ppd_pi_t_p90 = where(ppd_pi_t_p90.ge.ppd_pi_t_per90,ppd_pi_t_p90,ppd_pi_t_p90@_FillValue)
    ppd_pi_t_p75 = where(ppd_pi_t_p75.ge.ppd_pi_t_per75,ppd_pi_t_p75,ppd_pi_t_p75@_FillValue)
    ppd_pi_e_p99 = where(ppd_pi_e_p99.ge.ppd_pi_e_per99,ppd_pi_e_p99,ppd_pi_e_p99@_FillValue)
    ppd_pi_e_p95 = where(ppd_pi_e_p95.ge.ppd_pi_e_per95,ppd_pi_e_p95,ppd_pi_e_p95@_FillValue)
    ppd_pi_e_p90 = where(ppd_pi_e_p90.ge.ppd_pi_e_per90,ppd_pi_e_p90,ppd_pi_e_p90@_FillValue)
    ppd_pi_e_p75 = where(ppd_pi_e_p75.ge.ppd_pi_e_per75,ppd_pi_e_p75,ppd_pi_e_p75@_FillValue)

    ;----- creando mapa ------;
    type    = "png"
    ;type    = "x11"
    titulo1 = "perc-PISCOv21-"
    wks     = gsn_open_wks(type,titulo1+fecha)
    nrow    = 2
    ncol    = 4                           
    plot    = new(nrow*ncol,graphic)

    ;---- plot - percentil99 ----;
    res1                    = res
    res1@gsnCenterString    = "PERCENTIL-99"
    plot(0) = gsn_csm_contour_map(wks,ppd_pi_t_p99,res1)
    res1@gsnCenterString    = ""
    plot(4) = gsn_csm_contour_map(wks,ppd_pi_e_p99,res1)
    ;---- plot - percentil95 ----;
    res2                    = res
    res2@gsnCenterString    = "PERCENTIL-95"
    plot(1) = gsn_csm_contour_map(wks,ppd_pi_t_p95,res2)
    res2@gsnCenterString    = ""
    plot(5) = gsn_csm_contour_map(wks,ppd_pi_e_p95,res2)
    ;---- plot - percentil90 ----;
    res3                    = res
    res3@gsnCenterString    = "PERCENTIL-90"
    plot(2) = gsn_csm_contour_map(wks,ppd_pi_t_p90,res3)
    res3@gsnCenterString    = ""
    plot(6) = gsn_csm_contour_map(wks,ppd_pi_e_p90,res3)
    ;---- plot - percentil75 ----;
    res4                    = res
    res4@gsnCenterString    = "PERCENTIL-75"
    plot(3) = gsn_csm_contour_map(wks,ppd_pi_t_p75,res4)
    res4@gsnCenterString    = ""
    plot(7) = gsn_csm_contour_map(wks,ppd_pi_e_p75,res4)

    ;---- detalles del plot grande ----;
    resPP                   = resP                ; modify the panel plot
    resPP@gsnPanelMainString= "Percentiles PISCOv21 "+fecha

    gsn_panel(wks,plot,(/nrow,ncol/),resPP)

    pos1 = get_title_position(plot(0))         ; 1st row leftmost plot
    pos2 = get_title_position(plot(4))         ; 2nd row leftmost plot
    txres               = True
    txres@txFontHeightF = 0.012
    txres@txAngleF      = 90.
    gsn_text_ndc(wks,"TOTAL 1981-2018",pos1(0),pos1(1),txres)
    gsn_text_ndc(wks,"EXCLUYENDO 1983,1998,2017",pos2(0),pos2(1),txres)
        
    frame(wks)
end do
    orden1  = "convert -delay "
    tiempo  = tostring(150)     ;---> 100 = 1 seg
    fecha  := str_get_cols(fecha,0,6)
    cmd     = orden1+tiempo+" "+titulo1+fecha+"*.png anim-"+titulo1+fecha+".gif"
    system(cmd)
end