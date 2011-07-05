#!/bin/bash
robotsroot="/your/path/robots-relapse"
mkdir -pv ${robotsroot}
cd ${robotsroot}
./aria2c.sh 
./robots2sqlite.sh ${robotsroot}
