# ################################################################################
# 
# #                     Variables Importance and Selection
# 
# ################################################################################
# 
# # Applicazione di maxent su per individuare quali sono le variabili più importanti
# 
# # get predictor variables
# fnames <- list.files(path = "./INPUT/RASTER/ASCII", pattern = '\\.asc$', 
#                      full.names = TRUE)
# 
# variables <- c("roads", "rivers", "aspect", "fla", "slope", "tpi", "twi", "clay", "soc", "sand", "silt", "BIO4",
#   "BIO7", "green")
# 
# # Load the necessary packages
# library(biomod2);library(terra)
# 
# # Load the necessary packages
# 
# # Load the environmental raster  at 50 m of spatial resolution
# myExpl_0 <- rast("./INPUT/RASTER/environmental_100m_standardized.tiff")
# 
# # # Get only the selected variables
# myExpl <- subset(myExpl_0, variables)
# 
# summary(myExpl)
# 
# n_PA_3 <- length(myResp_train) 
# 
# # Format Data with pseudo - absences: random method
# myBiomodData_0 <- BIOMOD_FormatingData(expl.var = myExpl,
#                                      resp.var = myResp_train,
#                                      resp.xy = myRespXY_train,
#                                      eval.expl.var = myResp_test,
#                                      eval.resp.xy =	myRespXY_test,
#                                      resp.name = "Phytophthora",
#                                      PA.nb.rep = 1,
#                                      PA.nb.absences = c(1000),
#                                      PA.strategy = 'random',
#                                      filter.raster = TRUE,
#                                      dir.name = getwd())
# myBiomodData_0
# 
# # plot(myBiomodData_0)
# 
# {
#   # Percorso al file maxent.jar
#   path_to_maxent.jar <- file.path(getwd(), "maxent.jar")
#   
#   # Cartella dei file ASCII
#   ascii_folder <- "./INPUT/RASTER/ASCII"
#   
#   # Elimina la cartella temporanea e tutti i suoi contenuti
#   unlink("./INPUT/RASTER/maxent_background_data",
#          recursive = TRUE)
#   
#   # Estrai i nomi dei layer senza estensione
#   layer_names <- gsub("\\.asc$", "", names(myExpl))
#   
#   # Lista dei file .asc che corrispondono ai nomi dei layer
#   selected_files <- list.files(ascii_folder, pattern = "\\.asc$")[basename(list.files(ascii_folder, pattern = "\\.asc$")) %in% paste0(layer_names, ".asc")]
#   
#   # Crea la cartella per i file di background di Maxent
#   dir.create("./INPUT/RASTER/maxent_background_data")
#   
#   # Controlla se la directory esiste, altrimenti creala
#   maxent_background_folder <- "./INPUT/RASTER/maxent_background_data"
#   if (!dir.exists(maxent_background_folder)) {
#     dir.create(maxent_background_folder)
#   }
#   
#   # Aggiungi il percorso completo dei file
#   selected_files <- file.path(ascii_folder, selected_files)
#   
#   # Copia i file selezionati nella nuova cartella sovrascrivendo i file esistenti
#   file.copy(from = selected_files, 
#             to = maxent_background_folder, 
#             overwrite = TRUE)
#   
#   # Imposta il nuovo percorso per i file .asc
#   maxent.background.dat.dir <- maxent_background_folder
#   list.files(maxent.background.dat.dir)
# }
# 
# list.files(maxent.background.dat.dir)
# ########################### Modelling options ##################################
# # Set the modelling options
# myBiomodOption <- BIOMOD_ModelingOptions(
#   MAXENT = list( path_to_maxent.jar =  path_to_maxent.jar,
#                  background_data_dir = maxent.background.dat.dir)
#                  # maximumiterations = 200,
#                  # visible = FALSE,
#                  # linear = TRUE,
#                  # quadratic = TRUE,
#                  # product = TRUE,
#                  # threshold = TRUE,
#                  # hinge = TRUE,
#                  # lq2lqptthreshold = 80,
#                  # l2lqthreshold = 10,
#                  # hingethreshold = 15,
#                  # beta_threshold = -1,
#                  # beta_categorical = -1,
#                  # beta_lqp = -1,
#                  # beta_hinge = -1,
#                  # defaultprevalence = 0.5)
# )
# 
# ############################# Run the single models ############################
# # single models
# myBiomodModelOut <- BIOMOD_Modeling(
#   bm.format = myBiomodData_0,
#   bm.options = myBiomodOption,
#   modeling.id = as.character(format(Sys.time(), "%Y%m%d_%H%M_%S")),
#   models = 'MAXENT',
#   CV.strategy = 'kfold',
#   CV.nb.rep	= 2,
#   CV.k = 5,
#   var.import = 3,
#   metric.eval = c("ROC", "TSS", "KAPPA", "ACCURACY", "BIAS", 
#                   "POD", "FAR", "POFD", "SR", "CSI", "ETS", "HK", 
#                   "HSS", "OR", "ORSS"),
#   seed.val = 123,
#   do.progress = TRUE,
# )
# 
# # Get evaluation scores & variables importance
# evaluations_df <- get_evaluations(myBiomodModelOut)
# var_imp <- get_variables_importance(myBiomodModelOut)
# 
# library(dplyr)
# 
# # Calcola la media della variazione d'importanza per ogni variabile
# mean_var_imp <- aggregate(var_imp$var.imp, by = list(var_imp$expl.var), FUN = mean)
# 
# # Rinomina le colonne per chiarezza
# colnames(mean_var_imp) <- c("Variable", "Mean_Variance_Importance")
# 
# # Ordina i risultati in ordine decrescente
# mean_var_imp <- mean_var_imp[order(-mean_var_imp$Mean_Variance_Importance), ]
# 
# # Stampare il risultato
# print(mean_var_imp)
# 
# # Represent evaluation scores & variables importance
# bm_PlotEvalMean(bm.out = myBiomodModelOut, 
#                 group.by = c('run'), 
#                 metric.eval = c('ROC', 'ACCURACY'),
#                 dataset = "calibration", 
#                 do.plot = TRUE, 
#                 xlim = c(0, 1),  # Modifica i limiti dell'asse x
#                 ylim = c(0, 1),  # Modifica i limiti dell'asse y
#                 main = "Mean Evaluation Scores - Calibration")  # Modifica il titolo del grafico
# 
# bm_PlotVarImpBoxplot(bm.out = myBiomodModelOut, group.by = c('expl.var', 'algo', 'algo'))
# bm_PlotVarImpBoxplot(bm.out = myBiomodModelOut, group.by = c('expl.var', 'algo', 'run'))
# bm_PlotVarImpBoxplot(bm.out = myBiomodModelOut, group.by = c('algo', 'expl.var', 'run'))
# 
# 
# 
