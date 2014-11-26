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
# OPTIONS: ---
# REQUIREMENTS: ---
# BUGS: ---
# NOTES: No caso de sistemas RedHat pode ser utilizado o pacote sosreport
#	 No caso de sistemas Suse pode ser utilizado o pacote supportconfig
#
# AUTHOR: Mario Luz, mluz at suse.com, mario.mssl at gmail.com
# COMPANY: Suse
# VERSION: Drafth 0.4
# CREATED: 25.09.2014 - 01:12:50
# ROADMAP:
#	/etc/posgres*
#	/etc/postgre*
#	/etc/aliases*
#	/etc/bashrc*
#	/etc/filesystems*
#	/etc/inittab*
#	/etc/mail*
#	/etc/printcap*
#	/etc/sendmail.cf
#	/etc/sysconfig*
#	/etc/xinetd*
#	/etc/inetd.conf
#	/etc/cluster*
# REVISION: 01-25.09.2014
# REVISION: 02-24.11.2014 Adicionar captura de informacao de aplicacoes 
#			  PHP, JAVA, JBOSS, POSTGRESS, APACHE
#			  Ajustes nos logs
#			  Ajustes nos lacos das funcoes
#===================================================================================


#----------------------------------------------------------------------
# declaracao de variaveis
#----------------------------------------------------------------------
STARTSCRIPTTIME=`date +%s.%N`
TMP_FOLDER_TO_FILES="/tmp/GETFILES"
ZIP_BIN_PATH=`which zip`
TAR_BIN_PATH=`which tar`
FILE_TMP_ETC_ZIP=$TMP_FOLDER_TO_FILES"/FILE_ETC.zip"
FILE_TMP_VAR_ZIP=$TMP_FOLDER_TO_FILES"/FILE_VAR.zip"
FILE_TMP_COMMAND_OUT_LOG=$TMP_FOLDER_TO_FILES"/COMMAND_OUT_LOG.log"
FILE_TMP_ERROR_OUT_LOG=$TMP_FOLDER_TO_FILES"/ERROR_OUT_LOG.log"
FILE_TMP_APP_COMMAND_OUT_LOG=$TMP_FOLDER_TO_FILES"/APP_COMMAND_OUT_LOG.log"
FILE_TMP_SEC_CVE_COMMAND_OUT_LOG=$TMP_FOLDER_TO_FILES"/SEC_CVE_COMMAND_OUT_LOG.log"

