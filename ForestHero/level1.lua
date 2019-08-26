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

local hero = {}

local buttonLeft

local buttonRight

local buttonJump

local camera 
-- camera 
local function moveCamera(event)
	local leftOffset = 60

	local heroX = hero.x
	
	local screenLeft = -camera.x

	local bufferMoveArea = 380

	if heroX > leftOffset then
		if heroX > screenLeft+ bufferMoveArea then
			camera.x = -hero.x +leftOffset
		end
	else
		camera.x= 0
	end
	
end

-- hero features

local function heroFeatures()
	hero.speed = 50

end 

local function heroVelocity()
	hero:setLinearVelocity(hero.velocity, 0)

end
local sheetOptions =
{
    width = 96,
    height = 96,
    numFrames = 4
}

local moveHero=  graphics.newImageSheet( "spriteshero.png", sheetOptions )

local sequences_hero = {
    -- first sequence (consecutive frames)
	{
        name = "runLeft",
        start = 6,
        count = 2,
        time = 800,
        loopCount = 0
    },
    
	{
        name = "runRight",
        start = 2,
        count = 3,
        time = 800,
        loopCount = 0
    },
    -- next sequence (non-consecutive frames)
    {
        name = "walking",
        frames = { 1 },
        time = 400,
        loopCount = 0
    },
}

hero = display.newSprite( moveHero, sequences_hero )
local function spriteListener( event )
 
    local thisSprite = event.target  -- "event.target" references the sprite
 
    if ( event.phase == "ended" ) then 
		thisSprite:setSequence( "run" )  -- switch to "fastRun" sequence
        thisSprite:play()  -- play the new sequence
    end
end
 
-- add the event listener to the sprite
hero:addEventListener( "sprite", spriteListener )

function scene:create( event )

	
	
	local sceneGroup = self.view

	camera = display.newGroup()
	
	physics.start()
	physics.pause()

		
	print(display.screenOriginX)
	local background = display.newImageRect("fundo.png", 2000,display.contentHeight )
	background.x = display.screenOriginX
	background.y = display.screenOriginY

	print("background:",display.screenOriginX)
	
	background.anchorX = 0 
	
	background.anchorY = 0
	
	background:setFillColor( .5 )

	-- create sum
	local sol = display.newImageRect("sol.png",70, 70)
	
	sol.x = 100

	sol.y = 90
	
	-- crate clounds
	
	local cloud = display.newImageRect("nuvem.png",100, 70)
	
	cloud.x = 180



	cloud.y = 90

	
	local cloud = display.newImageRect("nuvem.png",100, 70)
	
	cloud.x = 60

	cloud.y = 100

	
	-- create ground
	local ground = display.newImageRect("terra.png",2000, 70)

	ground.anchorX = 0

	ground.anchorY = 1

	ground.x, ground.y = display.screenOriginX, display.actualContentHeight + display.screenOriginY

	
	--local groundShape = { -halfW,-34, halfW,-34, halfW,34, -halfW,34 }
	
	physics.addBody( ground, "static" )
	
	local ground1 = display.newImageRect("terra.png",400, 50)

	ground1.anchorX = 0

	ground1.anchorY = 1

	ground1.x, ground1.y = display.contentCenterX, display.actualContentHeight-50

	local groundShape = { -halfW,-34, halfW,-34, halfW,34, -halfW,34 }
	physics.addBody( ground1, "static", { friction=0.3, shape=groundShape } )

	local ground2 = display.newImageRect("terra.png",1000, 70)

	ground2.anchorX = 0

	ground2.anchorY = 1

	ground2.x, ground2.y = ground.x+800,  ground.y+20

	
	
	--local tree = display.newImageRect("arvore.png",100, 112)
	
	--tree.x = 400

	--tree.y = display.contentCenterX-60

	--local lenhador = display.newImageRect("lenhador.png",60, 60)
	
	--lenhador.x = 500

	--lenhador.y = display.contentCenterX-50

	
	
	-- Create hero

	--hero = display.newImageRect("hero.png",60,60)
	hero.x = 70

	hero.y = display.contentHeight-86
	
	
	physics.addBody( hero, { density=1, friction=0.3, bounce= 0 } )

	
	heroFeatures()
	-- Create controls
	
	-- Move to left
	
	buttonLeft = display.newImageRect("direcional2.png", 100,100)

	buttonLeft.id = "left"

	buttonLeft.x= 10 

	buttonLeft.y = display.contentHeight-20
	
	buttonLeft:addEventListener("touch",controls)


	-- Move to right
	buttonRight = display.newImageRect("direcional1.png", 100,100)

	buttonRight.id = "right"

	buttonRight.x = 70

	buttonRight.y = display.contentHeight-20
	buttonRight:addEventListener("touch", controls)

	
	
	
	-- Jump
	buttonJump = display.newImageRect("pular.png", 100,100)

	buttonJump.id = "jump"

	buttonJump.x = 450

	buttonJump.y = display.contentHeight-20

	buttonJump:addEventListener("touch", controls)

	
	-- Insert elements that follow the camera 
	
	camera:insert(background)

	camera:insert(ground)

	camera:insert(ground1)
	
	camera:insert(hero)

	

	-- Isert elements into the scene
	
	sceneGroup:insert( camera)
	
	sceneGroup:insert( buttonLeft )
	
	sceneGroup:insert( buttonRight )
	
	sceneGroup:insert( buttonJump )
	
	sceneGroup:insert( sol)
	
	sceneGroup:insert( cloud)
	
