;============== %%%% AYUDA %%%% ==============
;===>> t=1 dia, 2 dias, 3 dias #####
;===>> file_wrf   #####
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
color1  = read_colormap_file("GMT_drywet")
color2  = read_colormap_file("perc2_9lev")
color1(0,:)     = color2(9,:)
color1(1,:)     = color2(6,:)
color_paleta    = color1

levels2 := (/-50.,-40.,-30.,-25.,-20.,-18.,-16.,-14.,-12.,-10.,\
        -9.,-8.,-7.,-6,-5,-4.,-3.,-2.,-1.,-0.9,-0.8,-0.7,-0.6,\
        -0.5,-0.4,-0.3,-0.2,-0.1,0,0.1,0.2,0.3,0.4,0.5,0.6,0.7,\
        0.8,0.9,1.,2.,3.,4.,5.,6.,7.,8.,9.,10.,12.,14.,16.,18,\
        20.,25.,30.,40.,50/) 
color3  = read_colormap_file("MPL_BrBG")
color4  = read_colormap_file("MPL_autumn")
color3(0:31,:)  = color4(64:95,:)
color_paleta2   = color3


levels3         = ispan(13,31,1)
color_paleta3   = "NCV_bright"

begin 
    sst     = (/"-3sst","-2sst","-1sst","+1sst","+2sst","+3sst"/)
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
    type@wkHeight    = 5000
    title1  = dirS+"rain_"+fecha+"_"+t*24
    wks     = gsn_open_wks(type,title1)   
    plot    = new(dimsizes(sst)+2,graphic)
    title2  = dirS+"diff_"+fecha+"_"+t*24
    wks2    = gsn_open_wks(type,title2)   
    plot2   = new(dimsizes(sst),graphic)
    ;title3  = dirS+"sst_"+fecha+"_"+t*24
    ;wks3    = gsn_open_wks(type,title2)   
    ;plot3   = new(dimsizes(sst),graphic)
    
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
    res@mpFillDrawOrder     = "PostDraw"
    ;res@tiMainString        = "Prueba"
    ;res@lbOrientation       = "Vertical"

    ;---Limites Nacionales---;
    ;res@tmYLLabelsOn                = False         ; turn off lat labels
    ;res@tmXBLabelsOn                = False         ; turn off lon labels
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
    ;res2                   := res
    ;res2@gsnCenterString   := t*24+" hrs add RTG SST" 
    ;plot(1) = gsn_csm_contour_map(wks,pd_wrf_2,res2)

    fecha_sst = str_sub_str(fecha,"-","_")
    file_3   := addfile("rtg_sst_"+fecha_sst+".grb","r")
    sst      := file_3->TMP_P0_L1_GLL0
    sst      := sst({min_lat_n:max_lat_n},{min_lon_n+360:max_lon_n+360})
    res3                   := res
    res3@gsnCenterString   := "RTG SST "+fecha
    res3@cnFillPalette     := color_paleta3
    res3@cnLevels          := levels3
    plot(1) = gsn_csm_contour_map(wks,pd_wrf_2,res3)

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

        dif_i  := pd_wrf_i-pd_wrf_2
        dif_i@lat2d := lat_w
        dif_i@lon2d := lon_w  
        printVarSummary(dif_i)
        resi2                   := res
        resi2@gsnCenterString   := "dif "+sst(i) 
        resi2@cnFillPalette     := color_paleta2
        resi2@cnLevels          := levels2
        plot2(i) = gsn_csm_contour_map(wks2,dif_i,resi2)
    end do

    pres1 = True
    pres1@gsnMaximize        = True
    pres1@gsnPanelRowSpec    = True  ;====================
    pres1@gsnPanelLabelBar   = True                ; add common colorbar
    ;pres1@vpHeightF          = 0.6
    pres1@lbLabelFontHeightF = 0.01               ; make labels smaller
    ;pres1@gsnPanelLeft       = 0.1
    pres1@gsnPanelBottom     = 0.08
    pres1@gsnPanelSave       = True
    pres1@lbTitleOn          = True                  ; turn on title
    pres1@lbTitleString      = "mm/dia"
    pres1@lbBoxEndCapStyle   = "TriangleHighEnd"
    pres1@lbTitleFontHeightF = 0.01
    pres1@pmLabelBarHeightF  = 0.06
    pres1@gsnPanelMainString = "Influencia de SST en la lluvia WRF"+fecha

    agregando_shapefile1      = gsn_add_shapefile_polylines(wks,plot,shp1,shpres)
    agregando_shapefile2      = gsn_add_shapefile_polylines(wks,plot,shp2,shpres2)

    gsn_panel(wks,plot,(/2,6/),pres1)

    pres2 = True
    pres2@lbTitleOn          = False                  ; turn on title
    ;pres2@gsnPanelMainString = "Diferencia"
    pres2@gsnPanelLabelBar   = True
    pres2@lbLabelFontHeightF = 0.007
    
    agregando_shapefile3      = gsn_add_shapefile_polylines(wks,plot2,shp1,shpres)
    agregando_shapefile4      = gsn_add_shapefile_polylines(wks,plot2,shp2,shpres2)

    gsn_panel(wks2,plot2,(/1,6/),pres2)

    cmd1 = "convert "+title1+".png -crop `convert "+title1+".png -virtual-pixel edge -blur 0x15 -fuzz -15% -trim -format '%wx%h%O' info:` +repage "+title1+".png"
    system(cmd1)
    cmd2 = "convert "+title2+".png -crop `convert "+title2+".png -virtual-pixel edge -blur 0x15 -fuzz -15% -trim -format '%wx%h%O' info:` +repage "+title2+".png"
    system(cmd2)
    cmd3 = "convert "+title1+".png "+title2+".png -append "+dirS+"inf_rain_sst_"+fecha+"_"+t*24+"_hrs.png"
    system(cmd3)

end