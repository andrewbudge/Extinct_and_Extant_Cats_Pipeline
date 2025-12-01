# Load in packages
library(ggtree)
library(ggplot2)
library(geiger)
library(viridis)
library(scatterpie)


setwd("~/projects/extinct_extant_cats/")


ML_tree <- read.tree(file = "smatrix/partitions.nex.treefile")
ML_tree_rooted <- root.phylo(ML_tree, outgroup = 'Smilodon_populator')

# This will create the data set
geographic_data <- c(
  Acinonyx_jubatus = "Africa",
  Acinonyx_jubatus_jubatus = "Africa",
  Acinonyx_jubatus_soemmeringii = "Africa",
  Acinonyx_jubatus_venaticus = "Asia",
  Caracal_caracal = "Africa",
  Catopuma_badia = "Asia",
  Catopuma_temminckii = "Asia",
  Felis_catus = "Asia",
  Felis_chaus = "Asia",
  Felis_margarita = "Asia",
  Felis_nigripes = "Africa",
  Felis_silvestris = "Europe",
  Felis_silvestris_bieti = "Asia",
  Herpailurus_yagouaroundi = "South_America",
  Homotherium_latidens = "North_America",
  Leopardus_geoffroyi = "South_America",
  Leopardus_guigna_tigrillo = "South_America",
  Leopardus_guttulus = "South_America",
  Leopardus_jacobita = "South_America",
  Leopardus_pardalis_pardalis = "South_America",
  Leopardus_pardinoides = "South_America",
  Leopardus_tigrinus = "South_America",
  Leopardus_wiedii = "South_America",
  Leptailurus_serval = "Africa",
  Lynx_canadensis = "North_America",
  Lynx_lynx = "Asia",
  Lynx_pardinus = "Europe",
  Lynx_rufus = "North_America",
  Neofelis_diardi = "Asia",
  Neofelis_nebulosa = "Asia",
  Otocolobus_manul = "Asia",
  Panthera_leo = "Africa",
  Panthera_leo_atrox = "North_America",
  Panthera_leo_krugeri = "Africa",
  Panthera_leo_leo = "Africa",
  Panthera_leo_persica = "Asia",
  Panthera_onca = "South_America",
  Panthera_pardus = "Africa",
  Panthera_pardus_japonensis = "Asia",
  Panthera_pardus_kotiya = "Asia",
  Panthera_pardus_nimr = "Asia",
  Panthera_pardus_orientalis = "Asia",
  Panthera_spelaea = "Europe",
  Panthera_tigris = "Asia",
  Panthera_tigris_altaica = "Asia",
  Panthera_tigris_amoyensis = "Asia",
  Panthera_tigris_corbetti = "Asia",
  Panthera_tigris_jacksoni = "Asia",
  Panthera_tigris_sumatrae = "Asia",
  Panthera_tigris_tigris = "Asia",
  Panthera_uncia = "Asia",
  Pardofelis_marmorata = "Asia",
  Prionailurus_bengalensis = "Asia",
  Prionailurus_bengalensis_bengalensis = "Asia",
  Prionailurus_bengalensis_euptilurus = "Asia",
  Prionailurus_planiceps = "Asia",
  Prionailurus_rubiginosus = "Asia",
  Prionailurus_viverrinus = "Asia",
  Profelis_aurata = "Africa",
  Puma_concolor = "North_America",
  Smilodon_populator = "South_America"
)

geographic_data <- as.factor(geographic_data)
geographic_data_matched <- geographic_data[ML_tree_rooted$tip.label]


# Fit models and compare
er_model <- fitMk(ML_tree_rooted, geographic_data_matched, model = 'ER', pi = 'fitzjohn')

# Run stochastic mapping with best model
simmap_geo <- make.simmap(ML_tree_rooted, geographic_data_matched, model="ER", nsim=1000)

# Plot it
cols_geo <- setNames(viridis(5, option = "C", begin = 0.1, end = 0.9), levels(geographic_data_matched))
 
# Prune the original tree first
ML_tree_pruned <- drop.tip(ML_tree_rooted, c("Smilodon_populator", "Homotherium_latidens"))
geo_pruned <- geographic_data_matched[ML_tree_pruned$tip.label]

# Run simmap fresh
simmap_pruned <- make.simmap(ML_tree_pruned, geo_pruned, model = "ER", nsim = 100)

# Plot
plotSimmap(simmap_pruned[[1]], 
  colors = cols_geo, 
  ftype = "i", 
  fsize = 1.2, 
  lwd = 5, 
  xlim = c(0, 0.15),
  pts = FALSE)

legend("bottomright", 
  gsub("_", " ", levels(geo_pruned)), 
  pch = 15, 
  col = cols_geo, 
  pt.cex = 5,
  cex = 1.5,
  inset = c(-0.1, 0.1),
  bty = "n")

# Define the Lynx species
lynx_species <- c("Lynx_canadensis", "Lynx_lynx", "Lynx_pardinus", "Lynx_rufus")

# Extract just those tips
lynx_tree <- keep.tip(ML_tree_pruned, lynx_species)

plot(lynx_tree, 
  edge.width = 4, 
  cex = 2.5,           
  font = 3,
  label.offset = 0.001)           
