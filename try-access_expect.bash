#!/bin/bash
#===================================================================================
#
# FILE: try-access_expect.bash
#
# USAGE: try-access_expect.bash
#
# DESCRIPTION:  Testa o acesso a servidores.
#               
#
# OPTIONS: ---
# REQUIREMENTS: Pacotes Expect and Spawn
# BUGS: ---
# NOTES: ---
#
#
# AUTHOR: Mario Luz, mario.mssl at gmail.com
#         https://github.com/mariosergiosl/GetServerInfo/blob/master/try-access_expect.bash
# COMPANY:
# VERSION: Drafth 0.1
# CREATED: 09.12.2014 - 17:11:50
# ROADMAP:
# REVISION: 01-25.09.2014
#===================================================================================


#----------------------------------------------------------------------
# declaracao de variaveis
#----------------------------------------------------------------------

#### #!/bin/expect -f
#### para executar
##### for a in `cat server_jbsp` ; do  ./xxx.sh $a ; done



nome="$1"
expect -c "
spawn  ssh -t -o ConnectTimeout=1 -o ConnectTimeout=1 -o StrictHostKeyChecking=no root@$1
sleep 1
expect \"*Password:*\"
sleep 1
send \"SuA-SeNhA-AqUi\r\";
sleep 1
send \" uname -a\r\";
sleep 3
send \"exit\r\"
sleep 3
interact ;
"
