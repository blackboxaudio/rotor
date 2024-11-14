#!/bin/bash

printf "Formatting code...\n"
find src/ -name '*.h' -o -name '*.cpp' | xargs clang-format -i --style=WebKit
if [ $? -ne 0 ]; then
    printf "Failed to format source code\n"
    exit 1
fi

printf "Done.\n"
