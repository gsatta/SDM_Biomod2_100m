# Model ensemble models
myBiomodEM <- BIOMOD_EnsembleModeling(bm.mod = myBiomodModelOut,
                                      models.chosen = 'all',
                                      em.by = 'all',
                                      # em.algo = c('EMmean', 'EMmedian', 'EMcv', 'EMci', 'EMca', 'EMwmean'),
                                      em.algo = c('EMmean', 'EMmedian'),
                                      metric.select = c('ROC'),
                                      metric.select.thresh = c(0.8),
                                      metric.eval = c('TSS', 'ROC'),
                                      var.import = 3,
                                      EMci.alpha = 0.05,
                                      EMwmean.decay = 'proportional',
                                      nb.cpu = 4,
                                      do.progress = TRUE)
myBiomodEM

# Get evaluation scores & variables importance
get_evaluations(myBiomodEM)
get_variables_importance(myBiomodEM)

# Represent evaluation scores & variables importance
bm_PlotEvalMean(bm.out = myBiomodEM, group.by = 'full.name')
bm_PlotEvalBoxplot(bm.out = myBiomodEM, group.by = c('full.name', 'full.name'))
bm_PlotVarImpBoxplot(bm.out = myBiomodEM, group.by = c('expl.var', 'full.name', 'full.name'))
bm_PlotVarImpBoxplot(bm.out = myBiomodEM, group.by = c('expl.var', 'algo', 'merged.by.run'))
bm_PlotVarImpBoxplot(bm.out = myBiomodEM, group.by = c('algo', 'expl.var', 'merged.by.run'))

# Represent response curves
bm_PlotResponseCurves(bm.out = myBiomodEM, 
                      models.chosen = get_built_models(myBiomodEM)[c(1, 2)],
                      fixed.var = 'median')
bm_PlotResponseCurves(bm.out = myBiomodEM, 
                      models.chosen = get_built_models(myBiomodEM)[c(1, 2)],
                      fixed.var = 'mean')
bm_PlotResponseCurves(bm.out = myBiomodEM, 
                      models.chosen = get_built_models(myBiomodEM)[c(1, 2)],
                      fixed.var = 'median',
                      do.bivariate = TRUE)

# Project ensemble models (from single projections)
# myBiomodEMProj <- BIOMOD_EnsembleForecasting(bm.em = myBiomodEM, 
#                                              bm.proj = myBiomodProj,
#                                              models.chosen = 'all',
#                                              metric.binary = 'all',
#                                              metric.filter = 'all')

# # Project ensemble models (building single projections)
myBiomodEMProj <- BIOMOD_EnsembleForecasting(bm.em = myBiomodEM,
                                             proj.name = 'CurrentEM_2',
                                             new.env = myExpl,
                                             nb.cpu = 4,
                                             models.chosen = 'all',
                                             metric.binary = 'all',
                                             metric.filter = 'all',
                                             build.clamping.mask = TRUE,
                                             do.stack = TRUE,
                                             output.format = ".tif")
myBiomodEMProj
plot(myBiomodEMProj)

mappa <- rast("./Phytophthora/proj_CurrentEM_2/proj_CurrentEM_2_Phytophthora_ensemble.tif")
focolai <- read_sf("./INPUT/VECTOR/FOCOLAI.gpkg")
lim <- read_sf("./INPUT/VECTOR/limite_amministrativo_paulilatino_32632.gpkg")

mappa <- mappa$Phytophthora_EMmeanByROC_mergedData_mergedRun_mergedAlgo/1000

plot(mappa$Phytophthora_EMmeanByROC_mergedData_mergedRun_mergedAlgo, col = terrain.colors(100)) #1
# Sovrapposizione dei punti sul raster
points(myRespXY, col = "red")
# Disegna i bordi del poligono
lines(focolai, col = "red")
lines(lim, col = "black")

mapppa2 <- rast("./Phytophthora/proj_CurrentEM/proj_CurrentEM_Phytophthora_ensemble_ROCbin.tif")


plot(mapppa2) #2

plot(mappa$Phytophthora_EMcaByTSS_mergedData_mergedRun_mergedAlgo) #3

plot(mappa$Phytophthora_EMciInfByTSS_mergedData_mergedRun_mergedAlgo) #5

plot(mappa$Phytophthora_EMciSupByTSS_mergedData_mergedRun_mergedAlgo) #6

plot(mappa$Phytophthora_EMciSupByTSS_mergedData_mergedRun_mergedAlgo) #7








