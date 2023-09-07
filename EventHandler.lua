local EventHandler = {}

local RemoteEvents = {
	MainEvent = script.MainEvent,
	MainEvent2 = script.MainEvent2,
	BackupEvent = script.BackupEvent,
	BackupEvent2 = script.BackupEvent2
}

-- Keeping track of usage events for dynamic event running

local EventUsage = {
	MainEvent = 1,
	MainEvent2 = 1,
	BackupEvent = 1,
	BackupEvent2 = 1
}

local LoadedEvents = {}

local DEBUG = false

EventHandler.Events = {
	TestEvent = "TestEvent"
}

EventHandler.ConnectedClients = {}

EventHandler.OnEvent = {}

function EventHandler:FireEvent(Event: string, ...)
	local RunService = game:GetService("RunService")

	if RunService:IsClient() then
		if EventUsage.MainEvent % 100 ~= 0 then
			EventUsage.MainEvent = EventUsage.MainEvent + 1
			RemoteEvents.MainEvent:FireServer(Event, ...)
		elseif EventUsage.MainEvent2 % 100 ~= 0 then
			EventUsage.MainEvent2 = EventUsage.MainEvent2 + 1
			RemoteEvents.MainEvent2:FireServer(Event, ...)
		elseif EventUsage.BackupEvent % 100 ~= 0 then
			EventUsage.BackupEvent = EventUsage.BackupEvent + 1
			RemoteEvents.BackupEvent:FireServer(Event, ...)
		elseif EventUsage.BackupEvent2 % 100 ~= 0 then
			EventUsage.BackupEvent2 = EventUsage.BackupEvent2 + 1
			RemoteEvents.BackupEvent2:FireServer(Event, ...)
		else
			warn("Queues have been filled, resetting usage marks!")
			EventUsage.MainEvent = 1
			EventUsage.MainEvent2 = 1
			EventUsage.BackupEvent = 1
			EventUsage.BackupEvent2 = 1
			RemoteEvents.MainEvent:FireServer(Event, ...)
		end
		if DEBUG then
			print("[Client] Firing Event: " .. Event)
			print("[Client] Total Event Usage:\n" ..
				"MainEvent=" .. EventUsage.MainEvent .. "\n" ..
				"MainEvent2=" .. EventUsage.MainEvent2 .. "\n" ..
				"BackupEvent=" .. EventUsage.BackupEvent .. "\n" ..
				"BackupEvent2=" .. EventUsage.BackupEvent2)
		end
	elseif RunService:IsServer() then
		if EventUsage.MainEvent % 100 ~= 0 then
			EventUsage.MainEvent = EventUsage.MainEvent + 1
			RemoteEvents.MainEvent:FireAllClients(Event, ...)
		elseif EventUsage.MainEvent2 % 100 ~= 0 then
			EventUsage.MainEvent2 = EventUsage.MainEvent2 + 1
			RemoteEvents.MainEvent2:FireAllClients(Event, ...)
		elseif EventUsage.BackupEvent % 100 ~= 0 then
			EventUsage.BackupEvent = EventUsage.BackupEvent + 1
			RemoteEvents.BackupEvent:FireAllClients(Event, ...)
		elseif EventUsage.BackupEvent2 % 100 ~= 0 then
			EventUsage.BackupEvent2 = EventUsage.BackupEvent2 + 1
			RemoteEvents.BackupEvent2:FireAllClients(Event, ...)
		else
			warn("Queues have been filled, resetting usage marks!")
			EventUsage.MainEvent = 1
			EventUsage.MainEvent2 = 1
			EventUsage.BackupEvent = 1
			EventUsage.BackupEvent2 = 1
			RemoteEvents.MainEvent:FireAllClients(Event, ...)
		end
		if DEBUG then
			print("[Server] Firing Event: " .. Event)
			print("[Server] Total Event Usage:\n" ..
				"MainEvent=" .. EventUsage.MainEvent .. "\n" ..
				"MainEvent2=" .. EventUsage.MainEvent2 .. "\n" ..
				"BackupEvent=" .. EventUsage.BackupEvent .. "\n" ..
				"BackupEvent2=" .. EventUsage.BackupEvent2)
		end
	end
end

function EventHandler.OnEvent:Connect(Event: string, callback: (Player, {}) -> ())
	pcall(function()
		for remoteEvent, _ in pairs(RemoteEvents) do
			local RunService = game:GetService("RunService")
			if RunService:IsClient() then
				RemoteEvents[remoteEvent].OnClientEvent:Connect(function(event, ...)
					if EventHandler.ConnectedClients[event] == nil then
						EventHandler.ConnectedClients[event] = {}
					end
					table.insert(EventHandler.ConnectedClients[event], callback)
					if DEBUG then
						print("[Client] [ConnectedClients] - ", Event, " | ", EventHandler.ConnectedClients[event])
						print("[Client] Event is being received: ", event)
					end
					if event == Event then
						callback(...)
					end
				end)
			elseif RunService:IsServer() then
				RemoteEvents[remoteEvent].OnServerEvent:Connect(function(player, event, ...)
					if EventHandler.ConnectedClients[event] == nil then
						EventHandler.ConnectedClients[event] = {}
					end
					table.insert(EventHandler.ConnectedClients[event], callback)
					if DEBUG then
						print("[Server] [ConnectedClients] - ", Event, " | ", EventHandler.ConnectedClients[event])
						print("[Server] Event is being received: ", event)
					end
					if event == Event then
						callback(player, ...)
					end
				end)
			end
		end
	end)
end

function EventHandler:FireEventToClient(Event: string, player, ...)
	local RunService = game:GetService("RunService")

	if RunService:IsServer() then
		if EventUsage.MainEvent % 100 ~= 0 then
			EventUsage.MainEvent = EventUsage.MainEvent + 1
			RemoteEvents.MainEvent:FireClient(player, Event, ...)
		elseif EventUsage.MainEvent2 % 100 ~= 0 then
			EventUsage.MainEvent2 = EventUsage.MainEvent2 + 1
			RemoteEvents.MainEvent2:FireClient(player, Event, ...)
		elseif EventUsage.BackupEvent % 100 ~= 0 then
			EventUsage.BackupEvent = EventUsage.BackupEvent + 1
			RemoteEvents.BackupEvent:FireClient(player, Event, ...)
		elseif EventUsage.BackupEvent2 % 100 ~= 0 then
			EventUsage.BackupEvent2 = EventUsage.BackupEvent2 + 1
			RemoteEvents.BackupEvent2:FireClient(player, Event, ...)
		else
			warn("Queues have been filled, resetting usage marks!")
			EventUsage.MainEvent = 1
			EventUsage.MainEvent2 = 1
			EventUsage.BackupEvent = 1
			EventUsage.BackupEvent2 = 1
			RemoteEvents.MainEvent:FireClient(player, Event, ...)
		end
	end
end

-- TODO: Add support for cross script events, locally for client or server.

return EventHandler
