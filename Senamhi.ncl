    ;-----Extraendo datos senamhi
    dir_sen = "/data/users/jticse/data/"
    dir_est = "estaciones_senamhi/*.csv"
    fc_sen  = "senamhi-17-18.csv"
    fc_sen := asciiread(dir_sen+fc_sen,-1,"string")
    fc_sen := str_split_csv(fc_sen(1:),",",0)
    dim_fc  = dimsizes(fc_sen(:,0))
    f_sen   = systemfunc(ls+dir_sen+dir_est)
    print(sep+sep)
    print("Datos SENAMHI extraidos")
    print(f_sen)