#!/bin/bash
# ogg3mp3 Audio Converter
# Versão 0.002  de 2006/09/07
#
#        Copyright (C) <2006>  Licio Fernando Fonseca <eu@licio.eti.br>
#
#        This program is free software; you can redistribute it and/or modify
#        it under the terms of the GNU General Public License as published by
#        the Free Software Foundation; either version 2 of the License, or
#        (at your option) any later version.
#    
#        This program is distributed in the hope that it will be useful,
#        but WITHOUT ANY WARRANTY; without even the implied warranty of
#        MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#        GNU General Public License for more details.
#    
#        You should have received a copy of the GNU General Public License
#        along with this program; if not, write to the Free Software
#        Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA



function ogg2wav(){

   #zenity --warning --text=$arquivo
   zenity --progress --pulsate --title "ogg2mp3 audio convert" --text "Convertendo arquivo para wav" &
        ZENITY_PID="$!"
   saida=`oggdec $arquivo 2>&1`
   
   if [ $? -eq 0 ]
   then
      kill -9 $ZENITY_PID
      newarq=`basename $arquivo .ogg`
      newarqwav=$newarq.wav
      zenity --warning --text="Arquivo $newarqwav gerado com sucesso!"
   else
      kill -9 $ZENITY_PID
      zenity --error --title='Ocorreu um Erro' --text=$saida
      exit;
   fi
   
}

function ogg2mp3(){

   ogg2wav $arquivo
   arq="$(basename "$arquivo" .ogg)"
   diretorio="$(dirname "$arquivo")"
   bitrate=`zenity --entry --title='Escolha o bitrate' --text='Digite o valor do bitrate: 
   Caso você não saiba o que é isso, deixe em branco.'`
   if [ -z "$bitrate" ]
   then
      zenity --warning --text="O valor de bitrate nao foi fornecido. Padrao: 160kbps."
      zenity --progress --pulsate --title "ogg2mp3 audio convert" --text "Convertendo arquivo para mp3" &
                ZENITY_PID="$!"
                lame -b 160 "$diretorio/$arq.wav" "$diretorio/$arq.mp3"
                   
      
   else
      lame -b $1 "$diretorio/$arq.wav" "$diretorio/$arq.mp3"
   fi
   if [ $? -eq 0 ]
   then
      kill -9 $ZENITY_PID
      rm -f "$diretorio/$arq.wav"
      zenity --warning --text="Arquivo $diretorio/$arq.mp3 gerado com sucesso!"
      
   else
      kill -9 $ZENITY_PID
      zenity --error --title='Ocorreu um Erro' --text='Ocorreu um erro na geração do arquivo mp3'
   fi
      
   
}

function selectArq(){

   arquivo=`zenity --file-selection --width=400 --height=400`
   while [ -z "$arquivo" ]; do
      zenity --warning --text='É necessario selecionar um arquivo'
      if [ $? -eq 1 ]
      then
         exit;
      fi
      arquivo=`zenity --file-selection --width=400 --height=400`
   done
   
   zenity --warning --text=$arquivo
   if [ $? -eq 1 ]
   then
      exit;
   fi
   if [ $option = 'ogg2mp3' ]
   then
      ogg2mp3 $arquivo
   elif [ $option = 'ogg2wav' ]
   then
      ogg2wav $arquivo
   fi

   
}



# Inicio do Script

#Verifica dependencias
if [ -f '/usr/bin/zenity' ]
then
   if [ -f "/usr/bin/lame" ]
   then
      if [ ! -f "/usr/bin/oggdec" ]
      then
         zenity --error --text='É preciso ter o oggtools instalado'
         exit;
      fi
   else
      zenity --error --text='É preciso ter o lame instalado'
      exit;
   fi
else
   echo 'Você precisa ter o zenity instalado'
   exit;
fi
   

#Starts ogg2mp3 Audio Convert

option=`zenity --title="ogg2mp3" --width=400 --height=400 --list --text="Conversão de audio" --column="opções" ogg2mp3 ogg2wav wav2mp3`
    
if [ -f $option ]
then
   zenity --error --text='É preciso'
   exit;
else
   zenity --warning --text="Convert $option"
   if [ $? -eq 0 ]
   then
      selectArq
   else
      exit;
   fi
fi
