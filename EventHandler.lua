local EventHandler = {}

local RemoteEvents = {
	MainEvent = script:WaitForChild("MainEvent"),
	MainEvent2 = script:WaitForChild("MainEvent2"),
	BackupEvent = script:WaitForChild("BackupEvent"),
	BackupEvent2 = script:WaitForChild("BackupEvent2")
}

local BindableEvents = {
	BindEvent1 = script:WaitForChild("BindEvent1"),
	BindEvent2 = script:WaitForChild("BindEvent2"),
	BackupBind1 = script:WaitForChild("BackupBind1"),
	BackupBind2 = script:WaitForChild("BackupBind2")
}

-- Keeping track of usage events for dynamic event running

local EventUsage = {
	MainEvent = 1,
	MainEvent2 = 1,
	BackupEvent = 1,
	BackupEvent2 = 1,
}

local BindableUsage = {
	BindEvent1 = 1,
	BindEvent2 = 1,
	BackupBind1 = 1,
	BackupBind2 = 1,
}

local LoadedEvents = {}

local DEBUG = false

EventHandler.Events = {
	TestEvent = "TestEvent"
}

EventHandler.ConnectedClients = {}
EventHandler.BindableConnectedClients = {}

EventHandler.OnEvent = {}
EventHandler.OnLocalEvent = {}

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
		if EventHandler.ConnectedClients[Event] == nil then
			EventHandler.ConnectedClients[Event] = {}
		end
		table.insert(EventHandler.ConnectedClients[Event], callback)

		for remoteEvent, _ in pairs(RemoteEvents) do
			local RunService = game:GetService("RunService")
			if RunService:IsClient() then
				RemoteEvents[remoteEvent].OnClientEvent:Connect(function(event, ...)
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
	elseif RunService:IsClient() then
		
	end
end

function EventHandler:FireBind(Event: string, ...)
	local RunService = game:GetService("RunService")

	if RunService:IsClient() then
		if BindableUsage.BindEvent1 % 100 ~= 0 then
			BindableUsage.BindEvent1 += 1
			BindableEvents.BindEvent1:Fire(Event, ...)
		elseif BindableUsage.BindEvent2 % 100 ~= 0 then
			BindableUsage.BindEvent2 += 1
			BindableEvents.BindEvent2:Fire(Event, ...)
		elseif BindableUsage.BackupBind1 % 100 ~= 0 then
			BindableUsage.BackupBind1 += 1
			BindableEvents.BackupBind1:Fire(Event, ...)
		elseif BindableUsage.BackupBind2 % 100 ~= 0 then
			BindableUsage.BackupBind2 += 1
			BindableEvents.BackupBind2:Fire(Event, ...)
		else
			warn("BIND - Queues have been filled, resetting usage marks!")
			BindableUsage.BindEvent1 = 1
			BindableUsage.BindEvent2 = 1
			BindableUsage.BackupBind1 = 1
			BindableUsage.BackupBind2 = 1
			
			BindableEvents.BindEvent1:Fire(Event, ...)
		end
		if DEBUG then
			print("[Client] Firing BindEvent: " .. Event)
			print("[Client] Total BindEvent Usage:\n" ..
				"BindEvent1=" .. BindableUsage.BindEvent1 .. "\n" ..
				"BindEvent2=" .. BindableUsage.BindEvent2 .. "\n" ..
				"BackupBind1=" .. BindableUsage.BackupBind1 .. "\n" ..
				"BackupBind2=" .. BindableUsage.BackupBind2)
		end
	elseif RunService:IsServer() then
		if BindableUsage.BindEvent1 % 100 ~= 0 then
			BindableUsage.BindEvent1 += 1
			BindableEvents.BindEvent1:Fire(Event, ...)
		elseif BindableUsage.BindEvent2 % 100 ~= 0 then
			BindableUsage.BindEvent2 += 1
			BindableEvents.BindEvent2:Fire(Event, ...)
		elseif BindableUsage.BackupBind1 % 100 ~= 0 then
			BindableUsage.BackupBind1 += 1
			BindableEvents.BackupBind1:Fire(Event, ...)
		elseif BindableUsage.BackupBind2 % 100 ~= 0 then
			BindableUsage.BackupBind2 += 1
			BindableEvents.BackupBind2:Fire(Event, ...)
		else
			warn("BIND - Queues have been filled, resetting usage marks!")
			BindableUsage.BindEvent1 = 1
			BindableUsage.BindEvent2 = 1
			BindableUsage.BackupBind1 = 1
			BindableUsage.BackupBind2 = 1

			BindableEvents.BindEvent1:Fire(Event, ...)
		end
		if DEBUG then
			print("[Server] Firing BindEvent: " .. Event)
			print("[Server] Total BindEvent Usage:\n" ..
				"BindEvent1=" .. BindableUsage.BindEvent1 .. "\n" ..
				"BindEvent2=" .. BindableUsage.BindEvent2 .. "\n" ..
				"BackupBind1=" .. BindableUsage.BackupBind1 .. "\n" ..
				"BackupBind2=" .. BindableUsage.BackupBind2)
		end
	end
end

function EventHandler.OnLocalEvent:Connect(Event: string, callback: ({}) -> ())
	pcall(function()
		if EventHandler.BindableConnectedClients[Event] == nil then
			EventHandler.BindableConnectedClients[Event] = {}
		end
		table.insert(EventHandler.BindableConnectedClients[Event], callback)

		for bindEvent, _ in pairs(BindableEvents) do
			local RunService = game:GetService("RunService")
			if RunService:IsClient() then
				BindableEvents[bindEvent].Event:Connect(function(event, ...)
					if DEBUG then
						print("[Client] [BindConnectedClients] - ", Event, " | ", EventHandler.BindableConnectedClients[event])
						print("[Client] BindEvent is being received: ", event)
					end
					if event == Event then
						callback(...)
					end
				end)
			elseif RunService:IsServer() then
				BindableEvents[bindEvent].Event:Connect(function(event, ...)
					if DEBUG then
						print("[Server] [BindConnectedClients] - ", Event, " | ", EventHandler.BindableConnectedClients[event])
						print("[Server] BindEvent is being received: ", event)
					end
					if event == Event then
						callback(...)
					end
				end)
			end
		end
	end)
end

return EventHandler
