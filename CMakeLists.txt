cmake_minimum_required(VERSION 3.5)

cmake_policy(SET CMP0074 NEW)

project(%{ProjectName} LANGUAGES CXX)

set(CMAKE_CXX_STANDARD %{cpp-std})
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

add_executable(${PROJECT_NAME})

target_compile_features(${PROJECT_NAME} PUBLIC cxx_std_11)
set_target_properties(${PROJECT_NAME} PROPERTIES CXX_EXTENSIONS OFF)

set(SOURCES %{main-path})

target_sources(
    ${PROJECT_NAME}
    PRIVATE
        ${SOURCES}
        ${HEADERS}
    @if '%{use-conan}'
        conanfile.txt
    @endif
        %{JS: value('add-readme') && "readme.md" })

source_group(sources FILES ${HEADERS} ${SOURCES})
@if '%{use-conan}'
source_group(packages FILES conanfile.txt)
@endif
@if '%{add-readme}'
source_group(docs FILES readme.md)
@endif

%{JS:
    %{packages}
    .map(pkg =>
        value("find-" + pkg["conan-name"])
            && "find_package(" + pkg["cmake-name"] + " REQUIRED)")
    .filter(Boolean)
    .join("\\n")}

target_link_libraries(
    ${PROJECT_NAME}
    PRIVATE
        %{JS:
            %{packages}
            .map(pkg =>
                value("find-" + pkg["conan-name"])
                    && pkg["target-name"]
                       .split(" "))
            .reduce((p, c) => [].concat(p, c))
            .filter(Boolean)
            .join("\\n        ") })
