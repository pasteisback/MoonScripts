local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("Moon | Prison Life", "Synapse")

local Tab = Window:NewTab("Prison Life")
local Section = Tab:NewSection("Prison Life")

Events = {
	TeamEvent = workspace.Remote.TeamEvent,
	ShootEvent = game:GetService("ReplicatedStorage").ShootEvent,
	loadchar = function()
		if plr.Team == game.Teams.Inmates then
			local ohString1 = "Bright orange"
			workspace.Remote.TeamEvent:FireServer(ohString1)
		else
			local ohString1 = "Bright blue"
			workspace.Remote.TeamEvent:FireServer(ohString1)
		end
	end,
}

function getpos()
	return game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart").CFrame
end

function GetTeam()
	return game.Players.LocalPlayer.TeamColor.Name
end

function MoveTo(Pos,t)
	if typeof(Pos):lower() == "position" then
		Pos = CFrame.new(Pos)
	end
	for i =1,3 do
		plr.Character:FindFirstChild("HumanoidRootPart").CFrame = Pos
	end
end

function refresh(Pos)
	if not Pos then
		Pos = getpos()
	end
	local Goto = Pos or getpos()
	local Connections = {}
	local Cam = workspace.CurrentCamera.CFrame
	Connections[1] = plr.CharacterAdded:Connect(function(charnew)
		pcall(function()
			task.spawn(function()
				workspace.CurrentCamera:GetPropertyChangedSignal("CFrame"):Wait()
				for i =1,5 do
					workspace.CurrentCamera.CFrame = Cam
				end
			end)
			repeat task.wait() until charnew and charnew:FindFirstChild("HumanoidRootPart")
			MoveTo(Goto)
			task.spawn(function()
				wait(.05)
				MoveTo(Goto)
			end)
			Connections[1]:Disconnect()
		end)
	end)
	Events.loadchar()
	print("Refreshed")
	return
end

function Notif(msg)
	game:GetService("StarterGui"):SetCore("SendNotification",{
		Title = "Moon | Prison Life",
		Text = msg,
		Duration = 5
	})
end

function turnOnKAforseconds(seconds)
	local startTime = os.clock()
	local mainRemotes = game.ReplicatedStorage
	local meleeRemote = mainRemotes['meleeEvent']

	while os.clock() - startTime < seconds do
		for _, plr in pairs(game:GetService('Players'):GetChildren()) do
			if plr.Name ~= game.Players.LocalPlayer.Name then
				meleeRemote:FireServer(plr)
			end
		end
		wait(0.1)
	end
end

function teleport(target)
	game.Players.LocalPlayer.Character.Humanoid.Sit = false
	game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 1)
end

Section:NewButton("Kill Aura", "rawr", function()
	mainRemotes = game.ReplicatedStorage
	meleeRemote = mainRemotes['meleeEvent']

	killAura = false

	contextactionservice = game.ContextActionService

	function toggleKillAura(actionName, inputState, inputObject)
		if inputState == Enum.UserInputState.Begin then
			if killAura == true then
				killAura = false
			else
				killAura = true
			end
		end
	end

	contextactionservice:BindAction('ToggleKillAura', toggleKillAura, false, Enum.KeyCode.P)

	while wait() do
		if killAura == true then
			for _, plr in pairs(game:GetService('Players'):GetChildren()) do
				if plr.Name ~= game.Players.LocalPlayer.Name then
					meleeRemote:FireServer(plr)
				end
			end
		end
	end 
end)

Section:NewButton("Taser Bypass", "rawr", function()
	game.Players.LocalPlayer.Character.ClientInputHandler.Disabled = true
	game.Players.LocalPlayer.CharacterAdded:connect(function()
		game.Workspace:WaitForChild(game.Players.LocalPlayer.Name)
		game.Players.LocalPlayer.Character.ClientInputHandler.Disabled = true
	end)
end)

Section:NewButton("Arrest Bypass", "rawr", function()
	for i,v in pairs(getconnections(workspace:WaitForChild("Remote").arrestPlayer.OnClientEvent)) do
		v:Disable()
	end
end)

Section:NewButton("Team Guard", "rawr", function()
	workspace.Remote.TeamEvent:FireServer("Bright blue")
end)

Section:NewButton("Team Neutral", "rawr", function()
	workspace.Remote.TeamEvent:FireServer("Medium stone grey")
end)

Section:NewButton("Team Inmates", "rawr", function()
	workspace.Remote.TeamEvent:FireServer("Bright orange")
end)

