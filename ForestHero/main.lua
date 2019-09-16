-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

-- hide the status bar
display.setStatusBar( display.HiddenStatusBar )

-- include the Corona "composer" module
local composer = require "composer"
print( display.pixelWidth / display.actualContentWidth )

-- load menu screen
composer.gotoScene( "menu" )

