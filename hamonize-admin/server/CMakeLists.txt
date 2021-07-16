INCLUDE(BuildVeyonApplication)
INCLUDE(WindowsBuildHelpers)

FILE(GLOB server_INCLUDES ${CMAKE_CURRENT_SOURCE_DIR}/src/*.h)
FILE(GLOB server_SOURCES ${CMAKE_CURRENT_SOURCE_DIR}/src/*.cpp)

INCLUDE_DIRECTORIES(${CMAKE_CURRENT_BINARY_DIR} ${CMAKE_CURRENT_SOURCE_DIR}/src)

build_veyon_application(hamonize-server ${server_SOURCES} ${server_INCLUDES})
TARGET_LINK_LIBRARIES(hamonize-server hamonize-core)

ADD_WINDOWS_RESOURCE(hamonize-server)
MAKE_GRAPHICAL_APP(hamonize-server)

TARGET_LINK_LIBRARIES(hamonize-server
        Qt5::Gui
        Qt5::Network
        Qt5::Widgets
	)
