INCLUDE(BuildPlugin)

ADD_SUBDIRECTORY(kldap-hcenter)
ADD_SUBDIRECTORY(common-hcenter)

BUILD_PLUGIN(hcenter
	HCenterPlugin.cpp
	HCenterPlugin.h
)

TARGET_LINK_LIBRARIES(hcenter hcenter-common)
