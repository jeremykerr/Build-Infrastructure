#!/bin/bash


function build_workstation {
    # ------------------------------------------------------
    # Install infrastructure used for Ansible administration
    # Return an error code if any operation fails
    # ------------------------------------------------------
    echo "Building Workstation"
    ansible-playbook Configuration/Build-Workstation.yml
    if [ $? != 0 ]; then return 1; fi

    return 0
}

function main {
    # -----------------------------------------------
    # Run through all required steps, specified above
    # Return an error if any operation fails
    # -----------------------------------------------
    build_workstation
    if [ $? != 0 ]; then return 1; fi

    return 0
}

if [ "${1}" != "--no-execute" ]; then
    # --------------------------------------------------
    # Run main function, unless this script was imported 
    # into another script with the "no execute" flag
    # This script should be run with "sudo"
    # --------------------------------------------------
    main "${@}"
fi


