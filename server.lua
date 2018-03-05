local speakers = { }

function clearSpeakers()
	for key,value in ipairs(speakers) do
		if isElement(value) then
			destroyElement(value)
		end
		triggerClientEvent("stopTheSound", root, key)
		speakers[key] = nil
	end
end
setTimer(clearSpeakers, 2*60*60*1000, 0) -- Make sure there are no speakers left behind (every 2 hours)

function createSpeaker(thePlayer, cmd, station, volume)
	if (isElement(speakers[thePlayer])) then
		outputChatBox("You've already created a speaker.", thePlayer)
	else
		if not(station) or not(string.match(station, "http://")) then
			outputChatBox("You haven't choose a radio station.", thePlayer)
		else
			local x, y, z = getElementPosition(thePlayer)
			speakers[thePlayer] = createObject(1840, x, y, z-1)
			
			local int = getElementInterior(thePlayer)
			local dim = getElementDimension(thePlayer)
			
			setElementInterior(speakers[thePlayer], int)
			setElementDimension(speakers[thePlayer], dim)
			
			if (isPedInVehicle(thePlayer)) then
				local vehicle = getPedOccupiedVehicle(thePlayer)
				local xoff,yoff,zoff = 0,0,0
				
				attachElements(speakers[thePlayer], vehicle, xoff, yoff, zoff, 0, 0, 270)
				
				triggerClientEvent(root, "playTheSound", root, thePlayer, int, dim, x, y, z, station, vehicle, 0, volume)
			else
				triggerClientEvent(root, "playTheSound", root, thePlayer, int, dim, x, y, z, station, 0, 0, volume)
			end
			outputChatBox("You've placed the speaker.", thePlayer)
		end
	end
end
addCommandHandler("placespeaker", createSpeaker, false, false)
addCommandHandler("createspeaker", createSpeaker, false, false)
addCommandHandler("addspeaker", createSpeaker, false, false)
addEvent("rs:speaker3d:place", true)
addEventHandler("rs:speaker3d:place", root, createSpeaker)

function deleteSpeaker(thePlayer, cmd)
	if (isElement(speakers[thePlayer])) then
		destroyElement(speakers[thePlayer])
		triggerClientEvent("stopTheSound", root, thePlayer)
		speakers[thePlayer] = nil
		outputChatBox("You removed your speaker.", thePlayer)
	else
		outputChatBox("You don't have any speaker around here.", thePlayer)
	end
end
addCommandHandler("destroyspeaker", deleteSpeaker, false, false)
addCommandHandler("removespeaker", deleteSpeaker, false, false)
addCommandHandler("deletespeaker", deleteSpeaker, false, false)
addEvent("rs:speaker3d:remove", true)
addEventHandler("rs:speaker3d:remove", root, deleteSpeaker)

function personalSpeaker(thePlayer, cmd, station, volume)
	if (isElement(speakers[thePlayer])) then
		outputChatBox("You've already created a speaker.", thePlayer)
	else
		if not(station) or not(string.match(station, "http://")) then
			outputChatBox("You haven't choose a radio station.", thePlayer)
		else
			local x, y, z = getElementPosition(thePlayer)
			speakers[thePlayer] = createObject(330, x, y, z-1)
			
			local int = getElementInterior(thePlayer)
			local dim = getElementDimension(thePlayer)
			
			setElementInterior(speakers[thePlayer], int)
			setElementDimension(speakers[thePlayer], dim)
			
			setObjectScale(speakers[thePlayer], 0.8)

			exports['bone_attach']:attachElementToBone(speakers[thePlayer], thePlayer, 4, 0.18, 0.1, -0.1, -7, -70, 270)
			
			triggerClientEvent(root, "playTheSound", root, thePlayer, int, dim, x, y, z, station, thePlayer, 4, volume)

			outputChatBox("You've created the speaker.", thePlayer)
		end
	end
end
addCommandHandler("personalspeaker", personalSpeaker, false, false)
addEvent("rs:speaker3d:personal", true)
addEventHandler("rs:speaker3d:personal", root, personalSpeaker)


addEventHandler("onPlayerQuit", getRootElement(),
	function( )
		if speakers[source] then
			if isElement(speakers[source]) then
				destroyElement(speakers[source])
			end
			triggerClientEvent("stopTheSound", root, source)
			speakers[source] = nil
		end
	end
)