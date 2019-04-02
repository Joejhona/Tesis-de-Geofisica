begin

dir_est = "/data/users/jticse/data/estaciones"
est_sen = systemfunc("ls "+dir_est)
len_est = dimsizes(est_sen)

data2 = asciiread(dir_est+"/"+est_sen(0), (/3,2/),"float")

end