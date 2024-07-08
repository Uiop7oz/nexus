--[[
`7MN.   `7MF' .g8""8q.  MMP""MM""YMM `7MM"""YMM         
  MMN.    M .dP'    `YM.P'   MM   `7   MM    `7         
  M YMb   M dM'      `MM     MM        MM   d        
  M  `MN. M MM        MM     MM        MMmmMM        
  M   `MM.M MM.      ,MP     MM        MM   Y  ,        
  M     YMM `Mb.    ,dP'     MM        MM     ,M     
.JML.    YM   `"bmmd"'     .JMML.    .JMMmmmmMMM     
                                                        
Please be aware that this code is outdated and may not represent the best coding practices.
Please do not rename my things into your name and take credit for my code. [ DMCA PROTECTED ]
]]--

if not game:IsLoaded() then 
    game.Loaded:Wait()
end

local HttpService = Services.HttpService
local TeleportService = Services.TeleportService
local Players = Services.Players
local LocalPlayer = Players.LocalPlayer
local humanoid = Players.LocalPlayer.Character:WaitForChild("Humanoid")
local RunService = Services.RunService
local Workspace = Services.Workspace
local virtualUser = Services.VirtualUser
local Healing = false
local AutoFarm = false
local range = 15

local mt = getrawmetatable(game)
setreadonly(mt, false)

local oldindex = mt.__index
mt.__index = newcclosure(function(self, b)
    if b == 'JumpPower' then
        return 
    elseif b == 'WalkSpeed' then
        return 
    end
    return oldindex(self, b)
end)

for i, item in ipairs(workspace.Purchases:GetChildren()) do
    if item.Name == "MVPurchases" then 
        for i, item in ipairs(item:GetChildren()) do
            if item.Name == "[Group Armor]\010[12 Wins]" then
                item.Parent.Name = "Group" 
            end
        end
    end
end

local nexus = loadstring(game:HttpGet("https://github.com/s-o-a-b/nexus/releases/download/aYXKCuZPip/aYXKCuZPip.txt"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/s-o-a-b/nexus/main/assets/SaveManager"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/s-o-a-b/nexus/main/assets/InterfaceManager"))()

local Options = nexus.Options
SaveManager:SetLibrary(nexus)

local Window = nexus:CreateWindow({
    Title = "skid", "",
    SubTitle = "",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = true,
    Theme = "Dark",
})

local Tabs = {
    Main = Window:AddTab({
        Title = "Main",
        Icon = "rbxassetid://10734975692"
    }),
    Player = Window:AddTab({
        Title = "Player",
        Icon = "rbxassetid://10747373176"
    }),
    Server = Window:AddTab({
        Title = "Server",
        Icon = "rbxassetid://10734949856"
    }),
    Settings = Window:AddTab({
        Title = "Settings",
        Icon = "rbxassetid://10734950020"
    }),
}

local function buyArmor(armorName)
    pcall(function() 
        local button = workspace.Purchases.SPurchases.Armors[armorName].Button
        firetouchinterest(game.Players.LocalPlayer.Character.Head, button, 0)
        firetouchinterest(game.Players.LocalPlayer.Character.Head, button, 1)
    end)  
end

local function buyHelmet(helmetName)
    pcall(function() 
        local button = workspace.Purchases.MVPurchases.Helmets[helmetName].SWHelmet
        firetouchinterest(game.Players.LocalPlayer.Character.Head, button, 0)
        firetouchinterest(game.Players.LocalPlayer.Character.Head, button, 1)
    end)
end

local function findNearestPlayer()
    local localCharacter = LocalPlayer.Character
    local players = game.Players:GetPlayers()
    local nearestPlayer = nil
    local nearestDistance = math.huge

    for i, player in ipairs(players) do
        if player ~= LocalPlayer then
            local character = player.Character
            if character and character:FindFirstChild("Humanoid") and character.Humanoid.Health > 0 then
                local distance = (localCharacter.HumanoidRootPart.Position - character.HumanoidRootPart.Position).magnitude
                if distance < nearestDistance then
                    nearestPlayer = player
                    nearestDistance = distance
                end
            end
        end
    end

    return nearestPlayer, nearestDistance
end

