local storyboard = require "storyboard"
local dbScn = require("db")
local scene = storyboard.newScene()
local _W = display.contentWidth 
local _H = display.contentHeight
local timers = {}

local imgBGMain 
local imgBGStart 
local txtOyunIsmi
local txtSeviye
local txtIstatistik
local txtNasilOynanir
local txtOyunHakkinda
local imgBGIst
local txtToplam
local txtFinish
local txtBestTime
local txtSure
local imgBGHow
local txtHow
local imgBGCredits
local txtCredit1
local txtCredit2
local txtCredit3
local txtCredit4
local txtCredit5
local txtCredit6
local txtCredit7
local txtCredit8
local imgCrossIcon
local imgBumpyIcon
local txtBasla
local reklamSure = 0
local reklamBasladi = false
ads = require "ads"



local function killGameOverItems()
	if imgBGMain ~= nil then
		imgBGMain:removeSelf()
		imgBGMain = nil
	end
	if imgBGStart ~= nil then
		imgBGStart:removeSelf()
		imgBGStart = nil
	end
	if txtOyunIsmi ~= nil then
		txtOyunIsmi:removeSelf()
		txtOyunIsmi = nil
	end
	if txtSeviye ~= nil then
		txtSeviye:removeSelf()
		txtSeviye = nil
	end
	if txtIstatistik ~= nil then
		txtIstatistik:removeSelf()
		txtIstatistik = nil
	end
	if txtNasilOynanir ~= nil then
		txtNasilOynanir:removeSelf()
		txtNasilOynanir = nil
	end
	if txtOyunHakkinda ~= nil then
		txtOyunHakkinda:removeSelf()
		txtOyunHakkinda = nil
	end
	if txtBasla ~= nil then
		txtBasla:removeSelf()
		txtBasla = nil
	end
	
end
local function changeSeviyeText()

	if gameMode==1 then		
		txtSeviye.text = "Level: Regular"
	else
		txtSeviye.text = "Level: Easy"
	end

end

