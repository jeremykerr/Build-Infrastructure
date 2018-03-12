#!/bin/bash


function install_configuration_linux {
    # ------------------------------------------------------
    # Install repository as an application on the filesystem
    # Return an error code if installation fails
    # ------------------------------------------------------
    echo "installing configuration on linux system";
    
    echo "create configuration directory, if not exists";
    mkdir -p /var/opt/workstation;
    if [ $? != 0 ]; then return 1; fi

    echo "create ssh private key directory, if not exists";
    mkdir -p /var/opt/workstation/ssh.d/private;
    if [ $? != 0 ]; then return 1; fi

    echo "create ssh public key directory, if not exists";
    mkdir -p /var/opt/workstation/ssh.d/public;
    if [ $? != 0 ]; then return 1; fi

    echo "remove application files from system, if they exist";
    mkdir -p /var/opt/workstation/app.d;
    if [ $? != 0 ]; then return 1; fi
    rm -r /var/opt/workstation/app.d;
    if [ $? != 0 ]; then return 1; fi

    echo "remove configuration from system, if it exists";
    mkdir -p /var/opt/workstation/config.d;
    if [ $? != 0 ]; then return 1; fi
    rm -r /var/opt/workstation/config.d;
    if [ $? != 0 ]; then return 1; fi
    
    echo "copy configuration to system";
    cp -R ./filesystem/* /var/opt/workstation;
    if [ $? != 0 ]; then return 1; fi

    return 0;
}

function install_ansible_debian_artful {
    # ----------------------------------------------------------
    # Install latest version of ansible on debian artful (17.10)
    # Return an error code if installation fails
    # ----------------------------------------------------------
    echo "install ansible";
    
    echo "add ansible signing key to pgp keyring";
    add-apt-repository -y ppa:ansible/ansible > /dev/null;
    if [ $? != 0 ]; then return 1; fi
    
    echo "copy ansible apt repository source to filesystem if not exists";
    if [ ! -f "/etc/apt/sources.list.d/ansible-artful.list" ]; then
        cp /var/opt/workstation/settings.d/ansible-artful.list \
            /etc/apt/sources.list.d/;
        if [ $? != 0 ]; then return 1; fi

        echo "update apt repositories";
        apt-get update;
        if [ $? != 0 ]; then return 1; fi
    fi

    echo "remove ansible settings file from system, if exists";
    rm /etc/ansible/ansible.cfg;
    if [ $? != 0 ]; then return 1; fi

    echo "installing ansible using apt";
    apt-get -y install ansible > /dev/null;
    if [ $? != 0 ]; then return 1; fi

    echo "copy ansible settings to system";
    mkdir -p /etc/ansible;
    if [ $? != 0 ]; then return 1; fi
    cp /var/opt/workstation/settings.d/ansible.cfg /etc/ansible/;
    if [ $? != 0 ]; then return 1; fi

    return 0;
}

function main {
    # -----------------------------------------------
    # Run through all required steps, specified above
    # Return an error if any operation fails
    # -----------------------------------------------
    install_configuration_linux;
    if [ $? != 0 ]; then return 1; fi
    
    install_ansible_debian_artful;
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