end

function controls(event)
	
	local pressed = event.target

	if event.phase == "began" then

		if pressed.id == "jump" then
			display.currentStage:setFocus(buttonJump)
				
			hero:applyLinearImpulse(0,-50, hero.x, hero.y)
			hero:setSequence( "walking" )  -- switch to "fastRun" sequence
        	hero:play()
			
		else
			local leftEdge = display.screenOriginX+150
			print(leftEdge)
			
			if pressed.id == "left" then
				if hero.x > leftEdge then	
				
				display.currentStage:setFocus(buttonLeft)
				
				print("Hero x",hero.x)
				print("Hero y",hero.y)

				hero:applyLinearImpulse(-10,0, hero.x, hero.y)
				hero:setSequence( "runLeft" )  -- switch to "fastRun" sequence
        		hero:play()
				hero.velocity = -hero.speed
				
			end
			elseif pressed.id=="right" and hero.x <1400  then
				display.currentStage:setFocus(buttonRight)

				hero:applyLinearImpulse(10,0, hero.x, hero.y)
				hero:setSequence( "runRight" )  -- switch to "fastRun" sequence
        		hero:play()
				hero.velocity = hero.speed
				
			end	
				
	
		end
	elseif event.phase == "ended" then
		
		if pressed.id == "jump" then
			
			display.currentStage:setFocus(nil)
			
		elseif pressed.id == "left" then
			
			display.currentStage:setFocus(nil)
		
		elseif pressed.id == "right" then
			
			display.currentStage:setFocus(nil)
		end

	end


end

function moveToLeft(event) 
	buttonLeft = event.target
	if event.phase == "began" then
		display.currentStage:setFocus(buttonLeft)
		hero:applyLinearImpulse(-5,0, hero.x, hero.y)
	
	end
end

function moveToRight(event) 
	buttonRight = event.target
	
	if event.phase == "began" then
		display.currentStage:setFocus(buttonRight)
		hero:applyLinearImpulse(5,0, hero.x, hero.y)
		

	end
end

function jump(event) 

	buttonJump  = event.target

	if event.phase == "began" then
		display.currentStage:setFocus(buttonJump)
		hero:applyLinearImpulse(0,-30, hero.x, hero.y)
		

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
		Runtime:addEventListener("enterFrame", moveCamera)
		
		
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
scene:addEventListener( "jump", scene )
scene:addEventListener("controls",scene)

-----------------------------------------------------------------------------------------

return scene