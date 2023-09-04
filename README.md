# Event Handler

The `EventHandler` module is designed to manage and facilitate communication between client and server in a Roblox game environment. It provides methods for firing events, connecting event handlers, and maintaining event usage queues.

## Module Structure

The module consists of several components and functionalities:

### Remote Events

Remote events are created and stored in the `RemoteEvents` table for communication between the client and server. There are two sets of events: `MainEvent` and `BackupEvent`, each with two variants (`MainEvent` and `MainEvent2`, `BackupEvent` and `BackupEvent2`). These events are responsible for transmitting data between the client and server.

### Event Usage Tracking

The `EventUsage` table keeps track of how many times each event has been fired. If an event is fired too frequently (every 100 times), it switches to a backup event to prevent overwhelming the system. If all events are used up, the usage counters are reset.

### Connected Clients

The `ConnectedClients` table keeps track of clients connected to specific events. When an event is received, it calls the appropriate event handlers for the connected clients.

### Debugging

The `DEBUG` flag can be used to enable or disable debug information for event firing and client connections.

## Public Interface

The following methods and properties are available for external use:

### Properties

- `EventHandler.Events`: A table containing event names. (Example: `"TestEvent"`)

### Methods

-  `EventHandler:FireEvent(Event: string, ...)`

Fires an event from the client or server, depending on the context. It ensures that events are fired within the usage limits and switches to backup events if necessary.

- `EventHandler.OnEvent:Connect(Event: string, callback: (Player, ...) -> ())`

Connects a callback function to an event. When the specified event is received, the callback is invoked with the event data.

- `EventHandler:FireEventToClient(Event: string, player, ...)`

Fires an event to a specific client. This method is intended for server use and follows the same event usage logic as `FireEvent`.

## Example Usage

```lua
local EventHandler = require(path.to.EventHandler)

-- Connect a callback to an event on server
EventHandler.OnEvent:Connect(EventHandler.Events.TestEvent, function(player, data)
    print(player.Name .. " received TestEvent with data: " .. data)
end)

-- Connect a callback to an event on client
EventHandler.OnEvent:Connect(EventHandler.Events.TestEvent, function(data)
    print("Received TestEvent with data: " .. data)
end)

-- Fire an event from the client
EventHandler:FireEvent(EventHandler.Events.TestEvent, "Hello, world!")

-- Fire an event to all clients from the server
EventHandler:FireEventToClient(EventHandler.Events.TestEvent, "Hello, alll!")

-- Fire an event to a specific client from the server
local player = your.Player
EventHandler:FireEventToClient(EventHandler.Events.TestEvent, player, "Hello to you, client!")```
