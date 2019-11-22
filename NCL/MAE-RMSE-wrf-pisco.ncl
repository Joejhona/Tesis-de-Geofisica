    mae     = abs(wrf(:,:,:,{24})-pisco(:,:,:,{24}))
    mae    := dim_avg_n(mae,0)

    rmse    = (wrf(:,:,:,{24})-pisco(:,:,:,{24}))^2
    rmse   := dim_avg_n(rmse,0)
    rmse   := sqrt(rmse)