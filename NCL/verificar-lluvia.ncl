begin
    a   = addfile(file1,"r")
    b   = addfile(file2,"r")
    rcv_a   = wrf_user_getvar(a,"RAINC",-1)
    rncv_a  = wrf_user_getvar(a,"RAINNC",-1)
    rcv_b   = wrf_user_getvar(b,"RAINC",-1)
    rncv_b  = wrf_user_getvar(b,"RAINNC",-1)
    rain_a  = rcv_a+rncv_a
    rain_b  = rcv_b+rncv_b
    dif     = rain_a-rain_b
    print("max="+max(dif))
end