begin
    a   = file_wrf
    a1  = "+"
    if (dif.lt.0) then
        a1 = "-"
    end if
    a2  = a+a1+dif+"sst"
    cmd = "cp "+a+" "+a2
    system(cmd)
    b = addfile(a2,"w")
    c = b->SST
    d = c
    d = d+dif
    b->SST = d
    print(max(c)+"----"+max(d))
end