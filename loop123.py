#!/usr/bin/python

import os
import time

for x in range(6):
    os.system("set-net networks-config-123-1.xml")
    #os.system("get-net networks.xml networks-state-1.xml")
    os.system("set-net networks-config-123-2.xml")
    #os.system("get-net networks.xml networks-state-1.xml")
    os.system("set-net networks-config-123-3.xml")
    #os.system("get-net networks.xml networks-state-1.xml")

    
