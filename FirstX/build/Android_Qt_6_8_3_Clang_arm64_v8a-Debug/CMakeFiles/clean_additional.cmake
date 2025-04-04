# Additional clean files
cmake_minimum_required(VERSION 3.16)

if("${CONFIG}" STREQUAL "" OR "${CONFIG}" STREQUAL "Debug")
  file(REMOVE_RECURSE
  "CMakeFiles\\FirstX_autogen.dir\\AutogenUsed.txt"
  "CMakeFiles\\FirstX_autogen.dir\\ParseCache.txt"
  "FirstX_autogen"
  )
endif()
