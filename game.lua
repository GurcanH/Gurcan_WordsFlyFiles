local storyboard = require( "storyboard" )
local scene = storyboard.newScene()
local _W = display.contentWidth 
local _H = display.contentHeight
local wordsScn = require("words")
local dbScn = require("db")
local wordsonTable = {}
local sDikeySira = {}
local nYatayCount=10
local nDikeyCount=10
local bg = {}
local bgtext = {}
local sTemp=""
local mRandom = math.random
local sira=0
local bgFinish={}
local bgFinish2={}
local bgFinish3={}
local timers = {}
local isGamePaused = false
local alpDerece
--print(gameMode)
local bFound = false


local ilkX = 0 
local sonX = 0 
local ilkY = 0 
local sonY = 0 
local bYatayKelimeVar = false
local bDikeyKelimeVar = false
local bOyunBitti = false

local imgBGMain
local imgBGMainBoard 
local imgButtonNewGame 
local imgButtonMainMenu 
local imgButtonRecall 
local imgButtonPause 
local imgLetterBG =   {}
local txtTimer 
local gameTimer = 0
local R = mRandom(1,4)
local function RunAdModAdsBanner()
	local provider = "inmobi"

	-- Your application ID
	local appID = "df9e82f6176b4121aeeefe3d3931d845" --"com.gunapps.wordsfly"--"ca-app-pub-6414961667069598/7821964268"

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

--	ads.hide()		
	ads.init( provider,appID, adListener )
	ads.show( "banner320x48", { x=0, y=440, interval=8 } )
end


local function gameTimerUpdate ()
	if isGamePaused == false then
		gameTimer=gameTimer + 1
		txtTimer.text.text=   string.format("%.2d:%.2d",  gameTimer/60%60, gameTimer%60)  --gameTimer
	end

end


local function CreateGameMaterial()


	imgBGMain =   display.newImageRect("img/bg.png", 320,480 ) 
	imgBGMainBoard =   display.newImageRect("img/bgboard.png", 230,270 ) 
	imgButtonNewGame =   display.newImageRect("img/letter"..R..".png", 50,18 ) 
	imgButtonMainMenu =   display.newImageRect("img/letter"..R..".png", 50,18 ) 
	imgButtonRecall =   display.newImageRect("img/letter"..R..".png", 50,18 ) 
	imgButtonPause =   display.newImageRect("img/letter"..R..".png", 50,18 ) 
	txtTimer= display.newImageRect("img/letterbg.png", 60,18 ) 
	txtTimer.text= display.newText(string.format("%.2d:%.2d",  gameTimer/60%60, gameTimer%60) ,150,20,40, 40, native.systemFont, 13 )
	txtTimer:setReferencePoint( display.TopLeftReferencePoint )
	txtTimer.x=253
	txtTimer.y= 5
	txtTimer.text:setReferencePoint( display.TopLeftReferencePoint )
	txtTimer.text.x = txtTimer.x + 16
	txtTimer.text.y = txtTimer.y + 2
	txtTimer.text:setTextColor( 0,0,93 )


	imgBGMainBoard:setReferencePoint( display.TopCenterReferencePoint )
	imgBGMainBoard.x= 200
	imgBGMainBoard.y= -20

	imgBGMain:setReferencePoint( display.CenterReferencePoint )
	imgBGMain.x=_W /2
	imgBGMain.y=_H / 2 


	local function onTouchNewGame(self, event )
		if event.phase == "began" then
			--print("new game")
			R = mRandom(1,4)
			AddLevel(currentLevel +1 )
			gameTimer = 0 
			findWords()
		end
	end
	local function onTouchMainMenu(self, event )
		if event.phase == "began" then
			--print("main menu")
			killGameOverItems()
			storyboard.gotoScene( "menu" )	
		end
	end
	local function onTouchRecall(self, event )
		if event.phase == "began" then
			--print("main menu")
			findWords()
		end
	end
	local function onTouchPause(self, event )
		if event.phase == "began" then
			--print("main menu")
			if isGamePaused==true then
				isGamePaused=false
				imgButtonPause.text.text ="Pause"
			else
				isGamePaused=true
				imgButtonPause.text.text ="Continue"
			end
		end
	end

	imgButtonMainMenu:setReferencePoint( display.CenterReferencePoint )
	imgButtonMainMenu.x= 55
	imgButtonMainMenu.y= 170 
	imgButtonMainMenu.text= display.newText("Menu",0,0,native.systemFont, 10)
	imgButtonMainMenu.text:setReferencePoint( display.CenterReferencePoint )
	imgButtonMainMenu.text:setTextColor( 0,0,93 )
	imgButtonMainMenu.text.x= imgButtonMainMenu.x + 2
	imgButtonMainMenu.text.y= imgButtonMainMenu.y 
	imgButtonMainMenu.touch = onTouchMainMenu
	imgButtonMainMenu:addEventListener( "touch", imgButtonMainMenu )

	imgButtonNewGame:setReferencePoint( display.CenterReferencePoint )
	imgButtonNewGame.x= 55
	imgButtonNewGame.y= 191 
	imgButtonNewGame.text= display.newText("New",0,0, native.systemFont, 10 )
	imgButtonNewGame.text:setReferencePoint( display.CenterReferencePoint )
	imgButtonNewGame.text:setTextColor( 0,0,93 )
	imgButtonNewGame.text.x= imgButtonNewGame.x + 2
	imgButtonNewGame.text.y= imgButtonNewGame.y 
	imgButtonNewGame.touch = onTouchNewGame
	imgButtonNewGame:addEventListener( "touch", imgButtonNewGame )


	imgButtonRecall:setReferencePoint( display.CenterReferencePoint )
	imgButtonRecall.x= 55
	imgButtonRecall.y= 212 
	imgButtonRecall.text= display.newText("Clear",0,0, native.systemFont, 10 )
	imgButtonRecall.text:setReferencePoint( display.CenterReferencePoint )
	imgButtonRecall.text:setTextColor( 0,0,93 )
	imgButtonRecall.text.x= imgButtonRecall.x + 2
	imgButtonRecall.text.y= imgButtonRecall.y 
	imgButtonRecall.touch = onTouchRecall
	imgButtonRecall:addEventListener( "touch", imgButtonRecall )

	imgButtonPause:setReferencePoint( display.CenterReferencePoint )
	imgButtonPause.x= 55
	imgButtonPause.y= 233
	imgButtonPause.text= display.newText("Pause",0, 0, native.systemFont, 10 )
	imgButtonPause.text:setReferencePoint( display.CenterReferencePoint )
	imgButtonPause.text:setTextColor( 0,0,93 )
	imgButtonPause.text.x= imgButtonPause.x + 2
	imgButtonPause.text.y= imgButtonPause.y 
	imgButtonPause.touch = onTouchPause
	imgButtonPause:addEventListener( "touch", imgButtonPause )

