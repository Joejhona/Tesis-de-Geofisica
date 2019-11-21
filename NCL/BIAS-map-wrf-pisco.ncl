dirBIAS = "/data/users/jticse/Tesis-Maestria/SALIDAS/netcdf/"
f_bias  = "bias-wrfd01-pisco.nc"
f_bias  = "bias-wrfd02-pisco.nc"

f_bias := addfile(dirBIAS+f_bias,"r")

wrf     = f_bias->var01
pisco   = f_bias->var02

mae     = abs(wrf(:,:,:,{24})-pisco(:,:,:,{24}))
mae    := dim_avg_n(mae,0)

rmse    = (wrf(:,:,:,{24})-pisco(:,:,:,{24}))^2
rmse   := dim_avg_n(rmse,0)
rmse   := sqrt(rmse)

bias    = (wrf(:,:,:,{24})-pisco(:,:,:,{24}))
bias   := dim_avg_n(bias,0)