KILL=$(netstat -lpn |grep :5555)
comando="lsof -t -i:"
kill -9 $(lsof -t -i:$2)

cd /home/ubuntu
rm -rf C-Projects
mkdir /home/ubuntu/C-Projects
mkdir /home/ubuntu/C-Projects/OPC_UA
cd temp_opcua_installation_process/
cd /home/ubuntu/temp_opcua_installation_process/open62541/build/
cp open62541.* /home/ubuntu/C-Projects/OPC_UA
cd /home/ubuntu/C-Projects/OPC_UA

sudo git clone https://github.com/lorenzobassi96/opc_ua_server_adaptive.git
cd opc_ua_server_adaptive/
cp myServer.c /home/ubuntu/C-Projects/OPC_UA   #devo copiare il file nella cartella di lavoro
cd /home/ubuntu/C-Projects/OPC_UA

#vado a cambiare il tempo di pubblicazione
replace "tempo_pubblicazione" $1 -- myServer.c

gcc -std=c99 open62541.c myServer.c -o myServer
cp -R * /home/ubuntu/
chmod +x myServer

IP=$(/sbin/ifconfig ens3 | grep 'inet' | cut -d: -f2 | awk $'{print $2}')
./myServer (echo $IP) 5555