local function attackNearestPlayer()
    local success, result = pcall(function() 

        local localCharacter = LocalPlayer.Character
        local Axe = LocalPlayer.Backpack:FindFirstChild("Sword") or localCharacter:FindFirstChild("Sword")
        local humanoid = localCharacter:FindFirstChildOfClass("Humanoid")
        
        local nearestPlayer, nearestDistance = findNearestPlayer()
        
        if nearestPlayer and nearestDistance <= range then
            local targetCharacter = nearestPlayer.Character
    
            if LocalPlayer.Backpack:FindFirstChild("Sword") and not AutoFarm and not Healing then 
                humanoid:EquipTool(Axe) 
            end 
            if Axe and Axe:IsA("Tool") and Axe:FindFirstChild("Handle") then
                local targetHumanoid = targetCharacter:FindFirstChildOfClass("Humanoid")
                local targetAxeEquipped = targetCharacter:FindFirstChild("Sword")  
                local targetAxeInBackpack = nearestPlayer.Backpack:FindFirstChild("Sword") 
                
                if targetHumanoid and (targetAxeEquipped or targetAxeInBackpack) and not AutoFarm then
                    Axe:Activate()
                    for _, part in ipairs(targetCharacter:GetChildren()) do
                        if part:IsA("BasePart") and not AutoFarm then
                            local torso = localCharacter:FindFirstChild("HumanoidRootPart") or localCharacter:FindFirstChild("Torso")
                            
                            if torso then
                                local direction = (part.Position - torso.Position).unit
                                torso.CFrame = CFrame.new(torso.Position, torso.Position + Vector3.new(direction.X, 0, direction.Z))
                            end
                            
                            firetouchinterest(Axe.Handle, part, 0)
                            firetouchinterest(Axe.Handle, part, 1)
                        end
                    end
                end
            end
        end
    end)
end

local function AntiVoid()
    local Character = LocalPlayer.Character
    local HumanoidRootPart = Character and Character:FindFirstChild("HumanoidRootPart")
    local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")
    local FallenPartsDestroyHeight = Workspace.FallenPartsDestroyHeight
    local LastSafePosition = HumanoidRootPart.Position
    local LastSafeOrientation = HumanoidRootPart.CFrame
    local TeleportCount = 0
    local LastTeleportTime = tick()

    if not Options.AntiVoid.Value then
        return
    end
    repeat
        Character = LocalPlayer and LocalPlayer.Character
        HumanoidRootPart = Character and Character:FindFirstChild("HumanoidRootPart")
        Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")
        wait()
    until LocalPlayer and Character and HumanoidRootPart and Humanoid or not Options.AntiVoid.Value

    local function IsInVoid()
        return HumanoidRootPart.Position.Y < -250
    end

    local function IsTouchingGround()
        return Humanoid.FloorMaterial ~= Enum.Material.Air
    end

    local function TeleportToLastSafePosition()
        HumanoidRootPart.CFrame = LastSafeOrientation * CFrame.new(Vector3.new(0, 10, 0))
    end

    local function TeleportToFixedPosition()
        HumanoidRootPart.CFrame = CFrame.new(Vector3.new(-0, 81, 8))
    end

    local function Update()
        if IsInVoid() then
            TeleportToLastSafePosition()
            TeleportCount = TeleportCount + 1
            local currentTime = tick()
            if TeleportCount >= 3 and (currentTime - LastTeleportTime) <= 5 then
                TeleportToFixedPosition()
                TeleportCount = 0
            elseif (currentTime - LastTeleportTime) > 5 then
                TeleportCount = 1
            end
            LastTeleportTime = currentTime
        elseif IsTouchingGround() then
            LastSafePosition = HumanoidRootPart.Position
            LastSafeOrientation = HumanoidRootPart.CFrame
        end
    end

    RunService.Stepped:Connect(Update)
end

