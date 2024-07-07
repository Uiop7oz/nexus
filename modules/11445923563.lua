--[[
`7MN.   `7MF' .g8""8q.  MMP""MM""YMM `7MM"""YMM         
  MMN.    M .dP'    `YM.P'   MM   `7   MM    `7         
  M YMb   M dM'      `MM     MM        MM   d        
  M  `MN. M MM        MM     MM        MMmmMM        
  M   `MM.M MM.      ,MP     MM        MM   Y  ,        
  M     YMM `Mb.    ,dP'     MM        MM     ,M     
.JML.    YM   `"bmmd"'     .JMML.    .JMMmmmmMMM     
                                                        
Please be aware that this code is outdated and may not represent the best coding practices.
It was written before I had access to a decompiler, so it's a simple script not intended for educational purposes.
]]--

if not game:IsLoaded() then 
    game.Loaded:Wait()
end

local HttpService = Services.HttpService
local TeleportService = Services.TeleportService
local Workspace = Services.Workspace
local UserInputService = Services.UserInputService
local Players = Services.Players
local LocalPlayer = Players.LocalPlayer
local Islands = {}
local Interactions = {}
local availableTools = {} 
local GettingQuest
local ChestTeleporting
local infJumpConnection

local function setWalkSpeed(walkSpeed)
    local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")
    if humanoid then
        humanoid.WalkSpeed = walkSpeed
    end
end

local function setJumpPower(jumpPower)
    local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")
    if humanoid then
        humanoid.JumpPower = jumpPower
    end
end

function Alive(LocalPlayer)
    if LocalPlayer and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") ~= nil and LocalPlayer.Character:FindFirstChild("Humanoid") ~= nil and LocalPlayer.Character:FindFirstChild("Head") ~= nil then
        return true
    end
    return false
end

function forceServerHop()
    local Api = "https://games.roblox.com/v1/games/"
    local placeId, jobId = game.PlaceId, game.JobId
    local serversUrl = Api .. placeId .. "/servers/Public?sortOrder=Desc&limit=100"

    local function ListServers(cursor)
        local raw = game:HttpGet(serversUrl .. (cursor and "&cursor=" .. cursor or ""))
        return HttpService:JSONDecode(raw)
    end

    local nextCursor
    repeat
        local serversData = ListServers(nextCursor)
        for _, server in ipairs(serversData.data) do
            if server.playing < server.maxPlayers and server.id ~= jobId then
                local success, result = pcall(TeleportService.TeleportToPlaceInstance, TeleportService, placeId, server.id, LocalPlayer)
                if success then
                    break
                end
            end
        end
        nextCursor = serversData.nextPageCursor
    until not nextCursor
end

local success, result = pcall(function() 
    while LocalPlayer.PlayerGui.LoadingGui.Frame.LowDetail.LowDetail.Visible do wait(1)
        local a = LocalPlayer.PlayerGui.LoadingGui.Frame.LowDetail.LowDetail
        Services.VirtualInputManager:SendMouseButtonEvent(a.AbsolutePosition.X, a.AbsolutePosition.Y, 0, true, game, 1)
        Services.VirtualInputManager:SendMouseButtonEvent(a.AbsolutePosition.X, a.AbsolutePosition.Y, 0, false, game, 1)
    end
end)

for i,v in pairs(Services.Workspace["__GAME"]["__SpawnLocations"]:GetChildren()) do
	table.insert(Islands, v.Name)
end

for i,v in pairs(Services.Workspace["__GAME"]["__Interactions"]:GetChildren()) do
	if not table.find(Interactions, v.Name) then
		table.insert(Interactions, v.Name)
	end
end

local nexus = loadstring(game:HttpGet("https://github.com/s-o-a-b/nexus/releases/download/aYXKCuZPip/aYXKCuZPip.txt"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/s-o-a-b/nexus/main/assets/SaveManager"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/s-o-a-b/nexus/main/assets/InterfaceManager"))()

local Options = nexus.Options
SaveManager:SetLibrary(nexus)

local Window = nexus:CreateWindow({
    Title = "skid ", "",
    SubTitle = "",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = true,
    Theme = "Dark",
})

