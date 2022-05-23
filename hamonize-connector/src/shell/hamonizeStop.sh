#!/bin/bash



Init-HamonizeProgram() {

    # sudo apt-get install libfuse-dev -y >> $LOGFILE

    # Ldap Install && Connection -----------------#
    retval=$(ldapSettings)
    echo "===========================+"+ $retval
    if [ "$retval" == 0 ]; then
        echo >&1 "Y"
        # echo >&1 "Hamonize Ldap Settings Install-Y" >> $LOGFILE
    else
        echo >&2 "1942-LDAP"

        exit 0
    fi

    sleep 2

    #==== Hamonie-Usb protect -----------------#
    retval=$(deviceSettings)
    if [ "$retval" == 0 ]; then
        echo >&1 "Y"
    else
        echo >&2 "1942USB"

        

        exit 0
    fi
    sleep 2

    #==== Hamonie-Agent Install -----------------#
    retval=$(agentSettings)
    if [ "$retval" == 0 ]; then
        echo >&1 "Y"
    else
        echo >&2 "1942-AGENT"

      

        exit 0
    fi
    sleep 2

    #==== user loginout -----------------#
    retval=$(osLoginoutSettings)
    if [ "$retval" == 0 ]; then
        echo >&1 "Y"
        # echo >&1 "Hamonize osLoginout Service Install-Y :: "
    else
        echo >&2 "1942-OSLOGINOUT"



        exit 0
    fi
    sleep 2

    #==== timeshift Install -----------------#
    retval=$(timeshiftSettings)
    if [ "$retval" == 0 ]; then
        echo >&1 "Y"
        # echo >&1 "timeshiftSettings :: "
    else
        echo >&2 "1942-TIMESHIFT"


        exit 0
    fi
    sleep 2

    #==== telegraf Install -----------------#
    telegrafSettings
    retval=$?

    if [ "$retval" == 0 ]; then
        echo >&1 "Y"
        # echo >&1 "telegrafSettings :: "
    else
        echo >&2 "$retval---1942-TELEGRAF"

      
        exit 0
    fi
    sleep 2

    #==== Hamonize-admin Install -----------------#
    remoteToolSettings
    retval=$?

    if [ "$retval" == 0 ]; then
        echo >&1 "Y"
        # echo >&1 "remoteToolSettings :: " >>$LOGFILE
    elif [ "$retval" == 3 ]; then
        echo >&2 "$retval---1942-HAMONIZE_ADMIN-TOOL"
        echo "ERROR] 1942-HAMONIZE_ADMIN-TOOL  "

        exit 0
    elif [ "$retval" == 2 ]; then
        echo >&2 "$retval---1942-HAMONIZE_ADMIN-KEYS"

       
        exit 0
    else
        echo >&2 "$retval---1942-HAMONIZE_ADMIN-ETC"
       
        exit 0
    fi
    sleep 2

    #==== Hamonize-help Install -----------------#
    hamonizeHelpSettings
    retval=$?

    if [ "$retval" == 0 ]; then
        echo >&1 "Y"
    else
        echo >&2 "$retval---1942-HAMONIZE_HELP"
        exit 0
    fi

    # Hamonize Base Server Info Settings
    hamonizeServerSettings

    sleep 1

    # Tenant Apt Url Settings
    hamonieTenantAptUrl
}


Init-HamonizeProgram