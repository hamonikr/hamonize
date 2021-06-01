SET( CMAKE_VERBOSE_MAKEFILE true )
INCLUDE(WindowsBuildHelpers)


#FIND_PACKAGE(Qt5DBus REQUIRED)

IF(WEBENGINE)
    FIND_PACKAGE(Qt5WebEngineWidgets REQUIRED)
ENDIF()

FILE(GLOB server_INCLUDES ${CMAKE_CURRENT_SOURCE_DIR}/src/*.h)
FILE(GLOB server_SOURCES ${CMAKE_CURRENT_SOURCE_DIR}/src/*.cpp)

SET(server_RESOURCES ${CMAKE_CURRENT_SOURCE_DIR}/resources/desker.qrc)
IF(VEYON_DEBUG)
SET(server_RESOURCES ${server_RESOURCES} ${CMAKE_CURRENT_SOURCE_DIR}/resources/examples.qrc)
ENDIF()


INCLUDE_DIRECTORIES(${CMAKE_CURRENT_BINARY_DIR} ${CMAKE_CURRENT_SOURCE_DIR}/src)

ADD_EXECUTABLE(hamonize-server ${server_SOURCES} ${server_INCLUDES} ${server_RESOURCES})
TARGET_LINK_LIBRARIES(hamonize-server hamonize-core)

ADD_WINDOWS_RESOURCE(hamonize-server)
MAKE_GRAPHICAL_APP(hamonize-server)

INSTALL(TARGETS hamonize-server RUNTIME DESTINATION bin)

IF(WIN32)
    TARGET_LINK_LIBRARIES(hamonize-server
        Qt5::Gui
        Qt5::Network
        Qt5::Widgets
        )
ELSE()
    TARGET_LINK_LIBRARIES(hamonize-server
        Qt5::Gui
        Qt5::Network
        Qt5::Widgets
        #	Qt5::DBus
        #	Qt5::WebEngineWidgets
        )
ENDIF()



COTIRE_VEYON(hamonize-server)