local Tabs = {
    Main = Window:AddTab({
        Title = "Main",
        Icon = "rbxassetid://10723424505"
    }),
    Misc = Window:AddTab({
        Title = "Misc",
        Icon = "rbxassetid://10709818534"
    }),
    Player = Window:AddTab({
        Title = "Player",
        Icon = "rbxassetid://10747373176"
    }),
    Weapon = Window:AddTab({ 
        Title = "Weapon",
        Icon = "rbxassetid://4335480896"
    }),
    Server = Window:AddTab({
        Title = "Server",
        Icon = "rbxassetid://10734949856"
    }),
    Settings = Window:AddTab({
        Title = "Settings",
        Icon = "settings"
    }),
}

local islandData = {
    ["Starter Island"] = {
        options = {"Bandit", "Strong Bandit", "Bandit Leader"},
        mapping = CFrame.new(3388, 145, 1728),
        point = "Starter Island"
    },
    ["Jungle Island"] = {
        options = {"Monkey", "Gorilla", "King Gorilla"},
        mapping = CFrame.new(1986, 140, 598),
        point = "JunglePoint"
    },
    ["Clown Island"] = {
        options = {"Clown", "Killer Clown", "Clown King"},
        mapping = CFrame.new(3007, 150, -587),
        point = "BuggyPoint"
    },
    ["Marine Island"] = {
        options = {"Marine", "Marine Official", "Lorgan"},
        mapping = CFrame.new(4941, 145, 56),
        point = "MarinePoint"
    },
    ["Lier Island"] = {
        options = {"Cat Pirate", "Mansion Guard", "Buros"},
        mapping = CFrame.new(5557, 150, 2040),
        point = "UsoppPoint"
    },
    ["Baratie"] = {
        options = {"Don Pirate", "Perolado", "Gimbo", "Don Zig"},
        mapping = CFrame.new(1363, 180, 2680),
        point = "BaratiePoint"
    },
    ["AR Park"] = {
        options = {"Marine Soldier", "Captain Rat", "Fishman", "Chewing", "Kolobi"},
        mapping = CFrame.new(-672, 160, 631),
        point = "ArlongPoint"
    },
    ["Lulue Town"] = {
        options = {"Logue Bandit", "Bashigs", "White", "Alvarida", "Logue Marine"},
        mapping = CFrame.new(5791, 140, -3231),
        point = "LoguePoint"
    }
}

local function moveToPosition(position, duration)
    local Character = LocalPlayer.Character

    if Character and Character:FindFirstChild("HumanoidRootPart") then
        local LocalHumanoidRootPart = Character.HumanoidRootPart

        local success, err = pcall(function()
            local tweenInfo = TweenInfo.new(duration, Enum.EasingStyle.Quad)
            local tween = Services.TweenService:Create(LocalHumanoidRootPart, tweenInfo, {CFrame = position})
            tween:Play()
            wait(duration)
        end)
    end 
end

local function getClosestMob(name)
    local closest, maxDist = nil, 9e9
    for _, v in pairs(workspace["__GAME"]["__Mobs"]:GetChildren()) do
        local success, result = pcall(function() 
            for _, mob in pairs(v:GetChildren()) do
                if mob:FindFirstChild("NpcConfiguration") and mob.NpcConfiguration:GetAttribute("Health") > 0 then
                    if mob.NpcConfiguration:GetAttribute("Name") == name then
                        local dist = (mob.PrimaryPart.Position - LocalPlayer.Character.PrimaryPart.Position).magnitude
                        if dist < maxDist then
                            maxDist = dist
                            closest = mob
                        end
                    end
                end
            end
        end)
    end
    return closest
end

local Toggle = Tabs.Main:AddToggle("AutoFarm", {
    Title = "Auto Farm",
    Default = false,
    Callback = function(value)
        if value then 
            repeat
                local success, errorInfo = pcall(function()
                task.wait()  
                if not ChestTeleporting and not GettingQuest and Alive(LocalPlayer) then
                    local tool = LocalPlayer.Backpack:FindFirstChild("Combat")
                    if LocalPlayer.Character.Humanoid.Health > 0 then  
                        LocalPlayer.Character.Humanoid:EquipTool(tool)
                    end 
                    local enemy = getClosestMob(Options.SelectedMob.Value)
                    if enemy and enemy.PrimaryPart then 
                        moveToPosition(enemy.PrimaryPart.CFrame, 0.03)
                        
                        local playerCombat = workspace.__GAME.__Players:FindFirstChild(LocalPlayer.Name)
                        if playerCombat and playerCombat.Combat and Alive(LocalPlayer) then
                            local args = {
                                {
                                    {
                                        "\4",
                                        "Combat",
                                        1,
                                        false,
                                        playerCombat.Combat,
                                        "Melee"
                                    },
                                    {
                                        "\n",
                                        enemy,
                                        playerCombat.Combat
                                    }
                                }
                            }
                            
                            Services.ReplicatedStorage.RemoteEvent:FireServer(unpack(args))
                        end
                    end
                end 
            end)
            
            if not success then
                warn("Error in AutoFarm:", errorInfo)
            end
            task.wait() 
        until not Options.AutoFarm.Value 
    end
end
})

