INCLUDE(WindowsBuildHelpers)

SET(kitemmodels_SOURCE_DIR ${CMAKE_CURRENT_SOURCE_DIR}/../3rdparty/kitemmodels/src)
SET(kitemmodels_SOURCES
	${kitemmodels_SOURCE_DIR}/kextracolumnsproxymodel.cpp
	${kitemmodels_SOURCE_DIR}/krecursivefilterproxymodel.cpp
	${kitemmodels_SOURCE_DIR}/kextracolumnsproxymodel.h
	${kitemmodels_SOURCE_DIR}/krecursivefilterproxymodel.h
)

FILE(GLOB master_INCLUDES ${CMAKE_CURRENT_SOURCE_DIR}/src/*.h)
FILE(GLOB master_SOURCES ${CMAKE_CURRENT_SOURCE_DIR}/src/*.cpp ${CMAKE_CURRENT_SOURCE_DIR}/src/*.ui)

SET(master_RESOURCES ${CMAKE_CURRENT_SOURCE_DIR}/resources/master.qrc)
IF(VEYON_DEBUG)
SET(master_RESOURCES ${master_RESOURCES} ${CMAKE_CURRENT_SOURCE_DIR}/resources/examples.qrc)
ENDIF()

INCLUDE_DIRECTORIES(${CMAKE_CURRENT_BINARY_DIR} ${CMAKE_CURRENT_SOURCE_DIR}/src ${kitemmodels_SOURCE_DIR})
ADD_EXECUTABLE(hamonize-master ${master_SOURCES} ${master_INCLUDES} ${master_RESOURCES} ${kitemmodels_SOURCES})
TARGET_LINK_LIBRARIES(hamonize-master hamonize-core)

ADD_WINDOWS_RESOURCE(hamonize-master)
MAKE_GRAPHICAL_APP(hamonize-master)

INSTALL(TARGETS hamonize-master RUNTIME DESTINATION bin)

IF(VEYON_BUILD_LINUX)
	XDG_INSTALL(${CMAKE_CURRENT_BINARY_DIR}/data/hamonize-master.desktop ${CMAKE_CURRENT_SOURCE_DIR}/data/hamonize-master.xpm ${CMAKE_CURRENT_SOURCE_DIR}/data/hamonize-master.png ${CMAKE_CURRENT_SOURCE_DIR}/data/hamonize-master.svg)
ENDIF()

COTIRE_VEYON(hamonize-master)
