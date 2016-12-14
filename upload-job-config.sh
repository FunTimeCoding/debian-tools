#!/bin/sh -e

~/Code/Personal/jenkins-tools/bin/delete-job.sh debian-tools || true
~/Code/Personal/jenkins-tools/bin/put-job.sh debian-tools job.xml
