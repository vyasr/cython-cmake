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
  set(language_level --3str)
  if("${_CYTHON_LANGUAGE_LEVEL}" STREQUAL "2")
    set(language_level -2)
  elseif("${_CYTHON_LANGUAGE_LEVEL}" STREQUAL "3")
    set(language_level -3)
  elseif(NOT "${_CYTHON_LANGUAGE_LEVEL}" STREQUAL "3str" AND NOT "${_CYTHON_LANGUAGE_LEVEL}" STREQUAL "")
    message(FATAL_ERROR "LANGUAGE_LEVEL must be one of 2, 3, or 3str")
  endif()

  set(target_language "")
  set(extension ".c")
  if("${_CYTHON_TARGET_LANGUAGE}" STREQUAL "CXX")
    set(target_language "--cplus")
    set(extension ".cxx")
  elseif(NOT "${_CYTHON_TARGET_LANGUAGE}" STREQUAL "C" AND NOT "${_CYTHON_TARGET_LANGUAGE}" STREQUAL "")
    message(FATAL_ERROR "TARGET_LANGUAGE must be one of C or CXX")
  endif()

  # Maintain list of generated targets
  set(CREATED_FILES "")

  foreach(cython_filename IN LISTS _CYTHON_SOURCE_FILES)
    cmake_path(GET cython_filename FILENAME cython_module)
    cmake_path(REPLACE_EXTENSION cython_module "${extension}" OUTPUT_VARIABLE transpiled_filename)
    cmake_path(REPLACE_FILENAME cython_filename ${transpiled_filename} OUTPUT_VARIABLE transpiled_filename)
    cmake_path(REMOVE_EXTENSION cython_module)

    set(full_cython_filename "${CMAKE_CURRENT_SOURCE_DIR}/${cython_filename}")
    set(full_transpiled_filename "${CMAKE_CURRENT_BINARY_DIR}/${transpiled_filename}")

    # Have to ensure that the directory exists before we can write to it.
    cmake_path(GET full_transpiled_filename PARENT_PATH transpiled_directory)
    file(MAKE_DIRECTORY ${transpiled_directory})

    add_custom_command(OUTPUT "${full_transpiled_filename}"
                       DEPENDS "${full_cython_filename}"
                       VERBATIM
                       COMMENT "Transpiling ${full_cython_filename} to ${full_transpiled_filename}"
                       # TODO: Is setting the input and output paths this way a robust solution, or
                       # are there cases where it might be problematic?
                       COMMAND "${CYTHON}" ${target_language} ${language_level}
                               ${_CYTHON_CYTHON_ARGS}
                               "${full_cython_filename}" --output-file
                               "${full_transpiled_filename}")

    # Create a target that can be depended on by downstream targets to ensure
    # that the Cython file is compiled.
    add_custom_target(
        "${cython_module}_transpiled"
        DEPENDS "${full_transpiled_filename}"
    )
    list(APPEND CREATED_FILES "${CMAKE_CURRENT_BINARY_DIR}/${transpiled_filename}")
  endforeach()

  set(CYTHON_COMPILE_CREATED_FILES ${CREATED_FILES} PARENT_SCOPE)
endfunction()
