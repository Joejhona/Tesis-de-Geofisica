;===>> h=1 dia, 2 dias, 3 dias #####
;===>> file_wrf   #####
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
;---Limites del Rímac---;
min_lat_r = -12.5
max_lat_r = -11.2
min_lon_r = -77.5
max_lon_r = -75.7
;---Limites norte---;
min_lat_n = -13.
max_lat_n = -1.
min_lon_n = -84.
max_lon_n = -75.

;============== %%%% HERRAMIENTAS %%%% ==============
load "$NCARG_ROOT/lib/ncarg/nclscripts/contrib/cd_inv_string.ncl"   ;---> para fechas 
load "$NCARG_ROOT/lib/ncarg/nclscripts/contrib/cd_string.ncl"       ;---> para fechas

;============== %%%% COLORES %%%% ==============
levels = (/0.1,0.2,0.3,0.4,0.5,0.6,0.7,\
    0.8,0.9,1.,1.5,2.,2.5,3.,3.5,\
    4.,4.5,5.,6.,7.,8.,\
    9.,10.,15.,20.,25.,30.,35.,40.,\
    45.,50.,55.,60.,65.,70.,75.,\
    80.,85.,90.,95.,100./)
color_paleta = "WhBlGrYeRe"

levels2 := (/-50.,-40.,-30.,-25.,-20.,-18.,-16.,-14.,-12.,-10.,\
        -9.,-8.,-7.,-6,-5,-4.,-3.,-2.,-1.,-0.9,-0.8,-0.7,-0.6,\
        -0.5,-0.4,-0.3,-0.2,-0.1,0,0.1,0.2,0.3,0.4,0.5,0.6,0.7,\
        0.8,0.9,1.,2.,3.,4.,5.,6.,7.,8.,9.,10.,12.,14.,16.,18,\
        20.,25.,30.,40.,50/) 
;color_paleta2 = "precip_diff_12lev";--> paleta 12 colores
;color_paleta2 = "WhBlReWh"
;color_paleta2 = "ViBlGrWhYeOrRe"
color_paleta2 = "MPL_BrBG"

begin 
    sst     = (/"-3sst","-2sst","+2sst","+3sst"/)
    fecha   = str_get_cols(file_wrf,11,20)
    year    = stringtoint(str_get_cols(file_wrf,11,14))
    mes     = stringtoint(str_get_cols(file_wrf,16,17))
    dia     = stringtoint(str_get_cols(file_wrf,19,20))
    ;hora    = (/"24 hrs","48 hrs","72 hrs"/)
    ;horas   = hora
    ;----- creando mapa ------;
    type    = "png"
    ;type    = "x11"
    dirS    = "/data/users/jticse/Tesis-Maestria/SALIDAS/figuras/"
    type@wkWidth     = 7000
    type@wkHeight    = 8000             
    wks     = gsn_open_wks(type,dirS+"rain_sst_"+fecha+"_"+t*24+"_hrs")   
    plot    = new(6,graphic)
    plot2   = new(4,graphic)
    