local Dropdownn = Tabs.Main:AddDropdown("SelectedMob", {
    Title = "Select Mob", 
    Values = {},
    Multi = false, 
    Default = false, 
    Callback = function(value)
    end
})

local Dropdownnn = Tabs.Main:AddDropdown("SelectedWorld", {
    Title = "Select World",
    Values = {"Starter Island", "Jungle Island", "Clown Island", "Marine Island", "Lier Island", "Baratie", "AR Park", "Lulue Town"},
    Multi = false,
    Default = false,
    Callback = function(value)
        Options.SelectedWorld.Value = value
        local island = islandData[Options.SelectedWorld.Value]
        local PointOutput = island.point
        if PointOutput then
            local ohTable1 = {
                [1] = {
                    [1] = utf8.char(3),
                    [2] = "ChangeSpawnPoint",
                    [3] = PointOutput
                }
            }
            Services.ReplicatedStorage.RemoteEvent:FireServer(ohTable1)
        end
        
        local output = island.mapping
        if output then
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = output
        end

        Dropdownn:SetValues(island.options)
    end
})

local selectedIslandData = islandData[Options.SelectedWorld.Value]

if selectedIslandData and selectedIslandData.options then
    Dropdownn:SetValues(selectedIslandData.options)
end

local function TP(position, time)
    local humanoidRootPart = LocalPlayer.Character.HumanoidRootPart
    local info = TweenInfo.new(time, Enum.EasingStyle.Quad)
    local tween = Services.TweenService:Create(humanoidRootPart, info, {CFrame = CFrame.new(position)})
    tween:Play()
end

local areaFolder = game.Workspace.__GAME.__Quests

local function populateDropdown()
    local dropdownValues = {}
    if areaFolder and areaFolder:IsA("Folder") then
        for _, item in ipairs(areaFolder:GetChildren()) do
            if item:IsA("Model") and item:FindFirstChild("HumanoidRootPart") then
                local labelText = item.Head.Icon.TextLabel.Text
                if labelText ~= "" then
                    table.insert(dropdownValues, labelText)
                end
            end
        end
    end 

    table.sort(dropdownValues, function(a, b)
        local numA = tonumber(a:match("(%d+)"))
        local numB = tonumber(b:match("(%d+)"))
        return numA < numB
    end)
    
    return dropdownValues
end

local Toggle = Tabs.Main:AddToggle("AutoQuest", {
    Title = "Auto Start Quest",
    Default = false,
    Callback = function(value)
        if value then 
            nexus:Notify({Title = 'Auto Quest', Content = "Make sure you don't have any ongoing  quest", Duration = 5 })
            repeat task.wait()
                local questName = Options.SelectedQuest.Value or "nil"
                local questNumberStr = questName:match("(%d+)")
                local questNumber = tonumber(questNumberStr)
                local currentPosition = LocalPlayer.PlayerGui.Quests.CurrentQuestContainer.AbsolutePosition  
            
                if currentPosition == Vector2.new(2880, 352.226) or currentPosition == Vector2.new(2880, 347.158) and Alive(LocalPlayer) and not ChestTeleporting then
                    GettingQuest = true 
                    for _, item in ipairs(areaFolder:GetChildren()) do
                        if item:IsA("Model") and item:FindFirstChild("HumanoidRootPart") then
                            local itemName = item.Name 
                            local itemNumber = itemName:match("(%d+)")  
                            
                            itemNumber = tostring(tonumber(itemNumber)) or itemNumber            
                            local labelText = item.Head.Icon.TextLabel.Text
                            if labelText == Options.SelectedQuest.Value then
                                moveToPosition(item.HumanoidRootPart.CFrame, 0.5) wait(1)
                                Services.ReplicatedStorage.RemoteEvent:FireServer({{utf8.char(3), "GetQuest", itemNumber}})
                                break
                            end  
                        end
                    end
                    GettingQuest = false 
                end
            until not Options.AutoQuest.Value
        end
    end
})

