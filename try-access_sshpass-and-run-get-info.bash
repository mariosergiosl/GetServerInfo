#!/bin/bash
#===================================================================================
#
# FILE: try-access_sshpass-and-run-get-info.bash
#
# USAGE: try-access_sshpass-and-run-get-info.bash
#
# DESCRIPTION: 	Testa o acesso a servidores com ate 6 senhas diferentes.
#		testa se o servidor e alcansado via nome.
#
# OPTIONS: ---
# REQUIREMENTS: sshpass package and Password files (arquivos de senha .MyPass2011-2015 e 0000)
# BUGS: ---
# NOTES: A saida no arquivo de log exibe as tentativas e os codigos de erros
#	 
#
# AUTHOR: Mario Luz, mario.mssl at gmail.com
#	  https://github.com/mariosergiosl/GetServerInfo/blob/master/try-access_sshpass.bash
# COMPANY: 
# VERSION: Drafth 0.1
# CREATED: 09.12.2014 - 17:11:50
# ROADMAP:
# 	   Adicionar carregamento de arquivo
#	   Adicionar opcao para nome de arquivo de log		
# REVISION: 01-25.09.2014
#
#===================================================================================


#----------------------------------------------------------------------
# Problemas conhecidos
#----------------------------------------------------------------------
# se no arquivo de lista de servidor estiver o ip e nao o nome o arquivo nao vai ser transferido ja que o mesmo e criado com o nome do servidor e nao com o ip
#

#----------------------------------------------------------------------
# declaracao de variaveis
#----------------------------------------------------------------------


