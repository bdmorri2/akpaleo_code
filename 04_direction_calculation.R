
time = "rcp8"
months = c("jan", "feb", "mar", "april", "may", "june", "july", "aug", "sept", "oct", "nov", "dec")
u_files = list.files(path = paste('/projects/oa/tree_vel/climate/monthly_average/resample/', time, "/u", sep = ""), pattern = ".tif", include.dirs = T, full.names = T)
v_files = list.files(path = paste('/projects/oa/tree_vel/climate/monthly_average/resample/', time, "/v", sep = ""), pattern = ".tif", include.dirs = T, full.names = T)

for (i in 1:length(months))
{
  module = print("module load anaconda")
  gdal = print(paste("gdal_calc.py -A ", u_files[i], " -B ", v_files[i]," --outfile /projects/oa/tree_vel/downscale/averages/", time, "/wind/dir/dir_", months[i], "_", time, ".tif --calc='(45/numpy.arctan(1))*(numpy.arctan2(A, B))+180'", sep = ""))#(A**3)*1000*2629743.83
  combine = rbind(module, gdal)
  write(combine, file = paste("/projects/oa/tree_vel/downscale/averages/", time, "/wind/dir/qsub_files/dir_", i, ".sh", sep = ""))
}