#----------------------------------------------------------------------
# pastas do /etc para copia
#----------------------------------------------------------------------
FOLDERS_ETC_TO_COPY=( 'init.d' 'rsyslog.d' 'sysctl.d' 'rcS.d' 'rc[0-6].d' 'profile.d' 'modprobe.d' 'pam.d' 'apache' 'grub.d' 'logrotate.d' 'init' 'init.d' 'www' 'skel' 'mysql' 'postfix' 'cron.d' 'cron.daily' 'cron.hourly' 'cron.monthly' 'cron.weekly' 'default' )
#----------------------------------------------------------------------
# arquivos do /etc para copia
#----------------------------------------------------------------------
FILES_ETC_TO_COPY=( 'rsyslog.conf' 'sysctl.conf' 'rc.local' 'profile' 'modules' 'motd' 'passwd' 'pam.conf' 'nsswitch.conf' 'group' 'services' 'hosts' 'hosts.allow' 'hosts.deny' 'resolv.conf' 'bashrc' 'mtab' 'fstab' 'crontab' 'bash.bashrc' 'issue' 'issue.net' 'aliases' )
#----------------------------------------------------------------------
# pastas do /var/log para copia
#----------------------------------------------------------------------
FOLDERS_VAR_TO_COPY=( 'messages*' 'dmesg*' 'boot.log*' 'auth.log*' 'daemon.log*' 'dpkg.log*' 'kern.log*' 'lastlog*' 'maillog*' 'mail.log*' 'user.log*' 'Xorg.x.log*' 'alternatives.log*' 'btmp*' 'cups*' 'anaconda.log*' 'yum.log*' 'cron*' 'secure*' 'wtmp*' 'utmp*' 'faillog*' 'httpd*' 'www*' 'apache2*' 'lighttpd*' 'conman*' 'mail*' 'prelink*' 'audit*' 'setroubleshoot*' 'samba*' 'sa*' 'sssd*' 'mysql*' 'postgre*' 'posgre*' )
#----------------------------------------------------------------------
# arquivos do /var/log para copia
#----------------------------------------------------------------------
FILES_VAR_TO_COPY=('boot.log' 'faillog' 'lastlog' 'ntp' 'wtmp' 'journalctl.log')
#----------------------------------------------------------------------
# comandos a serem executados
#----------------------------------------------------------------------
COMMAND_LIST=( 'hostname -s' 'hostname -d' 'hostname -f' 'hostname -i' 'ip -4 address show' 'netstat -nr' 'netstat -i' 'free -m' 'vmstat' 'ps auxf | sort -nr -k 4 | head -5' 'bash --version' 'cat /proc/cpuinfo' 'lscpu' 'dmidecode -t processor' 'cat /proc/meminfo' 'dmidecode -t memory' 'df -h' 'cat /proc/partitions' 'uname -a' 'cat /proc/version' 'uptime' 'ps aux | grep java' 'ps auxww' 'ulimit -a' 'perl --version' 'php --version' 'python --version' 'multipath -l' 'pvs' 'pvdisplay' 'vgs' 'vgdisplay' 'lvs' 'lvdisplay' 'fdisk -l' 'dmesg' 'lshw -short' 'hwinfo --short' 'lspci' 'lsscsi' 'cat /proc/scsi/scsi' 'lsusb' 'lsblk' 'dmidecode -t bios' 'journalctl > /var/log/journalctl.log')
# rever sintaxe dos comandos
# 'nameserverips=$(sed -e '/^$/d' /etc/resolv.conf | awk '{if (tolower($1)=="nameserver") print $2}') ; echo $nameserverips'
#'echo "Usuarios ativos," ; w | cut -d ' ' -f 1 | grep -v USER | sort -u'
#----------------------------------------------------------------------
# dicionario da lista de comandos
#----------------------------------------------------------------------
#COMMAND_LIST_DICT=( 'echo "Nome do Servidor, " ; hostname -s' 'echo "Nome do Dominio DNS, " ; hostname -d' 'echo "FQDN," ; hostname -f' 'echo "Endereco IP" ; hostname -i' 'echo "Nome e IP dos servidores DNS," ; nameserverips=$(sed -e '/^$/d' /etc/resolv.conf | awk '{if (tolower($1)=="nameserver") print $2}') ; echo $nameserverips' 'echo "Endereco IP," ; ip -4 address show' 'echo "Processos 1 (Portas e enderecos)," ; netstat -nr' 'echo "Processos 2 (Portas e enderecos)," ; netstat -i' 'echo "Memoria usada e livre," ; free -m' 'echo "Stataistica de memoria virtual," ; vmstat' 'echo "Top 5 - Processos que utilizam memoria," ; ps auxf | sort -nr -k 4 | head -5' 'echo "Versao do Bash," ; bash --version' 'echo "Informacoes de CPU 1," ; cat /proc/cpuinfo' 'echo "Informacoes de CPU 2" ; lscpu' 'echo "Informacoes de CPU 3" ; dmidecode -t processor' 'echo "Informacoes de Memoria," ; cat /proc/meminfo' 'echo "Informacoes de Memoria 1," ; dmidecode -t memory' 'echo "Informacoes de disco," ; df -h' 'echo "informacoes de particao," ; cat /proc/partitions' 'echo "Versao da distribuicao e plataforma base," ; uname -a' 'echo "Versao da distribuicao e plataforma base 1," ; cat /proc/version' 'echo "Usuarios ativos," ; w | cut -d ' ' -f 1 | grep -v USER | sort -u' 'echo "Tempo desde a ultima parada," ; uptime' 'echo "Joss e Java (path, nome das instancias)," ; ps aux | grep java' 'echo "outros processos," ; ps auxww' 'echo "ulimit informacoes," ; ulimit -a' 'echo "Versao do Perl," ; perl --version' 'echo "Versao do PHP," ; php --version' 'echo "Versao do Python," ; python --version' 'echo "Informacao de Multipath," ; multipath -l' 'echo "Discos fisicos," ; pvs' 'echo "Grupos do LVM," ; vgs' 'echo "Volumes do LVM," ; lvs' 'echo "Sistemas de arquivo," ; fdisk -l' 'echo "Hardware Fisico 1," ; dmesg' 'echo "Hardware Fisico 2," ; lshw -short' 'echo "Hardware Fisico 3," ; hwinfo --short' 'echo "Dispositivos PCI," ; lspci' 'echo "Dispositivos SCSI 1," ; lsscsi' 'echo "Dispositivos SCSI 2," ; cat /proc/scsi/scsi' 'echo "Dispositivos USB," ; lsusb' 'echo "Dispositivos de Bloco," ; lsblk' 'echo "Detalhes da BIOS," ; dmidecode -t bios' )
#----------------------------------------------------------------------
# comandos a serem executados para captura de informacoes de aplicacoes
#----------------------------------------------------------------------
APP_COMMAND_LIST=( 'php -r phpinfo \(\)\;' 'java -version' 'java -version | head -n 1 | cut -d "\"" -f 2' 'which java' 'which javac' 'env | grep -i java' 'pgrep -f jboss' 'env | grep -i jboss' 'echo $JBOSS_HOME' 'echo $JBOSS_CONSOLE' 'netstat -tulpn | grep `pgrep org.jboss.Main`' 'tree -L 1 -d $JBOSS_HOME/server' 'ls -lh $JBOSS_HOME/server' )
#----------------------------------------------------------------------
# dicionario da lista de comandos para captura de informacoes de aplicacoes
#----------------------------------------------------------------------
#APP_COMMAND_LIST_DICT=('echo "PHP Info, " ; php -r phpinfo \(\)\;' 'echo "Java version Full, " ; java -version' 'echo "Java version, " ; java -version | head -n 1 | cut -d "\"" -f 2' 'echo "java path, " ; which java' 'echo "javac path, " ; which javac' 'echo "env java, " ; env | grep -i java' 'echo "Jboss Process, " ; pgrep -f jboss' 'echo "Jboss ENV, " ; env | grep -i jboss' 'echo "Jboss Home, " $JBOSS_HOME' 'echo "Jboss Console, " $JBOSS_CONSOLE' 'echo "Jboss Ports, " ; netstat -tulpn | grep `ps -ef | grep org.jboss.Main | awk '{print $2}'`' 'echo "Jboss tree home, " ; tree -L 1 -d $JBOSS_HOME/server' 'echo "Jboss home, " ; ls -lh $JBOSS_HOME/server' )

