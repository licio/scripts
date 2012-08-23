#!/usr/bin/env python
import glob
import Image

#percorre o diretorio pegando os arquivos .jpg 
for picture in glob.glob("*.JPG"):

	im = Image.open(picture)
	#gera o thub
	im.thumbnail((1024, 768), Image.ANTIALIAS)
	#salva os thumbus com o prefixo thumb_
	if picture[0:2] != "r_":
		im.save("r_" + picture, "JPEG")