Section:NewButton("Team Criminals", "rawr", function()
	workspace.Remote.TeamEvent:FireServer("Bright Red")
end)

Section:NewButton("Arrest All", "rawr", function()
	local Player = game.Players.LocalPlayer
	local cpos = Player.Character.HumanoidRootPart.CFrame
	for i,v in pairs(game.Teams.Criminals:GetPlayers()) do
		if v.Name ~= Player.Name then
			local i = 10
			repeat
				wait()
				i = i-1
				game.Workspace.Remote.arrest:InvokeServer(v.Character.HumanoidRootPart)
				Player.Character.HumanoidRootPart.CFrame = v.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 1)
			until i == 0
		end
	end
	Player.Character.HumanoidRootPart.CFrame = cpos
	Notif("Arrested everyone.")
end)

local eztarget = ""
Section:NewTextBox("Target", "rawr", function(txt)
	eztarget = txt
end)

Section:NewButton("Kill Target", "rawr", function()
	local playerTarget = game.Players:FindFirstChild(eztarget)

	if playerTarget then
		local startTime = os.clock()
		local mainRemotes = game.ReplicatedStorage
		local meleeRemote = mainRemotes['meleeEvent']

		while os.clock() - startTime < 3 do
			for _, plr in pairs(game:GetService('Players'):GetChildren()) do
				if plr.Name ~= game.Players.LocalPlayer.Name then
					meleeRemote:FireServer(plr)
					teleport(playerTarget)
				end
			end
			wait(0.1)
		end
	else
		warn("Invalid player target:", eztarget)
	end  
end)

Section:NewButton("Arrest Target", "rawr", function()
	local playerTarget = game.Players:FindFirstChild(eztarget)

	if playerTarget then
		game.Workspace.Remote.arrest:InvokeServer(v.Character.HumanoidRootPart)
	else
		warn("Invalid player target:", eztarget)
	end
end)

Section:NewButton("TP to target", "rawr", function()
	local playerTarget = game.Players:FindFirstChild(eztarget)

	if playerTarget then
		game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = playerTarget.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 1)
	else
		warn("Invalid player target:", eztarget)
	end
end)

Section:NewButton("Instant Punch", "rawr", function()
	mainRemotes = game.ReplicatedStorage meleeRemote = mainRemotes['meleeEvent'] mouse = game.Players.LocalPlayer:GetMouse() punching = false cooldown = false function punch() cooldown = true local part = Instance.new("Part", game.Players.LocalPlayer.Character) part.Transparency = 1 part.Size = Vector3.new(5, 2, 3) part.CanCollide = false local w1 = Instance.new("Weld", part) w1.Part0 = game.Players.LocalPlayer.Character.Torso w1.Part1 = part w1.C1 = CFrame.new(0,0,2) part.Touched:connect(function(hit) if game.Players:FindFirstChild(hit.Parent.Name) then local plr = game.Players:FindFirstChild(hit.Parent.Name) if plr.Name ~= game.Players.LocalPlayer.Name then part:Destroy() for i = 1,100 do meleeRemote:FireServer(plr) end end end end) wait(1) cooldown = false part:Destroy() end mouse.KeyDown:connect(function(key) if cooldown == false then if key:lower() == "f" then punch() end end end)
end)

Section:NewButton("Get guns", "rawr", function()
	local saved = game:GetService("Players").LocalPlayer.Character:GetPrimaryPartCFrame()
	game:GetService("Players").LocalPlayer.Character:SetPrimaryPartCFrame(CFrame.new(workspace.Prison_ITEMS.giver["Remington 870"].ITEMPICKUP.Position))
	for i =1,2 do
		local ohInstance1 = game:GetService("Workspace").Prison_ITEMS.giver.M9:GetChildren()[6]
		workspace.Remote.ItemHandler:InvokeServer(ohInstance1)
		task.spawn(function()
			for i =1,3 do
				workspace.Remote.ItemHandler:InvokeServer(ohInstance1)
			end		
		end)
		local ohInstance2 = workspace.Prison_ITEMS.giver["Remington 870"].ITEMPICKUP
		workspace.Remote.ItemHandler:InvokeServer(ohInstance2)
		task.spawn(function()
			for i =1,3 do
				workspace.Remote.ItemHandler:InvokeServer(ohInstance2)
			end		
		end)
		local ohInstance3 = game:GetService("Workspace").Prison_ITEMS.giver["AK-47"]:GetChildren()[51]
		wait()
		game:GetService("Players").LocalPlayer.Character:SetPrimaryPartCFrame(CFrame.new(game:GetService("Workspace").Prison_ITEMS.giver["AK-47"]:GetChildren()[51].Position+Vector3.new(0,4,0)))
		workspace.Remote.ItemHandler:InvokeServer(ohInstance3)
		task.spawn(function()
			for i =1,3 do
				workspace.Remote.ItemHandler:InvokeServer(ohInstance3)
			end		
		end)
	end
	game:GetService("Players").LocalPlayer.Character:SetPrimaryPartCFrame(saved) 
end)

