#!/bin/bash


function install_ansible_debian {
    # -----------------------------------------------------------------------
    # Ensure the latest version of Ansible is installed on the current system
    # Return an error code if installation fails
    # -----------------------------------------------------------------------
    echo "installing ansible";
    apt-get install ansible;
    if [ $? != 0 ]; then return 1; fi

    return 0;
}

function copy_host_files {
    # --------------------------------------------------------------------------------
    # Ensure files that need to be copied to hosts are available in a neutral location
    # Return an error code if any operation fails
    # --------------------------------------------------------------------------------
    echo "creating filesystem directory for workstation files"
    mkdir -p /var/opt/workstation
    if [ $? != 0 ]; then return 1; fi

    echo "copying files for config to filesystem"
    cp -r ./filesystem/config.d /var/opt/workstation/
    if [ $? != 0 ]; then return 1; fi

    echo "copying files for hosts to filesystem"
    cp -r ./filesystem/hosts.d /var/opt/workstation/
    if [ $? != 0 ]; then return 1; fi

    echo "copying ansible configuration to host"
    cp ./settings/ansible.cfg /etc/ansible/
    if [ $? != 0 ]; then return 1; fi

    return 0;
}

function main {
    # -----------------------------------------------
    # Run through all required steps, specified above
    # Return an error if any operation fails
    # -----------------------------------------------
    install_ansible_debian;
    if [ $? != 0 ]; then return 1; fi

    copy_host_files;
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


