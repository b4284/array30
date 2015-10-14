#!/bin/bash

WORKMAN='avmhrtgyuneolkp;qwsbfcdxjz./i,'
QWERTY='abcdefghijklmnopqrstuvwxyz./;,'

guile -e main convert-layout.scm "${1}" "${2}" "${QWERTY}" "${WORKMAN}"
