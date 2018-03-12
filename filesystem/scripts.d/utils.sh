#!/bin/bash


function run_command_inventory {
    # ---------------------------------------------------------------------------
    # Run the YAML command with all files in the config directory, one at a time,
    # against the inventory specified in the inventory file.
    #   => Parameters: YAML_FILE, INVENTORY, CONFIG_DIR
    # Return an error if any operation fails
    # ---------------------------------------------------------------------------
    local YAML_FILE=$1;
    local INVENTORY=$2;
    local CONFIG_DIR=$3;
    echo "building all from ${CONFIG_DIR} using ${YAML_FILE} on ${INVENTORY}";

    for filename in ${CONFIG_DIR}/*.json; do
        echo "building ${filename} using ${YAML_FILE}";
        ansible-playbook ${YAML_FILE} \
            -i "${INVENTORY}" \
            -e "@${filename}";
        if [ $? != 0 ]; then return 1; fi
    done
    if [ $? != 0 ]; then return 1; fi

    return 0;
}

function run_command_inventory_with_dependencies {
    # ---------------------------------------------------------------------------
    # Run the YAML command with all files in the config directory, one at a time,
    # against the inventory specified in the inventory file.
    #   => Parameters: YAML_FILE, INVENTORY, CONFIG_DIR
    # Return an error if any operation fails
    # ---------------------------------------------------------------------------
    local YAML_FILE=$1;
    local INVENTORY=$2;
    local CONFIG_DIR=$3;
    echo "building all from ${CONFIG_DIR} using ${YAML_FILE} on ${INVENTORY}";

    local DEPENDENCIES="";
    for filename in ${CONFIG_DIR}/dependencies/*.json; do
        echo "adding dependency ${filename}";
        DEPENDENCIES="${DEPENDENCIES} -e @${filename}";
        if [ $? != 0 ]; then return 1; fi
    done
    if [ $? != 0 ]; then return 1; fi

    for filename in ${CONFIG_DIR}/*.json; do
        echo "building ${filename} with dependencies using ${YAML_FILE}";
        ansible-playbook ${YAML_FILE} \
            -i "${INVENTORY}" \
            -e "@${filename}" \
            ${DEPENDENCIES};
        if [ $? != 0 ]; then return 1; fi
    done
    if [ $? != 0 ]; then return 1; fi

    return 0;
}

function main {
    # -----------------------------
    # No action needed, placeholder
    # This is just a library script
    # Return 0, no error will occur
    # -----------------------------
    return 0;
}


if [ "${1}" != "--no-execute" ]; then
    # --------------------------------------------------
    # Run main function, unless this script was imported 
    # into another script with the "no execute" flag
    # This script should be run with "sudo"
    # --------------------------------------------------
    main "${@}";
fi