local function CreateMenuMaterial()
	killGameOverItems()        

	local function onBGTouch( self, event )
	--	if event.phase == "began" then
		killGameOverItems()        
		storyboard.gotoScene( "game" ) 


		return true
	--	end
	end

	local function onSeviyeTouch( self, event )
		if event.phase == "began" then
			if gameMode==1 then		
				gameMode=2 
				updateGameMode()
				changeSeviyeText()
			else 
				gameMode=1 
				updateGameMode()
				changeSeviyeText()
			end
			return true
		end
	end

	local function onIstatistikTouch( self, event )
		if event.phase == "began" then

			local function kill(self, event)
				if event.phase == "began" then
					if imgBGIst ~= nil then
						imgBGIst:removeSelf()
						imgBGIst = nil
					end
					if txtToplam ~= nil then
						txtToplam:removeSelf()
						txtToplam = nil
					end
					if txtFinish ~= nil then
						txtFinish:removeSelf()
						txtFinish = nil
					end
					if txtBestTime ~= nil then
						txtBestTime:removeSelf()
						txtBestTime = nil
					end
					if txtSure ~= nil then
						txtSure:removeSelf()
						txtSure = nil
					end
				return true
				end
			end

			imgBGIst =   display.newImageRect("img/istatistikbg.png", 320,480 ) 
			imgBGIst:setReferencePoint( display.CenterReferencePoint )
			imgBGIst.x=_W /2
			imgBGIst.y=_H / 2 
			imgBGIst.xScale=0.1
			imgBGIst.yScale=0.1
			imgBGIst.alpha=0.1
			imgBGIst.touch = kill
			imgBGIst:addEventListener( "touch", imgBGIst )
			
			transition.to (imgBGIst, {time =1, xScale= 1 , yScale=1,alpha=1} )  
			
		 	findStatics()

			local function yaz()
				if gameMode==1 then		
					sMod="Regular Game"
				else
					sMod="Easy Game"
				end
				if sBestTime==999999 then
					sTempBest = "0"
				else
					sTempBest=sBestTime
				end
	
				txtToplam= display.newText("Total Game: " .. sPlayedGame,110,180, "Futura", 12 )
				txtToplam:setTextColor(0,0,93)
	
				txtFinish= display.newText("Finished Game: " .. sFinishedGame,110,210, "Futura", 12 )
				txtFinish:setTextColor(0,0,93)

				txtBestTime= display.newText("Best Time: " ..  string.format("%.2d:%.2d",  sTempBest/60%60, sTempBest%60) ,110,240, "Futura", 12 )
				txtBestTime:setTextColor(0,0,93)

				txtSure= display.newText("Total Time: " .. string.format("%.2d:%.2d",  sTotalTime/60%60, sTotalTime%60),110,270, "Futura", 12 )
				txtSure:setTextColor(0,0,93)
			end
			
			timer.performWithDelay( 550, yaz )

			return true
		end
	end

	local function onNasilOynanirTouch( self, event )
		if event.phase == "began" then
			local function kill(self, event)
				if event.phase == "began" then
					if imgBGHow ~= nil then
						imgBGHow:removeSelf()
						imgBGHow = nil
					end
					if txtHow ~= nil then
						txtHow:removeSelf()
						txtHow = nil
					end
				return true
				end
			end
			imgBGHow =   display.newImageRect("img/bghowtoplay.png", 320,480 ) 
			imgBGHow:setReferencePoint( display.CenterReferencePoint )
			imgBGHow.x=_W /2
			imgBGHow.y=_H / 2 
			imgBGHow.xScale=0.1
			imgBGHow.yScale=0.1
			imgBGHow.alpha=0.1
			imgBGHow.touch = kill
			imgBGHow:addEventListener( "touch", imgBGHow )
			
			transition.to (imgBGHow, {time =500, xScale= 1 , yScale=1,alpha=1} )  

			local function yaz()
				txtHow= display.newText("",20,30,280,460, "Minion Pro", 12 )
				txtHow:setTextColor(0,0,93)
				txtHow.text="*Words Fly has the square of hollow in both directions, including horizontal and vertical writing is a game that you solve. "
				txtHow.text=txtHow.text .. "\n"
				txtHow.text=txtHow.text .. ""--*This game of ours is a large square format and creates a regular pattern in each new game. "
				txtHow.text=txtHow.text .. ""--\n"
				txtHow.text=txtHow.text .. "*The purpose of the letters written to each square , from left to right and top to bottom is creating meaningful words. "
				txtHow.text=txtHow.text .. "\n"
				txtHow.text=txtHow.text .. ""--*To begin our game and to find the right words, the words are given clue. This hints at least 3 digits and maximum 10 digits. In addition, each word in itself is positioned by the number of households. "
				txtHow.text=txtHow.text .. ""--\n"
				txtHow.text=txtHow.text .. "*Each new game changing this word by clicking, place it where you want to click it once will be enough for positioning of words."
				txtHow.text=txtHow.text .. "\n"
				txtHow.text=txtHow.text .. "*When the word is correctly in place many intersecting horizontal and vertical letter word you can see that the joint letter. If you placed the letters of the word , the word or words do not correspond with intersecting if it is misplaced words . Placed inside the wrong word by clicking on the take back again and you can continue where you left off ."
				txtHow.text=txtHow.text .. "\n"
				txtHow.text=txtHow.text .. ""--*There are two different levels changing our content. "
				txtHow.text=txtHow.text .. ""--n"
				txtHow.text=txtHow.text .. "*İsterseniz kolay seviye de isterseniz de normal seviye de oynayıp, kısa sure de tamamlamaya çalışarak oyun istatistiklerinizi tutabilirsiniz."
				txtHow.text=txtHow.text .. "\n"
				txtHow.text=txtHow.text .. "*You want to play at normal levels or the easy levels? Trying to complete the game in a short time you can keep your stats. "
				txtHow.text=txtHow.text .. "\n"
				txtHow.text=txtHow.text .. "*In your home, on your lunch break , on the bus, you can easily play with your family or your friends. "

			end
			
			timer.performWithDelay( 550, yaz )

			return true
		end
	end

	local function onOyunHakkindaTouch( self, event )
		if event.phase == "began" then
			local function kill(self, event)
				if event.phase == "began" then
					if imgBGCredits ~= nil then
						imgBGCredits:removeSelf()
						imgBGCredits = nil
					end
					if txtCredit1 ~= nil then
						txtCredit1:removeSelf()
						txtCredit1 = nil
					end
					if txtCredit2 ~= nil then
						txtCredit2:removeSelf()
						txtCredit2 = nil
					end
					if txtCredit3 ~= nil then
						txtCredit3:removeSelf()
						txtCredit3 = nil
					end
					if txtCredit4 ~= nil then
						txtCredit4:removeSelf()
						txtCredit4 = nil
					end
					if txtCredit5 ~= nil then
						txtCredit5:removeSelf()
						txtCredit5 = nil
					end
					if txtCredit6 ~= nil then
						txtCredit6:removeSelf()
						txtCredit6 = nil
					end
					if txtCredit7 ~= nil then
						txtCredit7:removeSelf()
						txtCredit7 = nil
					end
					if txtCredit8 ~= nil then
						txtCredit8:removeSelf()
						txtCredit8 = nil
					end
					if imgCrossIcon ~= nil then
						imgCrossIcon:removeSelf()
						imgCrossIcon = nil
					end
					if imgBumpyIcon ~= nil then
						imgBumpyIcon:removeSelf()
						imgBumpyIcon = nil
					end

				return true
				end
			end
			imgBGCredits =   display.newImageRect("img/bgcredits.png", 320,480 ) 
			imgBGCredits:setReferencePoint( display.CenterReferencePoint )
			imgBGCredits.x=_W /2
			imgBGCredits.y=_H / 2 
			imgBGCredits.xScale=0.1
			imgBGCredits.yScale=0.1
			imgBGCredits.alpha=0.1

			imgBGCredits.touch = kill
			imgBGCredits:addEventListener( "touch", imgClose )
			
			transition.to (imgBGCredits, {time =1, xScale= 1 , yScale=1,alpha=1} )  

			local function yaz()
				local function openLink1( self, event)
					if event.phase == "began" then
						system.openURL("http://www.gunappsios.com")				
						return true
					end
				end
				local function openLink2( self, event)
					if event.phase == "began" then
						system.openURL("https://itunes.apple.com/us/app/bumpy-smiley/id792036013")				
						return true
					end
				end
				local function openLink3( self, event)
					if event.phase == "began" then
						system.openURL("https://itunes.apple.com/us/app/ucan-sozcukler/id845315604")				
						return true
					end
				end
				
				txtCredit1= display.newText("",152,40, "Chalkduster", 14 )
				txtCredit1:setReferencePoint( display.TopLeftReferencePoint )
				txtCredit1:setTextColor(0,93,0)
				txtCredit1.text="Programmer"

				txtCredit2= display.newText("",152,60, "Chalkduster", 18 )
				txtCredit2:setReferencePoint( display.TopLeftReferencePoint )
				txtCredit2:setTextColor(0,93,0)
				txtCredit2.text="Gürcan Hamalı"

				txtCredit3= display.newText("",152,130, "Chalkduster", 14 )
				txtCredit3:setReferencePoint( display.TopLeftReferencePoint )
				txtCredit3:setTextColor(0,93,0)
				txtCredit3.text="Graphic Designer"

				txtCredit4= display.newText("",152,150, "Chalkduster", 18 )
				txtCredit4:setReferencePoint( display.TopLeftReferencePoint )
				txtCredit4:setTextColor(0,93,0)
				txtCredit4.text="Neslihan Hamalı"

				txtCredit5= display.newText("",152,220, "Chalkduster", 14 )
				txtCredit5:setReferencePoint( display.TopLeftReferencePoint )
				txtCredit5:setTextColor(0,93,0)
				txtCredit5.text="(c) 2014 Gun Apss"

				txtCredit6= display.newText("",152,240, "Chalkduster", 18 )
				txtCredit6:setReferencePoint( display.TopLeftReferencePoint )
				txtCredit6:setTextColor(0,93,0)
				txtCredit6.text="www.gunappsios.com"

				txtCredit5.touch = openLink1
				txtCredit5:addEventListener( "touch", txtCredit5 )

				txtCredit6.touch = openLink1
				txtCredit6:addEventListener( "touch", txtCredit6 )

				imgBumpyIcon =   display.newImageRect("img/bumpyIcon.png", 50,50 ) 
				imgBumpyIcon:setReferencePoint( display.CenterReferencePoint )
				imgBumpyIcon.x= 70
				imgBumpyIcon.y= 325

				txtCredit7= display.newText("",162,315, "Chalkduster", 18 )
				txtCredit7:setReferencePoint( display.TopLeftReferencePoint )
				txtCredit7:setTextColor(0,93,0)
				txtCredit7.text="Bumpy Smiley"

				imgBumpyIcon.touch = openLink2
				imgBumpyIcon:addEventListener( "touch", imgBumpyIcon )

				txtCredit7.touch = openLink2
				txtCredit7:addEventListener( "touch", txtCredit7 )

				imgCrossIcon =   display.newImageRect("img/crossIcon.png", 50,50 ) 
				imgCrossIcon:setReferencePoint( display.CenterReferencePoint )
				imgCrossIcon.x= 70
				imgCrossIcon.y= 415

				txtCredit8= display.newText("",172,405, "Chalkduster", 18 )
				txtCredit8:setReferencePoint( display.TopLeftReferencePoint )
				txtCredit8:setTextColor(0,93,0)
				txtCredit8.text="Uçan Sözcükler"

				imgCrossIcon.touch = openLink3
				imgCrossIcon:addEventListener( "touch", imgBumpyIcon )

				txtCredit8.touch = openLink3
				txtCredit8:addEventListener( "touch", txtCredit7 )
				
			end
			
			timer.performWithDelay( 1, yaz )

			return true
		end
	end



	imgBGMain =   display.newImageRect("img/bgmenu.png", 320,480 ) 
	imgBGMain:setReferencePoint( display.CenterReferencePoint )
	imgBGMain.x=_W /2
	imgBGMain.y=_H / 2 


	imgBGStart =   display.newImageRect("img/start.png", 100,120 ) 
	imgBGStart:setReferencePoint( display.CenterReferencePoint )
	imgBGStart.x= display.contentWidth - imgBGStart.width + 50
	imgBGStart.y=_H / 2 + 180

	imgBGStart:addEventListener( "touch", onBGTouch )

