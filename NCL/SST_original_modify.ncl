a = file1
b = file2
a1 = addfile(a,"r")
b1 = addfile(b,"r")
a1_sst = a1->SST
b1_sst = b1->SST
print("Or="+max(a1_sst)+"----"+"Mod="+max(b1_sst))