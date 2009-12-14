#!/bin/sh
test -f Main.swf && mv Main.swf oldMain.swf
mxmlc -debug Main.as
test -f Main.swf && flashplayer-debug Main.swf
