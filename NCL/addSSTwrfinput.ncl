a = file_wrf
b = addfile(a,"w")
c = b->SST
d = c
d = d+1
b->SST = d
print(max(c)+"----"+max(d))