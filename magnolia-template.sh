#!/bin/bash

echo "Loading Config File"

# Get config path
source ./magnolia-template.config

echo "Validating Template and Dialog Directories"
sleep 1
if [ -d "$template_dir" ] ; then
    echo "Template Directory found!"
fi

if [ -d "$dialog_dir" ] ; then
    echo "Dialog Directory found!"
fi

sleep 1
echo "Dialog Directory: $dialog_dir"
echo "Template Directory: $template_dir"

sleep 1
echo "All right, let's go!"
echo "Enter the name of the component"
read DIALOG_LABEL
export DIALOG_LABEL

#Create and Update Dialog. 
touch index.yaml
yq -i '.label = strenv(DIALOG_LABEL)' index.yaml
cat index.yaml
#Create and update template yaml ---------------------------
instructionArray=(".title=strenv(DIALOG_LABEL)" ".templateScript=strenv(TEMPLATE_PATH)" ".renderType=strenv(TEMPLATE_TYPE)")
TEMPLATE_PATH="/sanofi-lm-dupixent/templates/components/dtc/$DIALOG_LABEL/$DIALOG_LABEL.ftl"
DIALOG_PATH="sanofi-lm-dupixent:components/dtc/$DIALOG_LABEL/$DIALOG_LABEL"
TEMPLATE_TYPE="freemarker"
export TEMPLATE_PATH
export DIALOG_PATH
export TEMPLATE_TYPE
touch indexTemp.yaml
for inst in ${instructionArray[@]}; do
    echo $inst
    yq -i $inst indexTemp.yaml
done

#Make an ftl
cat > temp.ftl << EOF
<h1>Hello World!</h1>
EOF

template_dir_dtc=$template_dir"/components/dtc"
dialog_dir_dtc=$dialog_dir"/components/dtc"
#bundle template and dialog and put it in the right spot
mkdir $DIALOG_LABEL
mv temp.ftl $DIALOG_LABEL/$DIALOG_LABEL.ftl
mv indexTemp.yaml $DIALOG_LABEL/$DIALOG_LABEL.yaml
mv $DIALOG_LABEL $template_dir_dtc/$DIALOG_LABEL
#move Dialog
mkdir $DIALOG_LABEL
cat index.yaml
mv index.yaml $DIALOG_LABEL/$DIALOG_LABEL.yaml
mv $DIALOG_LABEL $dialog_dir_dtc/$DIALOG_LABEL

echo "All Done!"

echo "NOTE: Dialog fileis made but NOT LINKED (I'm working on it), to link add this to your template yaml"
echo "dialog:sanofi-lm-dupixent:components/dtc/$DIALOG_LABEL/$DIALOG_LABEL"
echo ""
sleep 1
echo "put this where the you want your component and it should work ....hopefully"
echo "sanofi-lm-dupixent:components/dtc/$DIALOG_LABEL/$DIALOG_LABEL"
