#!/bin/bash

# Docs by jazzy
# https://github.com/realm/jazzy
# ------------------------------

git submodule update --remote

jazzy --swift-version 2.1.1 -o ./ \
      --source-directory JSQNotificationObserverKit/JSQNotificationObserverKit/ \
      --readme JSQNotificationObserverKit/README.md \
      -a 'Jesse Squires' \
      -u 'https://twitter.com/jesse_squires' \
      -m 'JSQNotificationObserverKit' \
      -g 'https://github.com/jessesquires/JSQNotificationObserverKit'
