;============== %%%% HERRAMIENTAS %%%% ==============
load "$NCARG_ROOT/lib/ncarg/nclscripts/contrib/cd_inv_string.ncl"   ;---> para fechas 
load "$NCARG_ROOT/lib/ncarg/nclscripts/contrib/cd_string.ncl"       ;---> para fechas
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/shea_util.ncl"


levels2 := (/-50.,-40.,-30.,-25.,-20.,-18.,-16.,-14.,-12.,-10.,\
        -9.,-8.,-7.,-6,-5,-4.,-3.,-2.,-1.,-0.9,-0.8,-0.7,-0.6,\
        -0.5,-0.4,-0.3,-0.2,-0.1,0,0.1,0.2,0.3,0.4,0.5,0.6,0.7,\
        0.8,0.9,1.,2.,3.,4.,5.,6.,7.,8.,9.,10.,12.,14.,16.,18,\
        20.,25.,30.,40.,50/) 

horas = (/"24 hrs","48 hrs","72 hrs"/)

begin
    ;f_data_vnp  = "/data/users/jticse/Tesis-Maestria/SALIDAS/csv/VNP.csv"
    ;f_data_vnp  = "/data/users/jticse/Tesis-Maestria/SALIDAS/csv/VNP2.csv"  ;---> estaciones y cuencas
    f_data_vnp  = "/data/users/jticse/Tesis-Maestria/SALIDAS/csv/VNP3.csv"  ;---> estaciones y cuencas
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

    do j=0,dim_fc_vnp-1
        cod_est    := fc_vnp(j,16)                          ;--> codigo de las estaciones 
        id_est     := str_match_ind(fc_anom(:,20),cod_est)  ;--> array de estaciones dentro de la cuenca
        if (.not.all(ismissing(id_est))) then
            ;¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬
            ;----- creando mapa ------;
            type    = "png"
            type@wkWidth     = 2000
            type@wkHeight    = 2000
            ;type    = "x11"
            dirS    = "/data/users/jticse/Tesis-Maestria/SALIDAS/figuras/"
            wks     = gsn_open_wks(type,dirS+"anom-WRF-SE-CU-BOX-"+fc_vnp(j,17))
            plot   := new(9,graphic)
            poly   := new(9,graphic)
            ;print("Plot---> "+isdefined("plot"))
            do k=0,2 
                year   := stringtoint(str_get_cols(periodos,0,3))
                mes    := stringtoint(str_get_cols(periodos,5,6))
                dia    := stringtoint(str_get_cols(periodos,8,9))
                hora   := dia
                hora    = 0
                minuto := hora
                seg    := minuto
                t_se   := cd_inv_calendar(year,mes,dia+k,hora,minuto,seg,"days since 1971-1-1",0)
                fecha_s:= cd_string(t_se,"%D-%N-%Y")        ;---> fechas del primer periodo
                fc_anom_2  := fc_anom(id_est,:)             ;---> anomalias de todas est de la cuenca todas las fechas
                dim1        = count_unique_values(fc_anom_2(:,0))   ;--> estaciones cantidad
                dim1_get   := get_unique_values(fc_anom_2(:,0))     ;--> estaciones unicas
                dim2        = dimsizes(periodos)
                fc_anom_3  := new((/dim1,dim2,2,2/),float)
                do i=0,dimsizes(fc_anom_2(:,0))-1
                    do m=0,dim1-1
                        do l=0,dim2-1
                            cond1 = fc_anom_2(i,0).eq.dim1_get(m)
                            cond2 = fc_anom_2(i,1).eq.fecha_s(l)
                            n=0
                            if stringtoint(str_get_cols(fecha_s(l),6,9)).eq.2018
                                n=1
                            end if
                            ;print(n+"--->"+str_get_cols(fecha_s(l),6,9))
                            if cond1.and.cond2 then
                                fc_anom_3(m,l,n,0) = tofloat(fc_anom_2(i,2))-tofloat(fc_anom_2(i,3))
                                fc_anom_3(m,l,n,1) = tofloat(fc_anom_2(i,8))
                            end if
                        end do
                    end do
                end do
                opt             = True ; Habilita personalizaÃ§Ã£o da estatÃ­stica.
                ;opt@PrintStat   = True ; Mostra na tela o resultado da estÃ¡tistica da funÃ§Ã£o stat_dispersion. 
                stat := new((/3,dim1,30/),float)
                do p=0,dim1-1
                    stat(0,p,:) = stat_dispersion(fc_anom_3(p,:,0,0),opt) ;----> 2017
                    stat(1,p,:) = stat_dispersion(fc_anom_3(p,:,1,0),opt) ;----> 2018
                    stat(2,p,:) = stat_dispersion(fc_anom_3(p,:,:,0),opt) ;----> 2017 y 2018
                end do
                yval     := new((/3,dim1,5/),float,-999.)
                do q=0,dim1-1
                    yval(0,q,0) = stat(0,q,2) ; Tamanho da haste inferior.
                    yval(0,q,1) = stat(0,q,7) ; Primeiro quartil.
                    yval(0,q,2) = stat(0,q,8) ; Mediana.
                    yval(0,q,3) = stat(0,q,11) ; Terceiro quartil.
                    yval(0,q,4) = stat(0,q,14) ; Tamanho da haste superior.
                    yval(1,q,0) = stat(1,q,2) ; Tamanho da haste inferior.
                    yval(1,q,1) = stat(1,q,7) ; Primeiro quartil.
                    yval(1,q,2) = stat(1,q,8) ; Mediana.
                    yval(1,q,3) = stat(1,q,11) ; Terceiro quartil.
                    yval(1,q,4) = stat(1,q,14) ; Tamanho da haste superior.
                    yval(2,q,0) = stat(2,q,2) ; Tamanho da haste inferior.
                    yval(2,q,1) = stat(2,q,7) ; Primeiro quartil.
                    yval(2,q,2) = stat(2,q,8) ; Mediana.
                    yval(2,q,3) = stat(2,q,11) ; Terceiro quartil.
                    yval(2,q,4) = stat(2,q,14) ; Tamanho da haste superior.    
                end do
		        print(yval)
                x := ispan(1,dim1,1) ; Valores para o eixo x.
                res                 = True
                res@tmXBLabelAngleF = 90.                                           ; InclinaÃ§Ã£o do texto.
                res@tmXBLabels     := dim1_get ; RÃ³tulos do eixo x.
                res@trYMinF         = -50.0              ; bottom of X-scale
                res@trYMaxF         =  50.0
                res@tiYAxisFontHeightF  = 0.04
                ;res@tiYAxisFontColor    = "navy"
                res@tiYAxisSide         = "right"
                res@tiYAxisAngleF       = 270
                res@tiYAxisString       = ""
		        opti          	= True			
  		        opti@boxWidth 	= 0.8				; Width of box (x units)
  		        opti@boxColors	= "blue"  	; Color of box(es)
                if (.not.all(ismissing(yval(0,:,:)))) then ;---> 2017
                    res@tiMainString    = horas(k)
                    if k.eq.2 then
                        res@tiYAxisString       = "2017"
                    end if
                    plot(k) = boxplot(wks,x,yval(0,:,:),opti,res,False) ; GeraÃ§Ã£o do boxplot.
                end if
                if (.not.all(ismissing(yval(1,:,:)))) then ;---> 2018
                    res@tiMainString    = ""
                    if k.eq.2 then
                        res@tiYAxisString       = "2018"
                    end if
                    plot(k+3) = boxplot(wks,x,yval(1,:,:),opti,res,False) ; GeraÃ§Ã£o do boxplot.
                end if
                if (.not.all(ismissing(yval(2,:,:)))) then ;---> 2019
                    res@tiMainString    = ""
                    if k.eq.2 then
                        res@tiYAxisString       = "Total"
                    end if
                    plot(k+6) = boxplot(wks,x,yval(2,:,:),opti,res,False) ; GeraÃ§Ã£o do boxplot.
                end if
            end do                
            if (.not.all(ismissing(plot))) then
                resP                    = True
                resP@gsnPanelMainString = "Anomalia WRF-SENAMHI-Boxplot-"+fc_vnp(j,17)
                resP@gsnPanelMainFontHeightF = 0.01 
                resP@gsnMaximize        = True
                ;resP@gsnFrame           = False
                resP@gsnPanelLeft       = 0.05	; shrink panel plot so that there is extra room for the left y-axis label
                resP@gsnPanelRight      = 0.95	; shrink panel plot so that there is extra room for the right y-axis label
                ;resP@gsnPanelRowSpec    = True
                gsn_panel(wks,plot,(/3,3/),resP)
                ;txres3               = True             
                ;txres3@txAngleF      = 90.          ; Rotate string clockwise 
                ;txres3@txFontHeightF = 0.01
                ;gsn_text_ndc(wks,"Anomalia",0.025,0.5,txres3)
                ;frame(wks)
            end if
            delete(plot)
            delete(wks)
        end if
    end do
end
