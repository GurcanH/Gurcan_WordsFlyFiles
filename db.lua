currentLevel=1
life = 5 
sPlayedGame=0
sFinishedGame=0
sBestTime=999999
sTotalTime=0
gameMode=1

--Include sqlite
require "sqlite3"
--Open data.db.  If the file doesn't exist it will be created
local path = system.pathForFile("wordendata.db", system.DocumentsDirectory)
db = sqlite3.open( path )   
 print(path)
--Handle the applicationExit event to close the db
local function onSystemEvent( event )
        if( event.type == "applicationExit" ) then              
            db:close()
        end
end
 
--local tablesetup = "DROP TABLE  CrossWord "
--db:exec( tablesetup )
--local tablesetup = "DROP TABLE  CrossWordStatics "
--db:exec( tablesetup )
--local tablesetup = "DROP TABLE  CrossWordGameMode "
--db:exec( tablesetup )

--Setup the table if it doesn't exist


local tablesetup = [[CREATE TABLE IF NOT EXISTS CrossWord (id INTEGER PRIMARY KEY, Level, GameMode);]]
db:exec( tablesetup )

local tablesetup = [[CREATE TABLE IF NOT EXISTS CrossWordStatics (id INTEGER PRIMARY KEY, PlayedGame,FinishedGame,BestTime,TotalTime,GameMode);]]
db:exec( tablesetup )

local tablesetup = [[CREATE TABLE IF NOT EXISTS CrossWordGameMode (id INTEGER PRIMARY KEY, GameMode);]]
db:exec( tablesetup )

function AddLevel(l) 
	findGameMode()
	findLevel()

	if l > currentLevel then
		local tablefill ="DELETE from CrossWord WHERE GameMode="..gameMode
		db:exec( tablefill )

		local tablefill ="INSERT INTO CrossWord VALUES (NULL,"..l..","..gameMode..")"
		db:exec( tablefill )
	end
end

function findLevel()
	findGameMode()
	for row in db:nrows("SELECT * FROM CrossWord WHERE GameMode="..gameMode) do
  		currentLevel = row.Level 
  		print(	  	currentLevel)	
	end
end 
function findGameMode()
  		print(	 "find:".. 	gameMode)	
	for row in db:nrows("SELECT Count(1) As Adet FROM CrossWordGameMode") do
  		print(	 "row.Adet :".. 	row.Adet )	
  		if row.Adet == 0 then
			local tablefill ="INSERT INTO CrossWordGameMode VALUES (NULL,"..gameMode .. ")"
			db:exec( tablefill )
  		end
	end

	for row in db:nrows("SELECT * FROM CrossWordGameMode") do
  		gameMode = row.GameMode 	  		
	end
end 
function updateGameMode()
  		print(	 "update:".. 	gameMode)	
	local tablefill ="UPDATE CrossWordGameMode SET GameMode=" .. gameMode 
	db:exec( tablefill )
end 

function findStatics()
	local iCount=0
	local sStatics=""
	sPlayedGame=0
	sFinishedGame=0
	sBestTime=0
	sTotalTime=0
	print("gm:"..gameMode)
	for row in db:nrows("SELECT *  FROM CrossWordStatics WHERE GameMode="..gameMode) do
		iCount=iCount + 1
--		sStatics="Played Game: " .. row.PlayedGame .. "  Finished Game:" .. row.FinishedGame .. "  Best Time:" .. row.BestTime  .. "  Total Time:" .. row.TotalTime 
		sPlayedGame=row.PlayedGame 
		sFinishedGame= row.FinishedGame 
		sBestTime=row.BestTime
		sTotalTime=row.TotalTime

	end
  	if iCount == 0 then
		print(0)
		local tablefill ="INSERT INTO CrossWordStatics VALUES (NULL,0,0,999999,0,"..gameMode..") "
		db:exec( tablefill )
	else
		print(sStatics)
  	end
end 
function updateStatics(sField,sValue)
	local isUpdate=true
	findGameMode()
	if sField=="BestTime" then
		for row in db:nrows("SELECT BestTime  FROM CrossWordStatics WHERE GameMode="..gameMode) do
			if row.BestTime < sValue then
				isUpdate=false
			end
		end
	end
	if isUpdate== true then
		local tablefill ="UPDATE CrossWordStatics SET " .. sField .. "=" .. sValue .. " WHERE GameMode=" .. gameMode 
		db:exec( tablefill )
	end
end 

--setup the system listener to catch applicationExit
Runtime:addEventListener( "system", onSystemEvent )