include_directories("${CMAKE_CURRENT_LIST_DIR}")
add_dart_native_extension(galileo_wings
	http-parser/http_parser.c
	galileo_wings.h galileo_wings.cc
	bind.cc http.cc wings_socket.cc
	util.cc)
install(TARGETS galileo_wings LIBRARY DESTINATION "${CMAKE_CURRENT_LIST_DIR}")
install(TARGETS galileo_wings LIBRARY DESTINATION "${CMAKE_CURRENT_LIST_DIR}/../..")
