#!/bin/bash
#===================================================================================
#
# FILE: stale-links.sh
#
# USAGE: stale-links.sh [-d] [-l] [-oD logfile] [-h] [starting directories]
#
# DESCRIPTION: List and/or delete all stale links in directory trees.
# The default starting directory is the current directory.
# Don’t descend directories on other filesystems.
#
# OPTIONS: see function ’usage’ below
# REQUIREMENTS: ---
# BUGS: ---
# NOTES: ---
# AUTHOR: Dr.-Ing. Fritz Mehner (fgm), mehner.fritz@fh-swf.de
# COMPANY: FH Südwestfalen, Iserlohn
# VERSION: 1.3
# CREATED: 12.05.2002 - 12:36:50
# REVISION: 20.09.2004
#===================================================================================


#verificando espaco em disco
#verificando se o tmp iesta em uma particao separada
STARTSCRIPT=`date +%s.%N`
OUTPUTFOLDER="/tmp/GETFILES"
OUTPUTLOG="getfiles-"`hostname -a`".log"
df -h | grep /tmp
TMPPART=$?
ROOTDIR=`df -h / | grep "/" | awk '{print $4}'`
TMPDIR=`df -h / | grep "/tmp" | awk '{print $4}'`
#=== FUNCTION ================================================================
# NAME: usage
# DESCRIPTION: Display usage information for this script.
# PARAMETER 1: ---
#===============================================================================

if [ $TMPPART -eq 0 ] ; then
        echo "diretorio /tmp e uma particao"
        echo "espaco no /tmp e de: "$TMPDIR
        echo $TMPDIR| grep "G"
#----------------------------------------------------------------------
# delete links, if demanded write logfile
#----------------------------------------------------------------------
        if [ `echo $?` -eq "0" ] ; then
                echo "espaco em giga"
                if [ `echo $TMPDIR | grep [0-9]` > 4 ] ; then
                        echo "espaco maior que 4G iniciando coleta"
                else
                        echo "espaco menor que 4G - ignorando coleta - verifique espaco em disco"
                fi
        fi
else
        echo "/tmp nao e particao"
        echo "espaco no diretorio root e: "$ROOTDIR
        echo $ROOTDIR | grep "G"
        if [ `echo $?` -eq "0" ] ; then
                echo "espaco em giga"
                if [ `echo $ROOTDIR | grep [0-9]` > 4 ] ; then
                        echo "espaco maior que 4G iniciando coleta"
                else
                        echo "espaco menor que 4G - ignorando coleta - verifique espaco em disc
o"
                fi
        fi
fi




#<<<< put all code here >>>>>>>



#Calculando tempo total de execucao do script
ENDSCRIPT=`date +%s.%N`
dt=$(echo "$ENDSCRIPT-$STARTSCRIPT" | bc)
dd=$(echo "$dt/86400" | bc)
dt2=$(echo "$dt-86400*$dd" | bc)
dh=$(echo "$dt2/3600" | bc)
dt3=$(echo "$dt2-3600*$dh" | bc)
dm=$(echo "$dt3/60" | bc)
ds=$(echo "$dt3-60*$dm" | bc)

printf "Total runtime: %d:%02d:%02d:%02.4f\n" $dd $dh $dm $ds  >> $OUTPUTLOG

echo $STARTSCRIPT >> $OUTPUTLOG
