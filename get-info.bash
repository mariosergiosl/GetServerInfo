
#!/bin/bash
#===================================================================================
#
# FILE: get-info.bash
#
# USAGE: get-info.bash
#
# DESCRIPTION: 	Captura arquivos de configuracao, log e informacoes sobre o sistema
#		para avaliacao e tunnig.
#
# OPTIONS: see function ’usage’ below
# REQUIREMENTS: ---
# BUGS: ---
# NOTES: No caso de sistemas RedHat pode ser utilizado o pacote sosreport
#	 No caso de sistemas Suse pode ser utilizado o pacote supportconfig
#
# AUTHOR: Mario Luz, mluz@suse.com
# COMPANY: Suse
# VERSION: Drafth 0.3
# CREATED: 25.09.2014 - 01:12:50
# REVISION: 01-25.09.2014
#===================================================================================


#----------------------------------------------------------------------
# verifica localizacao do /tmp e espaco em disco
#----------------------------------------------------------------------
STARTSCRIPT=`date +%s.%N`
OUTPUTFOLDER="/tmp/GETFILES"
OUTPUTLOG="getfiles-"`hostname -a`".log"
df -h | grep /tmp
TMPPART=$?
ROOTDIR=`df -h / | grep "/" | awk '{print $4}'`
TMPDIR=`df -h / | grep "/tmp" | awk '{print $4}'`


#=== FUNCTION ================================================================
# NAME: testaEspaco
# DESCRIPTION: Testa a localizacao do /tmp e o espaco em disco
# PARAMETER 1: ---
#===============================================================================
function testaEspaco {
if [ $TMPPART -eq 0 ] ; then
        echo "diretorio /tmp e uma particao"
        echo "espaco no /tmp e de: "$TMPDIR
        echo $TMPDIR| grep "G"
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

}


#<<<< put all code here >>>>>>>
#<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

#
#mkdir /tmp/4linux
#mkdir /tmp/4linux/files-etc
#mkdir /tmp/4linux/files-log
#NOMESERVIDOR=`hostname -s`
#LOGFILE='/tmp/4linux/'$NOMESERVIDOR'-4linux-get-server.log'
#FOLDERFILES='/tmp/4linux/files-etc'
#FOLDERFILES1='/tmp/4linux/files-log'

#1 . Comandos
#2 . Arquivos de Configuracao
#3 . Arquivos de log

echo "#######################################################################" >> $LOGFILE
echo "###################### 1 . Comamdos ###################################" >> $LOGFILE
echo "#######################################################################" >> $LOGFILE