local Dropdown = Tabs.Main:AddDropdown("SelectedQuest", {
    Title = "Select Quest",
    Values = populateDropdown(), 
    Multi = false,
    Default = false,
    Callback = function(value)
    end
})

areaFolder.ChildAdded:Connect(function()
    Dropdown:SetValues(populateDropdown())
end)

areaFolder.ChildRemoved:Connect(function()
    Dropdown:SetValues(populateDropdown())
end)

local Dropdown = Tabs.Weapon:AddDropdown("SelectedWeapon", {
    Title = "Weapon",
    Values = {},  
    Multi = false,
    Default = "Select",
    Callback = function(value)
    end
})

local function updateDropdownValues()
    local dropdownValues = {}

    for toolName, _ in pairs(availableTools) do
        table.insert(dropdownValues, toolName)
    end

    local equippedTool = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChildOfClass("Tool")
    if equippedTool then
        table.insert(dropdownValues, equippedTool.Name)
    end

    Dropdown:SetValues(dropdownValues)
end

game.Players.LocalPlayer.Backpack.ChildAdded:Connect(function(tool)
    if tool:IsA("Tool") then
        availableTools[tool.Name] = true
        updateDropdownValues()
    end
end)

game.Players.LocalPlayer.Backpack.ChildRemoved:Connect(function(tool)
    if tool:IsA("Tool") then
        availableTools[tool.Name] = nil
        updateDropdownValues()
    end
end)

for _, tool in ipairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
    if tool:IsA("Tool") then
        availableTools[tool.Name] = true
    end
end

updateDropdownValues()

local function equipSelectedTool()
    local selectedToolName = Options.SelectedWeapon.Value
    if LocalPlayer.Character.Humanoid.Health > 0 then
        local equippedTool = LocalPlayer.Character:FindFirstChildOfClass("Tool")
        local selectedTool = LocalPlayer.Backpack:FindFirstChild(selectedToolName)
        if selectedTool and (not equippedTool or equippedTool.Name ~= selectedToolName) then
            equippedTool = equippedTool or LocalPlayer.Character:FindFirstChildOfClass("Tool")
            if equippedTool then
                equippedTool.Parent = LocalPlayer.Backpack
            end
            selectedTool.Parent = LocalPlayer.Character
        end
    end
end

local Toggle = Tabs.Weapon:AddToggle("AutoLvWeapon", {
    Title = "Auto Lv Weapon",
    Default = false,
    Callback = function(value)
        if value then 
            repeat task.wait()
                equipSelectedTool()
                require(Services.ReplicatedStorage.SharedModules.Controllers.ToolController).UseTool("Combat", Enum.UserInputState.Begin)  
            until not Options.AutoLvWeapon.Value  
        end
    end
})

local Toggle = Tabs.Weapon:AddToggle("AutoLvAll", {
    Title = "Auto Lv All Weapons",
    Default = false,
    Callback = function(value)
        if value then 
            repeat task.wait()
                local Humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
                if LocalPlayer and LocalPlayer.Character and Humanoid then
                    local success, result = pcall(function() 
                        Humanoid:UnequipTools()
                        for i, Tool in pairs(LocalPlayer.Backpack:GetChildren()) do
                            if Tool:IsA("Tool") and Humanoid then
                                Tool.Parent = LocalPlayer.Character wait(0.1)
                                require(Services.ReplicatedStorage.SharedModules.Controllers.ToolController).UseTool("Combat", Enum.UserInputState.Begin)
                                wait(.2)
                                Tool.Parent = LocalPlayer.Backpack
                            end
                        end
                    end)  
                end
            until not Options.AutoLvAll.Value
        end
    end
})

local Toggle = Tabs.Weapon:AddToggle("AutoSkill", {
    Title = "Auto Use Skill",
    Default = false,
    Callback = function(value)
        if value then 
            repeat task.wait()
                local virtualInput = Services.VirtualInputManager              
                for _,r in pairs(LocalPlayer.Character:GetChildren()) do
                    if r:IsA("Tool") and r.Name ~= "Defence" then
                        for i,v in pairs({"Z", "X", "C", "V", "B"}) do
                            if LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                                virtualInput:SendKeyEvent(true, v, false, nil)
                                virtualInput:SendKeyEvent(false, v, false, nil)
                                task.wait(.1)
                            end
                        end
                    end
                end  
            until not Options.AutoSkill.Value
        end
    end
})