end

function killGameOverItems()
	if txtTimer ~= nil then
		txtTimer:removeSelf()
		txtTimer = nil
	end
	if imgBGMain ~= nil then
		imgBGMain:removeSelf()
		imgBGMain = nil
	end
	if imgButtonMainMenu ~= nil then
		imgButtonMainMenu.text:removeSelf()
		imgButtonMainMenu.text = nil
		imgButtonMainMenu:removeSelf()
		imgButtonMainMenu = nil
	end
	if imgButtonNewGame ~= nil then
		imgButtonNewGame.text:removeSelf()
		imgButtonNewGame.text = nil
		imgButtonNewGame:removeSelf()
		imgButtonNewGame = nil
	end
	if imgButtonRecall ~= nil then
		imgButtonRecall.text:removeSelf()
		imgButtonRecall.text = nil
		imgButtonRecall:removeSelf()
		imgButtonRecall = nil
	end
	if imgButtonPause ~= nil then
		imgButtonPause.text:removeSelf()
		imgButtonPause.text = nil
		imgButtonPause:removeSelf()
		imgButtonPause = nil
	end
	--Ekrandaki kutuları kaldır
	if bg[1] ~= nil then
		for i = 1, #bg, 1 do
			for j = 1, #bg[i], 1 do
				if bg[i][j] ~= nil then
					bg[i][j]:removeSelf()
					bg[i][j]=nil
				end
			end
		end
	end
	--Ekrandaki Kelimeleri Kaldır
	if wordsonTable[1] ~= nil then
		for i = 1, #wordsonTable, 1 do
			wordsonTable[i]:removeSelf()
			wordsonTable[i]= nil
		end
	end
	--Ekrandaki Kelimelerin Backgroundunu Kaldır
	if imgLetterBG[1] ~= nil then
		for i = 1, #imgLetterBG, 1 do
			imgLetterBG[i]:removeSelf()
			imgLetterBG[i]= nil
		end
	end
end

