#!/bin/env python

import os
import sys
import json
import toml

basedir = os.environ["PWD"] if not os.environ.get("BASEDIR") else  os.environ["BASEDIR"]
baseport = 10000 if not os.environ.get("BASEPORT") else  int(os.environ["BASEPORT"])

raw_cfg=open(sys.path[0]+"/config.toml").read()
cfg=toml.loads(raw_cfg)

cfg["wal"]["dir"]= basedir+"/data/wal"
cfg["logging"]["file"]= basedir+"/log/log.txt"
cfg["admin"]["port"]=baseport+83
cfg["storage"]["dir"]=basedir+"/data/db"
cfg["raft"]["dir"]=basedir+"/data/raft"
cfg["raft"]["port"]=baseport+90
cfg["api"]["port"]=baseport+86
cfg["cluster"]["protobuf_port"]=baseport+99

print "ports API:{0},BROWS{1},CLUSTER:{2}".format(cfg["api"]["port"],cfg["admin"]["port"],cfg["cluster"]["protobuf_port"])


open("tmp.influxdb.conf","w").write(toml.dumps(cfg))

