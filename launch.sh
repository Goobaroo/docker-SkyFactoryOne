#!/bin/bash

set -x

cd /data

if ! [[ -f SkyFactory_One_Server_1_0_1.zip ]]; then
	rm -fr config defaultconfigs global_data_packs global_resource_packs mods packmenu
	curl -o SkyFactory_One_Server_1_0_1.zip https://media.forgecdn.net/files/3495/89/SkyFactory_One_Server_1_0_1.zip && unzip -u SkyFactory_One_Server_1_0_1.zip -d /data
	echo "eula=true" > eula.txt
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
java $JVM_OPTS -XX:MaxPermSize=256M -jar $SERVER_JAR nogui