#!/bin/bash
set -e 

ip_address=`ifconfig | grep broadcast | sed -e 's/netmask.*//;/^$/d' -e 's/^.*inet/inet/' -e 's/inet //' -e 's/[ \t]*$//'`
echo "System ip address is ${ip_address}"
if [[ $1 == 'one' ]]; then
    agentname=agent-1
    mkdir -p ${agentname}/conf ${agentname}/workdir
    rm -f ${agentname}/conf/*   
    echo "Starting ${agentname}"
    docker run -d -e SERVER_URL="${ip_address}:8111" -e AGENT_NAME="${agentname}" --privileged -e DOCKER_IN_DOCKER=start --name teamcity-${agentname} --network teamcity-net -v /Users/Hamid/work/teamcity/${agentname}/conf:/data/teamcity_agent/conf -v /Users/Hamid/work/teamcity/${agentname}/workdir:/opt/buildagent/work jetbrains/teamcity-agent
    echo "${agentname} has started"
elif [[ $1 == 'all' ]]; then
    for agentname  in agent-1 agent-2 agent-3; do
        mkdir -p ${agentname}/conf ${agentname}/workdir
        rm -f ${agentname}/conf/*
        echo "Starting ${agentname}"
        docker run -d -e SERVER_URL="${ip_address}:8111" -e AGENT_NAME="${agentname}" --privileged -e DOCKER_IN_DOCKER=start --name teamcity-${agentname} --network teamcity-net -v /Users/Hamid/work/teamcity/${agentname}/conf:/data/teamcity_agent/conf -v /Users/Hamid/work/teamcity/${agentname}/workdir:/opt/buildagent/work jetbrains/teamcity-agent
        echo "${agentname} has started"
    done
else
    echo "Run $0 with (one|all]"
fi