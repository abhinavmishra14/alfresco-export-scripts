#!/bin/bash

###
### Script for getting Alfresco Groups via REST API /service/api/groups 
###

# Usage functions
usage() { echo "Usage: $0 [-f]" 1>&2; exit 1; }

# Command line options
while getopts "fu:p:he:s:" o; do
    case "${o}" in
        f)
            FULL=1
            ;;
        u)
            MYUSER=${OPTARG}
            ;;
        p)
            MYPASS=${OPTARG}
            ;;
        e)
            ALFURL=${OPTARG}
            ;;
        s)
            SITE=${OPTARG}
            ;;
        \?)
            echo "Invalid Option: -$OPTARG" 1>&2
            exit 1
            ;;
        h)
            usage 
            ;;
#        *)
#            usage
#            ;;
    esac
done
shift $((OPTIND-1))

# Exports ALFALFURL,MYUSER,MYPASS 
source ./exportENVARS.sh

# Needs at least ALFURL as parameter 
if [ -z "${ALFURL}" ] || [ -z "${MYUSER}" ] || [ -z "${MYPASS}" ]; then
    usage
fi

# Default parameters
#ALFURL=${ALFURL:-http://localhost:8080/alfresco}
#MYUSER=${MYUSER:-admin}
#MYPASS=${MYPASS:-admin}
FULL=${FULL:-0}

# Full/Brief report
# PS: Needs jq and jsonv
if [ "${FULL}" == "1" ]; then 
  curl -s -u $MYUSER:$MYPASS "$ALFURL/service/api/groups" | jq '.data[] | "\(.shortName),\(.fullName),\(.displayName)"' | sed -e 's#\"##g' | sed -e 's#\\##g'
else
  curl -s -u $MYUSER:$MYPASS "$ALFURL/service/api/groups" | jq '.data[] .shortName' | sed -e 's#\"##g' | sed -e 's#\\##g'
fi
