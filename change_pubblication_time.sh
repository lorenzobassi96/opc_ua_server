#usare lo script con: ./change_pubblication_time (port_number) (ip_client) (port_number_client)

echo "--------------------------------------"
echo "WAITING FOR COMMANDS...."
echo "--------------------------------------"

while true [ "$( python3 connection_to_server.py $2 $3)" != "Requested secure channel timeout to be 3600000ms, got 600000ms instead" ]

echo "--------------------------------------"
echo "COMMAND RECEIVED !"
echo "--------------------------------------"


timeout 5s python3 connection_to_server.py $2 $3 >> lista_tempi_pubblicazione.txt


echo "--------------------------------------"
echo "RIMASTO IN ASCOLTO PER 5 SECONDI"
echo "--------------------------------------"

PT=$(grep  -Eo '^[0-9]+$' lista_tempi_pubblicazione.txt | tail -1)

echo "--------------------------------------"
echo "NUMERO RILEVATO"
echo $PT
echo "--------------------------------------"






kill -9 $(lsof -t -i:$1)
echo "--------------------------------------"
echo "SERVER TERMIANTO"
echo "--------------------------------------"
IP=$(/sbin/ifconfig ens3 | grep 'inet' | cut -d: -f2 | awk $'{print $2}')

cd /home/ubuntu
sudo rm -rf C-Projects
sudo mkdir /home/ubuntu/C-Projects
sudo mkdir /home/ubuntu/C-Projects/OPC_UA
cd temp_opcua_installation_process/
cd /home/ubuntu/temp_opcua_installation_process/open62541/build/
sudo cp open62541.* /home/ubuntu/C-Projects/OPC_UA
cd /home/ubuntu/C-Projects/OPC_UA

sudo git clone https://github.com/lorenzobassi96/opc_ua_server_adaptive.git

cd opc_ua_server_adaptive/

sudo cp myServer.c /home/ubuntu/C-Projects/OPC_UA   #devo copiare il file nella cartella di lavoro
cd /home/ubuntu/C-Projects/OPC_UA

#vado a cambiare il tempo di pubblicazione
sudo replace "tempo_pubblicazione" $PT -- myServer.c

echo "--------------------------------------"
echo "RE-BUILD OF THE SERVER..."
echo "--------------------------------------"

#gcc -std=c99 open62541.c myServer.c -o myServer
sudo gcc myServer.c -o myServer -lopen62541

echo "--------------------------------------"
echo "STARTING NEW SERVER..."
echo "--------------------------------------"

sudo cp -R * /home/ubuntu/
cd /home/ubuntu/

#IP=$(/sbin/ifconfig ens3 | grep 'inet' | cut -d: -f2 | awk $'{print $2}')
#IP=$(/sbin/ifconfig ens3 | grep inet | awk '{print $2}' | awk  -F : '{print $2}')


./myServer $IP $1
