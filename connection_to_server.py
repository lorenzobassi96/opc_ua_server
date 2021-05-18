import sys
from sys import argv
ip_address = str(sys.argv[1])
port_number = str(sys.argv[2])         
domain = "opc.tcp://"
ddd = ":"
final_address = (domain+ip_address+ddd+port_number)
print (final_address)
from opcua import Client
client=Client(final_address)
client.connect()
from time import sleep
while True:
 print(client.get_node("ns=1;s=Random_Number").get_value())
 sleep(1)