local Toggle = Tabs.Misc:AddToggle("ServerHop", {
    Title = "Auto Chest [ Server - Hop ]",
    Default = false,
    Callback = function(value)
    end
})

local Toggle = Tabs.Misc:AddToggle("AutoChest", {
    Title = "Auto Chest",
    Default = false,
    Callback = function(value)
    end
})

spawn(function()
    while wait() do
        if _G.FB35D == true then 
            return 
        end
        local SavedPosition
        if Options.AutoChest.Value then
            local shouldServerHop = true

            local character = LocalPlayer.Character
            if character then
                SavedPosition = character:WaitForChild("HumanoidRootPart").CFrame
            end

            for i, v in pairs(Services.Workspace:GetChildren()) do
                if v:FindFirstChild("ChestInteract") or v.Name == "GiftModel" then
                    if character then
                        ChestTeleporting = true
                        character:WaitForChild("HumanoidRootPart").CFrame = v.PrimaryPart.CFrame * CFrame.new(0, 3, 0)
                        workspace.CurrentCamera.CFrame = CFrame.new(workspace.CurrentCamera.CFrame.Position, Vector3.new(-10.5, -11000, 11))
                        wait(3)
                        fireproximityprompt(v.ChestInteract, 1, true)
                        wait(0.2)
                        shouldServerHop = false
                    end
                end
            end

            if shouldServerHop and Options.ServerHop.Value then
                forceServerHop()
            end
        end
        ChestTeleporting = false

        if SavedPosition and not ChestTeleporting then
            LocalPlayer.Character:WaitForChild("HumanoidRootPart").CFrame = SavedPosition
            SavedPosition = nil  
        end
    end
end)

local Dropdown = Tabs.Misc:AddDropdown("Dropdown", {
    Title = "Teleport to Interaction",
    Values = Interactions,
    Multi = false,
    Default = "",
	Callback = function(Option)
        moveToPosition(Services.Workspace["__GAME"]["__Interactions"]:FindFirstChild(Option).PrimaryPart.CFrame, .1)
    end
})
local Dropdown = Tabs.Misc:AddDropdown("Dropdown", {
    Title = "Teleport to Island",
    Values = Islands,
    Multi = false,
    Default = "",
    Callback = function(Option)
        moveToPosition(Services.Workspace["__GAME"]["__SpawnLocations"]:FindFirstChild(Option).CFrame, .1)
    end  
})

local Toggle = Tabs.Player:AddToggle("WalkSpeed", {
    Title = "Walkspeed",
    Default = false,
    Callback = function(value)
        if value then 
            repeat task.wait()  
                setWalkSpeed(Options.Walk.Value)  
            until not Options.WalkSpeed.Value
            setWalkSpeed(35)
        end
    end
})

local Slider = Tabs.Player:AddSlider("Walk", {
    Title = "Walk Speed",
    Default = 16,
    Min = 16,
    Max = 200,
    Rounding = 0,
    Callback = function(Value)
    end
})
 
local Toggle = Tabs.Player:AddToggle("JumpPower", {
   Title = "Jump Power",
   Default = false,
   Callback = function(value)
    if value then 
        repeat task.wait()  
            setJumpPower(Options.Jump.Value)  
        until not Options.JumpPower.Value 
        setJumpPower(50)
    end
   end
})

local Slider = Tabs.Player:AddSlider("Jump", {
    Title = "Jump Power",
    Default = 50,
    Min = 50,
    Max = 200,
    Rounding = 1,
    Callback = function(Value)
    end
})

local Toggle = Tabs.Player:AddToggle("InfiniteJump", {
    Title = "Infinite Jump",
    Default = false,
    Callback = function(value)
        if value then 
            infJumpConnection = UserInputService.JumpRequest:Connect(function()
                LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState(Enum.HumanoidStateType.Jumping)  
            end)
            repeat task.wait() until not Options.InfiniteJump.Value 
            infJumpConnection:Disconnect()
        end
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
		if value then 
			repeat task.wait()
		local queueteleport = (syn and syn.queue_on_teleport) or queue_on_teleport or (fluxus and fluxus.queue_on_teleport)
		if queueteleport then
			queueteleport('loadstring(game:HttpGet("https://raw.githubusercontent.com/s-o-a-b/nexus/main/loadstring"))()')
		end  
	until not Options.ReExecute.Value 
end
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
