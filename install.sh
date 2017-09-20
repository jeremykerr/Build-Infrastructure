#!/bin/bash


function installAnsible {
    # -----------------------------------------------------------------------
    # Ensure the latest version of Ansible is installed on the current system
    # Return an error code if installation fails
    # -----------------------------------------------------------------------
    echo "Installing Ansible"
    apt-get install ansible
    if [ $? != 0 ]; then return 1; fi

    return 0
}

function setFacts {
    # -----------------------------------------------
    # Make sure that any relevant facts have been set
    # Return an error code if copy operation fails
    # -----------------------------------------------
    echo "Setting Ansible Facts"
    cp -r ./Settings/facts.d /etc/ansible/
    if [ $? != 0 ]; then return 1; fi

    return 0
}

function setHosts {
    # -----------------------------------------------
    # Make sure that any relevant hosts have been set
    # Return an error code if copy operation fails
    # -----------------------------------------------
    echo "Setting Ansible Hosts"
    cp -r ./Settings/hosts.d /etc/ansible/
    if [ $? != 0 ]; then return 1; fi

    return 0
}

function setModules {
    # ------------------------------------------------------
    # Make sure that any relevant modules have been included
    # Return an error code if copy operation fails
    # ------------------------------------------------------
    echo "Setting Ansible modules"
    cp -r ./Settings/modules.d /etc/ansible/
    if [ $? != 0 ]; then return 1; fi

    return 0
}

function setConfiguration {
    # -------------------------------------------------------------------
    # Use the correct Ansible configuration specified from the repository
    # Return an error code if the copy operation fails
    # -------------------------------------------------------------------
    echo "Setting Ansible configuration"
    cp ./Settings/ansible.cfg /etc/ansible/
    if [ $? != 0 ]; then return 1; fi

    return 0
}

function main {
    # -----------------------------------------------
    # Run through all required steps, specified above
    # Return an error if any operation fails
    # -----------------------------------------------
    installAnsible
    if [ $? != 0 ]; then return 1; fi
    
    setFacts
    if [ $? != 0 ]; then return 1; fi
    
    setHosts
    if [ $? != 0 ]; then return 1; fi
    
    #setModules
    #if [ $? != 0 ]; then return 1; fi
    
    setConfiguration
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


