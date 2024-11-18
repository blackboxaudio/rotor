# Checks that the installed version of CMake can understand the following commands
cmake_minimum_required(VERSION 3.15)

# Declaring targets and describing source/ binary directories
project(Rotor VERSION 1.0.0)

# Handle environment variables
set(ENV_FILE "${CMAKE_SOURCE_DIR}/plugin.env")
include("${CMAKE_SOURCE_DIR}/cmake/load_env.cmake")
load_env_file("${ENV_FILE}")

# Declare dependency on JUCE (as installed on the local system)
add_subdirectory(vendor/juce)

juce_add_plugin(Rotor
        COMPANY_NAME "${COMPANY_NAME}"
        COMPANY_WEBSITE "https://bbx-audio.com"
        # CAUTION: Only X.Y.Z format is allowed, no stage or stage versions (e.g. 1.0.0-beta.1)
        VERSION "1.0.0"
        BUNDLE_ID "${PLUGIN_BUNDLE}"
        PRODUCT_NAME "${PLUGIN_NAME}"
        PLUGIN_NAME "${PLUGIN_NAME}"
        PLUGIN_CODE "${PLUGIN_CODE}"
        PLUGIN_MANUFACTURER_CODE BBxA
        FORMATS AU VST3
        IS_SYNTH FALSE
        IS_MIDI_EFFECT FALSE
        NEEDS_MIDI_INPUT FALSE
        NEEDS_MIDI_OUTPUT FALSE)

# Create universal binaries to handle Intel- and ARM-based MacOS
set_target_properties(Rotor PROPERTIES OSX_ARCHITECTURES "x86_64;arm64")

# Generate the JUCE header file for our source code
juce_generate_juce_header(Rotor)

# Declare necessary source files to include into the target
target_sources(Rotor PRIVATE
        src/RotorAnalyzer.cpp
        src/RotorEditor.cpp
        src/RotorLookAndFeel.cpp
        src/RotorProcessor.cpp)

# Preprocessor definitions for our target
target_compile_definitions(Rotor PUBLIC
        JUCE_WEB_BROWSER=0
        JUCE_USE_CURL=0
        JUCE_VST3_CAN_REPLACE_VST2=0
        JUCE_DISPLAY_SPLASH_SCREEN=0
        JUCE_MODAL_LOOPS_PERMITTED=1)

# Add binary data from resources folder
juce_add_binary_data(RotorData HEADER_NAME "RotorData.h" NAMESPACE RotorData SOURCES
        resources/fonts/montserrat-light.ttf
        resources/fonts/montserrat.ttf
        resources/fonts/louis-george-cafe-light.ttf
        resources/fonts/louis-george-cafe.ttf
        resources/images/background.png)

# Link libraries to the plugin's source code and other resources (i.e. binary data)
target_link_libraries(Rotor PRIVATE
        # Link-time optimization (LTO) once applicable
        RotorData
        juce::juce_audio_utils
        juce::juce_dsp
        juce::juce_opengl
        juce::juce_recommended_warning_flags
        juce::juce_recommended_config_flags
        juce::juce_recommended_lto_flags)
