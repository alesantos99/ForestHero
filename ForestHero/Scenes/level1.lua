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

local wallLeft

local  wallRight

local  wallTop

local   wallBottom

-- Button's

local  buttonLeft


local buttonRight


local buttonJump

local  buttonShoot 

--Hero sprisheet

local sheetOptions =
{
    width = 209,
    height = 257,
    numFrames = 6
}

local moveHero=  graphics.newImageSheet( "Images/spritesmovendo.png", sheetOptions )

local  heroX 

local  heroY 

local sequences_hero = {
    -- first sequence (consecutive frames)
	{
        name = "idleLeft",
        frames = { 1},
        loopCount = 0
    },
    {
        name = "idleRight",
        frames = { 3},
        loopCount = 0
    },
    
	{
        name = "walkLeft",
        --start = 1,
        --count = 2,
        frames = { 1,2,1},
        time = 400,
        loopCount = 0,
    	loopDirection = "forward"

    },
    {
        name = "walkRight",
        start = 3,
        time = 	300,
        count = 2,
        loopCount = 0,
    	loopDirection = "forward"

    },
    {
        name = "jumpLeft",
        frames = { 6},
        loopCount = 0
    },
    {
        name = "jumpRight",
        frames = { 5},
        loopCount = 0
    },
    -- next sequence (non-consecutive frames)
    
}

local hero = {} 

hero = display.newSprite( moveHero, sequences_hero )

hero:setSequence("idleRight")

hero:play()


local  sheetOptions1 = {

	width = 239,
	height = 260,
	frames = 6
}

local atackHero=  graphics.newImageSheet( "Images/spritesatacando.png", sheetOptions1 )


local sequenceAtack ={

	{
        name = "shootArrowLeft",
        
        frames = { 1,5},
        time = 400,
        loopCount = 0,
    	loopDirection = "forward"

    },

    {
        name = "shootArrowRight",
        
        frames = { 2,6},
        time = 400,
        loopCount = 0,
    	loopDirection = "forward"

    }
    
}
 


function scene:create( event )



	local sceneGroup = self.view

	physics.start()

	physics.pause()


	local background = display.newImageRect( "Images/background.png", screenW, screenH)
	background.x = display.screenOriginX
	background.y = display.screenOriginY

	background.anchorX = 0 
	background.anchorY = 0
	--background:setFillColor( .5 )
	background.alpha = 0.5


	local ground = display.newImageRect("Images/ground.png", screenW+2080,200)

	ground.x = display.screenOriginX
	
	ground.y = display.contentHeight-30

	ground.id = "ground"

	ground.objType = "ground"

	physics.addBody( ground, "static",{ bounce=0.0, friction=0.3 } )
	



	hero.x = 100

	hero.id = "hero"
	hero.y = display.contentHeight-172

	heroX = hero.x
	heroY = hero.y

	hero.isFixedRotation = true
    hero.sensorOverlaps = 0
    

	physics.addBody( hero, { density=1, friction=0.3, bounce= 0.0 } )

	



	buttonLeft = display.newImageRect("Images/controleesquerdo.png", 100,100)

	buttonLeft.id = "left"

	buttonLeft.x= 200

	buttonLeft.y = display.contentHeight-80
	
	buttonLeft:addEventListener("touch",doControls)

	 
	buttonShoot = display.newCircle(50,50,50)
	



	-- Move to right


	buttonRight = display.newImageRect("Images/controledireito.png", 100,100)

	buttonRight.id = "right"

	buttonRight.x = 400

 	buttonRight.y = display.contentHeight-80
	buttonRight:addEventListener("touch", doControls)


	-- jumpRight

	buttonJump = display.newImageRect("Images/pulo.png", 100,100)
	buttonJump.id = "jump"

	buttonJump.x = 1700

 	buttonJump.y = display.contentHeight-80
	buttonJump:addEventListener("touch", doControls)

	-- shoot

	buttonShoot.x = 1900
	buttonShoot.y = display.contentHeight-80
	buttonShoot:addEventListener("touch", doControls)
	buttonShoot.id = "shoot"


	Runtime:addEventListener("collision",jumpCollide)	
	sceneGroup:insert( background )
	sceneGroup:insert( ground)
	sceneGroup:insert( hero)
	sceneGroup:insert( buttonLeft )
	sceneGroup:insert( buttonRight)
	sceneGroup:insert( buttonJump)
	

end



function doControls(event)
	local pressed = event.target

	if event.phase == "began" then

		if pressed.id == "left" then
			if(hero.x>80 ) then
				display.currentStage:setFocus(buttonLeft)
				
				print("Hero x",hero.x)
				print("Hero y",hero.y)

				hero:applyLinearImpulse(-50,0, hero.x, hero.y)
				hero:setSequence( "walkLeft" )  -- switch to "fastRun" sequence
	    		hero:play()
				print("Hero x",hero.x)
				print("Hero y",hero.y)

				--hero.velocity = -hero.speed
			end
		elseif pressed.id == "right" then

			display.currentStage:setFocus(buttonRight)

			hero:applyLinearImpulse(50,0, hero.x, hero.y)
			hero:setSequence( "walkRight" )  -- switch to "fastRun" sequence
    		hero:play()
			print("Hero x",hero.x)
			print("Hero y",hero.y)

			--hero.velocity = hero.speed
		elseif pressed.id == "jump" and hero.sensorOverlaps > 0 then
			
			
				
				display.currentStage:setFocus(buttonJump)
				local vx, vy = hero:getLinearVelocity()
				hero:setLinearVelocity( vx, 0 )	
				hero:applyLinearImpulse(0,-700, hero.x, hero.y)
				hero.count = 1
				hero:setSequence( "jumpRight" )  -- switch to "fastRun" sequence
	    		hero:play()
				--heroJumps = false
				print("Hero x",hero.x)
				print("Hero y",hero.y)
				--heroJumps = heroJumps+1
			
		elseif pressed.id == "shoot" then
			local bullet = display.newCircle( 100, 100, 10 )

			bullet.x = hero.x

			bullet.y = hero.y


			physics.addBody( bullet, "dynamic", { radius=10 } )
			bullet.gravityScale = 0
			 
			-- Make the object a "bullet" type object
			bullet.isBullet = true
			 
			bullet:setLinearVelocity( 800, 0 )

		end

	elseif event.phase == "ended" then 	
		if pressed.id == "left" then

			display.currentStage:setFocus(nil)
			
		elseif pressed.id == "right" then
			
			display.currentStage:setFocus(nil)
		
		elseif pressed.id == "jump" then
			
			display.currentStage:setFocus(nil)
			
			
		
		end
		
			
	end 

end


function jumpCollide( event)


 	local object1 = event.object1

 	local object2 = event.object2
 	
 	print(object1.id,object2.id)

 	if ( object1.id == "ground" and object2.id == "hero" ) then
 		print("passei")	
        -- Foot sensor has entered (overlapped) a ground object
        if ( event.phase == "began" ) then
            object2.sensorOverlaps = object2.sensorOverlaps + 1
        -- Foot sensor has exited a ground object
        elseif ( event.phase == "ended" ) then
            object2.sensorOverlaps = object2.sensorOverlaps - 1
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

scene:addEventListener( "doConrtrols", scene )

-----------------------------------------------------------------------------------------

return scene