--	txtOyunIsmi= display.newText("Uçan Sözcükler" ,50,120, "Chalkduster", 14 )
	txtOyunIsmi =   display.newImageRect("img/logo.png", 120,50 ) 
	txtOyunIsmi:setReferencePoint( display.CenterReferencePoint )
	txtOyunIsmi.x=160
	txtOyunIsmi.y=70
--	txtOyunIsmi:setTextColor(0,0,93)


	txtSeviye= display.newText("" ,50,120, native.systemFont, 13 )
	txtSeviye:setReferencePoint( display.CenterReferencePoint )
	txtSeviye.x=140
	txtSeviye.y=248
	txtSeviye:setTextColor(0,0,93)
	changeSeviyeText()

	txtSeviye.touch = onSeviyeTouch
	txtSeviye:addEventListener( "touch", txtSeviye )

	txtIstatistik= display.newText("Statistics" ,50,120,native.systemFont, 13 )
	txtIstatistik:setReferencePoint( display.CenterReferencePoint )
	txtIstatistik.x=140
	txtIstatistik.y=275
	txtIstatistik:setTextColor(0,0,93)

	txtIstatistik.touch = onIstatistikTouch
	txtIstatistik:addEventListener( "touch", txtIstatistik )

	txtNasilOynanir= display.newText("How to Play" ,50,120, native.systemFont, 13 )
	txtNasilOynanir:setReferencePoint( display.CenterReferencePoint )
	txtNasilOynanir.x=160
	txtNasilOynanir.y=298
	txtNasilOynanir:setTextColor(0,0,93)

	txtNasilOynanir.touch = onNasilOynanirTouch
	txtNasilOynanir:addEventListener( "touch", txtNasilOynanir )

	txtOyunHakkinda= display.newText("Credits" ,50,120, native.systemFont, 13)
	txtOyunHakkinda:setReferencePoint( display.CenterReferencePoint )
	txtOyunHakkinda.x=150
	txtOyunHakkinda.y=322
	txtOyunHakkinda:setTextColor(0,0,93)

	txtOyunHakkinda.touch = onOyunHakkindaTouch
	txtOyunHakkinda:addEventListener( "touch", txtOyunHakkinda )

	txtBasla=display.newText("Play" ,50,120, native.systemFont, 12)
	txtBasla:setReferencePoint( display.CenterReferencePoint )
	txtBasla.x=270
	txtBasla.y=388
	txtBasla:setTextColor(0,0,93)
	txtBasla.rotation = -10

	txtBasla:addEventListener( "touch", onBGTouch )


