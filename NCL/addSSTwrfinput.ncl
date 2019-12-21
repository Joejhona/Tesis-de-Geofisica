begin
    a = file_wrf
    b = addfile(a,"w")
    c = b->SST
    d = c
    d = d+dif
    b->SST = d
    print(max(c)+"----"+max(d))
end