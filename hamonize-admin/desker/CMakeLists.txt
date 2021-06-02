SET(CMAKE_VERBOSE_MAKEFILE ON)

INCLUDE(WindowsBuildHelpers)


CMAKE_POLICY(SET CMP0071 NEW)
FIND_PACKAGE(Qt5DBus REQUIRED)

FILE(GLOB desker_INCLUDES ${CMAKE_CURRENT_SOURCE_DIR}/src/*.h)
FILE(GLOB desker_SOURCES ${CMAKE_CURRENT_SOURCE_DIR}/src/*.cpp ${CMAKE_CURRENT_SOURCE_DIR}/src/*.ui)

SET(desker_RESOURCES ${CMAKE_CURRENT_SOURCE_DIR}/resources/desker.qrc)
IF(VEYON_DEBUG)
    SET(desker_RESOURCES ${desker_RESOURCES} ${CMAKE_CURRENT_SOURCE_DIR}/resources/examples.qrc)
ENDIF()

INCLUDE(DBusAdapter)

INCLUDE_DIRECTORIES(${CMAKE_CURRENT_BINARY_DIR} ${CMAKE_CURRENT_SOURCE_DIR}/src)
ADD_EXECUTABLE(hamonize-desker
    ${desker_SOURCES}
    ${desker_INCLUDES}
    ${desker_RESOURCES}
    )

TARGET_INCLUDE_DIRECTORIES(hamonize-desker
    PRIVATE
#    ${desker_INCLUDES}
    ${CMAKE_CURRENT_SOURCE_DIR}
    ${CMAKE_CURRENT_BINARY_DIR}
    )

TARGET_LINK_LIBRARIES(hamonize-desker
    hamonize-core
    Qt5::DBus
    )

ADD_WINDOWS_RESOURCE(hamonize-desker)
MAKE_GRAPHICAL_APP(hamonize-desker)

INSTALL(TARGETS hamonize-desker RUNTIME DESTINATION bin)

IF(VEYON_BUILD_LINUX)
        INSTALL(FILES ${CMAKE_CURRENT_SOURCE_DIR}/data/org.hamonikr.SDesker.conf DESTINATION /etc/dbus-1/system.d)
ENDIF()

COTIRE_VEYON(hamonize-desker)


MESSAGE("\n################\n")
message("desker_moc: " ${desker_moc} )
message("CMAKE_CURRENT_SOURCE_DIR: " ${CMAKE_CURRENT_SOURCE_DIR} )
message("CMAKE_CURRENT_BINARY_DIR: " ${CMAKE_CURRENT_BINARY_DIR} )
message("desker_INCLUDES: " ${desker_INCLUDES} )
message("desker_SOURCES: " ${desker_SOURCES} )
message("desker_RESOURCES: " ${desker_RESOURCES} )

message("desker_UIS: " ${desker_UIS} )
message("DBUS_ADAPTER_XML: " ${DBUS_ADAPTER_XML} )
MESSAGE("\n################\n")

