#!/bin/bash

YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# VARIABLES STANDAR
ENV=XXXXXX #THIS WORK FINE IF WE USE SAM IN LOCAL. IN PIPELINE IS NOT NEED
BUCKET=XXXXXX #BUCKET IS REQUIRED FOR SAM PACKAGE

STACK=XXXXXX-bakend-$ENV #NAME OF STACK, IS IMPORTANT FOR THE NAME OF ALL OBJECTS IN TEMPLATE
PROJECT=XXXXXX #PROJECT NAME FOR THE TAGS
CLIENTID='XXXXXX.apps.googleusercontent.com' #WE CAN FIND THIS IN GOOGLE CONSOLE
CLIENT_SECRET='XXXXX' #WE CAN FIND THIS IN GOOGLE CONSOLE
POOL_DOMAIN="XXXXXX" #THE NAME OF THE DOMAIN FOR OUR POOL.
CALLBACKURL='http://localhost:4200/auth' #CHANGE "localhost:4200" IF YOU ARE IN PRODUCTION. SET TE FINAL DOMAIN
LOGOUTURL='http://localhost:4200/logout'#CHANGE "localhost:4200" IF YOU ARE IN PRODUCTION. SET TE FINAL DOMAIN

echo "${YELLOW} Validating local SAM Template..."
echo " ================================${NC}"
sam validate --template "template.yaml"

echo "${YELLOW} Building local SAM App..."
echo " =========================${NC}"
sam build -t "template.yaml"

echo "${YELLOW} Package"
echo " ================================================= ${NC}"
sam package --template-file ./template.yaml --output-template-file packaged-template.yaml --s3-bucket $BUCKET

echo "${YELLOW} Deploy"
echo " ================================================= ${NC}"
sam deploy --template-file packaged-template.yaml --stack-name $STACK --tags Project=$PROJECT --parameter-overrides clientId=$CLIENTID clientSecret=$CLIENT_SECRET poolDomain=$POOL_DOMAIN callbackUrl=$CALLBACKURL logoutUrl=$LOGOUTURL --capabilities CAPABILITY_NAMED_IAM

