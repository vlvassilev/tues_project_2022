#!/usr/bin/python

import os
import time

while(True):
    os.system("set-net networks-config-1.xml")
    #os.system("get-net networks.xml networks-state-1.xml")
    time.sleep(5)
    os.system("set-net networks-config-2.xml")
    #os.system("get-net networks.xml networks-state-1.xml")
    time.sleep(5)

    
