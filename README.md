docker-nfs-ganesha
=====================

[![Microbadger Size](https://images.microbadger.com/badges/image/janeczku/nfs-ganesha.svg?maxAge=8600)][microbadger]
[![Docker Pulls](https://img.shields.io/docker/pulls/janeczku/nfs-ganesha.svg?maxAge=8600)][hub]

[microbadger]: https://microbadger.com/images/janeczku/nfs-ganesha
[hub]: https://hub.docker.com/r/janeczku/nfs-ganesha/

Docker image providing [NFS-Ganesha](http://nfs-ganesha.github.io/), a user space NFS v3/v4 fileserver.

## Usage

```bash
$ sudo docker run -d --cap-add SYS_ADMIN --cap-add DAC_READ_SEARCH --name nfs \
 -v /path/to/export:/data/nfs janeczku/nfs-ganesha:latest
```

Mount the NFS export:

```bash
$ mkdir -p /mnt/nfs
$ sudo mount -t nfs4 <server-name>:/ /mnt/nfs`
```

## Environment Variables

##### `EXPORT_PATH`
Default: `/data/nfs`    
The directory to export.

##### `PSEUDO_PATH`
Default: `/`    
NFS4 pseudo path.

##### `EXPORT_ID`
Default: `0`    
An identifier for the export, between 0 and 65535.

##### `PROTOCOLS`
Default: `4`    
The NFS protocols allowed. One or multiple (comma-seperated) of 3, 4, and 9P.

##### `TRANSPORTS`
Default: `UDP, TCP`    
The transport protocols allowed. One or multiple (comma-seperated) of UDP, TCP, and RDMA.

##### `SQUASH_MODE`
Default: `No_Root_Squash`    
What kind of user id squashing is performed. No_Root_Squash, Root_Id_Squash, Root_Squash, All_Squash.

##### `GRACELESS`
Default: `true`    
Whether to disable the NFSv4 grace period.

##### `VERBOSITY`
Default: `NIV_EVENT`    
Logging verbosity. One of NIV_DEBUG, NIV_EVENT, NIV_WARN.
