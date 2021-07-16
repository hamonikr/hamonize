INCLUDE(BuildVeyonApplication)
INCLUDE(WindowsBuildHelpers)

FILE(GLOB configurator_INCLUDES ${CMAKE_CURRENT_SOURCE_DIR}/src/*.h)
FILE(GLOB configurator_SOURCES ${CMAKE_CURRENT_SOURCE_DIR}/src/*.cpp ${CMAKE_CURRENT_SOURCE_DIR}/src/*.ui)
SET(configurator_RESOURCES ${CMAKE_CURRENT_SOURCE_DIR}/resources/configurator.qrc)

INCLUDE_DIRECTORIES(${CMAKE_CURRENT_BINARY_DIR} ${CMAKE_CURRENT_SOURCE_DIR}/src)
build_veyon_application(hamonize-configurator ${configurator_SOURCES} ${configurator_INCLUDES} ${configurator_RESOURCES})
TARGET_LINK_LIBRARIES(hamonize-configurator hamonize-core)

ADD_WINDOWS_RESOURCE(hamonize-configurator)
MAKE_GRAPHICAL_APP(hamonize-configurator)

IF(VEYON_BUILD_LINUX)
	XDG_INSTALL(${CMAKE_CURRENT_BINARY_DIR}/data/hamonize-configurator.desktop ${CMAKE_CURRENT_SOURCE_DIR}/data/hamonize-configurator.xpm ${CMAKE_CURRENT_SOURCE_DIR}/data/hamonize-configurator.png ${CMAKE_CURRENT_SOURCE_DIR}/data/hamonize-configurator.svg)
	INSTALL(FILES ${CMAKE_CURRENT_BINARY_DIR}/data/io.hamonize.hamonize-configurator.policy DESTINATION ${CMAKE_INSTALL_PREFIX}/share/polkit-1/actions)
ENDIF()
