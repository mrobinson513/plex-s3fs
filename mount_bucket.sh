#!/bin/bash

# Run script as init container

echo "${PLEX_S3_ACCESS_KEY}:${PLEX_S3_SECRET_KEY}" > "/etc/passwd-s3fs"

if ! [ -d "/mnt/${PLEX_S3_BUCKET}" ]; then
		mkdir -p "/mnt/${PLEX_S3_BUCKET}"
	fi

	# Make the Amazon AWS S3 Bucket mount on boot.
	payload="s3fs#${PLEX_S3_BUCKET} /mnt/${PLEX_S3_BUCKET} fuse _netdev,rw,nosuid,nodev,allow_other,nonempty 0 0"
	grep -Fq "${payload}" /etc/fstab || {
		echo "${payload}" >> /etc/fstab
	}
	
	# Mount the S3 Bucket
	mount -a
