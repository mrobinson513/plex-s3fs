FROM plexinc/pms-docker:latest

RUN apt update && apt -y install s3fs