#----------------------------------------------------------------------
# Main
#----------------------------------------------------------------------
for server in `cat sCentreon-Linux`;do
	#tenta a conexao com a primeira senha 
	sshpass -f .MyPass2011 ssh -t -o ConnectTimeout=1 -o ConnectTimeout=1 -o StrictHostKeyChecking=no root@$server exit; 
		#pega o retorno
		retorno=`echo $?`
		#loga o teste 
		echo $server, $retorno, "MyPass2011" >> teste.output
		#se a senha funcionar, instala a chave, copia o script de informacao, executa, e copia o resultado de volta
		if [ $retorno = 0 ] ; then
			#instala chave
			sshpass -f .MyPass2011 ssh-copy-id root@$server
			#copia script
			sshpass -f .MyPass2011 scp get-info.bash root@$server:/root/
			#executa script
			sshpass -f .MyPass2011 ssh -t -o ConnectTimeout=1 -o ConnectTimeout=1 -o StrictHostKeyChecking=no root@$server /root/get-info.bash
			#transfere resultado
			sshpass -f .MyPass2011 scp root@$server:/tmp/$server.get-info.zip ./log/
		fi
		#em caso de falha testa se a falha foi nao encontrar o host, se nao encontrar o host sai do laco 
		if [ $retorno != 255 ] ; then
			#se encontrar o host mas nao conectar testa a proxima senha
			if [ $retorno != 0 ] ; then
				sshpass -f .MyPass2012 ssh -t -o ConnectTimeout=1 -o ConnectTimeout=1 -o StrictHostKeyChecking=no root@$server exit
				retorno=`echo $?`
				echo $server, $retorno, "MyPass2012" >> teste.output
		                #se a senha funcionar, instala a chave, copia o script de informacao, executa, e copia o resultado de volta
                		if [ $retorno = 0 ] ; then
                        		#instala chave
		                        sshpass -f .MyPass2012 ssh-copy-id root@$server
		                        #copia script
		                        sshpass -f .MyPass2012 scp get-info.bash root@$server:/root/
		                        #executa script
		                        sshpass -f .MyPass2012 ssh -t -o ConnectTimeout=1 -o ConnectTimeout=1 -o StrictHostKeyChecking=no root@$server /root/get-info.bash
		                        #transfere resultado
		                        sshpass -f .MyPass2012 scp root@$server:/tmp/$server.get-info.zip ./log/
		                fi
				#testa a proxima senha
				if [ $retorno != 0 ] ; then
					sshpass -f .MyPass2013 ssh -t -o ConnectTimeout=1 -o ConnectTimeout=1 -o StrictHostKeyChecking=no root@$server exit
					retorno=`echo $?`
					echo $server, $retorno, "MyPass2013" >> teste.output
			                #se a senha funcionar, instala a chave, copia o script de informacao, executa, e copia o resultado de volta
			                if [ $retorno = 0 ] ; then
			                        #instala chave
			                        sshpass -f .MyPass2013 ssh-copy-id root@$server
			                        #copia script
			                        sshpass -f .MyPass2013 scp get-info.bash root@$server:/root/
			                        #executa script
			                        sshpass -f .MyPass2013 ssh -t -o ConnectTimeout=1 -o ConnectTimeout=1 -o StrictHostKeyChecking=no root@$server /root/get-info.bash
			                        #transfere resultado
			                        sshpass -f .MyPass2013 scp root@$server:/tmp/$server.get-info.zip ./log/
			                fi
					#testa a proxima senha
					if [ $retorno != 0 ] ; then
						sshpass -f .MyPass2014 ssh -t -o ConnectTimeout=1 -o ConnectTimeout=1 -o StrictHostKeyChecking=no root@$server exit
						retorno=`echo $?`
						echo $server, $retorno, "MyPass2014" >> teste.output
				                #se a senha funcionar, instala a chave, copia o script de informacao, executa, e copia o resultado de volta
				                if [ $retorno = 0 ] ; then
				                        #instala chave
				                        sshpass -f .MyPass2014 ssh-copy-id root@$server
				                        #copia script
				                        sshpass -f .MyPass2014 scp get-info.bash root@$server:/root/
				                        #executa script
				                        sshpass -f .MyPass2014 ssh -t -o ConnectTimeout=1 -o ConnectTimeout=1 -o StrictHostKeyChecking=no root@$server /root/get-info.bash
				                        #transfere resultado
				                        sshpass -f .MyPass2014 scp root@$server:/tmp/$server.get-info.zip ./log/
				                fi
						#testa a proxima senha
                                        	if [ $retorno != 0 ] ; then
                                                	sshpass -f .MyPass2015 ssh -t -o ConnectTimeout=1 -o ConnectTimeout=1 -o StrictHostKeyChecking=no root@$server exit
                                                	retorno=`echo $?`
                                                	echo $server, $retorno, "MyPass2015" >> teste.output
					                #se a senha funcionar, instala a chave, copia o script de informacao, executa, e copia o resultado de volta
					                if [ $retorno = 0 ] ; then
					                        #instala chave
					                        sshpass -f .MyPass2015 ssh-copy-id root@$server
					                        #copia script
					                        sshpass -f .MyPass2015 scp get-info.bash root@$server:/root/
					                        #executa script
					                        sshpass -f .MyPass2015 ssh -t -o ConnectTimeout=1 -o ConnectTimeout=1 -o StrictHostKeyChecking=no root@$server /root/get-info.bash
					                        #transfere resultado
					                        sshpass -f .MyPass2015 scp root@$server:/tmp/$server.get-info.zip ./log/
					                fi
							#testa a proxima senha
                                                	if [ $retorno != 0 ] ; then
                                                        	sshpass -f .MyPass0000 ssh -t -o ConnectTimeout=1 -o ConnectTimeout=1 -o StrictHostKeyChecking=no root@$server exit
                                                        	retorno=`echo $?`
                                                        	echo $server, $retorno, "MyPass0000" >> teste.output
						                #se a senha funcionar, instala a chave, copia o script de informacao, executa, e copia o resultado de volta
						                if [ $retorno = 0 ] ; then
						                        #instala chave
						                        sshpass -f .MyPass0000 ssh-copy-id root@$server
						                        #copia script
						                        sshpass -f .MyPass0000 scp get-info.bash root@$server:/root/
						                        #executa script
						                        sshpass -f .MyPass0000 ssh -t -o ConnectTimeout=1 -o ConnectTimeout=1 -o StrictHostKeyChecking=no root@$server /root/get-info.bash
						                        #transfere resultado
						                        sshpass -f .MyPass0000 scp root@$server:/tmp/$server.get-info.zip ./log/
						                fi

                                                	fi
						fi
					fi
				fi
			fi
		
		else 
			#loga a saida em caso de nao encontrar o host
			echo $server, $retorno, "nao encontrado" >> teste.output
		fi; 
done
