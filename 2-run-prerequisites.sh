#!/bin/bash


# -----------------------------
# Import all required functions
# -----------------------------
source "0-utils.sh" --no-execute;


function config_users {
    # ----------------------------------------------
    # Build all workstation dependency components
    # Return an error code if any operation fails
    # ----------------------------------------------
    echo "establishing system users";
    run_command_inventory \
        ./app/user.yml \
        ./inventory/local \
        /var/opt/workstation/config.d/user;
    if [ $? != 0 ]; then return 1; fi

    run_command_inventory \
        ./app/user_append_groups.yml \
        ./inventory/local \
        /var/opt/workstation/config.d/user_append_groups;
    if [ $? != 0 ]; then return 1; fi

    return 0;
}

function config_apt_repos {
    # ----------------------------------------------
    # Build all workstation dependency components
    # Return an error code if any operation fails
    # ----------------------------------------------
    echo "configuring apt dependencies";
    run_command_inventory \
        ./app/apt_key_url.yml \
        ./inventory/local \
        /var/opt/workstation/config.d/apt_key_url;
    if [ $? != 0 ]; then return 1; fi

    run_command_inventory \
        ./app/apt_key_id.yml \
        ./inventory/local \
        /var/opt/workstation/config.d/apt_key_id;
    if [ $? != 0 ]; then return 1; fi

    run_command_inventory \
        ./app/lineinfile_apt_repos.yml \
        ./inventory/local \
        /var/opt/workstation/config.d/lineinfile_apt_repos;
    if [ $? != 0 ]; then return 1; fi

    run_command_inventory \
        ./app/apt_update.yml \
        ./inventory/local \
        /var/opt/workstation/config.d/apt_update;
    if [ $? != 0 ]; then return 1; fi

    return 0;
}

function config_all {
    # -----------------------------------------------
    # Run through all required steps, specified above
    # Return an error if any operation fails
    # -----------------------------------------------
    config_users;
    if [ $? != 0 ]; then return 1; fi

    config_apt_repos;
    if [ $? != 0 ]; then return 1; fi
    
    return 0;
}

function main {
    # ---------------------------------------------------------------------
    # Build all required workstation, without doing any unnecessary work
    # Return an error if any operation fails
    # ---------------------------------------------------------------------
    config_all;
    if [ $? != 0 ]; then return 1; fi
    
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


