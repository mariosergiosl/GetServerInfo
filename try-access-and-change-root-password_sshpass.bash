#!/bin/bash
#===================================================================================
#
# FILE: try-access-and-change-root-password_sshpass.bash
#
# USAGE: try-access-and-change-root-password_sshpass.bash
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
#	  https://github.com/mariosergiosl/GetServerInfo/blob/master/try-access-and-change-root-password_sshpass.bash
# COMPANY: 
# VERSION: Drafth 0.1
# CREATED: 10.12.2014 - 14:34:50
# ROADMAP:
# 	   Adicionar carregamento de arquivo
#	   Adicionar opcao para nome de arquivo de log
#	   Adicionar arquivo para nova password		
# REVISION: 01-10.12.2014
#
#===================================================================================


#----------------------------------------------------------------------
# declaracao de variaveis
#----------------------------------------------------------------------


#----------------------------------------------------------------------
# Help
#----------------------------------------------------------------------
usage(){
	echo "Usage: $0"
	exit 1
}

#----------------------------------------------------------------------
# Main
#----------------------------------------------------------------------
main(){
for server in `cat serverT`;do
	#tenta a conexao com a primeira senha 
	sshpass -f .MyPass2011 ssh -t -o ConnectTimeout=1 -o ConnectTimeout=1 -o StrictHostKeyChecking=no root@$server exit; 
		#pega o retorno
		retorno=`echo $?`
		PassUser=".MyPass2011"
		#loga o teste 
		echo $server, $retorno, "MyPass2011" >> teste.output
		#em caso de falha testa se a falha foi nao encontrar o host, se nao encontrar o host sai do laco 
		if [ $retorno != 255 ] ; then
			#se encontrar o host mas nao conectar testa a proxima senha
			if [ $retorno != 0 ] ; then
				sshpass -f .MyPass2012 ssh -t -o ConnectTimeout=1 -o ConnectTimeout=1 -o StrictHostKeyChecking=no root@$server exit
				retorno=`echo $?`
                		PassUser=".MyPass2012"
				echo $server, $retorno, "MyPass2012" >> teste.output
				#testa a proxima senha
				if [ $retorno != 0 ] ; then
					sshpass -f .MyPass2013 ssh -t -o ConnectTimeout=1 -o ConnectTimeout=1 -o StrictHostKeyChecking=no root@$server exit
					retorno=`echo $?`
                			PassUser=".MyPass2013"
					echo $server, $retorno, "MyPass2013" >> teste.output
					#testa a proxima senha
					if [ $retorno != 0 ] ; then
						sshpass -f .MyPass2014 ssh -t -o ConnectTimeout=1 -o ConnectTimeout=1 -o StrictHostKeyChecking=no root@$server exit
						retorno=`echo $?`
						PassUser=".MyPass2014"
						echo $server, $retorno, "MyPass2014" >> teste.output
						#testa a proxima senha
                                        	if [ $retorno != 0 ] ; then
                                                	sshpass -f .MyPass2015 ssh -t -o ConnectTimeout=1 -o ConnectTimeout=1 -o StrictHostKeyChecking=no root@$server exit
                                                	retorno=`echo $?`
                					PassUser=".MyPass2015"
                                                	echo $server, $retorno, "MyPass2015" >> teste.output
							#testa a proxima senha
                                                	if [ $retorno != 0 ] ; then
                                                        	sshpass -f .MyPass0000 ssh -t -o ConnectTimeout=1 -o ConnectTimeout=1 -o StrictHostKeyChecking=no root@$server exit
                                                        	retorno=`echo $?`
                						PassUser=".MyPass0000"
                                                        	echo $server, $retorno, "MyPass0000" >> teste.output
                                                	fi
						fi
					fi
				fi
			fi
		
		else 
			#loga a saida em caso de nao encontrar o host
			echo $server, $retorno, "nao encontrado" >> teste.output
		fi;

		if [ $retorno != 255 ] ; then 
			if [ $retorno = 0 ] ; then
				sshpass -f $PassUser ssh -t -o ConnectTimeout=1 -o ConnectTimeout=1 -o StrictHostKeyChecking=no root@$server 'echo "nova senha aqui" | passwd root --stdin'
                                retorno=`echo $?`
				echo $server, $retorno, "senha alterada" >> teste.output
			fi;
		fi;
done
}


#----------------------------------------------------------------------
# Start
#----------------------------------------------------------------------
[[ $# -eq 0 ]] && main