;----- agregando detalles al mapa -----;
    res                     = True      ;--> activa los detalles
    res@gsnDraw             = False     ;--> don't draw the plot yet
    res@gsnFrame            = False     ;--> 
    res@mpFillOn            = False
    ;res@gsnMaximize         = True
    ;res@gsnLeftString       = "mm/dia"
    res@gsnLeftString      = ""
    res@mpLimitMode         = "Corners" ;--> Activa limites modo corners
    res@mpLeftCornerLatF    = min_lat_n ;--> limites.ncl r=rimac p=Perú   
    res@mpRightCornerLatF   = max_lat_n ;--> n=Norte
    res@mpLeftCornerLonF    = min_lon_n
    res@mpRightCornerLonF   = max_lon_n
    ;res@tiMainString        = "Prueba"
    ;res@lbOrientation       = "Vertical"

    ;---Limites Nacionales---;
    res@tmYLLabelsOn                = False         ; turn off lat labels
    res@tmXBLabelsOn                = False         ; turn off lon labels
    ;res@tmYROn                      = False
    ;res@tmYLOn                      = False
    ;res@tmXTOn                      = False
    ;res@tmXBOn                      = False

    res@gsnAddCyclic        = False
    res@lbLabelBarOn        = False             ;---> turn off individual cb's
    res@cnFillOn            = True
    res@cnFillPalette       = color_paleta
    res@cnLinesOn           = False             ;---> Contorno de linea (falso = no)
    res@cnLineLabelsOn      = False
    res@cnLevelSelectionMode= "ExplicitLevels"  ;---> Solo usa los indicados en levels
    res@cnLevels            = levels

    res@gsnCenterStringFontHeightF = 0.04



    file_1  = addfile(file_wrf,"r")
    lat_w  := wrf_user_getvar(file_1,"XLAT",0)
    lon_w  := wrf_user_getvar(file_1,"XLONG",0)
    t_wrf  := wrf_user_list_times(file_1)
    format  = "%Y-%N-%D_%H:%M:%S"
    t_wrf  := cd_inv_string(t_wrf, format)
    un_wrf  = t_wrf@units
    rcv     = wrf_user_getvar(file_1,"RAINC",-1)
    rncv    = wrf_user_getvar(file_1,"RAINNC",-1)
    it_wrf := cd_inv_calendar(year,mes,dia,12,0,0,un_wrf,0)   ;---->> hora de inicio de lluvia
    ft_wrf := cd_inv_calendar(year,mes,dia+t,12,0,0,un_wrf,0) ;---->> hora de inicio de lluvia
    id_tiw := get1Dindex(t_wrf,it_wrf)
    id_tfw := get1Dindex(t_wrf,ft_wrf)
    rcvi   := rcv(id_tiw,:,:)
    rcvf   := rcv(id_tfw,:,:)
    rncvi  := rncv(id_tiw,:,:)
    rncvf  := rncv(id_tfw,:,:)
    pd_wrf_1= (rcvf-rcvi)+(rncvf-rncvi)
    pd_wrf_1@lat2d := lat_w
    pd_wrf_1@lon2d := lon_w  
    printVarSummary(pd_wrf_1)
    res1                   := res
    res1@gsnCenterString   := t*24+" hrs Normal" 
    plot(0) = gsn_csm_contour_map(wks,pd_wrf_1,res1)

    file_2   := addfile(file_wrf+"_sst","r")
    rcv      := wrf_user_getvar(file_2,"RAINC",-1)
    rncv     := wrf_user_getvar(file_2,"RAINNC",-1)
    rcvi     := rcv(id_tiw,:,:)
    rcvf     := rcv(id_tfw,:,:)
    rncvi    := rncv(id_tiw,:,:)
    rncvf    := rncv(id_tfw,:,:)
    pd_wrf_2 := (rcvf-rcvi)+(rncvf-rncvi)
    pd_wrf_2@lat2d := lat_w
    pd_wrf_2@lon2d := lon_w 
    printVarSummary(pd_wrf_2)
    res2                   := res
    res2@gsnCenterString   := t*24+" hrs add RTG SST" 
    plot(1) = gsn_csm_contour_map(wks,pd_wrf_2,res2)

    do i=0,dimsizes(sst)-1
        file_i   := addfile(file_wrf+sst(i),"r")
        rcv      := wrf_user_getvar(file_i,"RAINC",-1)
        rncv     := wrf_user_getvar(file_i,"RAINNC",-1)
        rcvi     := rcv(id_tiw,:,:)
        rcvf     := rcv(id_tfw,:,:)
        rncvi    := rncv(id_tiw,:,:)
        rncvf    := rncv(id_tfw,:,:)
        pd_wrf_i := (rcvf-rcvi)+(rncvf-rncvi)
        pd_wrf_i@lat2d := lat_w
        pd_wrf_i@lon2d := lon_w  
        printVarSummary(pd_wrf_i)
        resi1                   := res
        resi1@gsnCenterString   := sst(i) 
        plot(i+2) = gsn_csm_contour_map(wks,pd_wrf_i,resi1)

        dif_i  := pd_wrf_1-pd_wrf_i
        dif_i@lat2d := lat_w
        dif_i@lon2d := lon_w  
        printVarSummary(dif_i)
        resi2                   := res
        resi2@gsnCenterString   := "dif "+sst(i) 
        resi2@cnFillPalette     := color_paleta2
        resi2@cnLevels          := levels2
        plot2(i) = gsn_csm_contour_map(wks,dif_i,resi2)
    end do

    dims1 = (/2,4/)
    dims2 = (/1,4/)


    ;pres                 = True
    ;pres@gsnPanelRowSpec = True  
    ;;pres@gsnPanelCenter  = False
    ;pres@gsnMaximize        = True
    ;pres@gsnPanelLabelBar   = True                ; add common colorbar
    ;pres@lbOrientation      = "vertical"
    ;pres@lbLabelFontHeightF = 0.01
    ;pres@gsnPanelLeft       = 0.04
    ;pres@gsnPanelBottom     = 0.08
    ;pres@lbTitleOn          = True                  ; turn on title
    ;pres@lbTitleString      = "mm/dia"
    ;pres@lbBoxEndCapStyle   = "TriangleHighEnd"
    ;pres@pmLabelBarHeightF  = 0.8
    ;pres@gsnPanelMainString = "Influencia SST "+fecha
    ;agregando_shapefile1 = gsn_add_shapefile_polylines(wks,plot,shp1,shpres)
    ;agregando_shapefile2 = gsn_add_shapefile_polylines(wks,plot,shp2,shpres2)

    ;gsn_panel(wks,plot,(/2,4,4/),pres)

    pres1@gsnMaximize        = True
    pres1@gsnPanelRowSpec    = True  ;====================
    pres1@gsnPanelLabelBar   = True                ; add common colorbar
    pres1@lbOrientation      = "vertical"
    pres1@vpHeightF          = 0.6
    pres1@lbLabelFontHeightF = 0.01               ; make labels smaller
    pres1@gsnPanelLeft       = 0.04
    pres1@gsnPanelBottom     = 0.08
    pres1@gsnPanelSave       = True
    pres1@lbTitleOn          = True                  ; turn on title
    pres1@lbTitleString      = "mm/dia"
    pres1@lbBoxEndCapStyle   = "TriangleHighEnd"
    pres1@lbTitleFontHeightF = 0.01
    pres1@pmLabelBarHeightF  = 0.6
    pres1@gsnPanelMainString = "Influencia SST "+fecha
    pres2 = True
    pres2@gsnMaximize        = True
    pres2@gsnPanelLabelBar   = True                ; add common colorbar
    pres2@lbOrientation      = "vertical"
    pres2@vpHeightF          = 0.6
    pres2@lbLabelFontHeightF = 0.01               ; make labels smaller
    pres2@gsnPanelLeft       = 0.04
    pres2@gsnPanelBottom     = 0.08
    pres2@gsnPanelSave       = True
    ;pres2@lbTitleOn          = True                  ; turn on title
    ;pres2@lbTitleString      = "mm/dia"
    pres2@lbBoxEndCapStyle   = "TriangleBothEnds"
    pres2@lbTitleFontHeightF = 0.01
    pres2@pmLabelBarHeightF   = 0.3
	;pres2@gsnPanelMainString = "Anomalia lluvia WRF - PISCO"
    pres  = True
    pres@gsnPanelTop         = 0.95
    ;pres1@lbLabelFontHeightF = 0.01     ; make labels slightly larger
    ;pres2@lbLabelFontHeightF = 0.01
    agregando_shapefile1      = gsn_add_shapefile_polylines(wks,plot,shp1,shpres)
    agregando_shapefile2      = gsn_add_shapefile_polylines(wks,plot2,shp1,shpres)
    agregando_shapefile3      = gsn_add_shapefile_polylines(wks,plot,shp2,shpres2)
    agregando_shapefile4      = gsn_add_shapefile_polylines(wks,plot2,shp2,shpres2)
    panel_two_sets(wks,plot,plot2,dims1,dims2,pres1,pres2,pres)

end
