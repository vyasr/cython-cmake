include_guard(GLOBAL)

function(cython)
  list(APPEND CMAKE_MESSAGE_CONTEXT "cython")

  find_program(CYTHON "cython" REQUIRED)

  set(_cython_options)
  set(_cython_one_value TARGET_LANGUAGE LANGUAGE_LEVEL)
  set(_cython_multi_value CYTHON_ARGS SOURCE_FILES)

  cmake_parse_arguments(_CYTHON "${_cython_options}" "${_cython_one_value}"
                        "${_cython_multi_value}" ${ARGN})

  # Match the Cython default language level.
  set(language_level -3str)
  if(${_CYTHON_LANGUAGE_LEVEL} STREQUAL "2")
    set(language_level -2)
  elseif(${_CYTHON_LANGUAGE_LEVEL} STREQUAL "3")
    set(language_level -3)
  elseif(NOT ${_CYTHON_LANGUAGE_LEVEL} STREQUAL "3str")
    message(FATAL_ERROR "LANGUAGE_LEVEL must be one of 2, 3, or 3str")
  endif()

  set(target_language "")
  set(extension ".c")
  if(${_CYTHON_TARGET_LANGUAGE} STREQUAL "CXX")
    set(target_language "--cplus")
    set(extension ".cxx")
  elseif(NOT ${_CYTHON_TARGET_LANGUAGE} STREQUAL "C")
    message(FATAL_ERROR "TARGET_LANGUAGE must be one of C or CXX")
  endif()

  # Maintain list of generated targets
  set(CREATED_FILES "")

  foreach(cython_filename IN LISTS _CYTHON_SOURCE_FILES)
    cmake_path(GET cython_filename FILENAME cython_module)
    cmake_path(REPLACE_EXTENSION cython_module "${extension}" OUTPUT_VARIABLE cpp_filename)
    cmake_path(REPLACE_FILENAME cython_filename ${cpp_filename} OUTPUT_VARIABLE cpp_filename)
    cmake_path(REMOVE_EXTENSION cython_module)

    add_custom_command(OUTPUT ${cpp_filename}
                       DEPENDS ${cython_filename}
                       VERBATIM
                       COMMENT "Transpiling ${CMAKE_CURRENT_SOURCE_DIR}/${cython_filename} to ${CMAKE_CURRENT_SOURCE_DIR}/${cpp_filename}"
                       # TODO: Is setting the input and output paths this way a robust solution, or
                       # are there cases where it might be problematic?
                       COMMAND "${CYTHON}" ${target_language} ${language_level}
                               ${_CYTHON_CYTHON_ARGS}
                               "${CMAKE_CURRENT_SOURCE_DIR}/${cython_filename}" --output-file
                               "${CMAKE_CURRENT_BINARY_DIR}/${cpp_filename}")

    list(APPEND CREATED_FILES "${CMAKE_CURRENT_BINARY_DIR}/${cpp_filename}")
  endforeach()

  set(RAPIDS_COMPILE_CREATED_FILES ${CREATED_FILES} PARENT_SCOPE)
endfunction()
