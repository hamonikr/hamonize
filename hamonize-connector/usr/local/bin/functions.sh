#!/usr/bin/env bash

if [ "$(uname -s)" == "Darwin" ]; then
    desktop="macos"
elif [ "$XDG_CURRENT_DESKTOP" != "" ]; then
  desktop=$(echo "$XDG_CURRENT_DESKTOP" | tr '[:upper:]' '[:lower:]' | sed 's/.*\(xfce\|kde\|gnome|cinnamon\).*/\1/')
elif [ "$XDG_DATA_DIRS" != "" ]; then
  desktop=$(echo "$XDG_DATA_DIRS" | sed 's/.*\(xfce\|kde\|gnome|cinnamon\).*/\1/')
else
  desktop="unknown"
fi

desktop=$(echo "$desktop" | tr '[:upper:]' '[:lower:]')  # convert to lower case

[ -t 0 ] && terminal=true || terminal=false

hasKDialog=false
hasZenity=false
hasDialog=false
hasWhiptail=false

if [ -z ${GUI+x} ]; then
  GUI=false
  if [ ! -e xdpyinfo ] || [ xdpyinfo | grep X.Org > /dev/null ]; then
    if [ $terminal == false ] ; then
      GUI=true
    # 하모니카 리눅스를 위해서 수정
    else 
      if [ "$desktop" == "x-cinnamon" ] ; then
        GUI=true
      fi
    fi
  fi
fi

if [ $GUI == true ] ; then
  if which kdialog > /dev/null; then
    hasKDialog=true
  fi

  if which zenity > /dev/null; then
    hasZenity=true
  fi
else
  if which dialog > /dev/null; then
    hasDialog=true
  fi

  if which whiptail > /dev/null; then
    hasWhiptail=true
  fi
fi

# 디버그 코드
# echo "Desktop : $desktop"
# echo "GUI : $GUI"
# exit 0;

if [ -z ${INTERFACE+x} ]; then
  if [ "$desktop" == "kde" ] || [ "$desktop" == "razor" ]  || [ "$desktop" == "lxqt" ]  || [ "$desktop" == "maui" ] ; then
    if  [ $hasKDialog == true ] && [ $GUI == true ] ; then
      INTERFACE="kdialog"
      GUI=true
    elif [ $hasZenity == true ] && [ $GUI == true ] ; then
      INTERFACE="zenity"
      GUI=true
    elif  [ $hasDialog == true ] ; then
      INTERFACE="dialog"
      GUI=false
    elif  [ $hasWhiptail == true ] ; then
      INTERFACE="whiptail"
      GUI=false
    fi
  elif [ "$desktop" == "unity" ] || [ "$desktop" == "gnome" ]  || [ "$desktop" == "xfce" ]  || [ -n $INTERFACE ]; then
    if [ $hasZenity == true ] && [ $GUI == true ] ; then
      INTERFACE="zenity"
      GUI=true
    elif  [ $hasDialog == true ] ; then
      INTERFACE="dialog"
      GUI=false
    elif  [ $hasWhiptail == true ] ; then
      INTERFACE="whiptail"
      GUI=false
    fi
  else
    if  [ $hasDialog == true ] ; then
      INTERFACE="dialog"
      GUI=false
    elif  [ $hasWhiptail == true ] ; then
      INTERFACE="whiptail"
      GUI=false
    fi
  fi
fi

# which sudo to use
NO_SUDO=false
SUDO_USE_INTERFACE=false
if [ $GUI == true ] && [ "`which pkexec`" > /dev/null ]; then
  SUDO="pkexec"
elif [ "$INTERFACE" == "kdialog" ] && [ `which gksudo` > /dev/null ]; then
  SUDO="kdesudo"
elif [ $GUI == true ] && [ `which gksudo` > /dev/null ]; then
  SUDO="gksudo"
elif [ $GUI == true ] && [ `which gksu` > /dev/null ]; then
  SUDO="gksu"
elif [ `which sudo` > /dev/null ]; then
  SUDO="sudo"
  if [ "$INTERFACE" == "whiptail" ] || [ "$INTERFACE" == "dialog" ]; then
    SUDO_USE_INTERFACE=true
  fi
