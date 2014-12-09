#!/bin/bash
#===================================================================================
#
# FILE: try-access_sshpass.bash
#
# USAGE: try-access_sshpass.bash
#
# DESCRIPTION:  Testa o acesso a servidores com ate 6 senhas diferentes.
#               testa se o servidor e alcansado via nome.
#
# OPTIONS: ---
# REQUIREMENTS: Password files (arquivos de senha .MyPass2011-2015 e 0000)
# BUGS: ---
# NOTES: A saida no arquivo de log exibe as tentativas e os codigos de erros
#
#
# AUTHOR: Mario Luz, mario.mssl at gmail.com
#         https://github.com/mariosergiosl/GetServerInfo/blob/master/try-access_sshpass.bash
# COMPANY:
# VERSION: Drafth 0.1
# CREATED: 09.12.2014 - 17:11:50
# ROADMAP:
# REVISION: 01-25.09.2014
#===================================================================================


#----------------------------------------------------------------------
# declaracao de variaveis
#----------------------------------------------------------------------


for server in `cat serverZ`;do 
	sshpass -f .MyPass2011 ssh -t -o ConnectTimeout=1 -o ConnectTimeout=1 -o StrictHostKeyChecking=no root@$server exit; 
		retorno=`echo $?` 
		echo $server, $retorno, "MyPass2011" >> teste.output 
		if [ $retorno != 255 ] ; then
			if [ $retorno != 0 ] ; then
				sshpass -f .MyPass2012 ssh -t -o ConnectTimeout=1 -o ConnectTimeout=1 -o StrictHostKeyChecking=no root@$server exit
				retorno=`echo $?`
				echo $server, $retorno, "MyPass2012" >> teste.output
				if [ $retorno != 0 ] ; then
					sshpass -f .MyPass2013 ssh -t -o ConnectTimeout=1 -o ConnectTimeout=1 -o StrictHostKeyChecking=no root@$server exit
					retorno=`echo $?`
					echo $server, $retorno, "MyPass2013" >> teste.output
					if [ $retorno != 0 ] ; then
						sshpass -f .MyPass2014 ssh -t -o ConnectTimeout=1 -o ConnectTimeout=1 -o StrictHostKeyChecking=no root@$server exit
						retorno=`echo $?`
						echo $server, $retorno, "MyPass2014" >> teste.output
                                        	if [ $retorno != 0 ] ; then
                                                	sshpass -f .MyPass2015 ssh -t -o ConnectTimeout=1 -o ConnectTimeout=1 -o StrictHostKeyChecking=no root@$server exit
                                                	retorno=`echo $?`
                                                	echo $server, $retorno, "MyPass2015" >> teste.output
                                                	if [ $retorno != 0 ] ; then
                                                        	sshpass -f .MyPass0000 ssh -t -o ConnectTimeout=1 -o ConnectTimeout=1 -o StrictHostKeyChecking=no root@$server exit
                                                        	retorno=`echo $?`
                                                        	echo $server, $retorno, "MyPass0000" >> teste.output
                                                	fi
						fi
					fi
				fi
			fi
		
		else 
			echo $server, $retorno, "nao encontrado" >> teste.output
		fi; done