echo "###################### Nome do Servidor" >> $LOGFILE
hostname -s >> $LOGFILE
echo "###################### #Nome do Dominio DNS" >> $LOGFILE
hostname -d >> $LOGFILE
echo "###################### #FQDN" >> $LOGFILE
hostname -f >> $LOGFILE
echo "###################### #Endereco IP" >> $LOGFILE
hostname -i >> $LOGFILE
echo "###################### #Nome e IP dos servidores DNS" >> $LOGFILE
nameserverips=$(sed -e '/^$/d' /etc/resolv.conf | awk '{if (tolower($1)=="nameserver") print $2}')
echo $nameserverips >> $LOGFILE
echo "###################### #Endereco IP" >> $LOGFILE
ip -4 address show >> $LOGFILE
echo "###################### #Processos (Portas e enderecos)" >> $LOGFILE
netstat -nr >> $LOGFILE
netstat -i >> $LOGFILE
echo "###################### #Memoria usada e livre" >> $LOGFILE
free -m >> $LOGFILE
echo "###################### #Stataistica de memoria virtual" >> $LOGFILE
vmstat >> $LOGFILE
echo "###################### # Top 5 - Processos comedores de memoria" >> $LOGFILE
ps auxf | sort -nr -k 4 | head -5 >> $LOGFILE
echo "###################### #Versao do Bash" >> $LOGFILE
bash --version >> $LOGFILE
echo "###################### #Informacoes de CPU" >> $LOGFILE
cat /proc/cpuinfo >> $LOGFILE
echo "###################### #Informacoes de CPU 1" >> $LOGFILE
lscpu >> $LOGFILE
echo "###################### #Informacoes de CPU 2" >> $LOGFILE
dmidecode -t processor >> $LOGFILE
echo "###################### #Informacoes de Memoria" >> $LOGFILE
cat /proc/meminfo >> $LOGFILE
echo "###################### #Informacoes de Memoria 1" >> $LOGFILE
dmidecode -t memory >> $LOGFILE
echo "###################### #Informacoes de disco" >> $LOGFILE
df -h >> $LOGFILE
echo "###################### #informacoes de particao" >> $LOGFILE
cat /proc/partitions >> $LOGFILE
echo "###################### #Versao da distribuicao e plataforma base" >> $LOGFILE
uname -a >> $LOGFILE
echo "###################### #Versao da distribuicao e plataforma base 1" >> $LOGFILE
cat /proc/version >> $LOGFILE
echo "###################### #Usuarios ativos" >> $LOGFILE
w | cut -d ' ' -f 1 | grep -v USER | sort -u >> $LOGFILE
echo "###################### #Tempo desde a ultima parada" >> $LOGFILE
uptime >> $LOGFILE
echo "###################### #Joss e Java (path, nome das instancias)" >> $LOGFILE
ps aux | grep java >> $LOGFILE
echo "###################### #outros processos" >> $LOGFILE
ps auxww >> $LOGFILE
echo "###################### #ulimit informacoes" >> $LOGFILE
ulimit -a >> $LOGFILE
echo "###################### #Versao do Perl" >> $LOGFILE
perl --version >> $LOGFILE
echo "###################### #Versao do PHP" >> $LOGFILE
php --version >> $LOGFILE
echo "###################### #Versao do Python"  >> $LOGFILE
python --version >> $LOGFILE
echo "###################### #Informacao de Multipath" >> $LOGFILE
multpath -l >> $LOGFILE
echo "###################### #Discos fisicos***" >> $LOGFILE
pvs >> $LOGFILE
echo "###################### #Grupos do LVM" >> $LOGFILE
vgs >> $LOGFILE
echo "###################### #Volumes do LVM" >> $LOGFILE
lvs >> $LOGFILE
echo "###################### #Sistemas de arquivo" >> $LOGFILE
fdisk -l >> $LOGFILE
echo "###################### #Hardware Fisico***" >> $LOGFILE
dmesg >> $LOGFILE
echo "###################### #Hardware Fisico***" 2 >> $LOGFILE
lshw -short >> $LOGFILE
echo "###################### #Hardware Fisico***" 3 >> $LOGFILE
hwinfo --short >> $LOGFILE
echo "###################### #Dispositivos PCI" >> $LOGFILE
lspci >> $LOGFILE
echo "###################### #Dispositivos SCSI" >> $LOGFILE
lsscsi >> $LOGFILE
echo "###################### #Dispositivos SCSI 1" >> $LOGFILE
cat /proc/scsi/scsi >> $LOGFILE
echo "###################### #Dispositivos USB" >> $LOGFILE
lsusb >> $LOGFILE
echo "###################### #Dispositivos de Bloco" >> $LOGFILE
lsblk >> $LOGFILE
echo "###################### #Detalhes da BIOS" >> $LOGFILE
dmidecode -t bios >> $LOGFILE

echo "#####################################################################" >> $LOGFILE
echo "###################### #INICIO DA COPIA DOS ARQUIVOS DE CONFIGURACAO" >> $LOGFILE
echo "#####################################################################" >> $LOGFILE

cp -R /etc/mtab* $FOLDERFILES >> $LOGFILE
cp -R /etc/fstab* $FOLDERFILES >> $LOGFILE
cp -R /etc/apache* $FOLDERFILES >> $LOGFILE
cp -R /etc/skel* $FOLDERFILES >> $LOGFILE
cp -R /etc/mysql* $FOLDERFILES >> $LOGFILE
cp -R /etc/posgres* $FOLDERFILES >> $LOGFILE
cp -R /etc/postgre* $FOLDERFILES >> $LOGFILE
cp -R /etc/aliases* $FOLDERFILES >> $LOGFILE
cp -R /etc/bashrc* $FOLDERFILES >> $LOGFILE
cp -R /etc/crontab* $FOLDERFILES >> $LOGFILE
cp -R /etc/cron.* $FOLDERFILES >> $LOGFILE
cp -R /etc/default* $FOLDERFILES >> $LOGFILE
cp -R /etc/filesystems* $FOLDERFILES >> $LOGFILE
cp -R /etc/group* $FOLDERFILES >> $LOGFILE
cp -R /etc/hosts* $FOLDERFILES >> $LOGFILE
cp -R /etc/inittab* $FOLDERFILES >> $LOGFILE
cp -R /etc/issue* $FOLDERFILES >> $LOGFILE
cp -R /etc/logrotate* $FOLDERFILES >> $LOGFILE
cp -R /etc/mail* $FOLDERFILES >> $LOGFILE
cp -R /etc/modules.conf $FOLDERFILES >> $LOGFILE
cp -R /etc/motd* $FOLDERFILES >> $LOGFILE
cp -R /etc/nssswitch.conf $FOLDERFILES >> $LOGFILE
cp -R /etc/pam.d* $FOLDERFILES >> $LOGFILE
cp -R /etc/passwd* $FOLDERFILES >> $LOGFILE
cp -R /etc/printcap* $FOLDERFILES >> $LOGFILE
cp -R /etc/profile* $FOLDERFILES >> $LOGFILE
cp -R /etc/rc* $FOLDERFILES >> $LOGFILE
cp -R /etc/resolv.conf $FOLDERFILES >> $LOGFILE
cp -R /etc/sendmail.cf $FOLDERFILES >> $LOGFILE
cp -R /etc/services* $FOLDERFILES >> $LOGFILE
cp -R /etc/sysconfig* $FOLDERFILES >> $LOGFILE
cp -R /etc/xinetd* $FOLDERFILES >> $LOGFILE
cp -R /etc/inetd.conf $FOLDERFILES >> $LOGFILE
cp -R /etc/rsyslog.conf $FOLDERFILES >> $LOGFILE
cp -R /etc/cluster* $FOLDERFILES >> $LOGFILE


