#!/bin/env python

import os
import sys
import json
import toml

basedir = os.environ["PWD"] if not os.environ.get("BASEDIR") else  os.environ["BASEDIR"]
baseport = 10000 if not os.environ.get("BASEPORT") else  int(os.environ["BASEPORT"])

raw_cfg=open(sys.path[0]+"/influxdb.conf").read()
cfg=toml.loads(raw_cfg)

cfg["port"]=baseport+86
cfg["data"]["dir"]= basedir+"/data/db"
cfg["admin"]["port"]=baseport+83
cfg["broker"]["dir"]=basedir+"/data/raft"

print "ports API:{0},ADMIN:{1},BROKER:{2}".format(cfg["port"],cfg["admin"]["port"],cfg["broker"]["dir"])

open("tmp.influxdb.conf","w").write(toml.dumps(cfg))