#=== FUNCTION 1 ================================================================
# NAME: RUN_COMMANDS
# DESCRIPTION: Execuata comandos para verificacar informacoes do SO
# PARAMETER 1: ---
#===============================================================================
function RUN_COMMANDS () {
	#processa os arquivos
	# intao a "#" na frente do nome da array e importante
	for (( i = 0; i < ${#COMMAND_LIST[@]}; i++ )) ; do
		#define o path de cada arquivo
		FILE_PATH=`echo "${COMMAND_LIST[$i]}" | cut -d " " -f 1 | xargs which`
		COMMAND=`echo "${COMMAND_LIST[$i]}"`

		#verifica se cada binario de comando esta instalado e qual o path
		if [ -f "$FILE_PATH" ]
		then
			#verifica se o arquivo de log existe, se nao cria ou faz o appende no arquivo ja existente
			if [ -f "$FILE_TMP_COMMAND_OUT_LOG" ]
			then
                		echo "#===============================================================================" >> $FILE_TMP_COMMAND_OUT_LOG
				$COMMAND 2>&1 >> $FILE_TMP_COMMAND_OUT_LOG
			else
                		echo "#===============================================================================" >> $FILE_TMP_COMMAND_OUT_LOG
				$COMMAND 2>&1 >> $FILE_TMP_COMMAND_OUT_LOG
			fi
		else
		#caso o binario não exista, loga a execao
                echo "ERROR: "`echo $COMMAND` " - Este binario nao existe ou nao foi encontrado no path" >> $FILE_TMP_ERROR_OUT_LOG
		fi
	done
}

#=== FUNCTION 2 ================================================================
# NAME: RUN_APP_COMMANDS
# DESCRIPTION: Execuata comandos para verificacar informacoes de aplicacoes
# PARAMETER 1: ---
#===============================================================================
function RUN_APP_COMMANDS () {
	#processa os arquivos
	# intao a "#" na frente do nome da array e importante
	for (( i = 0; i < ${#APP_COMMAND_LIST[@]}; i++ )) ; do
		#define o path de cada arquivo
		FILE_PATH=`echo "${APP_COMMAND_LIST[$i]}" | cut -d " " -f 1 | xargs which`
		COMMAND=`echo "${APP_COMMAND_LIST[$i]}"`

		#verifica se cada binario de comando esta instalado e qual o path
		if [ -f "$FILE_PATH" ]
		then
			#verifica se o arquivo de log para a saida dos comandos ja existe, se nao cria ou faz o appende no arquivo ja existente
			if [ -f "$FILE_TMP_COMMAND_OUT_LOG" ]
			then
                		echo "#===============================================================================" >> $FILE_TMP_COMMAND_OUT_LOG
				$COMMAND 2>&1 >> $FILE_TMP_COMMAND_OUT_LOG
			else
                		echo "#===============================================================================" >> $FILE_TMP_COMMAND_OUT_LOG
				$COMMAND 2>&1 >> $FILE_TMP_COMMAND_OUT_LOG
			fi
		else
		#caso o binario não exista, loga a execao
                echo "ERROR: "`echo $COMMAND` " - Este binario nao existe ou nao foi encontrado no path" >> $FILE_TMP_ERROR_OUT_LOG
		fi
	done
}


#=== FUNCTION 3 ================================================================
# NAME: COPY_ETC_CONF
# DESCRIPTION: Execuata a copia e a compactacao dos arquivos de configuracao do /etc
# PARAMETER 1: ---
#===============================================================================
function COPY_ETC_CONF () {

	#processa os arquivos
	#for FILE in `echo ${FILES_ETC_TO_COPY[@]}` ; do
	for (( i = 0; i < ${#FILES_ETC_TO_COPY[@]}; i++ )) ; do
		#define o path de cada arquivo
		#FILE_PATH="/etc/"$FILE
		FILE_PATH="/etc/"`echo "${FILES_ETC_TO_COPY[$i]}"`

		#verifica se cada arquivo existe no path
		if [ -f "$FILE_PATH" ]
		then
			#verifica se o arquivo zip ja existe, se nao cria ou faz o appende no arquivo ja existente
			if [ -f "$FILE_TMP_ETC_ZIP" ]
			then
				zip -9 $FILE_TMP_ETC_ZIP $FILE_PATH 2>&1 >> $FILE_TMP_COMMAND_OUT_LOG
			else
				zip -9 $FILE_TMP_ETC_ZIP $FILE_PATH 2>&1 >> $FILE_TMP_COMMAND_OUT_LOG
			fi
		else
        #caso o arquivo não exista, loga a execao
                echo "ERROR: "`echo $FILE_PATH` " - Nao existe ou nao foi encontrado no path" >>  $FILE_TMP_ERROR_OUT_LOG
		fi
	done

	#processa as pastas
	#for FOLDER in `echo ${FOLDERS_ETC_TO_COPY[@]}` ; do
	for (( i = 0; i < ${#FOLDERS_ETC_TO_COPY[@]}; i++ )) ; do
		#define o path de cada arquivo
		#FOLDER_PATH="/etc/"$FOLDER
		FOLDER_PATH="/etc/"`echo "${FOLDERS_ETC_TO_COPY[$i]}"`

		#verifica se cada arquivo existe no path
		if [ -d "$FOLDER_PATH" ]
		then
			#verifica se o arquivo zip ja existe, se nao cria ou faz o appende no arquivo ja existente
			if [ -f "$FILE_TMP_ETC_ZIP" ]
			then
				zip -9 $FILE_TMP_ETC_ZIP $FOLDER_PATH 2>&1 >> $FILE_TMP_COMMAND_OUT_LOG
			else
				zip -9 $FILE_TMP_ETC_ZIP $FOLDER_PATH 2>&1 >> $FILE_TMP_COMMAND_OUT_LOG
			fi
		else
		#caso o arquivo não exista, loga a execao
			echo "ERROR: "`echo $FOLDER_PATH` " - Nao existe ou nao foi encontrado no path" >>  $FILE_TMP_ERROR_OUT_LOG
		fi
	done
}

#=== FUNCTION 3 ================================================================
# NAME: COPY_VAR_LOG
# DESCRIPTION: Execuata a copia e a compactacao dos arquivos de log
# PARAMETER 1: ---
#===============================================================================
function COPY_VAR_LOG () {
	#processa os arquivos
	#for FILE in `echo ${FILES_VAR_TO_COPY[@]}` ; do
	for (( i = 0; i < ${#FILES_VAR_TO_COPY[@]}; i++ )) ; do
		#define o path de cada arquivo
		#FILE_PATH="/var/log/"$FILE
		FILE_PATH="/var/log/"`echo "${FILES_VAR_TO_COPY[$i]}"`

		#verifica se cada arquivo existe no path
		if [ -f "$FILE_PATH" ]
		then
			#verifica se o arquivo zip ja existe, se nao cria ou faz o appende no arquivo ja existente
			if [ -f "$FILE_TMP_VAR_ZIP" ]
			then
				zip -9 $FILE_TMP_VAR_ZIP $FILE_PATH 2>&1 >> $FILE_TMP_COMMAND_OUT_LOG
			else
				zip -9 $FILE_TMP_VAR_ZIP $FILE_PATH 2>&1 >> $FILE_TMP_COMMAND_OUT_LOG
			fi
		else
        #caso o arquivo não exista, loga a execao
                echo "ERROR: "`echo $FILE_PATH` " - Nao existe ou nao foi encontrado no path" >>  $FILE_TMP_ERROR_OUT_LOG
		fi
	done

	#processa as pastas
	#for FOLDER in `echo ${FOLDERS_VAR_TO_COPY[@]}` ; do
	for (( i = 0; i < ${#FOLDERS_VAR_TO_COPY[@]}; i++ )) ; do
		#define o path de cada arquivo
		#FOLDER_PATH="/var/log/"$FOLDER
		FOLDER_PATH="/var/log/"`echo "${FOLDERS_VAR_TO_COPY[$i]}"`

		#verifica se cada arquivo existe no path
		if [ -d "$FOLDER_PATH" ]
		then
			#verifica se o arquivo zip ja existe, se nao cria ou faz o appende no arquivo ja existente
			if [ -f "$FILE_TMP_ETC_ZIP" ]
			then
				zip -9 $FILE_TMP_VAR_ZIP $FOLDER_PATH 2>&1 >> $FILE_TMP_COMMAND_OUT_LOG
			else
				zip -9 $FILE_TMP_VAR_ZIP $FOLDER_PATH 2>&1 >> $FILE_TMP_COMMAND_OUT_LOG
			fi
		else
		#caso o arquivo não exista, loga a execao
			echo "ERROR: "`echo $FOLDER_PATH` " - Nao existe ou nao foi encontrado no path" >>  $FILE_TMP_ERROR_OUT_LOG
		fi
	done

}


#=== FUNCTION 4 ================================================================
# NAME: SEARCH_SPACE
# DESCRIPTION: Testa a localizacao do /tmp e o espaco em disco
# PARAMETER 1: ---
#===============================================================================
function SEARCH_SPACE () {
	if [ $TMPPART -eq 0 ] ; then
	
		echo 
        	echo "/tmp e uma particao - 1"  >> $FILE_TMP_COMMAND_OUT_LOG
        	echo "espaco no /tmp e de: - 1  "$FTMPDIR  >> $FILE_TMP_COMMAND_OUT_LOG
        	echo $FTMPDIR| grep "G"  >> $FILE_TMP_COMMAND_OUT_LOG
        	echo
        	
        	if [ `echo $?` -eq "0" ] ; then
			echo
                	echo "espaco em Gb -1 "  >> $FILE_TMP_COMMAND_OUT_LOG
			echo
                	if [ `echo $FTMPDIR | grep [0-9]` > 4 ] ; then
				echo
                        	echo "espaco maior que 4Gb iniciando coleta - 1"  >> $FILE_TMP_COMMAND_OUT_LOG
				echo "executando comandos - 1"  >> $FILE_TMP_COMMAND_OUT_LOG
				echo
				RUN_COMMANDS
				echo
				echo "fim da execucao de comandos - 1"  >> $FILE_TMP_COMMAND_OUT_LOG
				echo
				echo "executando comandos de aplicacoes- 1"  >> $FILE_TMP_COMMAND_OUT_LOG
				echo
				RUN_APP_COMMANDS
				echo
				echo "fim da execucao de comandos de aplicacoes - 1"  >> $FILE_TMP_COMMAND_OUT_LOG
				echo
				echo "copiando configuracao - 1"  >> $FILE_TMP_COMMAND_OUT_LOG
				echo
				COPY_ETC_CONF
				echo
				echo "fim da copia das configuracoes - 1"  >> $FILE_TMP_COMMAND_OUT_LOG
				echo
				echo "copiando logs - 1"  >> $FILE_TMP_COMMAND_OUT_LOG
				echo
				COPY_VAR_LOG
				echo
				echo "fim da copia dos logs - 1"  >> $FILE_TMP_COMMAND_OUT_LOG
				echo
				ENDSCRIPT 0
                	else
	                	echo "#===============================================================================" >> $FILE_TMP_ERROR_OUT_LOG
                        	echo "espaco menor que 4Gb - ignorando coleta - verifique espaco em disco - 1" >> $FILE_TMP_ERROR_OUT_LOG
	                	echo "#===============================================================================" >> $FILE_TMP_ERROR_OUT_LOG
				ENDSCRIPT 1
                	fi
        	fi
	else
        	echo "/tmp nao e particao - 2"  >> $FILE_TMP_COMMAND_OUT_LOG
        	echo "espaco no diretorio root e: - 2 "$ROOTDIR  >> $FILE_TMP_COMMAND_OUT_LOG

		echo hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh  >> $FILE_TMP_COMMAND_OUT_LOG
		echo $ROOTDIR  >> $FILE_TMP_COMMAND_OUT_LOG
		echo  >> $FILE_TMP_COMMAND_OUT_LOG
		echo $?  >> $FILE_TMP_COMMAND_OUT_LOG
		echo hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh  >> $FILE_TMP_COMMAND_OUT_LOG

        	echo $ROOTDIR | grep "G"  >> $FILE_TMP_COMMAND_OUT_LOG

		echo FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF  >> $FILE_TMP_COMMAND_OUT_LOG

        	if [ `echo $?` -eq "0" ] ; then
                	echo "espaco em giga - 2"  >> $FILE_TMP_COMMAND_OUT_LOG
                	if [ `echo $ROOTDIR | grep [0-9]` > 4 ] ; then
				echo
                        	echo "espaco maior que 4Gb iniciando coleta - 2"  >> $FILE_TMP_COMMAND_OUT_LOG
				echo "executando comandos 2"  >> $FILE_TMP_COMMAND_OUT_LOG
				echo
				RUN_COMMANDS
				echo
				echo "fim da execucao de comandos - 2"  >> $FILE_TMP_COMMAND_OUT_LOG
				echo
				echo "executando comandos de aplicacoes -2"  >> $FILE_TMP_COMMAND_OUT_LOG
				echo
				RUN_APP_COMMANDS
				echo
				echo "fim da execucao de comandos de aplicacoes - 2"  >> $FILE_TMP_COMMAND_OUT_LOG
				echo
				echo "copiando configuracao - 2"  >> $FILE_TMP_COMMAND_OUT_LOG
				echo
				COPY_ETC_CONF
				echo
				echo "fim da copia das configuracoes - 2"  >> $FILE_TMP_COMMAND_OUT_LOG
				echo
				echo "copiando logs - 2"  >> $FILE_TMP_COMMAND_OUT_LOG
				echo
				COPY_VAR_LOG
				echo
				echo "fim da copia dos logs - 2"  >> $FILE_TMP_COMMAND_OUT_LOG
				echo
				ENDSCRIPT 0
                	else
	                	echo "#===============================================================================" >> $FILE_TMP_ERROR_OUT_LOG
                        	echo "espaco menor que 4Gb - ignorando coleta - verifique espaco em disco - 2" >> $FILE_TMP_ERROR_OUT_LOG
	                	echo "#===============================================================================" >> $FILE_TMP_ERROR_OUT_LOG
				ENDSCRIPT 1
                	fi
        	fi
	fi
}


#=== FUNCTION 5 ================================================================
# NAME: ENDSCRIPT
# DESCRIPTION: Executa as acoes de log antes de finalizar o script
# PARAMETER 1: ---
#===============================================================================
function ENDSCRIPT () {
	#----------------------------------------------------------------------
	# Calcula e loga o tempo total de execucao do script
	#----------------------------------------------------------------------
	ENDSCRIPTTIME=`date +%s.%N`
	dt=$(echo "$ENDSCRIPTTIME-$STARTSCRIPTTIME" | bc)
	dd=$(echo "$dt/86400" | bc)
	dt2=$(echo "$dt-86400*$dd" | bc)
	dh=$(echo "$dt2/3600" | bc)
	dt3=$(echo "$dt2-3600*$dh" | bc)
	dm=$(echo "$dt3/60" | bc)
	ds=$(echo "$dt3-60*$dm" | bc)


	echo "#===============================================================================" >> $FILE_TMP_COMMAND_OUT_LOG
	echo "Total runtime: (dia - hora - minutos - segundos)\n" $dd $dh $dm $ds  >> $FILE_TMP_COMMAND_OUT_LOG
	echo "INICIO: "$STARTSCRIPTTIME >> $FILE_TMP_COMMAND_OUT_LOG
	echo "FINALIZADO: "$ENDSCRIPTTIME >> $FILE_TMP_COMMAND_OUT_LOG
	echo "SAINDO COM STATUS: " $1 >> $FILE_TMP_COMMAND_OUT_LOG
	echo "#===============================================================================" >> $FILE_TMP_COMMAND_OUT_LOG
	
	OUTPUTLOG="/tmp/get-info-"`hostname`".zip"
	zip -9 $OUTPUTLOG $TMP_FOLDER_TO_FILES
	rm -rf $TMP_FOLDER_TO_FILES

	exit $1
}



#=== FUNCTION 6 ================================================================
# NAME: MAIN
# DESCRIPTION: Executa todas as acoes do script
# PARAMETER 1: ---
#===============================================================================
function MAIN () {
        #----------------------------------------------------------------------
        # cria pasta para armazenar arquivos
        #----------------------------------------------------------------------
        mkdir -p $TMP_FOLDER_TO_FILES
	touch $FILE_TMP_COMMAND_OUT_LOG
	touch $FILE_TMP_ERROR_OUT_LOG

        #OUTPUTLOG="/tmp/getfiles-"`hostname`".log 2>&1"
        #touch $TMP_FOLDER_TO_FILES/getfiles-`hostname`.log
        #OUTPUTLOG=(` 2>&1 | tee -a `"/tmp/getfiles-"`hostname`".log")
        #OUTPUTLOG='2>&1 | tee -a '`$TMP_FOLDER_TO_FILES`'/getfiles-'`hostname`'.log'

        df -h | grep /tmp
        TMPPART=$?
        ROOTDIR=`df -h / | grep "/" | awk '{print $4}'`
        FTMPDIR=`df -h / | grep "/tmp" | awk '{print $4}'`


	#----------------------------------------------------------------------
	# verifica se o binario do zip esta instalado no sistema
	#----------------------------------------------------------------------
	if [ -f "$ZIP_BIN_PATH" ]
	then
		echo "#===============================================================================" >> $FILE_TMP_COMMAND_OUT_LOG
		echo "INFO: ZIP encontrado em "$ZIP_BIN_PATH  >> $FILE_TMP_COMMAND_OUT_LOG
		echo "#===============================================================================" >> $FILE_TMP_COMMAND_OUT_LOG
	else
	        echo "#===============================================================================" >> $FILE_TMP_ERROR_OUT_LOG
		echo >> $FILE_TMP_ERROR_OUT_LOG
		echo "ERROR: ZIP NAO ENCONTRADO" >> $FILE_TMP_ERROR_OUT_LOG
		echo "PARA UTILIZAR ESTE SCRIPT E NECESSARIO INSTALAR O PACOTE ZIP" >> $FILE_TMP_ERROR_OUT_LOG
		echo >> $FILE_TMP_ERROR_OUT_LOG
	        echo "#===============================================================================" >> $FILE_TMP_ERROR_OUT_LOG
		ENDSCRIPT 1
	fi

	#----------------------------------------------------------------------
	# chama a primeira funcao
	#----------------------------------------------------------------------
	SEARCH_SPACE

}

MAIN
