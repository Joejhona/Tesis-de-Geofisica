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
    ;f_data_vnp  = "/data/users/jticse/Tesis-Maestria/SALIDAS/csv/VNP.csv"
    f_data_vnp  = "/data/users/jticse/Tesis-Maestria/SALIDAS/csv/VNP2.csv"  ;---> estaciones y cuencas
    fc_vnp     := asciiread(f_data_vnp,-1,"string")
    fc_vnp     := str_split_csv(fc_vnp(1:),",",0)       
    dim_fc_vnp  = dimsizes(fc_vnp(:,0))
    dq = str_get_dq()
    fc_vnp     := str_sub_str(fc_vnp,dq,"")

    f_data_anom = "/data/users/jticse/Tesis-Maestria/SALIDAS/csv/anom-wrf-sen.csv"  ;---> registro de lluvia 
    fc_anom    := asciiread(f_data_anom,-1,"string")
    fc_anom    := str_split_csv(fc_anom(1:),",",0)
    ;dim_fc      = dimsizes(fc_anom(:,0))
    fc_anom    := str_sub_str(fc_anom,dq,"")

    f_data_se   = "/data/users/jticse/Tesis-Maestria/PREDATA/senamhi-17-18.csv"     ;---> registro de est-sen 
    fc_sen     := asciiread(f_data_se,-1,"string")

    fc_sen     := str_split_csv(fc_sen(1:),",",0)
    dim_fc_sen  = dimsizes(fc_sen(:,0))

    periodos:= (/"2017-01-14","2017-01-21","2017-01-24","2017-01-30","2017-02-02",\
        "2017-02-25","2017-03-08","2017-03-13","2017-03-21","2017-03-25",\
        "2018-01-10","2018-01-16","2018-01-21","2018-02-14","2018-02-17",\
        "2018-03-05","2018-03-17","2018-03-22"/)

    periodos := periodos(:9)    ;----> 2017
    ;periodos := periodos(10:)   ;----> 2018

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

    ;res@gsnXRefLine           = 0.              ; reference line   
    ;res@gsnXYBarChart         = True            ; create bar chart 
    ;res@gsnRightXRefLineColor = "red"           ; right of ref line fill red
    ;res@gsnLeftXRefLineColor  = "blue"          ; left of ref line fill blue

    do j=0,1;dim_fc_vnp-1
        cod_est    := fc_vnp(j,16)                          ;--> codigo de las estaciones 
        id_est     := str_match_ind(fc_anom(:,20),cod_est)  ;--> array de estaciones dentro de la cuenca
        if (.not.all(ismissing(id_est))) then
            ;¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬
            ;----- creando mapa ------;
            type    = "png"
            type@wkWidth     = 1000
            ;type@wkHeight    = 600
            ;type    = "x11"
            dirS    = "/data/users/jticse/Tesis-Maestria/SALIDAS/figuras/"
            wks     = gsn_open_wks(type,dirS+"anom-WRF-SE-CU-AVG-2017-"+fc_vnp(j,17))
            plot   := new(3,graphic)
            poly   := new(3,graphic)
            ;print("Plot---> "+isdefined("plot"))
            do k=0,2
                year   := stringtoint(str_get_cols(periodos,0,3))
                mes    := stringtoint(str_get_cols(periodos,5,6))
                dia    := stringtoint(str_get_cols(periodos,8,9))
                hora   := dia
                hora    = 0
                minuto  = hora
                seg     = minuto
                t_se    = cd_inv_calendar(year,mes,dia+k,hora,minuto,seg,"days since 1971-1-1",0)
                fecha_s = cd_string(t_se,"%D-%N-%Y")        ;---> fechas del primer periodo
                fc_anom_2  := fc_anom(id_est,:)             ;---> anomalias de todas est de la cuenca todas las fechas
                dim1        = count_unique_values(fc_anom_2(:,0)) 
                dim1_get   := get_unique_values(fc_anom_2(:,0))     ;--> estaciones
                dim2        = dimsizes(periodos)
                fc_anom_3  := new((/dim1,dim2,2/),float)
                do i=0,dimsizes(fc_anom_2(:,0))-1
                    do m=0,dim1-1
                        do l=0,dim2-1
                            cond1 = fc_anom_2(i,0).eq.dim1_get(m)
                            cond2 = fc_anom_2(i,1).eq.fecha_s(l)
                            if cond1.and.cond2 then
                                fc_anom_3(m,l,0) = tofloat(fc_anom_2(i,2))-tofloat(fc_anom_2(i,3))
                                fc_anom_3(m,l,1) = tofloat(fc_anom_2(i,8))
                            end if
                        end do
                    end do
                end do
                avg_anom   := dim_avg_n(fc_anom_3(:,:,0),1)
                altura     := dim_avg_n(fc_anom_3(:,:,1),1)
                if dimsizes(avg_anom).ge.3 then
                    res@tiMainString    = horas(k)
                    plot(k)  = gsn_csm_xy(wks,avg_anom,altura,res)  
                    ymin       := new(1,float)
                    ymax       := new(1,float)
                    getvalues plot(k)
                        "trYMinF": ymin
                        "trYMaxF": ymax
                    end getvalues    
                    gres             = True
                    gres@gsFillColor = "lightgray"
                    poly(k) = gsn_add_polygon(wks,plot(k),(/-5.,5.,5.,-5.,-5./),(/ymin,ymin,ymax,ymax,ymin/),gres)
                end if
            end do
            if (.not.all(ismissing(plot))) then
                resP                    = True
                resP@gsnPanelMainString = "Anomalia Promedio WRF-SENAMHI "+fc_vnp(j,17)
                resP@gsnPanelMainFontHeightF = 0.01 
                resP@gsnMaximize        = True
                resP@gsnFrame           = False
                resP@gsnPanelLeft  = 0.05	; shrink panel plot so that there is extra room for the left y-axis label
                resP@gsnPanelRight = 0.95	; shrink panel plot so that there is extra room for the right y-axis label
                gsn_panel(wks,plot,(/1,3/),resP)
                txres3               = True             
                txres3@txAngleF      = 90.          ; Rotate string clockwise 
                txres3@txFontHeightF = 0.01
                gsn_text_ndc(wks,"Altura Est. SENAMHI (msnm)",0.025,0.5,txres3)
                frame(wks)
            end if
            delete(plot)
            delete(wks)
        end if
    end do
end
