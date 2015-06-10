## Objective

run influxdb on localdir

## Usage

```
init.sh start
init.sh status
init.sh stop
```

## Contributes

### toml

```
wget https://pypi.python.org/packages/source/t/toml/toml-0.9.0.tar.gz
```

This toml library could not parse part of graphite plugin in influxdb default toml file


### influxdb

```
rm -rf tmp
mkdir tmp; cd tmp 
VER=0.9.0
RC=rc32
UPDATE=1
mkdir ${VER}-${RC}
wget -O - http://s3.amazonaws.com/influxdb/influxdb-${VER}_${RC}-${UPDATE}.x86_64.rpm | rpm2cpio -  | cpio -id
mv opt/influxdb/versions/${VER}-${RC}/in* ../${VER}-${RC}/
```

```
wget http://s3.amazonaws.com/influxdb/influxdb-0.8.8-1.x86_64.rpm
rpm2cpio influxdb-0.8.8-1.x86_64.rpm | cpio -id
```