Section:NewButton("No doors", "rawr", function()
	workspace.Prison_Cellblock.doors:Destroy()
	for i,v in pairs(workspace:GetChildren())do
		if v.Name == "Doors" then
			v:Destroy()
		end
	end 
end)

Section:NewButton("Btools", "rawr", function()
	local tool1 = Instance.new("HopperBin",game.Players.LocalPlayer.Backpack)
	local tool2 = Instance.new("HopperBin",game.Players.LocalPlayer.Backpack)
	local tool3 = Instance.new("HopperBin",game.Players.LocalPlayer.Backpack)
	local tool4 = Instance.new("HopperBin",game.Players.LocalPlayer.Backpack)
	local tool5 = Instance.new("HopperBin",game.Players.LocalPlayer.Backpack)
	tool1.BinType = "Clone"
	tool2.BinType = "GameTool"
	tool3.BinType = "Hammer"
	tool4.BinType = "Script"
	tool5.BinType = "Grab"
	Notif("You have received btools.")
end)

Section:NewButton("Mod equipped gun", "rawr", function()
	Reload_Guns = {}
	if plr.Character:FindFirstChildOfClass("Tool") then
		local Tool = plr.Character:FindFirstChildOfClass("Tool")
		if not Tool:FindFirstChild("GunStates") then
			return Notif("Needs to be a gun!")
		end
		local cc = require(Tool.GunStates)
		cc["Damage"] = 9e9
		cc["FireRate"] = 0.001
		cc["Range"] = math.huge
		cc["MaxAmmo"] = math.huge
		cc["StoredAmmo"] = math.huge
		cc["AmmoPerClip"] = math.huge
		cc["CurrentAmmo"] = math.huge
		if Tool.Name ~= "Remington 870" then
			cc["Bullets"] = 1
			cc["AutoFire"] = true
		end
		Notif("Modded "..Tool)
	else
		Notif("You need to hold the tool you want to mod!")
	end
end)

Section:NewButton("TP inside of prison", "rawr", function()
	game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(879,99,2377)
end)

Section:NewButton("TP to criminal base", "rawr", function()
	game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-943, 96, 2055)
end)

Section:NewButton("TP to guard area", "rawr", function()
	game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(802,99,2270)
end)

Section:NewButton("Loop kill all", "rawr", function()
	Notif("Not killing? Kill Aura is required to be on.")
	local players = game:GetService("Players"):GetPlayers()
	while wait(1) do
		if #players > 0 then
			local randomIndex = math.random(1, #players)
			local randomPlayer = players[randomIndex]
			if randomPlayer.Character and randomPlayer.Character:FindFirstChild("HumanoidRootPart") then
				Notif("Killing " .. randomPlayer.Name)
				game.Players.LocalPlayer.Character.Humanoid.Sit = false
				game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = randomPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 1)
			else
				print("Selected player has no character or HumanoidRootPart.")
			end
		else
			print("No players in the game.")
		end
	end
end)

Section:NewButton("Godmode", "rawr", function()
	repeat task.wait() until char and char:FindFirstChildOfClass("Humanoid")
	char:FindFirstChildOfClass("Humanoid").BreakJointsOnDeath = false
	char:FindFirstChildOfClass("Humanoid").Died:Connect(function()
		refresh()
	end)
end)

Section:NewButton("Admin", "rawr", function()
	loadstring(game:HttpGet("https://raw.githubusercontent.com/pasteisback/MoonScripts/refs/heads/main/infiniteyielduniversal.lua"))()
end)

Section:NewButton("Panic", "rawr", function()
	game.Players.LocalPlayer:Kick("Moon | Prison Life | Panic Module Enabled.")
end)

Section:NewButton("Join Discord", "rawr", function()
	setclipboard("https://discord.gg/9gFABDVsP3")
end)

Notif("Fully Loaded!")
