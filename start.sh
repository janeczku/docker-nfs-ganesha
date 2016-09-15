#!/bin/bash
set -e

# Options for starting Ganesha
: ${GANESHA_LOGFILE:="/dev/stdout"}
: ${GANESHA_CONFIGFILE:="/etc/ganesha/ganesha.conf"}
: ${GANESHA_OPTIONS:="-N NIV_EVENT"} # NIV_DEBUG
: ${GANESHA_EPOCH:=""}
: ${GANESHA_EXPORT:="/export"}

function bootstrap_config {
	echo "Bootstrapping Ganesha NFS config"
    cat <<END >${GANESHA_CONFIGFILE}

EXPORT
{
		# Export Id (mandatory, each EXPORT must have a unique Export_Id)
		Export_Id = 77;
		
		# Exported path (mandatory)
		Path = ${GANESHA_EXPORT};

		# Pseudo Path (for NFS v4)
		Pseudo = ${GANESHA_EXPORT}_nfs4;

		Access_Type = RW;
		Squash = No_Root_Squash;

		#Transports = TCP;
		#Protocols = NFS4;

		SecType = "sys";

		# Exporting FSAL
		FSAL {
			Name = VFS;
		}
}

END
}

function bootstrap_export {
	if [ ! -f ${GANESHA_EXPORT} ]; then
		mkdir -p "${GANESHA_EXPORT}"
    fi
}

function init_rpc {
	echo "Starting rpcbind"
	rpcbind || return 0
	rpc.statd -L || return 0
	rpc.idmapd || return 0
	sleep 1
}

function init_dbus {
	echo "Starting dbus"
	rm -f /var/run/dbus/system_bus_socket
	rm -f /var/run/dbus/pid
	dbus-uuidgen --ensure
	dbus-daemon --system --fork
	sleep 1
}

bootstrap_config
init_rpc
init_dbus

echo "Starting Ganesha NFS"
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/lib
exec /usr/bin/ganesha.nfsd -F -L ${GANESHA_LOGFILE} -f ${GANESHA_CONFIGFILE} ${GANESHA_OPTIONS}