echo "#####################################################################" >> $LOGFILE
echo "###################### #INICIO DA COPIA DOS ARQUIVOS DE LOG" >> $LOGFILE
echo "#####################################################################" >> $LOGFILE
cp -R /var/log/messages* $FOLDERFILES1 >> $LOGFILE
cp -R /var/log/dmesg* $FOLDERFILES1 >> $LOGFILE
cp -R /var/log/auth.log* $FOLDERFILES1 >> $LOGFILE
cp -R /var/log/boot.log* $FOLDERFILES1 >> $LOGFILE
cp -R /var/log/daemon.log* $FOLDERFILES1 >> $LOGFILE
cp -R /var/log/dpkg.log* $FOLDERFILES1 >> $LOGFILE
cp -R /var/log/kern.log* $FOLDERFILES1 >> $LOGFILE
cp -R /var/log/lastlog* $FOLDERFILES1 >> $LOGFILE
cp -R /var/log/maillog* $FOLDERFILES1 >> $LOGFILE
cp -R /var/log/mail.log* $FOLDERFILES1 >> $LOGFILE
cp -R /var/log/user.log* $FOLDERFILES1 >> $LOGFILE
cp -R /var/log/Xorg.x.log* $FOLDERFILES1 >> $LOGFILE
cp -R /var/log/alternatives.log* $FOLDERFILES1 >> $LOGFILE
cp -R /var/log/btmp* $FOLDERFILES1 >> $LOGFILE
cp -R /var/log/cups* $FOLDERFILES1 >> $LOGFILE
cp -R /var/log/anaconda.log* $FOLDERFILES1 >> $LOGFILE
cp -R /var/log/yum.log* $FOLDERFILES1 >> $LOGFILE
cp -R /var/log/cron* $FOLDERFILES1 >> $LOGFILE
cp -R /var/log/secure* $FOLDERFILES1 >> $LOGFILE
cp -R /var/log/wtmp* $FOLDERFILES1 >> $LOGFILE
cp -R /var/log/utmp* $FOLDERFILES1 >> $LOGFILE
cp -R /var/log/faillog* $FOLDERFILES1 >> $LOGFILE
cp -R /var/log/httpd* $FOLDERFILES1 >> $LOGFILE
cp -R /var/log/www* $FOLDERFILES1 >> $LOGFILE
cp -R /var/log/apache2* $FOLDERFILES1 >> $LOGFILE
cp -R /var/log/lighttpd* $FOLDERFILES1 >> $LOGFILE
cp -R /var/log/conman* $FOLDERFILES1 >> $LOGFILE
cp -R /var/log/mail* $FOLDERFILES1 >> $LOGFILE
cp -R /var/log/prelink* $FOLDERFILES1 >> $LOGFILE
cp -R /var/log/audit* $FOLDERFILES1 >> $LOGFILE
cp -R /var/log/setroubleshoot* $FOLDERFILES1 >> $LOGFILE
cp -R /var/log/samba* $FOLDERFILES1 >> $LOGFILE
cp -R /var/log/sa* $FOLDERFILES1 >> $LOGFILE
cp -R /var/log/sssd* $FOLDERFILES1 >> $LOGFILE
cp -R /var/log/mysql* $FOLDERFILES1 >> $LOGFILE
cp -R /var/log/postgre* $FOLDERFILES1 >> $LOGFILE
cp -R /var/log/posgre* $FOLDERFILES1 >> $LOGFILE


#<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

#----------------------------------------------------------------------
# Calcula e loga o tempo total de execucao do script
#----------------------------------------------------------------------
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
