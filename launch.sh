#!/bin/bash

set -x

cd /data

if ! [[ "$EULA" = "false" ]] || grep -i true eula.txt; then
	echo "eula=true" > eula.txt
else
	echo "You must accept the EULA by in the container settings."
	exit 9
fi

if ! [[ -f SkyFactory_One_Server_1_0_3.zip ]]; then
	rm -fr config defaultconfigs global_data_packs global_resource_packs mods packmenu
	curl -o SkyFactory_One_Server_1_0_3.zip https://media.forgecdn.net/files/3543/511/SkyFactory_One_Server_1_0_3.zip && unzip -u SkyFactory_One_Server_1_0_3.zip -d /data
	chmod +x Install.sh
	./Install.sh
fi

if [[ -n "$MOTD" ]]; then
    sed -i "/motd\s*=/ c motd=$MOTD" /data/server.properties
fi
if [[ -n "$LEVEL" ]]; then
    sed -i "/level-name\s*=/ c level-name=$LEVEL" /data/server.properties
fi

if [[ -n "$OPS" ]]; then
    echo $OPS | awk -v RS=, '{print}' >> ops.txt
fi

. ./settings.sh
curl -o log4j2_112-116.xml https://launcher.mojang.com/v1/objects/02937d122c86ce73319ef9975b58896fc1b491d1/log4j2_112-116.xml
java $JVM_OPTS -XX:MaxPermSize=256M -Dlog4j.configurationFile=log4j2_112-116.xml -jar $SERVER_JAR nogui