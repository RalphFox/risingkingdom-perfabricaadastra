#!/bin/bash
#Minecraft update script by RalphFox
NC='\033[0m'
RED='\033[0;31m'
CYAN='\033[0;36m'
YELLOW='\033[0;33m'
LGREEN='\033[1;32m'

printf "\n${CYAN}=====Server Update ${YELLOW}0.1 beta${CYAN}.=====\n${NC}"
printf "${RED}ATTENTION! This script does not check if the server is stopped nor starts it.\n"
# TODO:Find a way to stop the minecraft server through amp from the command line, send messages, start server
# TODO:Find a way to publish to discord server when update is complete or not
# TODO:Delete oldest backup
DATE=`date '+%Y-%m-%d_%H-%M-%S'`

printf "${CYAN}===Updating github..===\n${NC}"
git pull

VERSION=$(< version)
if [ -e ../version ]
then
  CURRENTVERSION=$(< ../version)
else
  CURRENTVERSION=""
fi
if [ "$VERSION" = "$CURRENTVERSION" ]
then
  printf "${LGREEN}==Version looks the same. Aborting update process.==\n${NC}"
  exit
else
  printf "${CYAN}==Current version [${CURRENTVERSION}] differs from local version [${VERSION}]. Initializing update..==\n${NC}"
fi

printf "${CYAN}===Backup of minecraft folder in progress..===\n${NC}"
if env GZIP=-9 tar -cvzf Minecraft_${DATE}_before_${CURRENTVERSION}.tar.gz ../Minecraft --exclude "../Minecraft/backups"
then
  printf "${LGREEN}===Backup successfully finished.===\n${NC}"
else
  printf "${RED}===Failure in backup. Aborting update process.===\n${NC}"
  exit
fi

printf "${CYAN}===Starting mods folder removal.===\n${NC}"
rm -rf "../Minecraft/mods"
printf "${CYAN}===installing mods, scripts, configs.===\n${NC}"
cp -r mods config scripts "../Minecraft"