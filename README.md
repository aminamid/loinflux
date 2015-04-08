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
wget https://pypi.python.org/packages/source/t/toml/toml-0.7.0.tar.gz
```

This toml library could not parse part of graphite plugin in influxdb default toml file


### influxdb

```
wget http://s3.amazonaws.com/influxdb/influxdb-0.9.0_rc20-1.x86_64.rpm
rpm2cpio influxdb-0.9.0_rc20-1.x86_64.rpm | cpio -id
```

```
wget http://s3.amazonaws.com/influxdb/influxdb-0.8.8-1.x86_64.rpm
rpm2cpio influxdb-0.8.8-1.x86_64.rpm | cpio -id
```
