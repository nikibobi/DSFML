@echo off
dmd -ofgame game.d lib/dsfml.lib "DSFML Libs/csfml-system.lib" "DSFML Libs/csfml-window.lib" "DSFML Libs/csfml-graphics.lib" "DSFML Libs/csfml-audio.lib" "DSFML Libs/csfml-network.lib"
del *.obj
game