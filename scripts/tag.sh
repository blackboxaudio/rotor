#!/bin/bash

source plugin.env

PUSH_TAG=true
DELETE_TAG=false

while [[ "$#" -gt 0 ]]; do
    case $1 in
    -d|--delete)
        DELETE_TAG=true
        PUSH_TAG=false
        shift
        ;;
    *)
        log_exit "Unknown argument: $1"
        ;;
    esac
    shift
done

if [ "$PUSH_TAG" == "true" ]; then
    if [ $(git tag -l "v$PLUGIN_VERSION") ]; then
        git tag -d "v$PLUGIN_VERSION"
    fi
    git tag "v$PLUGIN_VERSION"
    git push -u origin "v$PLUGIN_VERSION"
fi

if [ "$DELETE_TAG" == "true" ]; then
    if [ $(git tag -l "v$PLUGIN_VERSION") ]; then
        git tag -d "v$PLUGIN_VERSION"
    fi
    remote_tag=$(git ls-remote --tags origin "refs/tags/v$PLUGIN_VERSION")
    if [ -z "$remote_tag" ]; then
        printf ""
    else
        git push -d origin "v$PLUGIN_VERSION"
        echo "exists"
    fi
fi
