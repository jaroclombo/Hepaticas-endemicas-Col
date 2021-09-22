###############################################################
## Script para recorte de variáveis raster a partir de shapefile
# Rversion 4.1.1
###############################################################
## CArregando as biblbiotecas necessárias

library(raster)
library(rgdal)
library(maptools)

# Importar o shapefile

shape <- readOGR("./dados/shape/Colombia/MGN_DPTO_POLITICO.shp") 

# Plotando o shapefile
plot(shape) 

# Criando uma lista dos arquivos raster pela função list.files

lista <- list.files("./dados/raster/wc2.1_10m_bio/", full.names = T, pattern = ".tif") 

# Juntando todos os rasters num único objeto
stack_variaveis <- stack(lista) 

# Plotando 
plot(stack_variaveis)

### Cortando as variáveis a partir do shape
## Primeiro aplicamos uma máscara (shape) pela função mask do pacote raster, onde X é o argumento que indica as variáveis que queremos cortar e mask é o argumento que indica o shapefile usado para cortar. Esse processo pode ser demorado dependendo da resolução das variáveis e da extensão geográfica. 

mascara_variaveis <- mask(x = stack_variaveis, mask = shape) 

#PLot
plot(mascara_variaveis)  

## Cortando a partir da máscara
cortadas_variaveis <- crop(x = mascara_variaveis, y = extent(shape)) 
plot(cortadas_variaveis)

## O Comando a baixo pega os nomes a partir do objeto "stack_variavies"  (que são as variáveis orginais com seus respectivos nomes) e os salva no obejto "a", junto com sua extensão ".tif"

a <- paste0(names(stack_variaveis), ".tif")

###  Agora vamos salvar as variáveis cortadas com seus nomes corretos pela funçõa writeRaster do pacote raste. Esses arquivos serão salvos na pasta principal do projeto. 
writeRaster(cortadas_variaveis, filename=a, bylayer=TRUE) 

## Posteriormente, criei um nava pasta em dados movi esses arquivos para essa nova pasta (cortando e colando), no caminho a seguir:  "./dados/raster/Variaveis_Cortadas_Brasil"