end

local function alphaSet(a)
	if imgBGStart ~= nil then
		imgBGStart.alpha = a
	end
	if txtBasla ~= nil then
		txtBasla.alpha = a
	end
end

local function reklamTimerUpdate ()

reklamSure=reklamSure + 1
	if reklamBasladi == true or reklamSure>=15 then
		timer.performWithDelay( 1000, alphaSet(1) )		
	end
end


function RunAdModAds()
	local provider = "admob"

	-- Your application ID
	local appID = "ca-app-pub-6414961667069598/9525696663"

	-- Load Corona 'ads' library

	local function adListener( event )
    	if event.isError then
	  --      statusText.text = event.response
		  reklamBasladi=true
    	else
		  reklamBasladi=true    	
	    --    statusText.text = "Hata Yok"
    	end
	end

	ads.hide()		
	ads.init( provider,appID, adListener )
	ads.show( "interstitial", { x=0, y=0 , appId = "ca-app-pub-6414961667069598/9525696663"} )
end

	


function scene:createScene( event )
         screenGroup = self.view
 

        -----------------------------------------------------------------------------
                
        --      CREATE display objects and add them to 'group' here.
        --      Example use-case: Restore 'group' from previously saved state.
        
        -----------------------------------------------------------------------------
end



 
-- Called BEFORE scene has moved onscreen:
function scene:willEnterScene( event )
        local screenGroup = self.view
        
        -----------------------------------------------------------------------------
                
        --      This event requires build 2012.782 or later.
        
        -----------------------------------------------------------------------------
        
