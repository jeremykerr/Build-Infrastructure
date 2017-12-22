#!/bin/bash


# -----------------------------
# Import all required functions
# -----------------------------
source "0-utils.sh" --no-execute;


function install_apt_packages {
    # ----------------------------------------------
    # Build all workstation dependency components
    # Return an error code if any operation fails
    # ----------------------------------------------
    echo "installing apt repositories";
    run_command_inventory \
        ./app/apt.yml \
        ./inventory/local \
        /var/opt/workstation/config.d/apt;
    if [ $? != 0 ]; then return 1; fi

    return 0;
}

function config_all {
    # -----------------------------------------------
    # Run through all required steps, specified above
    # Return an error if any operation fails
    # -----------------------------------------------
    install_apt_packages;
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


