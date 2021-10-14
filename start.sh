#!/bin/bash
echo "hei"
./bin/live_chat eval "LiveChat.Release.create"
./bin/live_chat eval "LiveChat.Release.migrate"
./bin/live_chat "start"
