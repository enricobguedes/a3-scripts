# checks server up
# loop 5 minutes
# if not up, start exe again (arma op?)
# verify if arma 3 is not up AND arma op not running

import wmi;
import time;
import os


#Define the exes
arma3Process="arma3_x64.exe"
armaOPProcess="ArmaOP.exe"

#Thread sleep time
timeToWait=10 # int, five minutes for now

pathToArmaOP="insert/path/to/armaOP" #FULLPATH C://......

#used for logic
hasProcess=False

f = wmi.WMI()

while True:
    for process in f.Win32_Process():
      if (str(process.Name) == arma3Process or str(process.Name) == armaOPProcess):
        print("Process found: " + saveList[i])
        hasProcess=True
        
      if(!hasProcess):
        print("Strating ARMA OP, ARMA3 NOR ARMA OP FOUND")
        os.startfile(pathToArmaOP)
       
    time.sleep(timeToWait)
    print("Searching for Arma3 or ArmaOP")