end
 
-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
        local screenGroup = self.view
	findGameMode()
	CreateMenuMaterial()
	reklamBasladi=false
	alphaSet(1)
	reklamSure=0
--	RunAdModAds()

	--timers.reklamTimerUpdate = timer.performWithDelay(200, reklamTimerUpdate, 0)
 	
        -----------------------------------------------------------------------------
                
        --      INSERT code here (e.g. start timers, load audio, start listeners, etc.)
        
        -----------------------------------------------------------------------------
        
        --storyboard.purgeScene( "game-scene" )

	--print( "1: enterScene event" )
	
	-- remove previous scene's view
	--storyboard.purgeScene( "game-scene" )
	


end
 
 
-- Called when scene is about to move offscreen:
function scene:exitScene( event )
        local screenGroup = self.view
        
--	if timers.reklamTimerUpdate then 
--		timer.cancel(timers.reklamTimerUpdate)
--		timers.reklamTimerUpdate = nil
--	 end

        -----------------------------------------------------------------------------
        
        --      INSERT code here (e.g. stop timers, remove listeners, unload sounds, etc.)
        
        -----------------------------------------------------------------------------
        
end
 
-- Called AFTER scene has finished moving offscreen:
function scene:didExitScene( event )
        local screenGroup = self.view
        
        -----------------------------------------------------------------------------
                
        --      This event requires build 2012.782 or later.
        
        -----------------------------------------------------------------------------
        
end
 
 
-- Called prior to the removal of scene's "view" (display group)
function scene:destroyScene( event )
        local screenGroup = self.view
        
        -----------------------------------------------------------------------------
        
        --      INSERT code here (e.g. remove listeners, widgets, save state, etc.)
        
        -----------------------------------------------------------------------------
        
end
 
-- Called if/when overlay scene is displayed via storyboard.showOverlay()
function scene:overlayBegan( event )
        local screenGroup = self.view
        local overlay_scene = event.sceneName  -- overlay scene name
        
        -----------------------------------------------------------------------------
                
        --      This event requires build 2012.797 or later.
        
        -----------------------------------------------------------------------------
        
end
 
-- Called if/when overlay scene is hidden/removed via storyboard.hideOverlay()
function scene:overlayEnded( event )
        local screenGroup = self.view
        local overlay_scene = event.sceneName  -- overlay scene name
 
        -----------------------------------------------------------------------------
                
        --      This event requires build 2012.797 or later.
        
        -----------------------------------------------------------------------------
        
end
 
 
 
---------------------------------------------------------------------------------
-- END OF YOUR IMPLEMENTATION
---------------------------------------------------------------------------------
 
-- "createScene" event is dispatched if scene's view does not exist
scene:addEventListener( "createScene", scene )
 
-- "willEnterScene" event is dispatched before scene transition begins
scene:addEventListener( "willEnterScene", scene )
 
-- "enterScene" event is dispatched whenever scene transition has finished
scene:addEventListener( "enterScene", scene )
 
-- "exitScene" event is dispatched before next scene's transition begins
scene:addEventListener( "exitScene", scene )
 
-- "didExitScene" event is dispatched after scene has finished transitioning out
scene:addEventListener( "didExitScene", scene )
 
-- "destroyScene" event is dispatched before view is unloaded, which can be
-- automatically unloaded in low memory situations, or explicitly via a call to
-- storyboard.purgeScene() or storyboard.removeScene().
scene:addEventListener( "destroyScene", scene )
 
-- "overlayBegan" event is dispatched when an overlay scene is shown
scene:addEventListener( "overlayBegan", scene )
 
-- "overlayEnded" event is dispatched when an overlay scene is hidden/removed
scene:addEventListener( "overlayEnded", scene )
 
---------------------------------------------------------------------------------
 
return scene