else
  NO_SUDO=true
fi

APP_NAME="Script"
ACTIVITY=""
WINDOW_ICON=""
GUI_TITLE="$APP_NAME"

function superuser() {
  if [ $NO_SUDO == true ]; then
    (>&2 echo "No sudo available!")
    return 201
  fi

  if sudo -n true 2>/dev/null; then # if credentials cached
    sudo -- "$@"
  elif [ $SUDO_USE_INTERFACE == true ]; then
    ACTIVITY="Enter password to run \"""$@""\""
    echo $(password) | sudo -p "" -S -- "$@"
  elif [ "$SUDO" == "pkexec" ]; then
    $SUDO "$@"
  else
    $SUDO -- "$@"
  fi
}

function updateGUITitle() {
  if [ -n "$ACTIVITY" ]; then
    GUI_TITLE="$ACTIVITY - $APP_NAME"
  else
    GUI_TITLE="$APP_NAME"
  fi
}

MIN_HEIGHT=10
MIN_WIDTH=40
MAX_HEIGHT=$MIN_HEIGHT
MAX_WIDTH=$MIN_WIDTH

function updateDialogMaxSize() {
  if ! [ "`which tput`" > /dev/null ]; then
    return;
  fi

  if [ $GUI == true ] ; then
    MAX_HEIGHT=$( xdpyinfo | grep "dimensions" | awk '{ print $2 }' | cut -d'x' -f2)
    MAX_WIDTH=$( xdpyinfo | grep "dimensions" | awk '{ print $2 }' | cut -d'x' -f1)
  else
    MAX_HEIGHT=$(tput lines)
    MAX_WIDTH=$(tput cols)
  fi

  # Never really fill the whole screen space
  MAX_HEIGHT=$(( $MAX_HEIGHT / 2 ))
  MAX_WIDTH=$(( $MAX_WIDTH * 3 / 4 ))
}

RECMD_HEIGHT=10
RECMD_WIDTH=40
RECMD_SCROLL=false
TEST_STRING=""

