#!/bin/bash

git() 
{
    if [[ ! -z "$NAME" && ! -z "$USERNAME" && ! -z "$USERNAME" && ! -z "$PASSWORD" && ! -z "$REPO_URL" ]]; then
        aws secretsmanager create-secret \
            --name "$MASTER_PREFIX/git/$NAME" --region $REGION \
            --description "git-user secret created with the CLI." \
            --secret-string "{\"username\":\"$USERNAME\",\"password\":\"$PASSWORD\", \"repository\":\"$REPO_URL\"}"
    fi
}

helm() 
{
    if [[ ! -z "$NAME" && ! -z "$USERNAME" && ! -z "$PASSWORD" && ! -z "$REPO_URL" ]]; then
        aws secretsmanager create-secret \
            --name "$MASTER_PREFIX/helm/$NAME" --region $REGION \
            --description "helm-repo secret created with the CLI." \
            --secret-string "{\"username\":\"$USERNAME\",\"password\":\"$PASSWORD\", \"repository\":\"$REPO_URL\"}"
    fi
}

registry() 
{
    if [[ ! -z "$NAME" && ! -z "$USERNAME" && ! -z "$PASSWORD" && ! -z "$REGISTRY" ]]; then
        aws secretsmanager create-secret \
            --name "$MASTER_PREFIX/registry/$NAME" --region $REGION \
            --description "registry-user secret created with the CLI." \
            --secret-string "{\"username\":\"$USERNAME\",\"password\":\"$PASSWORD\", \"registry\":\"$REGISTRY\"}"
    fi
}

ldap() 
{
    if [[ ! -z "$NAME" && ! -z "$BIND_DN" && ! -z "$BIND_PW" ]]; then
        aws secretsmanager create-secret \
            --name "$MASTER_PREFIX/ldap/$NAME" --region $REGION \
            --description "ldap-config secret created with the CLI." \
            --secret-string "{\"bindDN\":\"$BIND_DN\",\"bindPW\":\"$BIND_PW\"}"
    fi
}

database() 
{
    if [[ ! -z "$NAME" && ! -z "$USERNAME" && ! -z "$PASSWORD" ]]; then
        aws secretsmanager create-secret \
            --name "$MASTER_PREFIX/database/$NAME" --region $REGION \
            --description "database-config secret created with the CLI." \
            --secret-string "{\"username\":\"$USERNAME\",\"password\":\"$PASSWORD\"}"
    fi
}


help()
{
    cat <<EOF
Decription:
    Create secrets on AWS secret manager to use in modules terraform.

Synosis:
    eks-secret-oc.sh -p PREFIX [-r <REGION>]
 
Options:
    -p PREFIX      Specify a prefix for secret.
    -r REGION      Specify a aws region. Default ap-southeast-1.
    -h HELP        Print this Help.
EOF
}

## MAIN ##

###########################################################
#Process the input options. Add options as needed.        #
###########################################################
# Get the options
REGION="ap-southeast-1"
while getopts ":hr:p:" option; do
   case $option in
        h) # display Help
            help
            exit;;
        p) # Enter a name
            MASTER_PREFIX=$OPTARG;;
        r) # Enter a name
            REGION=$OPTARG;;
        \?) # Invalid option
            echo "ERROR: INVALID OPTION"
            exit;;
   esac
done
echo $MASTER_PREFIX
echo $REGION
exit
if [ ! -z "$MASTER_PREFIX" ]; then
    OPTIONS=("GIT" "HELM" "REGISTY" "LDAP" "DATABASE" "QUIT")
    select opt in "${OPTIONS[@]}"
    do
        case $opt in
            "GIT")
                echo "FUNCTION CREATE SECRET FOR GIT"
                read -p 'SECRET NAME: ' NAME
                read -p 'USERNAME: ' USERNAME
                read -sp 'PASSWORD: ' PASSWORD
                echo ""
                read -p 'REPO URL: ' REPO_URL
                git;
                # break
                ;;
            "HELM")
                echo "FUNCTION CREATE SECRET FOR HELM"
                read -p 'SECRET NAME: ' NAME
                read -p 'USERNAME: ' USERNAME
                read -sp 'PASSWORD: ' PASSWORD
                echo ""
                read -p 'REPO URL: ' REPO_URL
                helm;
                # break
                ;;
            "REGISTY")
                echo "FUNCTION CREATE SECRET FOR REGISTY"
                read -p 'SECRET NAME: ' NAME
                read -p 'USERNAME: ' USERNAME
                read -sp 'PASSWORD: ' PASSWORD
                echo ""
                read -p 'REGISTRY URL: ' REGISTRY
                registry;
                # break
                ;;
            "LDAP")
                echo "FUNCTION CREATE SECRET FOR LDAP"
                read -p 'SECRET NAME: ' NAME
                read -p 'LDAP USERNAME: ' BIND_DN
                read -sp 'LDAP PASSWORD: ' BIND_PW
                ldap;
                # break
                ;;
            "DATABASE")
                echo "FUNCTION CREATE SECRET FOR DATABASE"
                read -p 'SECRET NAME: ' NAME
                read -p 'USERNAME: ' USERNAME
                read -sp 'PASSWORD: ' PASSWORD
                database;
                # break
                ;;
            "QUIT")
                break
                ;;
            *) echo "INVALID OPTION $REPLY";;
        esac
    done
else
    echo "MASTER PREFIX IS REQUIRED"
fi
