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
local RunService = Services.RunService
local Workspace = Services.Workspace
local ReplicatedStorage = Services.ReplicatedStorage
local player = Services.Players.LocalPlayer
local leaderstats = player:FindFirstChild("leaderstats")

local Fluent = loadstring(game:HttpGet("https://github.com/s-o-a-b/nexus/releases/download/aYXKCuZPip/aYXKCuZPip.txt"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/s-o-a-b/nexus/main/assets/SaveManager"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/s-o-a-b/nexus/main/assets/InterfaceManager"))()

local Options = Fluent.Options
SaveManager:SetLibrary(Fluent)

local Window = Fluent:CreateWindow({
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
        Icon = "rbxassetid://10734975692"
    }),
    Egg = Window:AddTab({
        Title = "Egg",
        Icon = "rbxassetid://10723345518"
    }),
    Webhook = Window:AddTab({
        Title = "Webhook",
        Icon = "rbxassetid://10734943902"
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

local success, result = pcall(function() 
    Workspace.raceMaps.Magma.Name = "Magma Race"
    Workspace.raceMaps.Desert.Name = "Desert Race"
    Workspace.raceMaps.Grassland.Name = "Grass Race"
end)

local targets = {
    {position = Vector3.new(-9684.84, 55.6854, 3093.3), name = "City"},
    {position = Vector3.new(-13097, 213.621, 5913.35), name = "Legends Highway"},
    {position = Vector3.new(-11053.1, 213.621, 4904.36), name = "Magma City"},
}

local areaCirclesFolder = Workspace:FindFirstChild("areaCircles")
if areaCirclesFolder then
    for _, areaCircle in ipairs(areaCirclesFolder:GetDescendants()) do
        if areaCircle.Name == "areaCircle" then
            local TeleportPart = areaCircle:FindFirstChild("circleOuter")
            if TeleportPart then
                for _, target in ipairs(targets) do
                    local distance = (TeleportPart.Position - target.position).Magnitude
                    if distance <= 50 then
                        TeleportPart.Parent.Name = target.name
                    end
                end
            end
        end
    end
end

local function formatNumber(number)
    if number >= 1e12 then
        return math.floor(number / 1e11) / 10 .. "T"
    elseif number >= 1e9 then
        return math.floor(number / 1e8) / 10 .. "B"
    elseif number >= 1e6 then
        return math.floor(number / 1e5) / 10 .. "M"
    elseif number >= 1e3 then
        return math.floor(number / 1e2) / 10 .. "K"
    else
        return tostring(number)
    end
end

local function travelToArea(areaName)
    repeat task.wait()
        currentMap = Players.LocalPlayer.currentMap.Value
    until currentMap ~= "Magma Race" and currentMap ~= "Grass Race" and currentMap ~= "Desert Race" or not Options.AutoFarmOrbs.Value
    
    if Players.LocalPlayer.currentMap.Value ~= areaName then
        ReplicatedStorage.rEvents.areaTravelRemote:InvokeServer("travelToArea", workspace.areaCircles[areaName])
    end
end

local function collectOrb(orbName, areaName)
	spawn(function()
		for i = 1, 8 do
			task.wait()
			ReplicatedStorage.rEvents.orbEvent:FireServer("collectOrb", orbName, areaName)
		end
	end)
end   

local function autoFarmOrbs(value)
    if value then
        repeat
            task.wait()
            local rebirths = player.leaderstats.Rebirths.Value

            if rebirths > 9 then
                travelToArea("Legends Highway")
                collectOrb("Red Orb", "Legends Highway")
            elseif rebirths > 0 then
                travelToArea("Magma City")
                collectOrb("Red Orb", "Magma City")
            elseif rebirths == 0 then
                travelToArea("City")
                collectOrb("Red Orb", "City")
            end
        until not Options.AutoFarmOrbs.Value
    end
end

local Toggle = Tabs.Main:AddToggle("AutoFarmOrbs", {
    Title = "Auto Farm",
    Default = false,
    Callback = autoFarmOrbs
})

local Toggle = Tabs.Main:AddToggle("AutoGems", {
    Title = "Auto Farm Gems",
	Default = false,
    Callback = function(value)
        if value then 
            repeat task.wait() 
                local rebirths = player.leaderstats.Rebirths.Value
                if rebirths > 9 then  
                    spawn(function()
                        for i = 1, 5 do
                            ReplicatedStorage.rEvents.orbEvent:FireServer("collectOrb", "Gem", "Legends Highway")
                        end 
                    end)
                elseif rebirths > 0  then
                    spawn(function()
                        for i = 1, 5 do
                            ReplicatedStorage.rEvents.orbEvent:FireServer("collectOrb", "Gem", "Magma City")
                        end 
                    end)
                elseif rebirths == 0 then 
                    spawn(function()
                        for i = 1, 5 do
                            ReplicatedStorage.rEvents.orbEvent:FireServer("collectOrb", "Gem", "City")
                        end 
                    end)
                end
            until not Options.AutoGems.Value 
        end
    end
})

local Toggle = Tabs.Main:AddToggle("AutoRebirth", {
    Title = "Auto Rebirth",
    Default = false,
    Callback = function(value)
        if value then
            repeat task.wait()
                local playerGui = Players.LocalPlayer:FindFirstChildOfClass("PlayerGui")
                if playerGui and playerGui:FindFirstChild("gameGui") and playerGui.gameGui.statsFrame.levelLabel.maxLabel.Visible then
                    ReplicatedStorage.rEvents.rebirthEvent:FireServer("rebirthRequest")
                end
            until not Options.AutoRebirth.Value
        end
    end
})

local Toggle = Tabs.Main:AddToggle("AutoHoop", {
    Title = "Auto Hoops",
	Default = false,
    Callback = function(value)
		if value then 
			repeat wait(1)  
				for i,v in pairs(game.Workspace.Hoops:GetChildren()) do
					if v.Name == 'Hoop' then
						firetouchinterest(game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart"), v, 0)
						firetouchinterest(game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart"), v, 1)
					end
				end
			until not Options.AutoHoop.Value 
		end  
	end
})

local Toggle = Tabs.Main:AddToggle("AutoRace", {
    Title = "Auto Race",
	Default = false,
    Callback = function(value)
		if value then 
			repeat task.wait(1)  
				local success, errorInfo = pcall(function()
				if Players.LocalPlayer.PlayerGui.gameGui.raceJoinLabel.Visible == true then 
					ReplicatedStorage.rEvents.raceEvent:FireServer("joinRace") wait(2)  
					local player = Players.LocalPlayer
					local currentMap = player.currentMap.Value
					repeat task.wait(.1) until workspace.raceMaps[currentMap].boundaryParts.boundaryPart.CanCollide == false
					for _,v in pairs(Services.Workspace.raceMaps:GetDescendants()) do
						if v:IsA("TouchTransmitter") and v.Parent.Name == "finishPart" then wait(0.5)
							player.Character.HumanoidRootPart.CFrame = CFrame.new(v.Parent.Position)  * CFrame.new(-40, -20, 0) 
							break;
						end 
					end
				end  
			end)
			until not Options.AutoRace.Value 
		end  
	end
})

local Toggle = Tabs.Egg:AddToggle("AutoHatch", {
    Title = "Auto Hatch",
	Default = false,
    Callback = function(value)
		if value then 
			repeat task.wait()  
		        ReplicatedStorage.rEvents.openCrystalRemote:InvokeServer("openCrystal", Options.SelectCrystal.Value)
			until not Options.AutoHatch.Value
		end  
	end
})

local Dropdownnn = Tabs.Egg:AddDropdown("SelectCrystal", {
    Title = "Select Crystal",
    Values = {"Red Crystal","Blue Crystal","Purple Crystal","Yellow Crystal","Lightning Crystal","Snow Crystal","Inferno Crystal","Lava Crystal","Electro Legends Crystal"},
    Multi = false,
    Default = false,
    Callback = function(value)
    end
})

local selectedValues = {}

local MultiDropdown = Tabs.Egg:AddDropdown("MultiDropdown", {
    Title = "Delete Rarity",
    Values = {"Basic", "Advanced", "Rare", "Epic", "Unique", "Omega"},
    Multi = true,
    Default = {},
    Callback = function(value)
        selectedValues = {}  -- Clear the selected values table
        for val, state in next, value do
            if state then
                table.insert(selectedValues, val)
            end
        end
    end
})

local Toggle = Tabs.Egg:AddToggle("AutoDelete", {
    Title = "Auto Delete Pets",
    Default = false,
    Callback = function(value)
        if value then 
            repeat task.wait() 
                for _, selectedValue in ipairs(selectedValues) do
                    for _, pet in ipairs(Players.LocalPlayer.petsFolder[selectedValue]:GetChildren()) do
                        if pet.Name ~= "Ultimate Overdrive Bunny" then 
                            ReplicatedStorage.rEvents.sellPetEvent:FireServer("sellPet", pet)
                        end
                    end  
                end
            until not Options.AutoDelete.Value 
        end 
    end
})

local Toggle = Tabs.Egg:AddToggle("AutoDeleteTrails", {
    Title = "Auto Delete Bad Trails",
    Default = false,
    Callback = function(value)
        if value then 
            repeat
                wait(1)  
                for _, selectedValue in ipairs(selectedValues) do
                    if selectedValue == "Omega" then 
                        continue 
                    end
                    for _, pet in ipairs(Players.LocalPlayer.trailsFolder[selectedValue]:GetChildren()) do
                        ReplicatedStorage.rEvents.sellTrailEvent:FireServer("sellTrail", pet)
                    end  
                end
            until not Options.AutoDeleteTrails.Value 
        end  
    end
})

local Toggle = Tabs.Egg:AddToggle("AutoEvolve", {
    Title = "Auto Evolve Pets",
	Default = false,
    Callback = function(value)
		if value then 
			repeat task.wait(3)  
				for _, child in ipairs(ReplicatedStorage.cPetShopFolder:GetChildren()) do
					ReplicatedStorage.rEvents.petEvolveEvent:FireServer("evolvePet", child.Name)
				end   
			until not Options.AutoEvolve.Value
		end  
	end
})

local Input = Tabs.Webhook:AddInput("Webhook", {
	Title = "Webhook",
	Default = "",
	Placeholder = "Webhook Url",
	Numeric = false, -- Only allows numbers
	Finished = false, -- Only calls callback when you press enter
	Callback = function(Value)
	end
})

local function send(description)
    local data = {
        ["embeds"] = {
            {
                ["title"] = "Legends Of Speed",
                ["description"] = description,
            }
        }
    }
    local newdata = HttpService:JSONEncode(data)

    local headers = {
        ["content-type"] = "application/json"
    }

    local request = http_request or request or HttpPost or syn.request
    local abcdef = { Url = Options.Webhook.Value, Body = newdata, Method = "POST", Headers = headers }

    local success, result = pcall(function()
        request(abcdef)
    end)

    if success then
        getgenv().lastExecutionTime = tick()
    else
        warn("An error occurred:", result)
    end
end

local Slider = Tabs.Webhook:AddSlider("WebhookCooldown", {
	Title = "Webhook Cooldown",
	Default = 60,
	Min = 10,
	Max = 60,
	Rounding = 1,
	Callback = function(Value)
	end
})

local Toggle = Tabs.Webhook:AddToggle("StepsWebhook", {
    Title = "Steps Webhook",
    Default = false,
    Callback = function(value)
        if value then
			repeat task.wait()  
				local success, errorInfo = pcall(function()
					if leaderstats and leaderstats:FindFirstChild("Steps") then
						local time = tonumber(Options.WebhookCooldown.Value)

						if time >= 0 then
							time = math.floor(time + 0.5) 
							Options.WebhookCooldown.Value = math.ceil(time - 0.5) 
						else
							time = math.ceil(time - 0.5) 
							Options.WebhookCooldown.Value = math.ceil(time - 0.5) 
						end  

						local stepsStart = leaderstats.Steps.Value
						wait(time)
						local stepsEnd = leaderstats.Steps.Value 
						
						local stepsEarned = stepsEnd - stepsStart 
						local formattedSteps = formatNumber(stepsEarned)
						if Options.StepsWebhook.Value then 
							send("Steps Made : `" .. formattedSteps .. "`\nMade in : `" .. time ..  " seconds`")
							wait(1)
						end
    
					end
				end)
			until not Options.StepsWebhook.Value 
		end
	end
})

local Toggle = Tabs.Webhook:AddToggle("GemsWebhook", {
    Title = "Gems Webhook",
    Default = false,
    Callback = function(value)
        if value then
			repeat task.wait()  
				local success, errorInfo = pcall(function()
					if leaderstats and leaderstats:FindFirstChild("Steps") then
						local time = tonumber(Options.WebhookCooldown.Value)

						if time >= 0 then
							time = math.floor(time + 0.5) 
							Options.WebhookCooldown.Value = math.ceil(time - 0.5) 
						else
							time = math.ceil(time - 0.5) 
							Options.WebhookCooldown.Value = math.ceil(time - 0.5) 
						end  

						local GemStart = Players.LocalPlayer.Gems.Value
						wait(time)
						local GemsEnd = Players.LocalPlayer.Gems.Value
						
						local GemsEarned = GemsEnd - GemStart 
						local formattedGems = formatNumber(GemsEarned)
						if Options.GemsWebhook.Value then 
							send("Gems Made : `" .. formattedGems .. "`\nMade in : `" .. time ..  " seconds`")
							wait(1)
						end
    
					end
				end)
			until not Options.GemsWebhook.Value 
		end
	end
})

local Toggle = Tabs.Webhook:AddToggle("RebirthWebhook", {
    Title = "Rebirth Webhook",
    Default = false,
    Callback = function(value)
        if value then
            repeat
                task.wait()  
                local success, errorInfo = pcall(function()
                    local leaderstats = game.Players.LocalPlayer:FindFirstChild("leaderstats")
                    
                    if leaderstats then
                        local Rebirths = leaderstats:FindFirstChild("Rebirths")
                        
                        if Rebirths then
                            local lastValue = Rebirths.Value
                            repeat task.wait() until Rebirths.Value ~= lastValue or not Options.RebirthWebhook.Value 
                            if Options.RebirthWebhook.Value and Rebirths.Value ~= lastValue then
                                lastValue = Rebirths.Value
								send("Rebirth Value Updated : `" .. lastValue .. "`")  -- Missing closing backtick
							end
						else
							warn("Rebirths not found in leaderstats")
						end
                    else
                        warn("leaderstats not found for the player")
                    end
                end)
            until not Options.RebirthWebhook.Value
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
            Fluent:Notify({Title = 'Auto Rejoin', Content = 'You will rejoin if you are kicked or disconnected from the game', Duration = 5 })
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
SaveManager:SetLibrary(Fluent)
InterfaceManager:SetLibrary(Fluent)
SaveManager:SetIgnoreIndexes({})
SaveManager:IgnoreThemeSettings()
InterfaceManager:SetFolder("nexus-001")
SaveManager:SetFolder("nexus-001")

-- Build interface section and load the game
InterfaceManager:BuildInterfaceSection(Tabs.Settings)
SaveManager:Load(game.PlaceId)

-- Select the first tab in the window
Window:SelectTab(1)