function calculateTextDialogSize() {
  updateDialogMaxSize
  CHARS=${#TEST_STRING}
  RECMD_SCROLL=false
  ORIG_RECMD_HEIGHT=$(($CHARS  / $MIN_WIDTH))
  ORIG_RECMD_WIDTH=$(($CHARS / $MIN_HEIGHT))
  RECMD_HEIGHT=$(($CHARS  / $MIN_WIDTH))
  RECMD_WIDTH=$(($CHARS / $MIN_HEIGHT))

  if [ "$RECMD_HEIGHT" -gt "$MAX_HEIGHT" ] ; then
    RECMD_HEIGHT=$MAX_HEIGHT
    RECMD_SCROLL=true
  fi
  if [ "$RECMD_WIDTH" -gt "$MAX_WIDTH" ]; then
    RECMD_WIDTH=$MAX_WIDTH
    #RECMD_SCROLL=true
  fi

  if [ "$RECMD_HEIGHT" -lt "$MIN_HEIGHT" ] ; then
    RECMD_HEIGHT=$MIN_HEIGHT
    RECMD_SCROLL=false
  fi
  if [ "$RECMD_WIDTH" -lt "$MIN_WIDTH" ]; then
    RECMD_WIDTH=$MIN_WIDTH
    RECMD_SCROLL=false
  fi

  TEST_STRING="" #blank out for memory's sake
}

function relaunchIfNotVisible() {
  parentScript=$(basename $0)

  if [ $GUI == false ] && [ $terminal == false ]; then
    if [ -e "/tmp/relaunching" ] && [ `cat /tmp/relaunching` == "$parentScript" ]; then
      echo "Won't relaunch $parentScript more than once"
    else
      echo "$parentScript" > /tmp/relaunching

      echo "Relaunching $parentScript ..."

      x-terminal-emulator -e "./$parentScript"
      rm /tmp/relaunching
      exit $?;
    fi
  fi
}

#standard window icons
function standardIconInfo() {
  if [ "$INTERFACE" == "zenity" ]; then
    echo "info"
  elif [ "$INTERFACE" == "kdialog" ]; then
    echo "dialog-information"
  else
    echo ""
  fi
}
function standardIconQuestion() {
  if [ "$INTERFACE" == "zenity" ]; then
    echo "question"
  elif [ "$INTERFACE" == "kdialog" ]; then
    echo "dialog-question"
  else
    echo ""
  fi
}
function standardIconError() {
  if [ "$INTERFACE" == "zenity" ]; then
    echo "error"
  elif [ "$INTERFACE" == "kdialog" ]; then
    echo "dialog-error"
  else
    echo ""
  fi
}
function standardIconWarning() {
  if [ "$INTERFACE" == "zenity" ]; then
    echo "warning"
  elif [ "$INTERFACE" == "kdialog" ]; then
    echo "dialog-warning"
  else
    echo ""
  fi
}
function standardIconFolderOpen() {
  if [ "$INTERFACE" == "zenity" ]; then
    echo "info"
  elif [ "$INTERFACE" == "kdialog" ]; then
    echo "folder-open"
  else
    echo ""
  fi
}
function standardIconFolderSave() {
  if [ "$INTERFACE" == "zenity" ]; then
    echo "info"
  elif [ "$INTERFACE" == "kdialog" ]; then
    echo "folder-save"
  else
    echo ""
  fi
}
function standardIconFileOpen() {
  if [ "$INTERFACE" == "zenity" ]; then
    echo "info"
  elif [ "$INTERFACE" == "kdialog" ]; then
    echo "document-open"
  else
    echo ""
  fi
}
function standardIconFileSave() {
  if [ "$INTERFACE" == "zenity" ]; then
    echo "info"
  elif [ "$INTERFACE" == "kdialog" ]; then
    echo "document-save"
  else
    echo ""
  fi
}
function standardIconPassword() {
  if [ "$INTERFACE" == "zenity" ]; then
    echo "question"
  elif [ "$INTERFACE" == "kdialog" ]; then
    echo "dialog-password"
  else
    echo ""
  fi
}
function standardIconCalendar() {
  if [ "$INTERFACE" == "zenity" ]; then
    echo "question"
  elif [ "$INTERFACE" == "kdialog" ]; then
    echo "x-office-calendar"
  else
    echo ""
  fi
}
function standardIconDocument() {
  if [ "$INTERFACE" == "zenity" ]; then
    echo "info"
  elif [ "$INTERFACE" == "kdialog" ]; then
    echo "x-office-document"
  else
    echo ""
  fi
}
#end standard icons

function messagebox() {
  updateGUITitle
  TEST_STRING="$1"
  calculateTextDialogSize

  if [ "$INTERFACE" == "whiptail" ]; then
    whiptail --clear $([ "$RECMD_SCROLL" == true ] && echo "--scrolltext") --backtitle "$APP_NAME" --title "$ACTIVITY" --msgbox "$1" $RECMD_HEIGHT $RECMD_WIDTH
  elif [ "$INTERFACE" == "dialog" ]; then
    dialog --clear --backtitle "$APP_NAME" --title "$ACTIVITY" --msgbox "$1" $RECMD_HEIGHT $RECMD_WIDTH
  elif [ "$INTERFACE" == "zenity" ]; then
    zenity --title "$GUI_TITLE" --window-icon "$WINDOW_ICON" --info --text "$1"
  elif [ "$INTERFACE" == "kdialog" ]; then
    kdialog --title "$GUI_TITLE" --icon "$WINDOW_ICON" --msgbox "$1"
  else
    echo "$1"
  fi
}

function yesno() {
  updateGUITitle
  TEST_STRING="$1"
  calculateTextDialogSize

  if [ "$INTERFACE" == "whiptail" ]; then
    whiptail --clear --backtitle "$APP_NAME" --title "$ACTIVITY" --yesno "$1" $RECMD_HEIGHT $RECMD_WIDTH
    answer=$?
  elif [ "$INTERFACE" == "dialog" ]; then
    dialog --clear --backtitle "$APP_NAME" --title "$ACTIVITY" --yesno "$1" $RECMD_HEIGHT $RECMD_WIDTH
    answer=$?
  elif [ "$INTERFACE" == "zenity" ]; then
    zenity --title "$GUI_TITLE" --window-icon "$WINDOW_ICON" --question --text "$1"
    answer=$?
  elif [ "$INTERFACE" == "kdialog" ]; then
    kdialog --title "$GUI_TITLE" --icon "$WINDOW_ICON" --yesno "$1"
    answer=$?
  else
    echo "$1 (y/n)" 3>&1 1>&2 2>&3
    read answer
    if [ "$answer" == "y" ]; then
      answer=0
    else
      answer=1
    fi
  fi

  return $answer
}

function inputbox() {
  updateGUITitle
  TEST_STRING="$1"
  calculateTextDialogSize

  if [ "$INTERFACE" == "whiptail" ]; then
    INPUT=$(whiptail --clear --backtitle "$APP_NAME" --title "$ACTIVITY" --inputbox " $1" $RECMD_HEIGHT $RECMD_WIDTH "$2" 3>&1 1>&2 2>&3)
  elif [ "$INTERFACE" == "dialog" ]; then
    INPUT=$(dialog --clear --backtitle "$APP_NAME" --title "$ACTIVITY" --inputbox " $1" $RECMD_HEIGHT $RECMD_WIDTH "$2" 3>&1 1>&2 2>&3)
  elif [ "$INTERFACE" == "zenity" ]; then
    INPUT="`zenity --entry --title="$GUI_TITLE" --window-icon "$WINDOW_ICON" --text="$1" --entry-text "$2"`"
  elif [ "$INTERFACE" == "kdialog" ]; then
    INPUT="`kdialog --title "$GUI_TITLE" --icon "$WINDOW_ICON" --inputbox "$1" "$2"`"
  else
    read -p "$1: " INPUT
  fi

  echo "$INPUT"
}

function userandpassword() {
  updateGUITitle
  TEST_STRING="$1"
  calculateTextDialogSize

  SUGGESTED_USERNAME="$3"

  USERANDPASSWORD=()

  if [ "$INTERFACE" == "whiptail" ]; then
    USERANDPASSWORD[0]=$(inputbox "$1" "$3")
    USERANDPASSWORD[1]=$(whiptail --clear --backtitle "$APP_NAME" --title "$ACTIVITY"  --passwordbox "$2" $RECMD_HEIGHT $RECMD_WIDTH 3>&1 1>&2 2>&3)
  elif [ "$INTERFACE" == "dialog" ]; then
    USERANDPASSWORD=($(dialog --clear --backtitle "$APP_NAME" --title "$ACTIVITY" --insecure --mixedform "Login:" $RECMD_HEIGHT $RECMD_WIDTH 0 "Username: " 1 1 "$3" 1 11 22 0 0 "Password :" 2 1 "" 2 11 22 0 1   3>&1 1>&2 2>&3))
  elif [ "$INTERFACE" == "zenity" ]; then
    ENTRY=`zenity --title="$GUI_TITLE" --window-icon "$WINDOW_ICON" --password --username`
    USERANDPASSWORD[0]=`echo $ENTRY | cut -d'|' -f1`
    USERANDPASSWORD[1]=`echo $ENTRY | cut -d'|' -f2`
  elif [ "$INTERFACE" == "kdialog" ]; then
    USERANDPASSWORD[0]=$(inputbox "$1" "$3")
    USERANDPASSWORD[1]=`kdialog --title="$GUI_TITLE" --icon "$WINDOW_ICON" --password "$2"`
  else
    read -p "$1 ($3): " USERANDPASSWORD[0]
    read  -sp "$2: " USERANDPASSWORD[1]
  fi
  echo "${USERANDPASSWORD[*]}"
}

function password() {
  updateGUITitle
  TEST_STRING="$1"
  calculateTextDialogSize

  if [ "$INTERFACE" == "whiptail" ]; then
    PASSWORD=$(whiptail --clear --backtitle "$APP_NAME" --title "$ACTIVITY"  --passwordbox "$1" $RECMD_HEIGHT $RECMD_WIDTH 3>&1 1>&2 2>&3)
  elif [ "$INTERFACE" == "dialog" ]; then
    PASSWORD=$(dialog --clear --backtitle "$APP_NAME" --title "$ACTIVITY"  --passwordbox "$1" $RECMD_HEIGHT $RECMD_WIDTH 3>&1 1>&2 2>&3)
  elif [ "$INTERFACE" == "zenity" ]; then
    PASSWORD=`zenity --title="$GUI_TITLE" --window-icon "$WINDOW_ICON" --password`
  elif [ "$INTERFACE" == "kdialog" ]; then
    PASSWORD=`kdialog --title="$GUI_TITLE" --icon "$WINDOW_ICON" --password "$1"`
  else
    read  -sp "$1: " PASSWORD
  fi
  echo "$PASSWORD"
}

function displayFile() {
  updateGUITitle
  TEST_STRING="`cat $1`"
  calculateTextDialogSize

  if [ "$INTERFACE" == "whiptail" ]; then
    whiptail --clear --backtitle "$APP_NAME" --title "$ACTIVITY" $([ "$RECMD_SCROLL" == true ] && echo "--scrolltext")  --textbox "$1" $RECMD_HEIGHT $RECMD_WIDTH
  elif [ "$INTERFACE" == "dialog" ]; then
    dialog --clear --backtitle "$APP_NAME" --title "$ACTIVITY" --textbox "$1" $RECMD_HEIGHT $RECMD_WIDTH
  elif [ "$INTERFACE" == "zenity" ]; then
    zenity --title="$GUI_TITLE" --window-icon "$WINDOW_ICON" --text-info --filename="$1"
  elif [ "$INTERFACE" == "kdialog" ]; then
    kdialog --title="$GUI_TITLE" --icon "$WINDOW_ICON" --textbox "$1" 512 256
  else
    less $1 3>&1 1>&2 2>&3
  fi
}

function checklist() {
  updateGUITitle
  TEXT=$1
  NUM_OPTIONS=$2
  shift
  shift

  if [ "$INTERFACE" == "whiptail" ]; then
    CHOSEN=$(whiptail --clear --backtitle "$APP_NAME" --title "$ACTIVITY" $([ "$RECMD_SCROLL" == true ] && echo "--scrolltext") --checklist "$TEXT" $RECMD_HEIGHT $MAX_WIDTH $NUM_OPTIONS "$@"  3>&1 1>&2 2>&3)
  elif [ "$INTERFACE" == "dialog" ]; then
    CHOSEN_LIST=$(dialog --clear --backtitle "$APP_NAME" --title "$ACTIVITY" $([ "$RECMD_SCROLL" == true ] && echo "--scrolltext") --separate-output --checklist "$TEXT" $RECMD_HEIGHT $MAX_WIDTH $NUM_OPTIONS "$@"  3>&1 1>&2 2>&3)

    ORIG_IFS="$IFS"
    IFS=$'\n'
    CHOSEN_LIST=( $CHOSEN_LIST )
    IFS="$ORIG_IFS"

    CHOSEN=""
    for i in "${CHOSEN_LIST[@]}"; do
      CHOSEN+="\"$i\" "
    done

  elif [ "$INTERFACE" == "zenity" ]; then
    OPTIONS=()
    while test ${#} -gt 0;  do
      if [ "$3" == "ON" ]; then
        OPTIONS+=("TRUE")
      else
        OPTIONS+=("FALSE")
      fi
      OPTIONS+=("$1")
      OPTIONS+=("$2")
      shift
      shift
      shift
    done
    CHOSEN_LIST=$(zenity --title "$GUI_TITLE" --window-icon "$WINDOW_ICON" --list --text "$TEXT" --checklist --column "" --column "Value" --column "Description" "${OPTIONS[@]}")

    ORIG_IFS="$IFS"
    IFS="|"
    CHOSEN_LIST=( $CHOSEN_LIST )
    IFS="$ORIG_IFS"

    CHOSEN=""
    for i in "${CHOSEN_LIST[@]}"; do
      CHOSEN+="\"$i\" "
    done

  elif [ "$INTERFACE" == "kdialog" ]; then
    CHOSEN=$(kdialog --title="$GUI_TITLE" --icon "$WINDOW_ICON" --checklist "$TEXT" "$@")
  else
    echo "$ACTIVITY\n $TEXT:" 3>&1 1>&2 2>&3
    CHOSEN=""
    while test ${#} -gt 0; do
      $(yesno "$2 (default: $3)?")
      if [ $? -eq 0 ]; then
        CHOSEN+="\"$1\" "
      fi
      shift
      shift
      shift
    done
  fi

  echo $CHOSEN
}

function radiolist() {
  updateGUITitle
  TEXT=$1
  NUM_OPTIONS=$2
  shift
  shift

  if [ "$INTERFACE" == "whiptail" ]; then
    CHOSEN=$(whiptail --clear --backtitle "$APP_NAME" --title "$ACTIVITY" $([ "$RECMD_SCROLL" == true ] && echo "--scrolltext") --radiolist "$TEXT" $RECMD_HEIGHT $MAX_WIDTH $NUM_OPTIONS "$@"  3>&1 1>&2 2>&3)
  elif [ "$INTERFACE" == "dialog" ]; then
    CHOSEN=$(dialog --clear --backtitle "$APP_NAME" --title "$ACTIVITY" $([ "$RECMD_SCROLL" == true ] && echo "--scrolltext") --quoted --radiolist "$TEXT" $RECMD_HEIGHT $MAX_WIDTH $NUM_OPTIONS "$@"  3>&1 1>&2 2>&3)
  elif [ "$INTERFACE" == "zenity" ]; then
    OPTIONS=()
    while test ${#} -gt 0;  do
      if [ "$3" == "ON" ]; then
        OPTIONS+=("TRUE")
      else
        OPTIONS+=("FALSE")
      fi
      OPTIONS+=("$1")
      OPTIONS+=("$2")
      shift
      shift
      shift
    done
    CHOSEN=$(zenity --title "$GUI_TITLE" --window-icon "$WINDOW_ICON" --list --text "$TEXT" --radiolist --column "" --column "Value" --column "Description" "${OPTIONS[@]}")
  elif [ "$INTERFACE" == "kdialog" ]; then
    CHOSEN=$(kdialog --title="$GUI_TITLE" --icon "$WINDOW_ICON" --radiolist "$TEXT" "$@")
  else
    echo "$ACTIVITY: " 3>&1 1>&2 2>&3
    OPTIONS=""
    while test ${#} -gt 0;  do
      OPTIONS+="$1 ($2)\n"
      shift
      shift
      shift
    done
    read -p "$(echo -e "$OPTIONS$TEXT: ")" CHOSEN
  fi

  echo $CHOSEN
}

function progressbar() {
  updateGUITitle

  if [ "$INTERFACE" == "whiptail" ]; then
    whiptail --gauge "$ACTIVITY" $RECMD_HEIGHT $RECMD_WIDTH 0
  elif [ "$INTERFACE" == "dialog" ]; then
    dialog --clear --backtitle "$APP_NAME" --title "$ACTIVITY"  --gauge "" $RECMD_HEIGHT $RECMD_WIDTH 0
  elif [ "$INTERFACE" == "zenity" ]; then
    zenity --title "$GUI_TITLE" --window-icon "$WINDOW_ICON" --progress --text="$ACTIVITY" --auto-close --auto-kill --percentage 0
  elif [ "$INTERFACE" == "kdialog" ]; then
    dbusRef=`kdialog --title "$GUI_TITLE" --icon "$WINDOW_ICON" --progressbar "$ACTIVITY" 100`
    qdbus $dbusRef Set "" value 0

    mkdir -p /tmp/script-dialog.$$/
    DBUS_BAR_PATH=/tmp/script-dialog.$$/progressbar_dbus
    echo "$dbusRef" > $DBUS_BAR_PATH

	# wait until finish called to leave function, so internal actions finish
    while [ -e $DBUS_BAR_PATH ]; do
		sleep 1
		read "$@" <&0;
	done

	qdbus $dbusRef close
  else
    echo -ne "\r$ACTIVITY 0%"
    cat
  fi
}

function progressbar_update() {
  if [ "$INTERFACE" == "kdialog" ]; then
    DBUS_BAR_PATH=/tmp/script-dialog.$$/progressbar_dbus
	if [ -e $DBUS_BAR_PATH ]; then
		dbusRef=`cat $DBUS_BAR_PATH`
		qdbus $dbusRef Set "" value $1
		sleep 0.2 # requires slight sleep
	else
		echo "Could not update progressbar $$"
    fi
  elif [ "$INTERFACE" == "whiptail" ] || [ "$INTERFACE" == "dialog" ] || [ "$INTERFACE" == "zenity" ]; then
    echo "$1"
  else
    #         echo -ne "\r$ACTIVITY $1%"
    echo -ne "\r$ACTIVITY $1%"
  fi
}

function progressbar_finish() {
  if [ "$INTERFACE" == "kdialog" ]; then
	DBUS_BAR_FOLDER=/tmp/script-dialog.$$
    DBUS_BAR_PATH=$DBUS_BAR_FOLDER/progressbar_dbus
    if [ -e $DBUS_BAR_PATH ]; then
		rm $DBUS_BAR_PATH
		rmdir $DBUS_BAR_FOLDER --ignore-fail-on-non-empty
	else
		echo "Could not close progressbar $$"
    fi
  elif [ "$INTERFACE" != "whiptail" ] && [ "$INTERFACE" != "dialog" ] && [ "$INTERFACE" != "zenity" ]; then
    echo ""
  fi
}

function filepicker() {
  updateGUITitle
  if [ "$INTERFACE" == "whiptail" ]; then
    files=($(ls -lBhpa "$1" | awk -F ' ' ' { print $9 " " $5 } '))
    SELECTED=$(whiptail --clear --backtitle "$APP_NAME" --title "$GUI_TITLE"  --cancel-button Cancel --ok-button Select --menu "$ACTIVITY" $((8+$RECMD_HEIGHT)) $((6+$RECMD_WIDTH)) $RECMD_HEIGHT "${files[@]}" 3>&1 1>&2 2>&3)
    FILE="$1/$SELECTED"

    #exitstatus=$?
    #if [ $exitstatus != 0 ]; then
        #echo "CANCELLED!"
        #exit;
    #fi

  elif [ "$INTERFACE" == "dialog" ]; then
    FILE=$(dialog --clear --backtitle "$APP_NAME" --title "$ACTIVITY" --stdout --fselect $1/ 14 48)
  elif [ "$INTERFACE" == "zenity" ]; then
    FILE=$(zenity --title "$GUI_TITLE" --window-icon "$WINDOW_ICON" --file-selection --filename $1/ )
  elif [ "$INTERFACE" == "kdialog" ]; then
    if [ "$2" == "save" ]; then
      FILE=$(kdialog --title="$GUI_TITLE" --icon "$WINDOW_ICON" --getsavefilename $1/ )
    else #elif [ "$2" == "open" ]; then
      FILE=$(kdialog --title="$GUI_TITLE" --icon "$WINDOW_ICON" --getopenfilename $1/ )
    fi
  else
    read -e -p "You need to $2 a file in $1/. Hit enter to browse this folder" IGNORE

    ls -lBhpa "$1" 3>&1 1>&2 2>&3 #| less

    read -e -p "Enter name of file to $2 in $1/: " SELECTED

    # TODO if SELECTED is empty

    FILE=$1/$SELECTED
  fi

    # Ignore choice and relaunch dialog
    if [[ "$SELECTED" == "./" ]]; then
        FILE=$(filepicker "$1" "$2")
    fi

    # Drill into folder
    if [ -d "$FILE" ]; then
        FILE=$(filepicker "$FILE" "$2")
    fi

  echo $FILE
}

function folderpicker() {
  updateGUITitle
  if [ "$INTERFACE" == "whiptail" ]; then
    files=($(ls -lBhpa "$1" | grep "^d" | awk -F ' ' ' { print $9 " " $5 } '))
    SELECTED=$(whiptail --clear --backtitle "$APP_NAME" --title "$GUI_TITLE"  --cancel-button Cancel --ok-button Select --menu "$ACTIVITY" $((8+$RECMD_HEIGHT)) $((6+$RECMD_WIDTH)) $RECMD_HEIGHT "${files[@]}" 3>&1 1>&2 2>&3)
    FILE="$1/$SELECTED"

    #exitstatus=$?
    #if [ $exitstatus != 0 ]; then
        #echo "CANCELLED!"
        #exit;
    #fi

  elif [ "$INTERFACE" == "dialog" ]; then
    FILE=$(dialog --clear --backtitle "$APP_NAME" --title "$ACTIVITY" --stdout --dselect $1/ 14 48)
  elif [ "$INTERFACE" == "zenity" ]; then
    FILE=$(zenity --title "$GUI_TITLE" --window-icon "$WINDOW_ICON" --file-selection --directory --filename $1/ )
  elif [ "$INTERFACE" == "kdialog" ]; then
    FILE=$(kdialog --title="$GUI_TITLE" --icon "$WINDOW_ICON" --getexistingdirectory $1/ )
  else
    read -e -p "You need to select a folder in $1/. Hit enter to browse this folder" IGNORE

    ls -lBhpa "$1" | grep "^d" 3>&1 1>&2 2>&3 #| less

    read -e -p "Enter name of file to $2 in $1/: " SELECTED

    # TODO if SELECTED is empty

    FILE=$1/$SELECTED
  fi

  echo $FILE
}

function datepicker() {
  updateGUITitle
  DAY="0"
  MONTH="0"
  YEAR="0"

  if [ "$INTERFACE" == "whiptail" ]; then
    STANDARD_DATE=$(inputbox "Input Date (DD/MM/YYYY)" " ")
  elif [ "$INTERFACE" == "dialog" ]; then
    STANDARD_DATE=$(dialog --clear --backtitle "$APP_NAME" --title "$ACTIVITY" --stdout --calendar "Choose Date" 0 40)
  elif [ "$INTERFACE" == "zenity" ]; then
    INPUT_DATE=$(zenity --title="$GUI_TITLE" --window-icon "$WINDOW_ICON" --calendar "Select Date")
    MONTH=`echo $INPUT_DATE | cut -d'/' -f1`
    DAY=`echo $INPUT_DATE | cut -d'/' -f2`
    YEAR=`echo $INPUT_DATE | cut -d'/' -f3`
    STANDARD_DATE="$DAY/$MONTH/$YEAR"
  elif [ "$INTERFACE" == "kdialog" ]; then
    INPUT_DATE=$(kdialog --title="$GUI_TITLE" --icon "$WINDOW_ICON" --calendar "Select Date")
    TEXT_MONTH=`echo $INPUT_DATE | cut -d' ' -f2`
    if [ "$TEXT_MONTH" == "Jan" ]; then
      MONTH=1
    elif [ "$TEXT_MONTH" == "Feb" ]; then
      MONTH=2
    elif [ "$TEXT_MONTH" == "Mar" ]; then
      MONTH=3
    elif [ "$TEXT_MONTH" == "Apr" ]; then
      MONTH=4
    elif [ "$TEXT_MONTH" == "May" ]; then
      MONTH=5
    elif [ "$TEXT_MONTH" == "Jun" ]; then
      MONTH=6
    elif [ "$TEXT_MONTH" == "Jul" ]; then
      MONTH=7
    elif [ "$TEXT_MONTH" == "Aug" ]; then
      MONTH=8
    elif [ "$TEXT_MONTH" == "Sep" ]; then
      MONTH=9
    elif [ "$TEXT_MONTH" == "Oct" ]; then
      MONTH=10
    elif [ "$TEXT_MONTH" == "Nov" ]; then
      MONTH=11
    else #elif [ "$TEXT_MONTH" == "Dec" ]; then
      MONTH=12
    fi

    DAY=`echo $INPUT_DATE | cut -d' ' -f3`
    YEAR=`echo $INPUT_DATE | cut -d' ' -f4`
    STANDARD_DATE="$DAY/$MONTH/$YEAR"
  else
    read -p "Date (DD/MM/YYYY): " STANDARD_DATE
  fi

  echo "$STANDARD_DATE"
}



