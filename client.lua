local stations = { -- Fill your own online radio stations in here
	{ "Classic Rock HD Plus", "http://uk5.internet-radio.com:8251/listen.pls" },
}


local GUIEditor_Window = {}
local GUIEditor_Button = {}
local GUIEditor_Label = {}
local GUIEditor_Grid = {}
local GUIEditor_Scrollbar = {}

function CreateGUI()
	if(isElement(GUIEditor_Window[1]))then
		RemoveGUI()
		return
	end
	
	local x, y = guiGetScreenSize()
	local guiWidth, guiHeight = 742, 409
	
	local centerX, centerY = (x/2) - (guiWidth/2), (y/2) - (guiHeight/2)
	
	guiSetInputEnabled(true)
	showCursor(true)
	
	GUIEditor_Window[1] = guiCreateWindow(centerX,centerY,guiWidth,guiHeight,"SPEAKER SYSTEM (By: Rataj; github.com/RatajVaver)",false)
	guiWindowSetSizable(GUIEditor_Window[1],false)
	
	GUIEditor_Button[1] = guiCreateButton(9,39,265,56,"Place speaker",false,GUIEditor_Window[1])
	addEventHandler("onClientGUIClick", GUIEditor_Button[1], PlaceSpeaker)
	
	GUIEditor_Button[2] = guiCreateButton(9,173,265,56,"Remove speaker",false,GUIEditor_Window[1])
	addEventHandler("onClientGUIClick", GUIEditor_Button[2], RemoveSpeaker)
	
	GUIEditor_Scrollbar[1] = guiCreateScrollBar(298,60,423,24,true,false,GUIEditor_Window[1])
	guiScrollBarSetScrollPosition(GUIEditor_Scrollbar[1],100)
	GUIEditor_Label[1] = guiCreateLabel(301,36,104,22,"Volume: 100%",false,GUIEditor_Window[1])
	
	addEventHandler("onClientGUIScroll", GUIEditor_Scrollbar[1], function()
		guiSetText(GUIEditor_Label[1], "Volume: "..guiScrollBarGetScrollPosition(source).."%")
	end, false)
	
	guiLabelSetVerticalAlign(GUIEditor_Label[1],"center")
	guiSetFont(GUIEditor_Label[1],"default-bold-small")
	
	GUIEditor_Grid[1] = guiCreateGridList(299,139,419,255,false,GUIEditor_Window[1])
	guiGridListSetSelectionMode(GUIEditor_Grid[1],0)

	guiGridListAddColumn(GUIEditor_Grid[1],"Radio station",0.7)

	guiGridListAddColumn(GUIEditor_Grid[1],"Frequency",0.2)

	for i = 1, #radia do
		guiGridListAddRow(GUIEditor_Grid[1])
	end

	for k,v in ipairs(radia)do
		guiGridListSetItemText(GUIEditor_Grid[1],(k-1),1,v[1],false,false)
		guiGridListSetItemText(GUIEditor_Grid[1],(k-1),2,(k+90),false,true)
	end
	
	guiGridListSetSelectedItem(GUIEditor_Grid[1], 0, 1)

	GUIEditor_Label[2] = guiCreateLabel(301,113,200,23,"Station: "..radia[1][1],false,GUIEditor_Window[1])
	guiLabelSetVerticalAlign(GUIEditor_Label[2],"center")
	guiSetFont(GUIEditor_Label[2],"default-bold-small")
	
	addEventHandler("onClientGUIClick", GUIEditor_Grid[1], function()
		guiSetText(GUIEditor_Label[2], "Station: "..guiGridListGetItemText(GUIEditor_Grid[1], guiGridListGetSelectedItem(GUIEditor_Grid[1]), 1))
	end, false)
	
	GUIEditor_Button[3] = guiCreateButton(9,105,265,56,"Create personal speaker",false,GUIEditor_Window[1])
	addEventHandler("onClientGUIClick", GUIEditor_Button[3], PersonalSpeaker)
	
	GUIEditor_Label[3] = guiCreateLabel(8,247,286,96,"Instructions:\n\n1. Choose your desired speaker volume.\n2. Choose a radio station from the list.\n3. Place the classic speaker or create personal one.\n4. If you don't want to listen anymore, simply remove the speaker.",false,GUIEditor_Window[1])
	guiLabelSetHorizontalAlign(GUIEditor_Label[3],"left",true)
	
	GUIEditor_Button[4] = guiCreateButton(9,349,265,44,"Close",false,GUIEditor_Window[1])
	addEventHandler("onClientGUIClick", GUIEditor_Button[4], RemoveGUI)
end
addCommandHandler("speaker", CreateGUI, false, false)
addCommandHandler("speakers", CreateGUI, false, false)

function RemoveGUI()
	guiSetInputEnabled(false)
	showCursor(false)
	guiSetVisible(GUIEditor_Window[1], false)
	destroyElement(GUIEditor_Window[1])
	GUIEditor_Window[1] = nil
end

function PlaceSpeaker()
	local station = stations[1][2]
	if guiGridListGetSelectedItem(GUIEditor_Grid[1]) then
		station = stations[guiGridListGetSelectedItem(GUIEditor_Grid[1])+1][2]
	end
	local volume = guiScrollBarGetScrollPosition(GUIEditor_Scrollbar[1])
	triggerServerEvent("rs:speaker3d:place", getLocalPlayer(), getLocalPlayer(), "placespeaker", station, volume)
end

function RemoveSpeaker()
	triggerServerEvent("rs:speaker3d:remove", getLocalPlayer(), getLocalPlayer(), "destroyspeaker")
end

function PersonalSpeaker()
	local station = stations[1][2]
	if guiGridListGetSelectedItem(GUIEditor_Grid[1]) then
		station = stations[guiGridListGetSelectedItem(GUIEditor_Grid[1])+1][2]
	end
	local volume = guiScrollBarGetScrollPosition(GUIEditor_Scrollbar[1])
	triggerServerEvent("rs:speaker3d:personal", getLocalPlayer(), getLocalPlayer(), "personalspeaker", station, volume)
end


local sound = { }

function playTheSound(player, int, dim, x, y, z, station, vehicle, dist, volume)
	if curl then
		sound[player] = playSound3D(station, x, y, z)
	else
		sound[player] = playSound3D(station, x, y, z)
	end
	
	if not dist or dist==0 then
		dist = 32
	end
	
	if not volume or volume==0 then
		volume = 50
	end
	
	setSoundMaxDistance(sound[player], dist)
	setSoundVolume(sound[player], volume/100)
	
	setElementInterior(sound[player], int)
	setElementDimension(sound[player], dim)
	if (isElement(vehicle)) then attachElements(sound[player], vehicle) end
end
addEvent("playTheSound", true)
addEventHandler("playTheSound", root, playTheSound)

function stopTheSound(player)
	stopSound(sound[player])
end
addEvent("stopTheSound", true)
addEventHandler("stopTheSound", root, stopTheSound)