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
mkdir tmp; cd tmp 
wget -O - http://s3.amazonaws.com/influxdb/influxdb-0.9.0_rc29-1.x86_64.rpm | rpm2cpio -  | cpio -id
mv opt/influxdb/versions/0.9.0-rc20/in* ../0.9.0-rc29/
```

```
wget http://s3.amazonaws.com/influxdb/influxdb-0.8.8-1.x86_64.rpm
rpm2cpio influxdb-0.8.8-1.x86_64.rpm | cpio -id
```
