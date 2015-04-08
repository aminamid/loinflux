#!/bin/env python

import os
import sys
import json
import toml

basedir = os.environ["PWD"] if not os.environ.get("BASEDIR") else  os.environ["BASEDIR"]
baseport = 10000 if not os.environ.get("BASEPORT") else  int(os.environ["BASEPORT"])

raw_cfg=open(sys.path[0]+"/influxdb.conf").read()
cfg=toml.loads(raw_cfg)

cfg["data"]["dir"]= basedir+"/data/db"
cfg["data"]["port"]=baseport+86
cfg["admin"]["port"]=baseport+83
cfg["broker"]["dir"]=basedir+"data/raft"
cfg["broker"]["port"]=baseport+86
cfg["cluster"]["dir"]=basedir+"data/state"
cfg["snapshot"]["port"]=baseport+87


print "ports API:{0},BROWS{1},BROKER:{2},SNAPSHOT:{3}".format(cfg["data"]["port"],cfg["admin"]["port"],cfg["broker"]["port"],cfg["snapshot"]["port"]) 


open("tmp.influxdb.conf","w").write(toml.dumps(cfg))

