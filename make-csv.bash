#!/bin/bash
###descompactar arquivos
for A in `ls *-4linux-get-server.tar.gz`; do tar -xzf $A; echo -n $A","`cat tmp/4linux/files-etc/issue | head -1` $'\n' >> so1.csv; sed s/'-4linux-get-server.tar.gz'/''/g so1.csv >> so.csv; rm -f so1.csv ; done
###cabecalho do csv
echo "Nome do Servidor:, Endereco IP:, Architecture:, CPUs:,  MemTotal:, Linux version:, Disk:, Disk:,Disk:,Disk:,Disk:,Disk:,Disk:,Disk:,Disk:,Disk:,Disk:,Disk:,Disk:,Disk:,Disk:,Disk:,Disk:,Disk:,Disk:,Disk:,Disk:,Disk:,Disk:," >> OUT
###corpo do csv
for f in `ls tmp/4linux/*.log`;do echo -n `grep -A1 -ir 'Nome do Servidor' $f`"," \ ; echo -n `grep -A1 -ir 'Endereco IP' $f | head -2`"," \ ; echo -n `grep 'Architecture:' $f`"," ; echo -n `grep 'CPU(s):' $f | head -1`","; echo -n `grep 'MemTotal:' $f`"," ;echo -n `grep 'Linux version ' $f | head -1`","; echo -n `grep 'Disk /dev/s' $f | cut -d "," -f 1` $'\n'; done >> OUT
###finalizando csv
sed s/'###################### Nome do Servidor '/''/g OUT >> OUT1
rm -f OUT
mv OUT1 OUT
sed s/'###################### #Endereco '/''/g OUT >> OUT1
rm -f OUT
mv OUT1 OUT
sed s/'Architecture: '/''/g OUT >> OUT1
rm -f OUT
mv OUT1 OUT
sed s/'CPU(s): '/''/g OUT >> OUT1
rm -f OUT
mv OUT1 OUT
sed s/'MemTotal: '/''/g OUT >> OUT1
rm -f OUT
mv OUT1 OUT
sed s/'Linux version '/''/g OUT >> OUT1
rm -f OUT
mv OUT1 OUT
sed s/'Disk '/''/g OUT >> OUT1
rm -f OUT
mv OUT1 OUT
sed s/' MB '/' MB,'/g OUT >> OUT1
rm -f OUT
mv OUT1 OUT
sed s/' GB '/' GB,'/g OUT >> OUT1
rm -f OUT
mv OUT1 OUT
sed s/' TB '/' TB,'/g OUT >> OUT1
rm -f OUT
mv OUT1 OUT
sed s/' ('/';'/g OUT >> OUT1
rm -f OUT
mv OUT1 OUT
sed s/') '/''/g OUT >> OUT1
rm -f OUT
mv OUT1 OUT
###criacao do arquivo
sed  s/' bytes '/' bytes, '/g OUT >> dados.csv
rm -f OUT
rm -rf tmp