local Toggle = Tabs.Main:AddToggle("AutoFarm", {
    Title = "Auto Farm",
    Default = false,
    Callback = function(value)
        if value then 
            repeat task.wait(.1) 
                local success, result = pcall(function() 
                local character = LocalPlayer.Character

                local stuff = workspace:GetDescendants()
                for i = 1, #stuff do
                    if stuff[i] and stuff[i].Parent and stuff[i].Name == "Block" and stuff[i].Parent.Name == "Ores" then
                        AutoFarm = true 
                        repeat wait()
                            local Axe = LocalPlayer.Backpack:FindFirstChild("Axe") or character:FindFirstChild("Axe")

                            LocalPlayer.Character:WaitForChild("Humanoid"):EquipTool(LocalPlayer.Backpack:FindFirstChild("Axe") or LocalPlayer.Character:FindFirstChild("Axe"))
                            if Axe and Axe:IsA("Tool") and Axe.Enabled then
                                LocalPlayer.Character.HumanoidRootPart.CFrame = stuff[i].CFrame
                                LocalPlayer.Character.Axe.RemoteEvent:FireServer(stuff[i])
                            end
                        until not Options.AutoFarm.Value or not stuff[i] or stuff[i].Name ~= "Block" or not stuff[i].Parent or stuff[i].Parent.Name ~= "Ores" or not value 
                    end
                end  
                if LocalPlayer.Backpack:FindFirstChild("Axe") or LocalPlayer.Character:FindFirstChild("Axe") then
                    LocalPlayer.Character:SetPrimaryPartCFrame(CFrame.new(0, 181.5, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1))
                end
                AutoFarm = false  
            end)
            until not Options.AutoFarm.Value
        end
    end
})

local Toggle = Tabs.Main:AddToggle("KillAura", {
    Title = "Kill Aura",
    Default = false,
    Callback = function(value)
        if value then
            repeat task.wait()  
                attackNearestPlayer()
            until not Options.KillAura.Value
        end
    end
})

local Toggle = Tabs.Main:AddToggle("Esp", {
    Title = "Player Chams",
    Default = false,
    Callback = function(value)
        if value then 
            repeat 
                local success, result = pcall(function() 
                    task.wait()  
                for _, player in ipairs(game.Players:GetPlayers()) do
                    if player ~= game.Players.LocalPlayer then
                        local character = player.Character
                        if character and not character:FindFirstChild("ESP") then
                            local esp = Instance.new("Highlight", character)
                            esp.OutlineTransparency = 1
                            esp.Name = "ESP"
                            esp.FillColor = Color3.fromRGB(255, 0, 0)
                            esp.OutlineTransparency = 0
                            esp.FillColor = Color3.fromRGB(255, 0, 0)
                            esp.OutlineColor = Color3.new(0, 0, 255)
                        end
                    end
                end      
            end)     
          
            until not Options.Esp.Value

            for _, player in ipairs(game.Players:GetPlayers()) do
                if player ~= game.Players.LocalPlayer then
                    local character = player.Character
                    if character then
                        local esp = character:FindFirstChild("ESP")
                        if esp then
                            esp:Destroy()
                        end
                    end
                end   

            end 
        end
    end
})

local Toggle = Tabs.Main:AddToggle("AntiVoid", {
    Title = "Anti-Void",
    Default = false,
    Callback = function(value)
        if value then 
            AntiVoid() 
        end
    end
})
local Toggle = Tabs.Main:AddToggle("AutoHeal", {
    Title = "Auto Heal",
    Default = false,
    Callback = function(value)
        if value then 
            repeat task.wait()
                pcall(function()  
                    local Heal = LocalPlayer.Backpack:FindFirstChild("Heal") or LocalPlayer.Character:FindFirstChild("Heal")
                    local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
                    
                    if humanoid and Heal and humanoid.Health < 25 then
                        Healing = true
                        humanoid:EquipTool(Heal)
                        virtualUser:ClickButton1(Vector2.new(777, 777))
                        Healing = false
                    end 
                end)
            until not Options.AutoHeal.Value
        end
    end
})

