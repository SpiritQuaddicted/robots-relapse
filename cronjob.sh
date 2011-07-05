#!/bin/bash
robotsroot="/home/hannes/kram/projekte/robotstxt/robots-relapse"
mkdir -pv ${robotsroot}
cd ${robotsroot}
./aria2c.sh 
./robots2sqlite.sh ${robotsroot}
