#./change_time.sh (intervallo pubblicazione) (porta)
#questo deve essere invocato dalla parte client per inviare al server il numero con cui cambiare l'intervallo di pubblicazione
kill -9 $(lsof -t -i:$2)
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

sudo git clone https://github.com/lorenzobassi96/opc_ua_client_adaptive

cd opc_ua_client_adaptive/

sudo cp myServer.c /home/ubuntu/C-Projects/OPC_UA   #devo copiare il file nella cartella $
cd /home/ubuntu/C-Projects/OPC_UA

#vado a cambiare il tempo di pubblicazione
sudo replace "tempo_pubblicazione" $1 -- myServer.c


echo "--------------------------------------"
echo "BUILD OF THE SERVER..."
echo "--------------------------------------"

sudo gcc -std=c99 open62541.c myServer.c -o myServer
#sudo gcc myServer.c -o myServer -lopen62541

echo "--------------------------------------"
echo "STARTING  SERVER..."
echo "--------------------------------------"

sudo cp -R * /home/ubuntu/
cd /home/ubuntu/

#IP=$(/sbin/ifconfig ens3 | grep 'inet' | cut -d: -f2 | awk $'{print $2}')
#IP=$(/sbin/ifconfig ens3 | grep inet | awk '{print $2}' | awk  -F : '{print $2}')

./myServer $IP $2
