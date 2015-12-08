# JBoss-EAP6-patch-01477141
Patch for JBoss EAP issue 01477141 - JSF 2.1 API is missing 3 methods in ExternalContextWrapper

## Usage

Options are not optional and must exactly follow this format: `--optionname=value`. The `=` must be present when there is a value. There are no short forms for the option names.

In the following sections, substitute `patch-gen` for `java -jar patch-gen-*-shaded.jar`, or set up an alias with


### Step 1. Setup directories
    cd /java/jboss/redhat-eap-6.4/EBS-patch/JBoss-EAP6-patch-01477141

    export PROJECT_DIR=`pwd -P`
    export JBOSS_EAP_ROOT=/java/jboss/redhat-eap-6.4
    export JBOSS_EAP_UNPATCHED_DIR=$JBOSS_EAP_ROOT/jboss-eap-6.4
    export JBOSS_EAP_PATCHED_DIR=$JBOSS_EAP_ROOT/jboss-eap-6.4-patched


### Step 2. Build clean EAP 6.4.5 installation
    mkdir -p $JBOSS_EAP_ROOT
    cd $JBOSS_EAP_ROOT

    unzip $JBOSS_EAP_ROOT/download/jboss-eap-6.4.0.zip
    cd $JBOSS_EAP_UNPATCHED_DIR

    bin/add-user.sh --silent --user jbossadmin --password jboss@min1 --realm ManagementRealm
    bin/standalone.sh
    bin/jboss-cli.sh --user=jbossadmin --password=jboss@min1 --connect

    patch apply $JBOSS_EAP_ROOT/download/jboss-eap-6.4.5-patch.zip
    patch info
    exit


### Step 3. Build patched EAP 6.4.5 installation

    cd $JBOSS_EAP_ROOT

    # cleanup
    find . -name \.DS_Store -execdir rm {} \;
    rm -rf $JBOSS_EAP_PATCHED_DIR

    mkdir -p $JBOSS_EAP_PATCHED_DIR
    cp -R $JBOSS_EAP_UNPATCHED_DIR/* $JBOSS_EAP_PATCHED_DIR

    rm $JBOSS_EAP_PATCHED_DIR/modules/system/layers/base/javax/faces/api/main/jboss-jsf-api_2.1_spec-2.1.28.Final-redhat-1.jar
    cp $PROJECT_DIR/EBS-01477141/EBS01477141/modules/javax/faces/api/main/* \
             $JBOSS_EAP_PATCHED_DIR/modules/system/layers/base/javax/faces/api/main


#### Step 4. Create patch to be applied cleanly on EAP 6.4.5 installations

    $PROJECT_DIR/create-patch.sh

    # >>> Prepared EBS-01477141-v2.patch.zip at /java/jboss/redhat-eap-6.4/EBS-patch/JBoss-EAP6-patch-01477141/target/EBS-01477141-v2.patch.zip


#### Step 5. Apply patch on all EAP 6.4.5 installations

    cd $JBOSS_EAP_UNPATCHED_DIR
    bin/standalone.sh
    bin/jboss-cli.sh --user=jbossadmin --password=jboss@min1 --connect

    patch apply /java/jboss/redhat-eap-6.4/EBS-patch/JBoss-EAP6-patch-01477141/target/EBS-01477141-v2.patch.zip --override-all
    patch info
