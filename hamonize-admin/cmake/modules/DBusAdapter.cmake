# xml 파일 절대 위치는 앞에 ${CMAKE_CURRENT_BINARY_DIR}가 생략되어 있음
SET(DBUS_ADAPTER_DIR ${CMAKE_CURRENT_BINARY_DIR}/hamonize-desker_autogen)
SET(DBUS_ADAPTER_XML org.hamonize.Desker.xml)
SET(DBUS_ADAPTER_FULL_PATH ${DBUS_ADAPTER_DIR}/${DBUS_ADAPTER_XML})

#: error: No rule to make target
#'${CMAKE_CURRENT_SOURCE_DIR}/src/DeskerSessionControl.h',
# needed by 'desker/src/org.hamonize.Desker.xml'.  Stop.
#
# $ qdbuscpp2xml --help
# Usage: qdbuscpp2xml [options...] [files...]
# Parses the C++ source or header file containing a QObject-derived class and
# produces the D-Bus Introspection XML.
# Options:
#   -p|-s|-m       Only parse scriptable Properties, Signals and Methods (slots)
#   -P|-S|-M       Parse all Properties, Signals and Methods (slots)
#   -a             Output all scriptable contents (equivalent to -psm)
#   -A             Output all contents (equivalent to -PSM)
#   -o <filename>  Write the output to file <filename>
#   -h             Show this information
#   -V             Show the program version and quit.
#
# QT5_GENERATE_DBUS_INTERFACE( header [interfacename] OPTIONS ...)

QT5_GENERATE_DBUS_INTERFACE(src/DeskerSessionControl.h
    ${DBUS_ADAPTER_FULL_PATH}
    OPTIONS -A
    )

# QT5_ADD_DBUS_ADAPTOR(outfiles xmlfile
#                      parentheader parentclassname [basename] [classname]
#
# Create a dbus adaptor (header and implementation file) from the xml file
# describing the interface, and add it to the list of sources.
# The adaptor forwards the calls to a parent class,
# defined in parentheader and named parentclassname.
# The name of the generated files will be <basename>adaptor.{cpp,h}
# where basename defaults to the basename of the xml file.
# If <classname> is provided, then it will be used as the classname
# of the adaptor itself.

# https://doc.qt.io/qt-5/cmake-manual.html
message("desker_SOURCES: " ${desker_SOURCES} )

QT5_ADD_DBUS_ADAPTOR(desker_SOURCES
    ${DBUS_ADAPTER_FULL_PATH}
    DeskerSessionControl.h
    DeskerSessionControl
    )

message("desker_SOURCES: " ${desker_SOURCES} )
#QT5_WRAP_UI( UI_HEADERS ${desker_UIS} )
#qt5_wrap_cpp( desker_moc src/DeskerSessionControl.h)
#qt5_wrap_cpp( deskerwidget_moc src/DeskerWidget.h)
message("desker_moc: " ${desker_moc} )

#TARGET_INCLUDE_DIRECTORIES(hamonize-desker PRIVATE ${CMAKE_CURRENT_SOURCE_DIR} ${CMAKE_CURRENT_BINARY_DIR})
