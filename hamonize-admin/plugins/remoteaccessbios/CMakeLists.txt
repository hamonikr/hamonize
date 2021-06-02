INCLUDE(BuildPlugin)

BUILD_PLUGIN(remoteaccessbios RemoteAccessBiosFeaturePlugin.cpp RemoteAccessWidget.cpp
        RemoteAccessBiosFeaturePlugin.h RemoteAccessWidget.h
	remoteaccessbios.qrc)
