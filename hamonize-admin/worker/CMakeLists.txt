INCLUDE(BuildVeyonApplication)
INCLUDE(WindowsBuildHelpers)

FILE(GLOB worker_INCLUDES ${CMAKE_CURRENT_SOURCE_DIR}/src/*.h)
FILE(GLOB worker_SOURCES ${CMAKE_CURRENT_SOURCE_DIR}/src/*.cpp)

INCLUDE_DIRECTORIES(${CMAKE_CURRENT_BINARY_DIR} ${CMAKE_CURRENT_SOURCE_DIR}/src)
build_veyon_application(hamonize-worker ${worker_SOURCES} ${worker_INCLUDES})
TARGET_LINK_LIBRARIES(hamonize-worker hamonize-core Qt5::Network)

ADD_WINDOWS_RESOURCE(hamonize-worker)
MAKE_GRAPHICAL_APP(hamonize-worker)
