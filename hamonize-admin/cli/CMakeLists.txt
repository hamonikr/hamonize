INCLUDE(BuildVeyonApplication)
INCLUDE(WindowsBuildHelpers)

INCLUDE_DIRECTORIES(${CMAKE_CURRENT_BINARY_DIR} ${CMAKE_CURRENT_SOURCE_DIR}/src)
SET(cli_SOURCES src/main.cpp)

build_veyon_application(hamonize-cli ${cli_SOURCES})
TARGET_LINK_LIBRARIES(hamonize-cli hamonize-core Qt5::Network)

ADD_WINDOWS_RESOURCE(hamonize-cli ${CMAKE_CURRENT_BINARY_DIR}/hamonize-cli.rc)
MAKE_CONSOLE_APP(hamonize-cli)

IF(VEYON_BUILD_WIN32)
build_hamonize_application(hamonize-wcli ${cli_SOURCES})
TARGET_LINK_LIBRARIES(hamonize-wcli hamonize-core Qt5::Network)

ADD_WINDOWS_RESOURCE(hamonize-wcli ${CMAKE_CURRENT_BINARY_DIR}/hamonize-wcli.rc)
MAKE_GRAPHICAL_APP(hamonize-wcli)
ENDIF()
