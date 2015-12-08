#!/bin/bash
set -e

echo "################################################################"
echo "Creating patch for JSF issue 01477141"
echo "################################################################"

if [ -z "$JBOSS_EAP_UNPATCHED_DIR" ]; then
    echo "Need to set JBOSS_EAP_UNPATCHED_DIR"
    exit 1
fi
if [ -z "$JBOSS_EAP_PATCHED_DIR" ]; then
    echo "Need to set JBOSS_EAP_PATCHED_DIR"
    exit 1
fi

pushd `dirname $0` > /dev/null
SCRIPTPATH=`pwd -P`
popd > /dev/null

alias patch-gen='java -jar $SCRIPTPATH/dist/patch-gen-1.0.0.Alpha1-SNAPSHOT-shaded.jar'

java -jar $SCRIPTPATH/dist/patch-gen-1.0.0.Alpha1-SNAPSHOT-shaded.jar \
            --applies-to-dist=$JBOSS_EAP_UNPATCHED_DIR \
            --updated-dist=$JBOSS_EAP_PATCHED_DIR \
            --patch-config=$SCRIPTPATH/EBS-01477141/conf/patch-config-EBS-01477141-v2.xml \
            --output-file=$SCRIPTPATH/target/EBS-01477141-v2.patch.zip

