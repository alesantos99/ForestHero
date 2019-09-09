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

--Hero sprisheet

local sheetOptions =
{
    width = 300,
    height = 295,
    numFrames = 5
}

local moveHero=  graphics.newImageSheet( "sprittemp.png", sheetOptions )

local  buttonLeft
local buttonRight

local sequences_hero = {
    -- first sequence (consecutive frames)
	{
        name = "idleLeft",
        frames = { 5},
        loopCount = 0
    },
    
	{
        name = "walkLeft",
        frames = { 1,2,3,},
        loopCount = 0,
    	loopDirection = "forward"

    },
    {
        name = "walkRight",
        frames = { 4,5},
        loopCount = 0,
    	loopDirection = "forward"

    },
    -- next sequence (non-consecutive frames)
    
}

local hero = {} 
hero = display.newSprite( moveHero, sequences_hero )


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
	local background = display.newImageRect( "background.png", screenW, screenH)
	background.x = display.screenOriginX
	background.y = display.screenOriginY

	background.anchorX = 0 
	background.anchorY = 0
	--background:setFillColor( .5 )
	background.alpha = 0.5


	local ground = display.newImageRect("ground.png", screenW+2080,172)

	ground.x = display.screenOriginX
	
	ground.y = display.contentHeight-30

	physics.addBody( ground, "static" )
	

	hero.x = 70

	hero.y = display.contentHeight-172
	
	physics.addBody( hero, { density=1, friction=0.3, bounce= 0 } )

	buttonLeft = display.newCircle(10,10,10)

	buttonLeft.id = "left"

	buttonLeft.x= 10 

	buttonLeft.y = display.contentHeight-20
	
	buttonLeft:addEventListener("touch",controls)


	-- Move to right
	buttonRight = display.newCircle(10,10,10)

	buttonRight.id = "right"

	buttonRight.x = 70

	buttonRight.y = display.contentHeight-20
	buttonRight:addEventListener("touch", controls)


	sceneGroup:insert( background )
	sceneGroup:insert( ground)
	sceneGroup:insert( hero)
		

end
function controls(event)
	
	local pressed = event.target

	if event.phase == "began" then

		if pressed.id == "jump" then
			display.currentStage:setFocus(buttonJump)
				
			hero:applyLinearImpulse(0,-50, hero.x, hero.y)
			hero:setSequence( "idleLeft" )  -- switch to "fastRun" sequence
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
				hero:setSequence( "walkLeft" )  -- switch to "fastRun" sequence
        		hero:play()
				hero.velocity = -hero.speed
				
			end
			elseif pressed.id=="right" and hero.x <1400  then
				display.currentStage:setFocus(buttonRight)

				hero:applyLinearImpulse(10,0, hero.x, hero.y)
				hero:setSequence( "walkRight" )  -- switch to "fastRun" sequence
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

function scene:hide( event )
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

-----------------------------------------------------------------------------------------

return scene