local Toggle = Tabs.Main:AddToggle("AutoArmor", {
    Title = "Auto Armor",
    Default = false,
    Callback = function(value)
        if value then 
            repeat task.wait()
                pcall(function() 
                    local wins = LocalPlayer.leaderstats.Wins.Value
                    if wins >= 200 then
                        buyArmor("[Diamond Armor]\010[200 Wins]")
                    elseif wins >= 120 then
                        buyArmor("[Iron Armor]\010[120 Wins]")
                    elseif wins >= 80 then
                        buyArmor("[Gold Armor]\010[80 Wins]")
                    elseif wins >= 20 then
                        buyArmor("[Wood Armor]\010[20 Wins]")
                    else
                        print("You can't buy any armor with your current number of wins.")
                    end
                    
                    if wins >= 6 then
                        buyHelmet("[Obsidian Helmet]\010[6 Wins]")
                    elseif wins >= 4 then
                        buyHelmet("[Emerald Helmet]\010[4 Wins]")
                    elseif wins >= 2 then
                        buyHelmet("[Ruby Helmet]\010[2 Wins]")
                    else
                        buyHelmet("[ Diamond Helmet ]\010[FREE]")
                    end
                end)
            until not Options.AutoArmor.Value
        end
    end
})

local Toggle = Tabs.Main:AddToggle("AP", {
    Title = "Auto Buy Powers",
    Default = false,
    Callback = function(value)
        if value then 
            repeat task.wait()
                pcall(function() 
                    if LocalPlayer.leaderstats.Coins.Value > 80 and not LocalPlayer:FindFirstChild("PowerUpHighJump") then
                        firetouchinterest(game.Players.LocalPlayer.Character.Head, workspace.Purchases.MVPurchases.PowerUps["[High Jump]\010[80 Coins]"].Head, 0)
                        firetouchinterest(game.Players.LocalPlayer.Character.Head, workspace.Purchases.MVPurchases.PowerUps["[High Jump]\010[80 Coins]"].Head, 1)
                    end 
                    if LocalPlayer.leaderstats.Coins.Value > 160 and not LocalPlayer:FindFirstChild("PowerUpHeal") then
                        firetouchinterest(game.Players.LocalPlayer.Character.Head, workspace.Purchases.MVPurchases.PowerUps["[Heal]\010[160 Coins]"].Head, 0)
                        firetouchinterest(game.Players.LocalPlayer.Character.Head, workspace.Purchases.MVPurchases.PowerUps["[Heal]\010[160 Coins]"].Head, 1)
                    end 
                    if LocalPlayer.leaderstats.Coins.Value > 120 and not LocalPlayer:FindFirstChild("PowerUpSpeed") then
                        firetouchinterest(game.Players.LocalPlayer.Character.Head, workspace.Purchases.MVPurchases.PowerUps["[+10 Speed]\010[120 Coins]"].Head, 0)
                        firetouchinterest(game.Players.LocalPlayer.Character.Head, workspace.Purchases.MVPurchases.PowerUps["[+10 Speed]\010[120 Coins]"].Head, 1)
                    end 
                    if LocalPlayer.leaderstats.Coins.Value > 200 and not LocalPlayer:FindFirstChild("PowerUpShield") then
                        firetouchinterest(game.Players.LocalPlayer.Character.Head, workspace.Purchases.SPurchases["Power Ups"]["[Shield]\010[200 Coins]"].Head, 0)
                        firetouchinterest(game.Players.LocalPlayer.Character.Head, workspace.Purchases.SPurchases["Power Ups"]["[Shield]\010[200 Coins]"].Head, 1)
                    end 
                end)
            until not Options.AP.Value
        end
    end
})

local Toggle = Tabs.Player:AddToggle("InfiniteJump", {
    Title = "Infinite Jump",
    Default = false,
    Callback = function(value)
        InfiniteJump = value
		 
        Services.UserInputService.JumpRequest:Connect(function()
            if InfiniteJump then
                game:GetService "Players".LocalPlayer.Character:FindFirstChildOfClass'Humanoid':ChangeState("Jumping")
            end
        end)
    end
})

local Toggle = Tabs.Player:AddToggle("Walkspeed", {
    Title = "Walkspeed",
    Default = false,
    Callback = function(value)
        if value then
            repeat task.wait()  
                local humanoid = Players.LocalPlayer.Character:WaitForChild("Humanoid")
                humanoid.WalkSpeed = tonumber(Options.Speed.Value)
            until not Options.Walkspeed.Value
            local humanoid = Players.LocalPlayer.Character:WaitForChild("Humanoid")
            humanoid.WalkSpeed = tonumber(16)
        end
    end
})


