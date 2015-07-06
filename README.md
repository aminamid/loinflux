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
VER=0.9.0
RC=rc32
UPDATE=1
cp -rp 090base ${VER}-${RC}
rm -rf tmp
mkdir tmp; cd tmp 
mkdir ${VER}-${RC}
wget -O - http://s3.amazonaws.com/influxdb/influxdb-${VER}_${RC}-${UPDATE}.x86_64.rpm | rpm2cpio -  | cpio -id
mv opt/influxdb/versions/${VER}-${RC}/in* ../${VER}-${RC}/
```

```
VER=0.9.1
UPDATE=1
cp -rp 090base ${VER}
mkdir data${VER}
ln -s data${VER} data
rm -rf tmp
mkdir tmp; cd tmp
mkdir ${VER}
wget -O - http://s3.amazonaws.com/influxdb/influxdb-${VER}-${UPDATE}.x86_64.rpm | rpm2cpio -  | cpio -id
mv opt/influxdb/versions/${VER}/in* ../${VER}/
```
