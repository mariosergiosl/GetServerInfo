#!/bin/bash
#===================================================================================
#
# FILE: get-info.bash
#
# USAGE: get-info.bash
#
# DESCRIPTION: Get files, info and data to servers.
# 
# 
#
# OPTIONS: see function ’usage’ below
# REQUIREMENTS: ---
# BUGS: ---
# NOTES: ---
# AUTHOR: Mario Luz, mluz@suse.com
# COMPANY: Suse
# VERSION: Drafth 0.3
# CREATED: 25.09.2014 - 01:12:50
# REVISION: 01-25.09.2014
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
