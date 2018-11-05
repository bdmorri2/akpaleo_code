library(spatial.tools)

time = "rcp8"
months = c("jan", "feb", "mar", "april", "may", "june", "july", "aug", "sept", "oct", "nov", "dec")
u_files = list.files(path = paste('/projects/oa/tree_vel/climate/monthly_average/resample/', time, "/u", sep = ""), pattern = ".tif", include.dirs = T, full.names = T)
v_files = list.files(path = paste('/projects/oa/tree_vel/climate/monthly_average/resample/', time, "/v", sep = ""), pattern = ".tif", include.dirs = T, full.names = T)


for (i in 1:length(months))
{
  module = print("module load anaconda")
  gdal = print(paste("gdal_calc.py -A ", u_files[i] , " -B ", v_files[i], " --outfile /projects/oa/tree_vel/downscale/averages/", time, "/wind/speed/speed_", months[i], "_", time, ".tif --calc='numpy.sqrt(A**2+B**2)'", sep = ""))#(A**3)*1000*2629743.83
  combine = rbind(module, gdal)
  write(combine, file = paste("/projects/oa/tree_vel/downscale/averages/", time, "/wind/speed/qsub_files/speed_",i, ".sh", sep = ""))
}
