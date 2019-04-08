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


;----- Datos ya procesados ------;
;f_perc_t_EFM    = addfile("/data/users/jticse/data/ppd_pi_t_percEFM.nc","r")
;f_perc_e_EFM    = addfile("/data/users/jticse/data/ppd_pi_e_percEFM.nc","r")
;f_perc_t        = addfile("/data/users/jticse/data/ppd_pi_t_percE.nc","r")
;f_perc_e        = addfile("/data/users/jticse/data/ppd_pi_e_percE.nc","r")
;f_perc_t        = addfile("/data/users/jticse/data/ppd_pi_t_percF.nc","r")
;f_perc_e        = addfile("/data/users/jticse/data/ppd_pi_e_percF.nc","r")
;f_perc_t        = addfile("/data/users/jticse/data/ppd_pi_t_percM.nc","r")
;f_perc_e        = addfile("/data/users/jticse/data/ppd_pi_e_percM.nc","r")
;f_perc_t        = addfile("/data/users/jticse/data/pisco21ppd_perc_t_ENE.nc","r")
f_perc_e        = addfile("/data/users/jticse/data/pisco21ppd_perc_e_ENE.nc","r")
;f_perc_t        = addfile("/data/users/jticse/data/pisco21ppd_perc_t_FEB.nc","r")
;f_perc_e        = addfile("/data/users/jticse/data/pisco21ppd_perc_e_FEB.nc","r")
;f_perc_t        = addfile("/data/users/jticse/data/pisco21ppd_perc_t_MAR.nc","r")
;f_perc_e        = addfile("/data/users/jticse/data/pisco21ppd_perc_e_MAR.nc","r")

;ppd_pi_t_per    = f_perc_t->ppd_pi_t_per
ppd_pi_e_per    = f_perc_e->ppd_pi_e_per


;----- creando mapa ------;
type    = "png"
;type    = "x11"
titulo  = "Enero-81-16"
dir     = "/data/users/jticse/resultados/github/Tesis-de-Geofisica/salidas"
wks     = gsn_open_wks(type,dir+"/perc-PISCOv21-"+titulo)
nrow    = 1  ;2
ncol    = 4                           
plot    = new(nrow*ncol,graphic)
;---Detalles de mapa---;
res                     = True      ;--> activa los detalles
res@gsnDraw             = False     ;-- don't draw the plot yet
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
;ppd_pi_t_per99 = ppd_pi_t_per(0,:,:)
ppd_pi_e_per99 = ppd_pi_e_per(0,:,:)
res1                    = res
res1@gsnCenterString    = "Percentil-99"
plot(0) = gsn_csm_contour_map(wks,ppd_pi_e_per99,res1)
;res1@gsnCenterString    = ""
;plot(4) = gsn_csm_contour_map(wks,ppd_pi_e_per99,res1)
;---- plot - percentil95 ----;
;ppd_pi_t_per95 = ppd_pi_t_per(1,:,:)
ppd_pi_e_per95 = ppd_pi_e_per(1,:,:)
res2                    = res
res2@gsnCenterString    = "Percentil-95"
plot(1) = gsn_csm_contour_map(wks,ppd_pi_e_per95,res2)
;res2@gsnCenterString    = ""
;plot(5) = gsn_csm_contour_map(wks,ppd_pi_e_per95,res2)
;---- plot - percentil90 ----;
;ppd_pi_t_per90 = ppd_pi_t_per(2,:,:)
ppd_pi_e_per90 = ppd_pi_e_per(2,:,:)
res3                    = res
res3@gsnCenterString    = "Percentil-90"
plot(2) = gsn_csm_contour_map(wks,ppd_pi_e_per90,res3)
;res3@gsnCenterString    = ""
;plot(6) = gsn_csm_contour_map(wks,ppd_pi_e_per90,res3)
;---- plot - percentil75 ----;
;ppd_pi_t_per75 = ppd_pi_t_per(3,:,:)
ppd_pi_e_per75 = ppd_pi_e_per(3,:,:)
res4                    = res
res4@gsnCenterString    = "Percentil-75"
plot(3) = gsn_csm_contour_map(wks,ppd_pi_e_per75,res4)
;res4@gsnCenterString    = ""
;plot(7) = gsn_csm_contour_map(wks,ppd_pi_e_per75,res4)

;---- detalles del plot grande ----;
resP                    = True                ; modify the panel plot
resP@gsnMaximize        = True
resP@gsnPanelMainString = "Percentiles con data PISCOv21"+titulo
;resP@gsnFrame           = False
resP@gsnPanelLabelBar   = True                ; add common colorbar
resP@lbBoxEndCapStyle   = "TriangleHighEnd"
;resP@lbOrientation      = "vertical"
resP@vpHeightF          = 0.1
resP@vpWidthF 		= 0.95
resP@lbLabelFontHeightF = 0.012               ; make labels smaller
;resP@gsnPanelLeft       = 0.04
resP@gsnPanelBottom     = 0.08
;resP@gsnPanelSave       = True


gsn_panel(wks, plot, (/nrow,ncol/), resP)

;pos1 = get_title_position(plot(0))         ; 1st row leftmost plot
;pos2 = get_title_position(plot(4))         ; 2nd row leftmost plot
;txres               = True
;txres@txFontHeightF = 0.012
;txres@txAngleF      = 90.
;gsn_text_ndc(wks, "TOTAL 1981-2016",   pos1(0), pos1(1), txres)
;gsn_text_ndc(wks, "EXCLUYENDO 1983,1998",   pos2(0), pos2(1), txres)
    
;frame(wks)

end
