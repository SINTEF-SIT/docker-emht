#!/bin/sh
cd /opt/emht && git pull
#/opt/emht/target/universal/stage/bin/emht -DapplyEvolutions.default=true
cd /opt/emht && play run