function spairs(t, order)
    local keys = {}
    for k in pairs(t) do keys[#keys+1] = k end

    -- if order function given, sort by it by passing the table and keys a, b,
    -- otherwise just sort the keys 
    if order then
        table.sort(keys, function(a,b) return order(t, a, b) end)
    else
        table.sort(keys)
    end

    -- return the iterator function
    local i = 0
    return function()
        i = i + 1
        if keys[i] then
            return keys[i], t[keys[i]]
        end
    end
end

local function OyunBitti()
	bOyunBitti=true
	
	for i=1 , #wordsonTable do
		if wordsonTable[i].alpha==1 then
			bOyunBitti=false
		end
	end	
	
	if bOyunBitti==true then
		isGamePaused = true
		updateStatics("FinishedGame","FinishedGame + 1 ")
		updateStatics("TotalTime","TotalTime +  "..gameTimer)
		updateStatics("BestTime", gameTimer)
		
		local bFinish =false
		
	
		local harf ={}
	
		harf[1]=display.newText("W",150,20)
		harf[2]=display.newText("E",30,-20)
		harf[3]=display.newText("L",40,-20)
		harf[4]=display.newText("L",50,-20)
		harf[5]=display.newText(" ",60,-20)
		harf[6]=display.newText("D",70,-20)
		harf[7]=display.newText("O",80,-20)
		harf[8]=display.newText("N",90,-20)
		harf[9]=display.newText("E",100,-20)
	
		local function Turn()
    		for i = 1, #harf  do
				harf[i].alpha = 0
			end
		end
		local function BGVisible()
    		for i = 1, #bg  do
	    		for j = 1, #bg[1]  do
					bg[i][j].alpha = 0
					bg[i][j].text.alpha = 0
				end
			end
		end
		local function ButtonVisible(a)
			imgButtonNewGame.alpha = a
			imgButtonMainMenu.alpha = a
			imgButtonRecall.alpha = a
			imgButtonPause.alpha = a
			imgButtonNewGame.text.alpha = a
			imgButtonMainMenu.text.alpha = a
			imgButtonRecall.text.alpha = a
			imgButtonPause.text.alpha = a
		end

		function finishText(i)
			local term = 200

			bgFinish[i].text.text=harf[i].text
			bgFinish[i].text.alpha=0
			transition.to (bgFinish[i].text, {delay=(i-1)*term, time =term, x= bgFinish[i].x , y=bgFinish[i].y,alpha=1} )  
		end

	
		local function showCong()
			local imgName = ""
		--	local R = mRandom(1,4)
			BGVisible()
			for i = 1, #harf do
				imgName="img/letter"..R..".png"
				bgFinish[i] = display.newImageRect(imgName,20,20)
				bgFinish[i]:setReferencePoint( display.CenterReferencePoint )
				bgFinish[i].x = i * 20 +99
				bgFinish[i].y =  140
				bgFinish[i].text = display.newText( "" ,0, 410, "Chalkduster", 12)
				bgFinish[i].text:setReferencePoint( display.CenterReferencePoint )
				bgFinish[i].text.x = -100 -- bgFinish[i].x
				bgFinish[i].text.y =  bgFinish[i].y
				bgFinish[i].text:setTextColor(0,0,93)
				finishText(i)
			end

			local function finishText2(i)
				for aa = 1, 1 do
					local countSon =300
						for x = 1, 9 do
							countSon=countSon + 100
							transition.to( bgFinish[x].text, { delay=countSon, time=100, xScale= 1.5,yScale=1.5 } )
							transition.to( bgFinish[x].text, { delay=countSon + 100,time=100, xScale= 1,yScale=1 } )
						end
				end
			end
			local function finishTextYeniOyun(i)

				local function onTouchNewGame(self, event )
					if event.phase == "began" then
						--print("new game")
						R = mRandom(1,4)
						AddLevel(currentLevel +1 )
						gameTimer = 0 
						findWords()
					end
				end
			
				bgFinish[1].text.text = "N"
				bgFinish[2].text.text = "E"
				bgFinish[3].text.text = "W"
				bgFinish[4].text.text = " "
				bgFinish[5].text.text = "G"
				bgFinish[6].text.text = "A"
				bgFinish[7].text.text = "M"
				bgFinish[8].text.text = "E"
				bgFinish[9].text.text = " "
					for x = 1, 9 do
						bgFinish[x].touch = onTouchNewGame
						bgFinish[x]:addEventListener( "touch", bgFinish[x] )

						bgFinish[x].text.xScale = 0.1
						bgFinish[x].text.yScale = 0.1
						transition.to( bgFinish[x].text, { time=500, xScale= 1,yScale=1 } )
					end
					timer.performWithDelay( 3500, ButtonVisible(1) )

			end

			timer.performWithDelay( 1500, finishText2 )
			timer.performWithDelay( 3500, finishTextYeniOyun )
		end

		local function finishEffect()
			for aa = 1, 3 do
				local countSon =300
				for y = 1, 10 do
					for x = 1, 10 do
						countSon=countSon + 20
						transition.to( bg[y][x], { delay=countSon, time=100, xScale= 1.2,yScale=1.2 } )
						transition.to( bg[y][x], { delay=countSon + 100,time=100, xScale= 1,yScale=1 } )
					end
				end
			end
		end

		ButtonVisible(0)
		Turn()
		finishEffect()
		AddLevel(currentLevel +1 )
		timer.performWithDelay( 3000, showCong )
		
	end

end

function findWords()



	killGameOverItems()
	CreateGameMaterial()
	updateStatics("PlayedGame","PlayedGame + 1 ")

	if gameMode==1 then
		alpDerece = 0.99 --0.3 
	else
		alpDerece = 0.3 
	end


	local y=0
	local x=0
	local imgName = ""
	isGamePaused = false
	findLevel()
	
	local function onTouchBG(self, event )
		if event.phase == "began" then
	
		local tempDizi={}
		local bDevam = true	
		local bSeciliYok = true	
		local function seciliBul(obj)
			
			for y=1, 10 do
				for x=1, 10 do
					if bg[y][x].alpha~=1 then
						bSeciliYok = false	
					end
				end
			end

			for i=1 , #wordsonTable do
				if wordsonTable[i].secili==true then
					if wordsonTable[i].harfSayisi == obj.yataySayi then
--					print("wordsonTable[i].harfSayisi:"..wordsonTable[i].harfSayisi .. "-obj.yataySayi:" ..obj.yataySayi)
						nCount=0
						for y=1, 10 do
							for x=1, 10 do
								if bg[y][x].yatayKelime==obj.yatayKelime and obj.alpha==1 then
									nCount=nCount+1 
									if (bg[y][x].text.text == "" or bg[y][x].text.text == wordsonTable[i].harf[nCount] ) then
										tempDizi[#tempDizi+1] = display.newText("" ,0, 410, "Helvetica", 12)
										tempDizi[#tempDizi].harf = wordsonTable[i].harf[nCount] 
										tempDizi[#tempDizi].x = x
										tempDizi[#tempDizi].y = y
										tempDizi[#tempDizi].i = i
									else
										bDevam=false
									end
								end
							end
						end
						if bDevam==false then
							tempDizi={}
							transition.to( obj, { time=200, xScale= 1.2,yScale=1.2 } )
							transition.to( obj, { delay=200,time=200, xScale= 1,yScale=1 } )

						else
							for i=1, #tempDizi do
								bg[tempDizi[i].y][tempDizi[i].x].text.text =  tempDizi[i].harf					
								wordsonTable[tempDizi[i].i].alpha=0		
								--print("1")	
								bFound=true
								bg[tempDizi[i].y][tempDizi[i].x].text.alpha=0
								bg[tempDizi[i].y][tempDizi[i].x].text.x =wordsonTable[tempDizi[i].i].x 
								bg[tempDizi[i].y][tempDizi[i].x].text.y =wordsonTable[tempDizi[i].i].y
								transition.to( bg[tempDizi[i].y][tempDizi[i].x].text, { delay=(i-1)*100, alpha=1, time=200, x= bg[tempDizi[i].y][tempDizi[i].x].text.destX } )
								transition.to( bg[tempDizi[i].y][tempDizi[i].x].text, { delay=(i-1)*100, time=200, y= bg[tempDizi[i].y][tempDizi[i].x].text.destY } )
							end
							tumHarflerAlpha(1)

						end
					else
						if wordsonTable[i].harfSayisi == obj.dikeySayi then
							nCount=0
							for y=1, 10 do
								for x=1, 10 do
									if bg[y][x].dikeyKelime==obj.dikeyKelime and obj.alpha==1  then
										nCount=nCount+1 
										if (bg[y][x].text.text == "" or bg[y][x].text.text == wordsonTable[i].harf[nCount] ) then
											tempDizi[#tempDizi+1] = display.newText("" ,0, 410, "Helvetica", 12)
											tempDizi[#tempDizi].harf = wordsonTable[i].harf[nCount] 
											tempDizi[#tempDizi].x = x
											tempDizi[#tempDizi].y = y
											tempDizi[#tempDizi].i = i
										else
											bDevam=false
										end
									end
								end
							end
							if bDevam==false then
								tempDizi={}
								transition.to( obj, { time=200, xScale= 1.2,yScale=1.2 } )
								transition.to( obj, { delay=200,time=200, xScale= 1,yScale=1 } )
							else
								for i=1, #tempDizi do
									bg[tempDizi[i].y][tempDizi[i].x].text.text =  tempDizi[i].harf
									wordsonTable[tempDizi[i].i].alpha=0									
								--print("2")	
									bFound=true
									bg[tempDizi[i].y][tempDizi[i].x].text.alpha=0
									bg[tempDizi[i].y][tempDizi[i].x].text.x =wordsonTable[tempDizi[i].i].x 
									bg[tempDizi[i].y][tempDizi[i].x].text.y =wordsonTable[tempDizi[i].i].y
									transition.to( bg[tempDizi[i].y][tempDizi[i].x].text, { delay=(i-1)*100, alpha=1, time=200, x= bg[tempDizi[i].y][tempDizi[i].x].text.destX } )
									transition.to( bg[tempDizi[i].y][tempDizi[i].x].text, { delay=(i-1)*100, time=200, y= bg[tempDizi[i].y][tempDizi[i].x].text.destY } )
								end
								tumHarflerAlpha(1)								
							end
						--print("TDD:"..#tempDizi)
							
						end
					end
				end
			end
			if bSeciliYok == true	then
				if obj.text.text ~= "" then

					local axx =1
					local ayy =1
					tempDizi={}
					local tempKelime=""
					local tempKelimeYatay=""
					kCount=0

					local function kelimeleriSil(b) 
						for y=1, 10 do
							for x=1, 10 do
								if bg[y][x].silinecek== true then
									bg[y][x].silinecek=false
									if b>1 then
										bg[y][x].text.text= ""
									end
								end
							end
						end
					end

					--Yatay Kontroller yapılıyor

					local function checkKelimeYatay(y,x)
						if x>0 and x<= nYatayCount then
							if bg[y][x] ~= nil then
								if bg[y][x].bgType ~=0 then
									if bg[y][x].text.text ~= "" then
										checkKelimeYatay(y,x-1)
									else
										--bYataySilme=true
										axx = x +1 
									end
								else
									axx = x +1 
								end
							end
						end
					end


					--Dikey kontroller yapılıyor
					kCount=0
					
					local function checkKelimeDikey(y,x)
									--print("bg[y][x].text.text "..y,x)
						if y>0 and y < nDikeyCount + 1 then
							if bg[y][x] ~= nil then	
								if bg[y][x].bgType~=0 then
									if bg[y][x].text.text ~= "" then
										checkKelimeDikey(y-1,x)
									else
										ayy = y +1 
									end
								else
									ayy = y +1 
								end
							end
						end
					end
					
					local function ilkyBul(y,x)
						if y>0 and y < nDikeyCount + 1 then
							if bg[y][x] ~= nil then	
								if bg[y][x].bgType~=0 then
									if bg[y][x].text.text ~= "" then
										ilkyBul(y-1,x)
									else
										ilkY = y + 1
									end
								else
									ilkY = y + 1
								end
							else
								ilkY = y + 1
							end
						else
							ilkY = y + 1
						end
						
					end
					local function sonyBul(y,x)
						if y>0 and y < nDikeyCount + 1 then
							if bg[y][x] ~= nil then	
								if bg[y][x].bgType~=0 then
									if bg[y][x].text.text ~= "" then
										sonyBul(y+1,x)
									else
										sonY = y - 1
									end
								else
									sonY = y -1 
								end
							else
								sonY = y - 1
							end
						else
							sonY = y - 1
						end
						
					end
					
					local function DikeyKelimeVarmi(x)
						tempKelimeDikey=""
						for y=ilkY, sonY do
							tempKelimeDikey=tempKelimeDikey ..  bg[y][x].text.text
						end
						
						for i=1 , #wordsonTable do
							if tempKelimeDikey==wordsonTable[i].text then
								bDikeyKelimeVar =true
							end
						end						
					end
					
					local function killKelimeYatay(y,x)
						if y>0 and x>0 and y <= nDikeyCount and x <= nYatayCount then
							if bg[y][x] ~= nil then
								if bg[y][x].bgType~=0  then
									tempDizi[#tempDizi+1] = display.newText("" ,0, 410, "Helvetica", 12)
									tempDizi[#tempDizi].harf = bg[y][x].text.text  
									tempDizi[#tempDizi].x = x
									tempDizi[#tempDizi].y = y
									tempDizi[#tempDizi].i = i
									tempKelime=tempKelime .. tempDizi[#tempDizi].harf
									kCount=kCount + 1
									tempKelimeDikey=""
									ilkyBul(y,x)
									sonyBul(y,x)
									bDikeyKelimeVar =false
									DikeyKelimeVarmi(x)

									if	bDikeyKelimeVar == false then
										bg[y][x].silinecek = true
										bg[y][x].text.x= -100
										bg[y][x].text.y= 500
									else
										bg[y][x].silinecek = false
									end
									killKelimeYatay(y,x+1)
								end
							end
						end
					end
					checkKelimeYatay(obj.dikeySira,obj.yataySira)
					tempKelime=""
					killKelimeYatay(obj.dikeySira,axx)
					kelimeleriSil (kCount)

					if 	kCount>1 then
						for i=1 , #wordsonTable do
							if tempKelime==wordsonTable[i].text then
								xx = wordsonTable[i].x 
								yy = wordsonTable[i].y 
								wordsonTable[i].x = obj.x
								wordsonTable[i].y = obj.y
								wordsonTable[i].xScale = 0.1
								wordsonTable[i].yScale = 0.1
								wordsonTable[i].alpha=1	
								wordsonTable[i].secili =false
								--print("3")	
								transition.to( wordsonTable[i], {  time=300, x= xx , y= yy, xScale=1,yScale=1 } )
							end
						end
						secimiKaldir()			
					end
					
					local function ilkxBul(y,x)
						if x>0 and x < nYatayCount + 1 then
							if bg[y][x] ~= nil then	
								if bg[y][x].bgType~=0 then
									if bg[y][x].text.text ~= "" then
										ilkxBul(y,x-1)
									else
										ilkX = x + 1
									end
								else
									ilkX = x + 1
								end
							else
								ilkX = x + 1
							end
						else
							ilkX = x + 1
						end
						
					end
					local function sonxBul(y,x)
						if x>0 and x < nYatayCount + 1 then
							if bg[y][x] ~= nil then	
								if bg[y][x].bgType~=0 then
									if bg[y][x].text.text ~= "" then
										sonxBul(y,x+1)
									else
										sonX = x - 1
									end
								else
									sonX = x -1 
								end
							else
								sonX = x - 1
							end
						else
							sonX = x - 1
						end
						
					end
					
					local function YatayKelimeVarmi(y)
						tempKelimeYatay=""
						for x=ilkX, sonX do
							tempKelimeYatay=tempKelimeYatay ..  bg[y][x].text.text
						end
						
						for i=1 , #wordsonTable do
							if tempKelimeYatay==wordsonTable[i].text then
								bYatayKelimeVar =true
							end
						end						
					end
					
					local function killKelimeDikey(y,x)
						if y>0 and x>0 and y < nDikeyCount+1 and x < nYatayCount + 1 then
							if bg[y][x] ~= nil then
								if bg[y][x].bgType~=0  then
									tempDizi[#tempDizi+1] = display.newText("" ,0, 410, "Helvetica", 12)
									tempDizi[#tempDizi].harf = bg[y][x].text.text  
									tempDizi[#tempDizi].x = x
									tempDizi[#tempDizi].y = y
									tempDizi[#tempDizi].i = i
									tempKelime=tempKelime .. tempDizi[#tempDizi].harf
									kCount=kCount + 1
									tempKelimeYatay=""
									ilkxBul(y,x)
									sonxBul(y,x)
									bYatayKelimeVar =false
									YatayKelimeVarmi(y)

									if	bYatayKelimeVar == false then
										bg[y][x].silinecek = true
										bg[y][x].text.x= -100
										bg[y][x].text.y= 500
									else
										bg[y][x].silinecek = false
									end
									killKelimeDikey(y+1,x)
								end
							end
						end
					end
					checkKelimeDikey(obj.dikeySira,obj.yataySira)
					tempKelime=""
					killKelimeDikey(ayy,obj.yataySira)
					kelimeleriSil (kCount)
					
					if 	kCount>1 then
						for i=1 , #wordsonTable do
							--print("kkkkk:" ..tempKelime , wordsonTable[i].text )
							if tempKelime==wordsonTable[i].text then
								xx = wordsonTable[i].x 
								yy = wordsonTable[i].y 
								wordsonTable[i].x = obj.x
								wordsonTable[i].y = obj.y
								wordsonTable[i].xScale = 0.1
								wordsonTable[i].yScale = 0.1
								wordsonTable[i].alpha=1	
								wordsonTable[i].secili =false
								--print("4")	
								transition.to( wordsonTable[i], {  time=300, x= xx , y= yy, xScale=1,yScale=1 } )
							end
						end
						secimiKaldir()			
					end
				end
			end
		end

		
		if event.phase == "began" then
			bFound=false
			if self.alpha== 1 then
				seciliBul(self)
				OyunBitti()
			end
				if bFound==true then
--					print("found")
				else
--					print("nofound")
					transition.to (self, { time =200, xScale=1.5 , yScale=1.5} )  
					transition.to (self, { delay=200,time =200, xScale=1 , yScale=1} )  

				end
			return true
		end
	end
	end

	local GameLevel = 0 
	if currentLevel <= #wordList then
		GameLevel = currentLevel
	else
		GameLevel = mRandom(1,#wordList )

	end
	currentLevel=GameLevel
--currentLevel
--gürcan sil
--	GameLevel = 1
	for i = 1, #wordList[GameLevel] do
		x= x + 1
		if (i-1) % 10 == 0 then
			y= y + 1
			x=1
			bg[y] = {}
		end
		sTemp =  wordList[GameLevel][i]
		if sTemp=="-" then
			imgName="img/space.png"
			bgType=0
		else
		
			imgName="img/letter"..R..".png"
			bgType=1
		end
		-- bg burada başlıyor ggggg
		bg[y][x] = display.newImageRect(imgName,20,20)
		bg[y][x]:setReferencePoint( display.CenterReferencePoint )
		bg[y][x].letter = sTemp
		bg[y][x].bgType = bgType
		bg[y][x].yatayKelime=""
		bg[y][x].yataySayi=0
		bg[y][x].dikeyKelime=""
		bg[y][x].dikeySayi=0
		bg[y][x].x = x * 20 +92
		bg[y][x].y = y * 20 + 25
		bg[y][x].text = display.newText( "" ,0, 410, "Chalkduster", 12)
		bg[y][x].text:setTextColor(0,0,93)
		bg[y][x].dikeySira=y
		bg[y][x].yataySira=x
		bg[y][x].silinecek=false

		bg[y][x].text.x= -100
		bg[y][x].text.y= 500
		bg[y][x].text.destX= bg[y][x].x
		bg[y][x].text.destY= bg[y][x].y
		bg[y][x].touch = onTouchBG
		bg[y][x]:addEventListener( "touch", bg[y][x] )

	end
	

	local function YatayKelimeBul(y,x)
		local bFind= false
		
		if bg[y][x].letter == "-"  then
			bg[y][x].yatayKelime=""
		else
			sTemp=""
			sTempCount = 0
			sTempHarf={}
			for i= 1 , 10  do
				sTempHarf[i]=""
			end			
			j = x
			for i= j , 1 , -1 do
				if i ~= 1 then
					if bg[y][i-1].letter ~= "-"  and bFind==false  then
						j=i-1
					else
						bFind=true
					end
				end 
			end

			local bFind= false				
			for i = j, 10 do
				if bg[y][i].letter ~= "-" and bFind==false then
					sTemp=sTemp .. bg[y][i].letter
					sTempCount= sTempCount +1 
					sTempHarf[sTempCount] = bg[y][i].letter
				else
					bFind=true
				end
			end
				
			if sTempCount==1 then 
				sTemp=""
			end		
	
			bg[y][x].yatayKelime=sTemp
			bg[y][x].yataySayi=sTempCount
			
			bFind=false
			for i = 1, #wordsonTable do
				if sTemp == wordsonTable[i].text then
					bFind=true
				end
			end
			
			if bFind==false and sTempCount>1 then
--			print("syatay:"..sTemp
				wordsonTable[#wordsonTable +1 ]= display.newText( sTemp ,0, 410, "Helvetica", 11)
				wordsonTable[#wordsonTable ].text=sTemp
				wordsonTable[#wordsonTable ].harfSayisi=sTempCount
				wordsonTable[#wordsonTable ].durum="Y"
				wordsonTable[#wordsonTable ].secili=false
				wordsonTable[#wordsonTable ].harf ={}
				for i=1, 10 do
					wordsonTable[#wordsonTable ].harf[i]=sTempHarf[i]
				end
			end
		end
	end

	local function DikeyKelimeBul(y,x)
		local bFind= false
		
		if bg[y][x].letter == "-"  then
			bg[y][x].dikeyKelime=""
		else
			sTemp=""
			sTempCount = 0
			sTempHarf={}
			for i= 1 , 10  do
				sTempHarf[i]=""
			end			
			j = y
			for i= j , 1 , -1 do
				if i ~= 1 then
					if bg[i-1][x].letter ~= "-"  and bFind==false  then
						j=i-1
					else
						bFind=true
					end
				end 
			end

			local bFind= false				
			for i = j, 10 do
				if bg[i][x].letter ~= "-" and bFind==false then
					sTemp=sTemp .. bg[i][x].letter
					sTempCount= sTempCount +1 
					sTempHarf[sTempCount] = bg[i][x].letter
				else
					bFind=true
				end
			end
				
			if sTempCount==1 then 
				sTemp=""
			end		
	
			bg[y][x].dikeyKelime=sTemp
			bg[y][x].dikeySayi=sTempCount

			bFind=false
			for i = 1, #wordsonTable do
				if sTemp == wordsonTable[i].text  then
					bFind=true
				end
			end
			
			if bFind==false and sTempCount>1 then
				wordsonTable[#wordsonTable +1 ]= display.newText( sTemp ,0, 410, "Helvetica", 11)
				wordsonTable[#wordsonTable ].text=sTemp
				wordsonTable[#wordsonTable ].harfSayisi=sTempCount
				wordsonTable[#wordsonTable ].durum="D"
				wordsonTable[#wordsonTable ].secili=false
				wordsonTable[#wordsonTable ].harf ={}
				for i=1, 10 do
					wordsonTable[#wordsonTable ].harf[i]=sTempHarf[i]
				end
			end
			
		end
	end
	
	for y = 1, 10 do
		for x = 1, 10 do
			YatayKelimeBul(y,x)
			DikeyKelimeBul(y,x)
		end
	end


	function returnHarf(t,a,b) 
		return t[b].harfSayisi > t[a].harfSayisi  --and t[b].text > t[a].text  
	end



	sTempTable={}
	i=0
	for k,v in spairs(wordsonTable,returnHarf) do
		i=i + 1
		sTempTable[i] = wordsonTable[k]
	end
	
	wordsonTable = sTempTable

				for i=1, 10 do
					--print("ttt:"..wordsonTable[1].text)
					--print("hhh:"..wordsonTable[1].harf[i])
				end
	
	local function ayniHarfleriBul(harf)
		for y = 1, 10 do
			for x = 1, 10 do
				if bg[y][x].yataySayi ~= harf and bg[y][x].dikeySayi ~= harf  then
					bg[y][x].alpha= alpDerece
				end
			end
		end

	end
    function tumHarflerAlpha(alp)
		for y = 1, 10 do
			for x = 1, 10 do
				bg[y][x].alpha=alp
			end
		end

	end
	function secimiKaldir()
		for i=1 , #wordsonTable do
			wordsonTable[i].xScale = 1
			wordsonTable[i].yScale = 1
			wordsonTable[i]:setTextColor(0,0,93)
			wordsonTable[i].secili=false
		end
	end

	local function onTouchWOT(self, event )
		
		if event.phase == "began" then
			tumHarflerAlpha(1)
			if self.secili== false then
				secimiKaldir()
				ayniHarfleriBul(self.harfSayisi)
				self.xScale = 1.2
				self.yScale = 1.2
				self:setTextColor(173,0,0)
				self.secili= true
			else
				self.xScale = 1
				self.yScale = 1
				self:setTextColor(0,0,93)
				self.secili=false
				secimiKaldir()
			end
			return true
		end
	end
	
	
	x=45
	y=260
	for i = 1, #wordsonTable do
		x = x +  78  -- (wordsonTable[i-1].harfSayisi * 15)

		imgLetterBG[i] =   display.newImageRect("img/letterbg.png", 70,18 ) 
		imgLetterBG[i]:setReferencePoint( display.CenterReferencePoint )
		imgLetterBG[i].x= x
		imgLetterBG[i].y= y 
		imgLetterBG[i].touch = onTouchWOT
		imgLetterBG[i]:addEventListener( "touch", wordsonTable[i] )

		wordsonTable[i]:setReferencePoint( display.CenterReferencePoint )
		wordsonTable[i]:setTextColor(0,0,93)
		wordsonTable[i].touch = onTouchWOT
		wordsonTable[i]:addEventListener( "touch", wordsonTable[i] )
		wordsonTable[i].x = x 
		wordsonTable[i].y = y 
		wordsonTable[i]:toFront()
		if  i % 3 == 0  then --wordsonTable[i].harfSayisi ==  wordsonTable[i-1].harfSayisi then
			x=45
			y=y + 20
		end
	end

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
        
        -----------------------------------------------------------------------------
                
        --      INSERT code here (e.g. start timers, load audio, start listeners, etc.)
        
        -----------------------------------------------------------------------------
        
        --storyboard.purgeScene( "game-scene" )

	gameTimer = 0 
	findWords()
	RunAdModAdsBanner()
	
	timers.gameTimerUpdate = timer.performWithDelay(1000, gameTimerUpdate, 0)
	
	-- remove previous scene's view
	--storyboard.purgeScene( "game-scene" )
	


end
 
 
-- Called when scene is about to move offscreen:
function scene:exitScene( event )
        local screenGroup = self.view
        
        -----------------------------------------------------------------------------
        
        --      INSERT code here (e.g. stop timers, remove listeners, unload sounds, etc.)
        
        -----------------------------------------------------------------------------
	if timers.gameTimerUpdate then 
		timer.cancel(timers.gameTimerUpdate)
		timers.gameTimerUpdate = nil
	 end
        
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