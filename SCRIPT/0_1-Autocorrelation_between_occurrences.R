# Autocorealation

library(spdep)

# Load specie occurrences file
DataSpecies_0 <- st_read("./INPUT/VECTOR/p-psa.gpkg")

# Sostituisci 'DataSpecies_0' con il nome del tuo data frame
coords <- st_coordinates(DataSpecies_0$geom)
w <- dnearneigh(coords, d1 = 0, d2 = 500, row.names = NULL)

# Converti la matrice di pesi spaziali in un oggetto listw
w_listw <- nb2listw(w, style="W")

# Esegui il test di Moran's I
a <- moran.test(DataSpecies_0$presence, listw = w_listw)

a
# esiste autocorrelazione tra i dati
