#!/bin/bash

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