local Slider = Tabs.Player:AddSlider("Speed", {
	Title = "Speed",
	Default = 16,
	Min = 16,
	Max = 200,
	Rounding = 0,
	Callback = function(Value)
	end
})
local Toggle = Tabs.Player:AddToggle("JP", {
    Title = "Jump-Power",
    Default = false,
    Callback = function(value)
        if value then
            repeat task.wait()  
                local humanoid = Players.LocalPlayer.Character:WaitForChild("Humanoid")
                humanoid.JumpPower = tonumber(Options.Power.Value)
            until not Options.JP.Value
            humanoid.JumpPower = tonumber(50)
        end
    end
})


local Slider = Tabs.Player:AddSlider("Power", {
	Title = "Power",
	Default = 50,
	Min = 50,
	Max = 200,
	Rounding = 0,
	Callback = function(Value)
	end
})

local Toggle = Tabs.Settings:AddToggle("Settings", {
    Title = "Save Settings",
	Default = false,
    Callback = function(value)
		if value then 
            repeat task.wait() 
                if _G.FB35D == true then return end SaveManager:Save(game.PlaceId) 
            until not Options.Settings.Value
		end
	end
})
Tabs.Settings:AddButton({
	Title = "Delete Setting Config",
	Callback = function()
		delfile("nexus-001/settings/".. game.PlaceId ..".json")
	end  
})  

local Toggle = Tabs.Server:AddToggle("AutoRejoin", {
	Title = "Auto Rejoin",
	Default = false,
	Callback = function(value)
		if value then 
            nexus:Notify({Title = 'Auto Rejoin', Content = 'You will rejoin if you are kicked or disconnected from the game', Duration = 5 })
            repeat task.wait() 
                local lp,po,ts = Players.LocalPlayer,game.CoreGui.RobloxPromptGui.promptOverlay,Services.TeleportService
                po.ChildAdded:connect(function(a)
                    if a.Name == 'ErrorPrompt' then
                        ts:Teleport(game.PlaceId)
                        task.wait(2)
                    end
                end)
            until Options.AutoRejoin.Value
        end  
    end
})
 
local Toggle = Tabs.Server:AddToggle("ReExecute", {
    Title = "Auto ReExecute",
    Default = false,
    Callback = function(value)
        local KeepNexus = value
        local queueteleport = (syn and syn.queue_on_teleport) or queue_on_teleport or (fluxus and fluxus.queue_on_teleport)

        Players.LocalPlayer.OnTeleport:Connect(function(State)
            if KeepNexus and (not TeleportCheck) and queueteleport then
                TeleportCheck = true
                queueteleport("loadstring(game:HttpGet('https://raw.githubusercontent.com/s-o-a-b/nexus/main/loadstring'))()")
            end
        end)
    end 
})

Tabs.Server:AddButton({
	Title = "Rejoin-Server",
	Callback = function()
		Services.TeleportService:Teleport(game.PlaceId, Player)
	end
})  

Tabs.Server:AddButton({
	Title = "Server-Hop", 
	Callback = function()
	   local Http = Services.HttpService
		local TPS = Services.TeleportService
		local Api = "https://games.roblox.com/v1/games/"
		local _place,_id = game.PlaceId, game.JobId
		local _servers = Api.._place.."/servers/Public?sortOrder=Desc&limit=100"
		local function ListServers(cursor)
			local Raw = game:HttpGet(_servers .. ((cursor and "&cursor="..cursor) or ""))
			return Http:JSONDecode(Raw)
		end
		local Next; repeat
			local Servers = ListServers(Next)
			for i,v in next, Servers.data do
				if v.playing < v.maxPlayers and v.id ~= _id then
					local s,r = pcall(TPS.TeleportToPlaceInstance,TPS,_place,v.id,Player)
					if s then break end
				end
			end
			Next = Servers.nextPageCursor
		until not Next
	end
})

-- Set libraries and folders
SaveManager:SetLibrary(nexus)
InterfaceManager:SetLibrary(nexus)
SaveManager:SetIgnoreIndexes({})
SaveManager:IgnoreThemeSettings()
InterfaceManager:SetFolder("nexus-001")
SaveManager:SetFolder("nexus-001")

-- Build interface section and load the game
InterfaceManager:BuildInterfaceSection(Tabs.Settings)
SaveManager:Load(game.PlaceId)

-- Select the first tab in the window
Window:SelectTab(1)
