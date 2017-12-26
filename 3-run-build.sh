#!/bin/bash


# -----------------------------
# Import all required functions
# -----------------------------
source "0-utils.sh" --no-execute;


function install_apt_repositories {
    # -------------------------------------------
    # Build all workstation dependency components
    # Return an error code if any operation fails
    # -------------------------------------------
    echo "installing apt repositories";
    run_command_inventory \
        ./app/apt.yml \
        ./inventory/local \
        /var/opt/workstation/config.d/apt;
    if [ $? != 0 ]; then return 1; fi

    return 0;
}

function install_pip_packages {
    # -------------------------------------------
    # Build all workstation dependency components
    # Return an error code if any operation fails
    # -------------------------------------------
    echo "installing pip packages";
    run_command_inventory \
        ./app/pip.yml \
        ./inventory/local \
        /var/opt/workstation/config.d/pip;
    if [ $? != 0 ]; then return 1; fi

    return 0;
}

function copy_system_settings {
    # ----------------------------------------------
    # Create any necessary system settings and files
    # Return an error code if any operation fails
    # ----------------------------------------------
    echo "copying system files";
    run_command_inventory \
        ./app/copy_file.yml \
        ./inventory/local \
        /var/opt/workstation/config.d/copy_file;
    if [ $? != 0 ]; then return 1; fi

    echo "copying system settings";
    run_command_inventory \
        ./app/replace.yml \
        ./inventory/local \
        /var/opt/workstation/config.d/replace;
    if [ $? != 0 ]; then return 1; fi

    return 0;
}

function run_system_commands {
    # -------------------------------------------
    # Build all workstation dependency components
    # Return an error code if any operation fails
    # -------------------------------------------
    echo "running system commands";
    run_command_inventory \
        ./app/command.yml \
        ./inventory/local \
        /var/opt/workstation/config.d/command;
    if [ $? != 0 ]; then return 1; fi

    return 0;
}

function config_all {
    # -----------------------------------------------
    # Run through all required steps, specified above
    # Return an error if any operation fails
    # -----------------------------------------------
    install_apt_repositories;
    if [ $? != 0 ]; then return 1; fi
    
    install_pip_packages;
    if [ $? != 0 ]; then return 1; fi
    
    copy_system_settings;
    if [ $? != 0 ]; then return 1; fi
    
    run_system_commands;
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


