SET(hcenter_common_SOURCES
        HCenterBrowseDialog.cpp
        HCenterBrowseDialog.ui
        HCenterBrowseDialog.h
        HCenterBrowseModel.cpp
        HCenterBrowseModel.h
        HCenterClient.cpp
        HCenterClient.h
        HCenterConfiguration.cpp
        HCenterConfiguration.h
        HCenterConfigurationPage.h
        HCenterConfigurationPage.cpp
        HCenterConfigurationPage.ui
        HCenterDirectory.cpp
        HCenterDirectory.h
        HCenterNetworkObjectDirectory.cpp
        HCenterNetworkObjectDirectory.h
        hcenter.qrc
        )

ADD_LIBRARY(hcenter-common SHARED ${hcenter_common_SOURCES})
TARGET_INCLUDE_DIRECTORIES(hcenter-common PRIVATE ${CMAKE_CURRENT_BINARY_DIR})
TARGET_INCLUDE_DIRECTORIES(hcenter-common PUBLIC ${CMAKE_CURRENT_SOURCE_DIR})
TARGET_LINK_LIBRARIES(hcenter-common hamonize-core)
SET_TARGET_PROPERTIES(hcenter-common PROPERTIES LINK_FLAGS "-Wl,-no-undefined")
INSTALL(TARGETS hcenter-common DESTINATION ${VEYON_LIB_DIR})
COTIRE_VEYON(hcenter-common)
