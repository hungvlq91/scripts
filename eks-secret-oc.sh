#!/bin/bash

git() 
{
    if [[ ! -z "$NAME" && ! -z "$USERNAME" && ! -z "$USERNAME" && ! -z "$PASSWORD" && ! -z "$REPO_URL" ]]; then
        aws secretsmanager create-secret \
            --name "$MASTER_PREFIX/$NAME" \
            --description "git-user secret created with the CLI." \
            --secret-string "{\"username\":\"$USERNAME\",\"password\":\"$PASSWORD\", \"repository\":\"$REPO_URL\"}"
    fi
}

helm() 
{
    if [[ ! -z "$NAME" && ! -z "$USERNAME" && ! -z "$PASSWORD" && ! -z "$REPO_URL" ]]; then
        aws secretsmanager create-secret \
            --name "$MASTER_PREFIX/$NAME" \
            --description "helm-repo secret created with the CLI." \
            --secret-string "{\"username\":\"$USERNAME\",\"password\":\"$PASSWORD\", \"repository\":\"$REPO_URL\"}"
    fi
}

registry() 
{
    if [[ ! -z "$NAME" && ! -z "$USERNAME" && ! -z "$PASSWORD" && ! -z "$REGISTRY" ]]; then
        aws secretsmanager create-secret \
            --name "$MASTER_PREFIX/$NAME" \
            --description "registry-user secret created with the CLI." \
            --secret-string "{\"username\":\"$USERNAME\",\"password\":\"$PASSWORD\", \"registry\":\"$REGISTRY\"}"
    fi
}

ldap() 
{
    if [[ ! -z "$NAME" && ! -z "$BIND_DN" && ! -z "$BIND_PW" ]]; then
        aws secretsmanager create-secret \
            --name "$MASTER_PREFIX/$NAME" \
            --description "ldap-config secret created with the CLI." \
            --secret-string "{\"bindDN\":\"$BIND_DN\",\"bindPW\":\"$BIND_PW\"}"
    fi
}

database() 
{
    if [[ ! -z "$NAME" && ! -z "$USERNAME" && ! -z "$PASSWORD" ]]; then
        aws secretsmanager create-secret \
            --name "$MASTER_PREFIX/$NAME" \
            --description "database-config secret created with the CLI." \
            --secret-string "{\"username\":\"$USERNAME\",\"password\":\"$PASSWORD\"}"
    fi
}

help()
{
   # Display Help
   echo "Add description of the script functions here."
   echo
   echo "Syntax: scriptTemplate [-p|h|r]"
   echo "options:"
   echo "p     Master prefix for secret"
   echo "h     Print this Help."
   echo "r     Specify a aws region"
   echo
}

## MAIN ##

############################################################
# Process the input options. Add options as needed.        #
############################################################
# Get the options
while getopts ":hnr:" option; do
   case $option in
      h) # display Help
         help
         exit;;
      n) # Enter a name
         Name=$OPTARG;;
     \?) # Invalid option
         echo "Error: Invalid option"
         exit;;
   esac
done

MASTER_PREFIX=$1
if [ ! -z "$MASTER_PREFIX" ]; then
    OPTIONS=("GIT" "HELM" "REGISTY" "LDAP" "DATABASE" "QUIT")
    select opt in "${OPTIONS[@]}"
    do
        case $opt in
            "GIT")
                echo "FUNCTION CREATE SECRET FOR GIT"
                read -p 'Username: ' USERNAME
                read -sp 'Password: ' PASSWORD
                read -p 'Repo URL: ' REPO_URL
                git;
                # break
                ;;
            "HELM")
                echo "FUNCTION CREATE SECRET FOR HELM"
                read -p 'Username: ' USERNAME
                read -sp 'Password: ' PASSWORD
                read -p 'Repo URL: ' REPO_URL
                helm;
                # break
                ;;
            "REGISTY")
                echo "FUNCTION CREATE SECRET FOR REGISTY"
                read -p 'Username: ' USERNAME
                read -sp 'Password: ' PASSWORD
                read -p 'Registry URL: ' REGISTRY
                registry;
                # break
                ;;
            "LDAP")
                echo "FUNCTION CREATE SECRET FOR LDAP"
                read -p 'Username: ' BIND_DN
                read -sp 'Password: ' BIND_PW
                ldap;
                # break
                ;;
            "DATABASE")
                echo "FUNCTION CREATE SECRET FOR DATABASE"
                read -p 'Username: ' USERNAME
                read -sp 'Password: ' PASSWORD
                ldap;
                # break
                ;;
            "QUIT")
                break
                ;;
            *) echo "invalid option $REPLY";;
        esac
    done
else
echo "MASTER PREFIX IS REQUIRED"
fi
