#!/bin/env python

import os
import sys
import json
import toml

basedir = os.environ["PWD"] if not os.environ.get("BASEDIR") else  os.environ["BASEDIR"]
baseport = 10000 if not os.environ.get("BASEPORT") else  int(os.environ["BASEPORT"])

raw_cfg=open(sys.path[0]+"/influxdb.generated.conf").read()
cfg=toml.loads(raw_cfg)

print cfg

cfg["meta"]["dir"]=basedir+"/data/meta"
cfg["meta"]["bind-address"]=":{0}".format(baseport+88)
cfg["meta"]["reporting-disabled"]=False
cfg["data"]["dir"]= basedir+"/data/db"
cfg["admin"]["bind-address"]=":{0}".format(baseport+83)
cfg["http"]["bind-address"]=":{0}".format(baseport+86)
cfg["hinted-handoff"]["dir"]=basedir+"/data/hh"

print "ports API:{0},ADMIN:{1},BROKER:{2}".format(cfg["meta"]["bind-address"],cfg["admin"]["bind-address"],cfg["meta"]["dir"])

open("tmp.influxdb.conf","w").write(toml.dumps(cfg))
