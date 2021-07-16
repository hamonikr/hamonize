include(CreateTranslations)
include(FindQtTranslations)

file(GLOB hamonize_translations ${CMAKE_CURRENT_SOURCE_DIR}/*.ts)
set(ts_targets "")
set(qm_targets "")
file(GLOB_RECURSE hamonize_sources ${CMAKE_SOURCE_DIR}/*.cpp ${CMAKE_SOURCE_DIR}/*.h ${CMAKE_SOURCE_DIR}/*.ui ${CMAKE_SOURCE_DIR}/*.qml)
string(REGEX REPLACE "${CMAKE_SOURCE_DIR}/3rdparty[^;]+;?" "" hamonize_sources "${hamonize_sources}")
string(REGEX REPLACE "${CMAKE_SOURCE_DIR}/addons[^;]+;?" "" hamonize_sources "${hamonize_sources}")

create_translations(hamonize "${hamonize_translations}" "${hamonize_sources}")
find_qt_translations()
