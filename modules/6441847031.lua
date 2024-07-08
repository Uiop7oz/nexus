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

local UserInputService = Services.UserInputService
local Players = Services.Players
local LocalPlayer = Players.LocalPlayer

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
        Icon = "rbxassetid://10734884548"
    }),
    Target = Window:AddTab({
        Title = "Target",
        Icon = "rbxassetid://10709818534"
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

local function isItemInBackpack(player, itemName)
    local backpack = player.Backpack
    if backpack then
        for _, item in pairs(backpack:GetChildren()) do
            if item.Name == itemName then
                return true
            end
        end
    end
    return false
end

local function isItemEquipped(player, itemName)
    local character = player.Character
    if character then
        local humanoid = character:FindFirstChild("Humanoid")
        if humanoid then
            local torso = character:FindFirstChild("Torso") or character:FindFirstChild("UpperTorso")
            if torso then
                local tool = torso:FindFirstChild(itemName)
                if tool then
                    return true
                end
            end
        end
    end
    return false
end

local function findNearestPlayerWithCriteria(criteria)
    local currentPlayer = game.Players.LocalPlayer
    local allPlayers = game.Players:GetPlayers()
    local nearestPlayer = nil
    local shortestDistance = math.huge

    for _, player in pairs(allPlayers) do
        local success, result = pcall(function()

            if player ~= currentPlayer then
                local character = player.Character
                if character and character:FindFirstChild("Humanoid") then
                    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
                    if humanoidRootPart then
                        local humanoid = character.Humanoid
                        if criteria(player, humanoid, character) then
                            local distance = (currentPlayer.Character.HumanoidRootPart.Position - humanoidRootPart.Position).Magnitude
                            if distance < shortestDistance then
                                nearestPlayer = player
                                shortestDistance = distance
                            end
                        end
                    end
                end
            end
        end)  
    end
    return nearestPlayer
end

local function hasToolWithName(player, toolName)
    local backpack = player.Backpack
    local character = player.Character

    if backpack then
        local toolInBackpack = backpack:FindFirstChild(toolName)
        if toolInBackpack then
            return true, "Backpack"
        end
    end

    if character then
        local toolEquipped = character:FindFirstChild(toolName)
        if toolEquipped then
            return true, "Equipped"
        end
    end

    return false
end

local function hasToolWithName(player, toolName)
    local backpack = player.Backpack
    local character = player.Character

    local toolInBackpack, toolEquipped = nil, nil

    if backpack then
        toolInBackpack = backpack:FindFirstChild(toolName)
    end

    if character then
        toolEquipped = character:FindFirstChild(toolName)
    end

    return toolInBackpack, toolEquipped
end

local function getEquippedWeaponName()
    local replicatedStorage = Services.ReplicatedStorage
    local weaponsFolder = replicatedStorage:WaitForChild("Weapons")

    if weaponsFolder then

        local weaponsList = weaponsFolder:GetChildren()
        local localPlayer = game.Players.LocalPlayer
        local equippedTool, toolInBackpack = nil, nil

        for _, weapon in pairs(weaponsList) do
            local toolInBP, toolEquipped = hasToolWithName(localPlayer, weapon.Name)
            if toolInBP then
                toolInBackpack = toolInBP
            end
            if toolEquipped then
                equippedTool = toolEquipped
                return weapon.Name, toolInBackpack 
            end
        end

        return equippedTool and equippedTool.Name or nil, toolInBackpack 
    end

    return nil, nil 
end

local function attackNearestPlayer()
    local nearestPlayer = findNearestPlayerWithCriteria(function(player, humanoid, character)
        return humanoid.Health > 0 and not character:FindFirstChild("ForceField")
    end)
    local equippedWeaponName, toolInBackpack = getEquippedWeaponName()
    if toolInBackpack then
        toolInBackpack.Parent = game.Players.LocalPlayer.Character  
    end

    if nearestPlayer then
        local success, result = pcall(function()
            local args = {
                [1] = workspace:FindFirstChild(nearestPlayer.Name) and workspace[nearestPlayer.Name].Humanoid,
            }

            if args[1] then
                workspace[game.Players.LocalPlayer.Name][equippedWeaponName].DamageRemote:FireServer(unpack(args))
            end
        end)
    end
end

function QuickDash()
    UserInputService.InputBegan:Connect(function(input)
        local sprint = LocalPlayer.PlayerGui.Sprinting.Sprinting
        if not Options.QuickDash.Value then
            return
        end
        if input.KeyCode == Enum.KeyCode.E then  
            if interval then return end  
            sprint.Enabled = false
            sprint.Enabled = true
            interval = true
            task.wait(0.5)
            interval = false
        end    
    end)
end

local Toggle = Tabs.Main:AddToggle("KillAura", {
    Title = "Kill Aura",
    Default = false,
    Callback = function(value)
        if value then
            repeat task.wait(.1)
                attackNearestPlayer()
            until not Options.KillAura.Value
        end
    end
})

local Toggle = Tabs.Target:AddToggle("AutoKill", {
    Title = "Auto Kill [Target]",
    Default = false,
    Callback = function(value)
        if value then
            repeat
                task.wait() 
                local success, result = pcall(function() 

                if Options.SelectedPlayer.Value == false then
                    nexus:Notify({Title = 'Select A Target', Content = 'You need to select a player.', Duration = 5})
                    wait(5)
                else
                    local selectedPlayer = game.Players:FindFirstChild(Options.SelectedPlayer.Value)
                    local localPlayer = game.Players.LocalPlayer
                    local character = localPlayer.Character

                    if selectedPlayer and localPlayer and character then
                        local selectedCharacter = selectedPlayer.Character
                        local humanoidRootPart = selectedCharacter:WaitForChild("HumanoidRootPart")
                        local selectedCharacterBase = humanoidRootPart.Position + Vector3.new(0, humanoidRootPart.Size.Y/2, 0) 

                        character:SetPrimaryPartCFrame(CFrame.new(selectedCharacterBase) * CFrame.new(0, 15, 0))

                        local equippedWeaponName, toolInBackpack = getEquippedWeaponName()
                        if toolInBackpack then
                            toolInBackpack.Parent = game.Players.LocalPlayer.Character  
                        end

                        local success, result = pcall(function()
                            local args = {  
                                [1] = selectedCharacter:FindFirstChild("Humanoid"),
                            }
                            workspace[LocalPlayer.Name][equippedWeaponName].DamageRemote:FireServer(unpack(args))
                        end)
                    end
                end
            end)
            until not Options.AutoKill.Value
        end
    end
})

local Dropdown = Tabs.Target:AddDropdown("SelectedPlayer", {
    Title = "Select Player",
    Values = {}, 
    Multi = false,
    Default = false,
    Callback = function(value)
    end
})

local function UpdateDropdown()
    local playerList = {} 
    
    for _, player in pairs(game.Players:GetPlayers()) do
        if player ~= game.Players.LocalPlayer then
            table.insert(playerList, player.Name)
        end
    end
    
    Dropdown:SetValues(playerList) 
end

game.Players.PlayerAdded:Connect(UpdateDropdown)
game.Players.PlayerRemoving:Connect(UpdateDropdown)

UpdateDropdown()

local Toggle = Tabs.Main:AddToggle("AutoEquip", {
    Title = "Auto Equip",
	Default = false,
    Callback = function(value)
		if value then 
			repeat task.wait()    
                local success, result = pcall(function() 
                local Menu = LocalPlayer.PlayerGui:FindFirstChild("Menu Screen")
                if Options.SelectedWorld.Value ~= false and Menu then 
                    if Menu.Enabled and Options.KillAura.Value then 
                        local args = {  
                            [1] = "Pencil",  
                        }
                        LocalPlayer.PlayerGui["Menu Screen"].RemoteEvent:FireServer(unpack(args))
                        LocalPlayer.PlayerGui:FindFirstChild("Menu Screen"):Destroy()

                    elseif Menu.Enabled then
                        local args = {  
                            [1] = Options.SelectedWorld.Value,  
                        }
                        LocalPlayer.PlayerGui["Menu Screen"].RemoteEvent:FireServer(unpack(args))
                        LocalPlayer.PlayerGui:FindFirstChild("Menu Screen"):Destroy()
                    end  
                end
            end)
			until not Options.AutoEquip.Value
		end
	end  
})

local Dropdownnn = Tabs.Main:AddDropdown("SelectedWorld", {
    Title = "Select Tool",
    Values = {"Mace", "Chainsaw", "Knife", "Pan", "Pencil", "Baseball Bat", "Scythe", "Emerald Greatsword", "Blood Dagger", "Frost Spear"},
    Multi = false,
    Default = false,
    Callback = function(value)
    end
})

local Toggle = Tabs.Main:AddToggle("AV", {
    Title = "Anti-Void-Stuck",
    Default = false,
    Callback = function(value)
        if value then
            repeat task.wait()
                local Character = LocalPlayer.Character

                if Character then
                    local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")
            
                    if HumanoidRootPart then
                        local function IsInVoid()
                            return HumanoidRootPart.Position.Y < 0
                        end
            
                        if IsInVoid() then
                            Character.Humanoid.Health = 0 
                        end 
                    end
                end  
            
            until not Options.AV.Value
        end
    end
})

local Toggle = Tabs.Main:AddToggle("QuickDash", {
    Title = "Quick Dash",
	Default = false,
    Callback = function(value)
        if value then 
            QuickDash()
        end  
	end  
})

local Toggle = Tabs.Main:AddToggle("Dash", {
    Title = "Dash Animation",
    Default = false,
    Callback = function(value)
        if value then
            repeat task.wait(0.2)
                pcall(function() 
                    local animation = LocalPlayer.Character.Humanoid:LoadAnimation(LocalPlayer.PlayerGui.Sprinting.Sprinting.Animation2)
                    animation:Play()
                end)  
            until not Options.Dash.Value
        end
    end
})

Tabs.Main:AddButton({
	Title = "Unlock Gamepass Tools",
	Callback = function()
		local Old;
        Old = hookmetamethod(game, "__namecall", function(...)
            if not checkcaller() and getnamecallmethod() == "UserOwnsGamePassAsync" then
                return true
            end
            return Old(...)
        end)
    end   
})  

local function setWalkSpeed(walkSpeed)
    local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")
    if humanoid then
        humanoid.WalkSpeed = walkSpeed
    end
end
 
local Toggle = Tabs.Player:AddToggle("WalkSpeed", {
    Title = "Walkspeed",
    Default = false,
    Callback = function(value)
        if value then 
            repeat task.wait()  
                setWalkSpeed(Options.Walk.Value)  
            until not Options.WalkSpeed.Value
            setWalkSpeed(16)
        end
    end
})

local Slider = Tabs.Player:AddSlider("Walk", {
    Title = "Walk Speed",
    Default = 16,
    Min = 16,
    Max = 70,
    Rounding = 0,
    Callback = function(Value)
    end
})

local function setJumpPower(jumpPower)
    local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")
    if humanoid then
        humanoid.JumpPower = jumpPower
    end
end
 
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

local Toggle = Tabs.Player:AddToggle("AntiFling", {
    Title = "Anti-Fling",
    Default = false,
    Callback = function(value)
    end
})

local function PlayerAdded(Player)
    local Character;
    local PrimaryPart;
 
    local function CharacterAdded(NewCharacter)
        Character = NewCharacter
        repeat
            wait()
            PrimaryPart = NewCharacter:FindFirstChild("HumanoidRootPart")
        until PrimaryPart
    end
 
    CharacterAdded(Player.Character or Player.CharacterAdded:Wait())
    Player.CharacterAdded:Connect(CharacterAdded)
    Services.RunService.Heartbeat:Connect(function()
        if (Character and Character:IsDescendantOf(workspace)) and (PrimaryPart and PrimaryPart:IsDescendantOf(Character)) then
            for i,v in ipairs(Character:GetDescendants()) do
                if v:IsA("BasePart") then
                    v.CanCollide = false
                    v.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
                    v.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                    v.CustomPhysicalProperties = PhysicalProperties.new(0, 0, 0)
                end
            end
            PrimaryPart.CanCollide = false
            PrimaryPart.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
            PrimaryPart.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
            PrimaryPart.CustomPhysicalProperties = PhysicalProperties.new(0, 0, 0)
        end
    end)
end  
 
for i,v in ipairs(Services.Players:GetPlayers()) do
    if v ~= LocalPlayer then
        PlayerAdded(v)
    end
end
Services.Players.PlayerAdded:Connect(PlayerAdded)
 
local LastPosition = nil
Services.RunService.Heartbeat:Connect(function()
    pcall(function()
        if not Options.AntiFling.Value then 
            local LastPosition = nil
            return 
        end 
        local PrimaryPart = LocalPlayer.Character.PrimaryPart
        if PrimaryPart.AssemblyLinearVelocity.Magnitude > 250 or PrimaryPart.AssemblyAngularVelocity.Magnitude > 250 then
            PrimaryPart.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
            PrimaryPart.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
            PrimaryPart.CFrame = LastPosition
 
            game.StarterGui:SetCore("ChatMakeSystemMessage", {
                Text = "You were flung. Neutralizing velocity.";
                Color = Color3.fromRGB(255, 0, 0);
            })
        elseif PrimaryPart.AssemblyLinearVelocity.Magnitude < 50 or PrimaryPart.AssemblyAngularVelocity.Magnitude > 50 then
            LastPosition = PrimaryPart.CFrame
        end
    end)
end) 

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
