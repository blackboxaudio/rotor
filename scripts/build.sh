#!/bin/bash

# Builds the plugin with CMake commands among other things as necessary (cloning JUCE, clearing cache, etc.).

start_time=$(date +%s)

COPY_BUILD_STEP=false
DAW_TO_OPEN=
REMOVE_PREV_BUILD=false
BUILD_TYPE=Release

COMPANY_NAME="Black Box Audio"
PLUGIN_NAME=Rotor

for i in "$@"; do
    case $i in
    -c|--copy)
        COPY_BUILD_STEP=true
        shift
        ;;
    -d=*|--daw=*)
        DAW_TO_OPEN="${i#*=}"
        shift
        ;;
    -r|--remove-prev-build)
        REMOVE_PREV_BUILD=true
        shift
        ;;
    -b=*|--build-type=*)
        BUILD_TYPE="${i#*=}"
        shift
        ;;
    esac
done

if [ ${REMOVE_PREV_BUILD} = true ]; then
    rm -rf ./bin
    echo -e "[Success] Removed previous build's folders!\n"
fi

echo -e "Configuring ${PLUGIN_NAME}...\n"
cmake -B bin . -DCMAKE_BUILD_TYPE="$BUILD_TYPE"
echo -e "\n[Success] Configured plugin build!\n"

echo -e "Building ${PLUGIN_NAME}...\n"
cmake --build bin --config ${BUILD_TYPE} --target "${PLUGIN_NAME}_All" --parallel 8
echo -e "\n[Success] Built plugin executable(s)!\n"

if [ ! -z ${DAW_TO_OPEN} ]; then
    start ${DAW_TO_OPEN}
    echo -e "[Success] Launched ${DAW_TO_OPEN} application!\n"
fi

if [ ${COPY_BUILD_STEP} = true ]; then
    if [[ ${OSTYPE} == "darwin"* ]]; then
        mkdir -p "/Library/Audio/Plug-Ins/VST3/${COMPANY_NAME}"
        rm -rf "/Library/Audio/Plug-Ins/VST3/${COMPANY_NAME}/${PLUGIN_NAME}.vst3"
        cp -r "./bin/${PLUGIN_NAME}_artefacts/${BUILD_TYPE}/VST3/${PLUGIN_NAME}.vst3" "/Library/Audio/Plug-Ins/VST3/${COMPANY_NAME}/${PLUGIN_NAME}.vst3"
        echo -e "[Success] Copied VST3 bundle to plugins directory!\n"

        rm -rf "/Library/Audio/Plug-Ins/Components/${PLUGIN_NAME}.component"
        cp -r "./bin/${PLUGIN_NAME}_artefacts/${BUILD_TYPE}/AU/${PLUGIN_NAME}.component" "/Library/Audio/Plug-Ins/Components/${PLUGIN_NAME}.component"
        echo -e "[Success] Copied AU bundle to plugins directory!\n"
    else
        mkdir -p "/c/Program Files/Steinberg/Vst3Plugins/${COMPANY_NAME}"
        rm -f "/c/Program Files/Steinberg/Vst3Plugins/${COMPANY_NAME}/${PLUGIN_NAME}.vst3"
        cp "./bin/${PLUGIN_NAME}_artefacts/${BUILD_TYPE}/VST3/${PLUGIN_NAME}.vst3/Contents/x86_64-win/${PLUGIN_NAME}.vst3" "/c/Program Files/Steinberg/Vst3Plugins/${COMPANY_NAME}/${PLUGIN_NAME}.vst3"
        echo -e "[Success] Copied VST3 bundle to plugins directory!\n"
    fi
fi

convertsecs() {
    ((m = (${1} % 3600) / 60))
    ((s = ${1} % 60))
    printf "%02dm %02ds\n" $m $s
}

end_time=$(date +%s)
execution_time=$(expr $end_time - $start_time)
echo -e "Total time elapsed:    $(convertsecs $execution_time)"

me=`basename "$0"`
echo -e "Script name:           ${me}"
