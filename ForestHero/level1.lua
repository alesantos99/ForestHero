-----------------------------------------------------------------------------------------
--
-- level1.lua
--
-----------------------------------------------------------------------------------------

local composer = require( "composer" )
local scene = composer.newScene()

-- include Corona's "physics" library
local physics = require "physics"

--------------------------------------------

-- forward declarations and other locals
local screenW, screenH, halfW = display.actualContentWidth, display.actualContentHeight, display.contentCenterX

local hero

local buttonLeft

local buttonRight


function scene:create( event )

	-- Called when the scene's view does not exist.
	-- 
	-- INSERT code here to initialize the scene
	-- e.g. add display objects to 'sceneGroup', add touch listeners, etc.

	local sceneGroup = self.view

	-- We need physics started to add bodies, but we don't want the simulaton
	-- running until the scene is on the screen.
	physics.start()
	physics.pause()


	-- create a grey rectangle as the backdrop
	-- the physical screen will likely be a different shape than our defined content area
	-- since we are going to position the background from it's top, left corner, draw the
	-- background at the real top, left corner.
	local background = display.newImageRect("fundo.png", 2024,2024 )
	background.x = display.screenOriginX
	--local background = display.newRect("fundo.png" ,display.screenOriginX, display.screenOriginY, screenW, screenH )
	background.anchorX = 0 
	background.anchorY = 0
	background:setFillColor( .5 )

	-- create sum
	local sol = display.newImageRect("sol.png",70, 70)
	
	sol.x = 100

	sol.y = 90
	
	-- crate cloud
	
	local cloud = display.newImageRect("nuvem.png",100, 70)
	
	cloud.x = 180

	cloud.y = 90

	
	local cloud = display.newImageRect("nuvem.png",100, 70)
	
	cloud.x = 60

	cloud.y = 100

	local tree = display.newImageRect("arvore.png",100, 112)
	
	tree.x = 400

	tree.y = display.contentCenterX-60

	local lenhador = display.newImageRect("lenhador.png",60, 60)
	
	lenhador.x = 500

	lenhador.y = display.contentCenterX-50

	
	-- create ground
	local ground = display.newImageRect("terra.png",screenW, 70)

	ground.anchorX = 0

	ground.anchorY = 1

	ground.x, ground.y = display.screenOriginX, display.actualContentHeight + display.screenOriginY

	local groundShape = { -halfW,-34, halfW,-34, halfW,34, -halfW,34 }
	physics.addBody( ground, "static", { friction=0.3, shape=groundShape } )
	
	local ground1 = display.newImageRect("terra.png",400, 50)

	ground1.anchorX = 0

	ground1.anchorY = 1

	ground1.x, ground1.y = display.contentCenterX, display.actualContentHeight-50

	local groundShape = { -halfW,-34, halfW,-34, halfW,34, -halfW,34 }
	physics.addBody( ground1, "static", { friction=0.3, shape=groundShape } )

	

	hero = display.newImageRect("hero.png",60,60)

	hero.x = 70

	hero.y = display.contentHeight-86
	
	character = hero

	physics.addBody( hero, { density=1.0, friction=0.3, bounce= 0 } )

	buttonLeft = display.newImageRect("esquerda.png", 100,100)

	buttonLeft.x = 80

	buttonLeft.y = display.contentHeight-20
	
	buttonLeft:addEventListener("touch", moveToLeft)

	buttonRight = display.newImageRect("direita.png", 100,100)

	buttonRight.x = 100

	buttonRight.y = display.contentHeight-20
	buttonRight:addEventListener("touch", moveToRight)

	
	sceneGroup:insert( background )
	sceneGroup:insert( ground )
	sceneGroup:insert( hero )
	sceneGroup:insert( buttonLeft )
	sceneGroup:insert( buttonRight )
	sceneGroup:insert( sol)
	sceneGroup:insert( cloud)
	
	--sceneGroup:insert( grass)
	
end

function moveToLeft(event) 
	buttonLeft = event.target
	if event.phase == "began" then
		display.currentStage:setFocus(buttonLeft)
		hero:applyLinearImpulse(-10,0, hero.x, hero.y)
	
	end
end

function moveToRight(event) 
	buttonRight = event.target
	
	if event.phase == "began" then
		display.currentStage:setFocus(buttonRight)
		hero:applyLinearImpulse(10,0, hero.x, hero.y)
		

	end
end

function scene:show( event )
	local sceneGroup = self.view
	local phase = event.phase
	
	if phase == "will" then
		-- Called when the scene is still off screen and is about to move on screen
	elseif phase == "did" then
		-- Called when the scene is now on screen
		-- 
		-- INSERT code here to make the scene come alive
		-- e.g. start timers, begin animation, play audio, etc.
		physics.start()
	end
end

function scene:hide( event)
	local sceneGroup = self.view
	
	local phase = event.phase
	
	if event.phase == "will" then
		-- Called when the scene is on screen and is about to move off screen
		--
		-- INSERT code here to pause the scene
		-- e.g. stop timers, stop animation, unload sounds, etc.)
		physics.stop()
	elseif phase == "did" then
		-- Called when the scene is now off screen
	end	
	
end

function scene:destroy( event )

	-- Called prior to the removal of scene's "view" (sceneGroup)
	-- 
	-- INSERT code here to cleanup the scene
	-- e.g. remove display objects, remove touch listeners, save state, etc.
	local sceneGroup = self.view
	
	package.loaded[physics] = nil
	physics = nil
end

---------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
scene:addEventListener( "moveToLeft", scene )
scene:addEventListener( "moveToRight", scene )

-----------------------------------------------------------------------------------------

return scene