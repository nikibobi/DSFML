@echo off
dmd -ofgame game.d lib/dsfml.lib "DSFML Bins/csfml-system.lib" "DSFML Bins/csfml-window.lib" "DSFML Bins/csfml-graphics.lib" "DSFML Bins/csfml-audio.lib" "DSFML Bins/csfml-network.lib"
del *.obj
game