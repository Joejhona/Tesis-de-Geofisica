;============== %%%% HERRAMIENTAS %%%% ==============
load "$NCARG_ROOT/lib/ncarg/nclscripts/contrib/cd_inv_string.ncl"   ;---> para fechas 
load "$NCARG_ROOT/lib/ncarg/nclscripts/contrib/cd_string.ncl"       ;---> para fechas

levels2 := (/-50.,-40.,-30.,-25.,-20.,-18.,-16.,-14.,-12.,-10.,\
        -9.,-8.,-7.,-6,-5,-4.,-3.,-2.,-1.,-0.9,-0.8,-0.7,-0.6,\
        -0.5,-0.4,-0.3,-0.2,-0.1,0,0.1,0.2,0.3,0.4,0.5,0.6,0.7,\
        0.8,0.9,1.,2.,3.,4.,5.,6.,7.,8.,9.,10.,12.,14.,16.,18,\
        20.,25.,30.,40.,50/) 

horas = (/"24 hrs","48 hrs","72 hrs"/)

begin
    f_data_vnp  = "/data/users/jticse/Tesis-Maestria/SALIDAS/csv/VNP.csv"
    fc_vnp     := asciiread(f_data_vnp,-1,"string")
    fc_vnp     := str_split_csv(fc_vnp(1:),",",0)
    dim_fc      = dimsizes(fc_vnp(:,0))
    dq = str_get_dq()
    fc_vnp     := str_sub_str(fc_vnp,dq,"")

    f_data_anom = "/data/users/jticse/Tesis-Maestria/SALIDAS/csv/anom-wrf-sen.csv"
    fc_anom    := asciiread(f_data_anom,-1,"string")
    fc_anom    := str_split_csv(fc_anom(1:),",",0)
    ;dim_fc      = dimsizes(fc_anom(:,0))
    fc_anom    := str_sub_str(fc_anom,dq,"")

    periodos:= (/"2017-01-14","2017-01-21","2017-01-24","2017-01-30","2017-02-02",\
        "2017-02-25","2017-03-08","2017-03-13","2017-03-21","2017-03-25",\
        "2018-01-10","2018-01-16","2018-01-21","2018-02-14","2018-02-17",\
        "2018-03-05","2018-03-17","2018-03-22"/)

    periodos := periodos(:9)
    ;periodos := periodos(10:)

    res = True
    res@gsnDraw         = False                ; Don't draw plot 
    res@gsnFrame        = False                ; Don't advance frame
    res@trXMinF         = -50.0              ; bottom of X-scale
    res@trXMaxF         =  50.0  
    res@xyMarkerColor   = "blue"
    ;res@tiMainString    = "Scatter Plot"           ; add title
    res@xyMarkLineModes = "Markers"                ; choose which have markers
    res@xyMarkers       =  16                      ; choose type of marker  
    res@xyMarkerSizeF   = 0.01                     ; Marker size (default 0.01)
    res@tmXBMode        = "Explicit"
    res@tmXBValues      = levels2
    res@tfPolyDrawOrder = "PreDraw"
    ;res@tmXBLabels      = tostring_with_format(levels2,"%3.1f")
    ;res@tmXBLabels      = (/"-50","","-30","","-20","","","","","-10",\
    ;    "","","","","-5","","","","-1","","","","",\
    ;    "","","","","","0","","","","","","","",\
    ;    "","","1","","","","5","","","","","10","","","","",\
    ;    "20","","30","40","50"/) 
    res@tmXBLabels      = (/"-50","","-30","","-20","","","","","-10",\
        "","","","","","","","","","","","","",\
        "","","","","","0","","","","","","","",\
        "","","","","","","","","","","","10","","","","",\
        "20","","30","40","50"/) 

    do j=0,1;dim_fc-1
        cod_est    := fc_vnp(j,16)
        id_est     := str_match_ind(fc_anom(:,20),cod_est)
        if (.not.all(ismissing(id_est))) then
            ;¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬
            ;----- creando mapa ------;
            type    = "png"
            type@wkWidth     = 4000
            type@wkHeight    = 8500
            ;type    = "x11"
            dirS    = "/data/users/jticse/Tesis-Maestria/SALIDAS/figuras/"
            wks     = gsn_open_wks(type,dirS+"anom-WRF-SE-CU-"+fc_vnp(j,16))
            plot    = new(dimsizes(periodos)*3,graphic)
            poly    = new(dimsizes(periodos)*3,graphic)
            do i=0,dimsizes(periodos)-1
                periodo = periodos(i)
                year    = stringtoint(str_get_cols(periodo,0,3))
                mes     = stringtoint(str_get_cols(periodo,5,6))
                dia     = stringtoint(str_get_cols(periodo,8,9))
                do k=0,2
                    t_se        = cd_inv_calendar(year,mes,dia+k,0,0,0,"days since 1971-1-1",0)
                    fecha_s     = cd_string(t_se,"%D-%N-%Y")
                    fc_anom_2  := fc_anom(id_est,:)
                    id_fe      := str_match_ind(fc_anom_2(:,1),fecha_s)
                    anom       := tofloat(fc_anom_2(id_fe,2))-tofloat(fc_anom_2(id_fe,3))
                    res@tiMainString    = ""
                    res@tiYAxisString   = ""
                    if (3*i+k).le.2 then
                        res@tiMainString    = horas(k)
                    end if
                    if (3*i+k).eq.(3*i+2) then
                        res@tiYAxisString       = fecha_s
                        res@tiYAxisFontHeightF  = 0.04
                        ;res@tiYAxisFontColor    = "navy"
                        res@tiYAxisSide         = "right"
                        res@tiYAxisAngleF       = 270
                    end if
                    plot(3*i+k) = gsn_csm_xy(wks,anom,tofloat(fc_anom_2(id_fe,8)),res)  
                    ;delete([/res@tiMainString,res@tiYAxisString/])
                    ymin       := new(1,float)
                    ymax       := new(1,float)
                    getvalues plot(3*i+k)
                        "trYMinF": ymin
                        "trYMaxF": ymax
                    end getvalues    
                    gres             = True
                    gres@gsFillColor = "lightgray"
                    poly(3*i+k) = gsn_add_polygon(wks,plot(3*i+k),(/-5.,5.,5.,-5.,-5./),(/ymin,ymin,ymax,ymax,ymin/),gres)       
                end do
            end do
            resP                    = True
            resP@gsnPanelMainString = "Anomalia WRF-SENAMHI "+fc_vnp(j,17)
            resP@gsnPanelMainFontHeightF = 0.01 
            resP@gsnMaximize        = True
            resP@gsnFrame           = False
            gsn_panel(wks,plot,(/dimsizes(periodos),3/),resP)
            txres3               = True             
            txres3@txAngleF      = 90.          ; Rotate string clockwise 
            txres3@txFontHeightF = 0.01
            gsn_text_ndc(wks,"Altura Est. SENAMHI (msnm)",0.3,0.5,txres3)
            frame(wks)
        end if
    end do
end
