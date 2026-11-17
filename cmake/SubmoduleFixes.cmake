# Compile patched copies of the affected sources from the pinned submodules.
function(krkrz_patch_submodule_sources target patch_name)
    find_package(Git REQUIRED)
    get_target_property(source_dir ${target} SOURCE_DIR)
    get_target_property(sources ${target} SOURCES)
    set(patch_file "${CMAKE_CURRENT_FUNCTION_LIST_DIR}/../patches/${patch_name}.patch")
    set(staging_dir "${CMAKE_CURRENT_BINARY_DIR}/submodule-fixes/${patch_name}")
    set_property(DIRECTORY APPEND PROPERTY CMAKE_CONFIGURE_DEPENDS "${patch_file}")

    foreach(path IN LISTS ARGN)
        configure_file("${source_dir}/${path}" "${staging_dir}/${path}" COPYONLY)
        if(path MATCHES "\\.cpp$")
            list(FIND sources "${path}" index)
            if(index EQUAL -1)
                list(FIND sources "${source_dir}/${path}" index)
            endif()
            if(index EQUAL -1)
                message(FATAL_ERROR "${target} no longer compiles ${path}. Review ${patch_file}.")
            endif()
            list(REMOVE_AT sources ${index})
            list(INSERT sources ${index} "${staging_dir}/${path}")
        endif()
    endforeach()

    # Apply relative to the staging directory, including for builds inside the checkout.
    set(git_apply "${CMAKE_COMMAND}" -E env --unset=GIT_DIR --unset=GIT_WORK_TREE
        "GIT_CEILING_DIRECTORIES=${CMAKE_CURRENT_BINARY_DIR}"
        "${GIT_EXECUTABLE}" -c core.autocrlf=false apply --ignore-space-change)
    execute_process(COMMAND ${git_apply} "${patch_file}"
        WORKING_DIRECTORY "${staging_dir}" RESULT_VARIABLE result ERROR_VARIABLE error)
    if(NOT result STREQUAL "0")
        execute_process(COMMAND ${git_apply} --reverse --check "${patch_file}"
            WORKING_DIRECTORY "${staging_dir}" RESULT_VARIABLE already_applied ERROR_QUIET)
        if(NOT already_applied STREQUAL "0")
            message(FATAL_ERROR "Could not apply ${patch_file} to ${source_dir}\n${error}")
        endif()
    endif()

    set_property(TARGET ${target} PROPERTY SOURCES "${sources}")
endfunction()

if(TARGET movieplayer)
    krkrz_patch_submodule_sources(movieplayer movie-player-looper
        src/common/MessageLooper.cpp src/common/MessageLooper.h)
    target_include_directories(movieplayer BEFORE PRIVATE
        "${CMAKE_CURRENT_BINARY_DIR}/submodule-fixes/movie-player-looper/src/common")

    # The WebM backend lives under src/windows and also builds on desktop Unix.
    if(NOT ANDROID)
        krkrz_patch_submodule_sources(movieplayer movie-player-playback
            src/windows/MoviePlayer.cpp src/windows/MoviePlayerCore.cpp
            src/windows/MoviePlayerCore.h)
    endif()
endif()

if(KRKRZ_VARIANT STREQUAL "WIN")
    if(CMAKE_SIZEOF_VOID_P EQUAL 8)
        set(krkrz_video_target krkrz64)
    else()
        set(krkrz_video_target krkrz)
    endif()
    krkrz_patch_submodule_sources(${krkrz_video_target} win32-video-state
        win32/visual/VideoOvlImpl.cpp)
endif()

if(TARGET menu)
    krkrz_patch_submodule_sources(menu win32-menu-shortcuts Main.cpp)
    get_target_property(menu_source_dir menu SOURCE_DIR)
    target_include_directories(menu BEFORE PRIVATE "${menu_source_dir}")
endif()
