#!/bin/bash

fish_cmd_exists() {
    fish -c "$1 -v" &> /dev/null
}
