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
local Workspace = Services.Workspace
local UserInputService = Services.UserInputService
local GetPlayerDataRemote = Services.ReplicatedStorage:FindFirstChild("GetPlayerData", true)
local trapSystem = Services.ReplicatedStorage:FindFirstChild("TrapSystem")
local TeleportingToMurderer, GettingGun = false, false
local Murderer, Sheriff = nil, nil
local infJumpConnection, Device = false, nil
local highlights = {}

if UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled and not UserInputService.MouseEnabled then
	Device = "MOBILE"
end

local function FindMap()
    for _, v in pairs(workspace:GetChildren()) do
        if v:FindFirstChild("CoinContainer") then
            return v.CoinContainer
        end
    end
    return nil
end

local function findGunDrop()
    if FindMap() then 
        return FindMap().Parent:FindFirstChild("GunDrop") or false
    end
end

local function IsAlive(Player, roles)
    local role = roles and roles[Player.Name]
    return role and not role.Killed and not role.Dead
end

local function updatePlayerData()
    if GetPlayerDataRemote then
        return GetPlayerDataRemote:InvokeServer()
    end
end

local function CreateHighlight()
    for _, v in pairs(Players:GetChildren()) do
        if v ~= LocalPlayer then 
            pcall(function()
                if v.Character and not v.Character:FindFirstChild("Highlight") then
                    Instance.new("Highlight", v.Character)  
                end
            end)
        end
    end
end

local function UpdateHighlights()
    for _, v in pairs(Players:GetChildren()) do
        pcall(function()
            local highlight = v.Character and v.Character:FindFirstChild("Highlight")
            if highlight then
                if IsAlive(v, roles) then
                    local role = roles[v.Name]
                    if role then
                        if role.Role == "Murderer" then
                            highlight.FillColor = Color3.fromRGB(225, 0, 0)
                        elseif role.Role == 'Sheriff' then
                            highlight.FillColor = Color3.fromRGB(0, 0, 225)
                        elseif role.Role == 'Hero' then
                            highlight.FillColor = Color3.fromRGB(0, 0, 225)
                        else
                            highlight.FillColor = Color3.fromRGB(76, 215, 134)
                        end 
                    else 
                        highlight.FillColor = Color3.fromRGB(76, 215, 134)
                    end
                else
                    highlight.FillColor = Color3.fromRGB(255, 255, 255)
                end
            end
        end)
    end
end

local function DestroyHighlight()
    for _, player in next, Players:GetPlayers()  do
        if player ~= LocalPlayer then
            local character = player.Character
            if character then
                local highlight = character:FindFirstChild("Highlight")
                if highlight then
                    highlight:Destroy()
                end
            end
        end
    end
end

local function InGame()
    local Cannon = workspace:FindFirstChild("ConfettiCannon")
    if Cannon then 
        LocalPlayer.PlayerGui.MainGUI.Game.EarnedXP.Visible = false 
        LocalPlayer.PlayerGui.MainGUI.Game.Timer.Visible = false
    elseif Murderer == nil or not Murderer or not Murderer and not Sheriff then 
        return false 
    elseif LocalPlayer.PlayerGui.MainGUI.Game.EarnedXP.XPText.Text == "900" and LocalPlayer.PlayerGui.MainGUI.Game.Timer.Visible == false and Murderer ~= LocalPlayer.Name then 
        return false 
    elseif LocalPlayer.PlayerGui.MainGUI.Game.EarnedXP.Visible == true or LocalPlayer.PlayerGui.MainGUI.Game.Timer.Visible == true then 
        return true
    else
        return false
    end
end

local function GetMurderer()
    for _, player in ipairs(game.Players:GetPlayers()) do 
        if player.Backpack:FindFirstChild("Knife") or (player.Character and player.Character:FindFirstChild("Knife")) then
            return player.Name
        end
    end   
    return nil 
end

local function GetSheriff()
    for _, player in ipairs(game.Players:GetPlayers()) do 
        if player.Backpack:FindFirstChild("Gun") or (player.Character and player.Character:FindFirstChild("Gun")) then
            return player.Name
        end
    end   
    return nil 
end

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
 
local function tween_teleport(TargetFrame)
    local character = LocalPlayer.Character
    local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")
        
    if humanoidRootPart and IsAlive(LocalPlayer, roles) then
        local distance = (humanoidRootPart.Position - TargetFrame.p).Magnitude
        local tweenInfo = TweenInfo.new(distance / 70, Enum.EasingStyle.Linear, Enum.EasingDirection.In)
             
        local move = Services.TweenService:Create(humanoidRootPart, tweenInfo, {CFrame = TargetFrame})
        move:Play()
        move.Completed:Wait()

    end
end

local function playerHasItem(itemName)
    repeat task.wait() 
         MainGUI = LocalPlayer.PlayerGui:FindFirstChild("MainGUI")
    until MainGUI

    for _, child in pairs(MainGUI.Game.Inventory.Main.Perks.Items.Container.Current.Container:GetChildren()) do
        if child:IsA("Frame") and child.ItemName.Label.Text == itemName then
            return true
        end
    end

    return false
end

local function ToggleSprintTrail(value)  
    local characterModel = workspace:FindFirstChild(LocalPlayer.Name)
    if characterModel then 
        local speedTrail = characterModel:FindFirstChild("SpeedTrail")
        if speedTrail then
            speedTrail.Toggle:FireServer(value)
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
    Sheriff = Window:AddTab({
        Title = "Sheriff",
        Icon = "rbxassetid://10747372702"
    }),
    Murderer = Window:AddTab({
        Title = "Murderer",
        Icon = "rbxassetid://10747372992"
    }),
    Player = Window:AddTab({
        Title = "Player",
        Icon = "rbxassetid://10747373176"
    }),
    Emotes = Window:AddTab({
        Title = "Emotes",
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

local function isValidPart(part, checkMaterial)
    if IsAlive(LocalPlayer, roles) then
        return part and part:IsA("BasePart") and part.Parent and part.Parent.Name == "Coin_Server" and part.Parent:FindFirstChild("TouchInterest") and (not checkMaterial or part.Material == Enum.Material.Glass)
    end
    return false
end

local function moveToPosition(position)
    LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(position)
end

local function farmCoins(title)
    local success, result = pcall(function()
        if FindMap() then
            if Options.AutoFarm.Value and 
                LocalPlayer.PlayerGui.MainGUI.Game.CoinBags.Container.Coin.Full.Visible and 
                LocalPlayer.PlayerGui.MainGUI.Game.CoinBags.Container.BeachBall.Full.Visible and 
                not TeleportingToMurderer and 
                not GettingGun and 
                InGame() then
                moveToPosition(Vector3.new(-108, 138, -11))
            elseif Options.AutoFarmBeachBalls.Value and 
                LocalPlayer.PlayerGui.MainGUI.Game.CoinBags.Container.BeachBall.Full.Visible and 
                not TeleportingToMurderer and 
                not GettingGun and 
                InGame() then
                moveToPosition(Vector3.new(-108, 138, -11))
            elseif IsAlive(LocalPlayer, roles) then
                local minimum_distance = math.huge
                local minimum_object = nil
                local murderer = game.Players:FindFirstChild(Murderer)

                for _, v in pairs(FindMap():GetChildren()) do
                    if Options.AutoFarm.Value and isValidPart(v:FindFirstChild("CoinVisual")) or
                        Options.AutoFarmBeachBalls.Value and isValidPart(v:FindFirstChild("CoinVisual"), true) then
                        local partPosition = v.CoinVisual.Position
                        local distance = (LocalPlayer.Character.HumanoidRootPart.Position - partPosition).Magnitude

                        if murderer then
                            local murdererDistance = (murderer.Character.HumanoidRootPart.Position - partPosition).Magnitude
                            if murdererDistance < 50 then
                                continue
                            end
                        end

                        if distance < minimum_distance then
                            minimum_distance = distance
                            minimum_object = v
                        end
                    end
                end

                if minimum_object then
                    local anchorPosition = minimum_object:FindFirstChild("CoinVisual") and minimum_object.CoinVisual.Position or minimum_object.Position
                    moveToPosition(anchorPosition)
                    wait(0.1)
                    for rotation = 0, 10, 1 do
                        if LocalPlayer.Character.Humanoid.Health > 0 then
                            LocalPlayer.Character:SetPrimaryPartCFrame(LocalPlayer.Character.PrimaryPart.CFrame * CFrame.Angles(0, math.rad(rotation), 0))
                            wait(0.02)
                        end
                    end
                    wait(0.1)

                    minimum_object.Name = 'False_Coin'

                    repeat
                        wait()
                    until minimum_object.Name ~= 'Coin_Server' or not Murderer

                    wait(0.5)
                    moveToPosition(Vector3.new(-108, 138, -11))
                    wait(1.5)
                end
            end
        end
    end)
end

local Toggle = Tabs.Main:AddToggle("AutoFarm", {
    Title = "Auto Farm [ Coins / BeachBalls]",
    Default = false,
    Callback = function(value)
        if value then 
            repeat task.wait() 
        farmCoins("Auto Farm [ Coins / BeachBalls]")
            until not Options.AutoFarm.Value
        end
    end
})

local Toggle1 = Tabs.Main:AddToggle("AutoFarmBeachBalls", {
    Title = "Auto Farm [BeachBalls]",
    Default = false,
    Callback = function(value)
        if value then 
            repeat task.wait() 
        farmCoins("Auto Farm [ Coins / BeachBalls]")
            until not Options.AutoFarmBeachBalls.Value
        end
    end
})


local Toggle = Tabs.Main:AddToggle("CoinChams", {
    Title = "Coin Chams",
    Default = false,
    Callback = function(value)
        if value then 
            repeat task.wait()
                if FindMap() then
                    for _, v in pairs(FindMap():GetChildren()) do
                        if v.Name == 'Coin_Server' and not highlights[v] then
                            local esp = Instance.new("Highlight")
                            esp.Name = "CoinESP"
                            esp.FillTransparency = 0.5
                            esp.FillColor = Color3.new(94/255, 1, 255/255)
                            esp.OutlineColor = Color3.new(94/255, 1, 255/255)
                            esp.OutlineTransparency = 0
                            esp.Parent = v.Parent
                            highlights[v] = esp  
                        end
                    end
                end 
            until not Options.CoinChams.Value
            for _, highlight in pairs(highlights) do
                highlight:Destroy()
            end         
        end
    end
})

local Toggle = Tabs.Main:AddToggle("PlayerESP", {
    Title = "Player Chams",
    Default = false,
    Callback = function(value)
        if value then 
        repeat task.wait()
            CreateHighlight() 
            UpdateHighlights()
        until not Options.PlayerESP.Value
        DestroyHighlight()
        end 
    end
})  

local ToggleGrabbingGun = Tabs.Main:AddToggle("GrabbingGun", {
    Title = "Automatically Grab Gun",
    Default = false,
    Callback = function(value)
        if value then
            local success, result = pcall(function()
                repeat
                    task.wait()

                    if not (findGunDrop() and Murderer) then
                        print("UPDATING")
                        GettingGun = false
                        continue
                    end

                    local murderer = game.Players:FindFirstChild(Murderer)
                    local Humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")

                    local distance = (murderer.Character.HumanoidRootPart.Position - findGunDrop().Position).magnitude

                    if distance < 8 then
                        GettingGun = false
                        continue
                    end

                    if InGame() and Murderer ~= LocalPlayer.Name and Humanoid then
                        GettingGun = true
                        local savedPosition = Humanoid.CFrame
                        local gunPosition = findGunDrop().Position + Vector3.new(0, 5, 0)
                        Humanoid.CFrame = CFrame.new(gunPosition)
                        task.wait(0.3)
                        Humanoid.CFrame = savedPosition
                        task.wait(1)
                    end
                until not Options.GrabbingGun.Value

                GettingGun = false
            end)

            if not success then
                warn("Error in ToggleGrabbingGun callback:", result)
                GettingGun = false  
            end
        end
    end
})

local ToggleGunCham = Tabs.Main:AddToggle("GunCham", {
    Title = "Gun Dropped ESP",
    Default = false,
    Callback = function(value)
        if value then
            local success, result = pcall(function()
                repeat
                    task.wait()

                    if findGunDrop() then
                        local esp = findGunDrop():FindFirstChild("GunESP")

                        if not esp then
                            esp = Instance.new("Highlight")
                            esp.Name = "GunESP"
                            esp.FillTransparency = 0.5
                            esp.FillColor = Color3.new(94, 1, 255)
                            esp.OutlineColor = Color3.new(94, 1, 255)
                            esp.OutlineTransparency = 0
                            esp.Parent = findGunDrop()
                        end
                    end
                until not Options.GunCham.Value

                if findGunDrop() then
                    local esp = findGunDrop():FindFirstChild("GunESP")
                    if esp then
                        esp:Destroy()
                    end
                end
            end)

            if not success then
                warn("Error in ToggleGunCham callback:", result)
            end
        end
    end
})

local Toggle = Tabs.Murderer:AddToggle("KillAura", {
    Title = "Kill Aura",
    Default = false,
    Callback = function(value)
        if value then 
            repeat
                task.wait()
                local success, result = pcall(function() 
                    local Knife = LocalPlayer.Backpack:FindFirstChild("Knife") or LocalPlayer.Character:FindFirstChild("Knife")
                    local humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
                    
                    for i, v in ipairs(game.Players:GetPlayers()) do
                        if v ~= LocalPlayer and v.Character and Knife and IsAlive(v, roles) then
                            local EnemyRoot = v.Character:FindFirstChild("HumanoidRootPart")
                            if EnemyRoot then

                                local EnemyPosition = EnemyRoot.Position
                                local EnemyDistance = (EnemyPosition - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
                                
                                if EnemyDistance <= tonumber(Options.Distance.Value) and Knife and Murderer == LocalPlayer.Name then
                                    humanoid:EquipTool(Knife) 
                                    wait(0.1)
                                    local teleportPosition = LocalPlayer.Character.HumanoidRootPart.Position + LocalPlayer.Character.HumanoidRootPart.CFrame.LookVector * 3 
                                    EnemyRoot.CFrame = CFrame.new(teleportPosition)
                                    
                                    if Device ~= "MOBILE" then 
                                        LocalPlayer.Character.Knife.Stab:FireServer('Down') 
                                        firetouchinterest(EnemyRoot, myKnife.Handle, 1)
                                        wait(0.1)
                                        firetouchinterest(EnemyRoot, myKnife.Handle, 0)
                                    end 
                                end
                            end
                        end  
                    end
                end)
            until not Options.KillAura.Value 
        end
    end
})

local Slider = Tabs.Murderer:AddSlider("Distance", {
	Title = "Aura Distance",
	Default = 5,
	Min = 5,
	Max = 50,
	Rounding = 0,
	Callback = function(Value)
	end
})

local Toggle = Tabs.Sheriff:AddToggle("SilentAim", {
    Title = "Silent Aim",
    Default = false,
    Callback = function(value)
    end
})

local Slider = Tabs.Sheriff:AddSlider("Slider", {
    Title = "Accuracy",
    Default = 5,
    Min = 25,
    Max = 100,
    Rounding = 0,
    Callback = function(value)
    end
})  

local KillMurderToggle = Tabs.Sheriff:AddToggle("KillMurder", {
    Title = "Kill Murderer",
    Default = false,
    Callback = function(value)
        if value then
            repeat  
                task.wait()
                if not InGame() then
                    TeleportingToMurderer = false
                end
                local success, result = pcall(function()
                    local Gun = LocalPlayer.Backpack:FindFirstChild("Gun") or LocalPlayer.Character:FindFirstChild("Gun")
                    local murderer = workspace[Murderer]

                    if murderer and murderer ~= LocalPlayer and LocalPlayer.Character then

                        if Gun then
                            local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
                            TeleportingToMurderer = true
                            humanoid:EquipTool(Gun)
                            
                            if Gun and Gun.Handle.Reload.Playing then
                                LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(-109, 138.1, -17))
                                if Murderer then 
                                    nexus:Notify({Title = 'Notification', Content = 'Shot missed reloading...', Duration = 5})
                                end 
                                repeat task.wait() until not (Gun and Gun.Handle.Reload.Playing) or not value
                            else
                                local playerRootPart = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                                local directionToMurderer = murderer.HumanoidRootPart.CFrame.LookVector
                                local teleportPosition = murderer.HumanoidRootPart.Position - directionToMurderer * 7
                                local lookAtPosition = murderer.HumanoidRootPart.Position
                                  LocalPlayer.Character:SetPrimaryPartCFrame(CFrame.new(teleportPosition, Vector3.new(lookAtPosition.X, playerRootPart.Position.Y, playerRootPart.Position.Z)))
                                  workspace.CurrentCamera.CFrame = CFrame.new(workspace.CurrentCamera.CFrame.Position, (murderer.HumanoidRootPart.Position - Vector3.new(-0.5, 0, 1)))
                                spawn(function()
                                  wait(0.14)
                                    local args = {1, murderer.HumanoidRootPart.Position + (murderer.HumanoidRootPart.Velocity * 0.5) * (4 / 15), "AH2"}
                                    local success, result = pcall(function() 
                                        Gun.KnifeLocal.CreateBeam.RemoteFunction:InvokeServer(unpack(args))
                                    end)
                                end)  
                            end
                        end  
                    end
                end)
                task.wait()
            until not Options.KillMurder.Value
            TeleportingToMurderer = false
        end
    end
})

Tabs.Sheriff:AddButton({
    Title = "Shoot Murder",
    Callback = function()
        local Gun = LocalPlayer.Backpack:FindFirstChild("Gun") or LocalPlayer.Character:FindFirstChild("Gun")
        local murderer = game.Players:FindFirstChild(Murderer)
        local murdererHRP = murderer.Character and murderer.Character:FindFirstChild("HumanoidRootPart")

        if Sheriff ~= LocalPlayer.Name then
            return
        elseif Gun then 
            local humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
            humanoid:EquipTool(Gun)
        end  

        local args = {
            [1] = 1,
            [2] = murdererHRP.Position + (murdererHRP.Velocity * 0.5) * (4 / 15),
            [3] = "AH2"
        }
        local success, result = pcall(function() 
          Gun.KnifeLocal.CreateBeam.RemoteFunction:InvokeServer(unpack(args))
        end)  
    end
})

local Toggle = Tabs.Murderer:AddToggle("AutoKilkl", {
    Title = "Auto Kill All",
    Default = false,
    Callback = function(value)
        if value then
            repeat task.wait()
                local success, result = pcall(function() 
                    local myKnife = LocalPlayer.Backpack:FindFirstChild("Knife") or LocalPlayer.Character:FindFirstChild("Knife")
                    if myKnife and myKnife:IsA("Tool") and InGame() then
                        local humanoid = LocalPlayer.Character:WaitForChild("Humanoid")
                        humanoid:EquipTool(myKnife)
                        for _, v in ipairs(Players:GetPlayers()) do   
                            local enemyRoot = v.Character:WaitForChild("HumanoidRootPart")
                            local enemyPosition = enemyRoot.Position
                            if IsAlive(v, roles) and v ~= LocalPlayer and InGame() and Device == "MOBILE" then  
                                v.Character.HumanoidRootPart.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, -2)
                            elseif v ~= LocalPlayer and InGame() and IsAlive(v, roles) then  
                                LocalPlayer.Character.Knife.Stab:FireServer('Down') 
                                firetouchinterest(enemyRoot, myKnife.Handle, 1)
                                wait(0.1)
                                firetouchinterest(enemyRoot, myKnife.Handle, 0)
                            end
                        end
                    end   
                end)  
            until not Options.AutoKilkl.Value
        end
    end
})

--if LocalPlayer.UserId == 5024146829 then
    local Toggle = Tabs.Main:AddToggle("EndRound", {
        Title = "End Round (BETA)",
        Default = false,
        Callback = function(value)
            if value then
                repeat task.wait()
                    local success, result = pcall(function()
                        local murderer = game.Players:FindFirstChild(Murderer)
                        if Options.AutoFarm.Value and LocalPlayer.PlayerGui.MainGUI.Game.CoinBags.Container.Coin.Full.Visible and LocalPlayer.PlayerGui.MainGUI.Game.CoinBags.Container.BeachBall.Full.Visible then wait(5) 
                            module:fling(murderer)
                        elseif Options.AutoFarmBeachBalls.Value and LocalPlayer.PlayerGui.MainGUI.Game.CoinBags.Container.BeachBall.Full.Visible then wait(5) 
                            module:fling(murderer)
                        elseif not InGame() and not IsAlive(LocalPlayer, roles) then wait(5)
                            module:fling(murderer)
                        end
                    end)
                until not Options.EndRound.Value
            end
        end
    })
--end 

Tabs.Main:AddButton({
    Title = "End Round (BETA)",
    Callback = function()
        for _, player in pairs(Players:GetChildren()) do
            if IsAlive(player, roles) then
                local role = roles[player.Name]
                if role and role.Role == "Murderer" then
                    local Target = game.Players:FindFirstChild(player.Name)
                    module:fling(Target)

                    if Target and Target.Parent and Target:FindFirstChild("Humanoid") and Target.Humanoid.Health > 0 then
                        repeat
                            task.wait()
                            module:fling(Target)
                            wait(1)
                        until not (Target and Target.Parent and Target:FindFirstChild("Humanoid") and Target.Humanoid.Health == 0)
                    end
                end   
            end
        end
    end 
})

Tabs.Murderer:AddButton({
    Title = "Kill All",
    Callback = function()
        local Knife = LocalPlayer.Backpack:FindFirstChild("Knife") or LocalPlayer.Character:FindFirstChild("Knife")
        if Knife and Knife:IsA("Tool") then 

            local humanoid = LocalPlayer.Character:WaitForChild("Humanoid")
            humanoid:EquipTool(Knife)
            
            for i = 1, 3 do
                local success, result = pcall(function() 
                    for i, v in ipairs(Players:GetPlayers()) do task.wait()
                        if v ~= LocalPlayer and v.Character and IsAlive(v, roles) then
                            local enemyRoot = v.Character:WaitForChild("HumanoidRootPart")

                            if Device == "MOBILE" then 
                                v.Character.HumanoidRootPart.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, -2)
                            else
                                LocalPlayer.Character.Knife.Stab:FireServer('Down') 
                                firetouchinterest(enemyRoot, Knife.Handle, 1)
                                wait(0.1)
                                firetouchinterest(enemyRoot, Knife.Handle, 0)
                            end 
                        end         
                    end
                end)  
            end
            LocalPlayer.Character.HumanoidRootPart.CFrame = initialPosition
        end
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
            setWalkSpeed(16) 
        end
    end
})

local Slider = Tabs.Player:AddSlider("Walk", {
    Title = "Walk Speed",
    Default = 16,
    Min = 16,
    Max = 25,
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
    Rounding = 0,
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

Tabs.Emotes:AddButton({
    Title = "Ninja",
    Callback = function()
        module:emote("ninja")
    end
})

Tabs.Emotes:AddButton({
    Title = "Dab",
    Callback = function()
        module:emote("dab")
    end
})

Tabs.Emotes:AddButton({
    Title = "Floss",
    Callback = function()
        module:emote("floss")
    end
})

Tabs.Emotes:AddButton({
    Title = "Headless",
    Callback = function()
        module:emote("headless")
    end
})

Tabs.Emotes:AddButton({
    Title = "Zen",
    Callback = function()
        module:emote("zen")
    end
})

Tabs.Emotes:AddButton({
    Title = "Zombie",
    Callback = function()
        module:emote("zombie")
    end
}) 

Tabs.Emotes:AddButton({
    Title = "Sit",
    Callback = function()
        module:emote("sit")
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
                local lp,po,ts = LocalPlayer,game.CoreGui.RobloxPromptGui.promptOverlay,Services.TeleportService
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

nexus:Notify({Title = 'Notification', Content = 'This script is currently in development and is currently in its beta phase.', Duration = 10})

coroutine.wrap(function()
    while true do
        task.wait(.1)
        if _G.FB35D == true then 
            return 
        end
        local success, err = pcall(function()
            Murderer = GetMurderer()
            Sheriff = GetSheriff()
            roles = updatePlayerData()
        end)
    end
end)()

local GunHook
GunHook = hookmetamethod(game, "__namecall", function(self, ...)
    local method = getnamecallmethod()
    local args = { ... }
    if not checkcaller() then
        if typeof(self) == "Instance" then
            if self.Name == "RemoteFunction" and method == "InvokeServer" then
                if Options.SilentAim.Value then 
                    if Murderer and Sheriff == LocalPlayer.Name then
                        local Root = workspace[tostring(Murderer)].HumanoidRootPart;
                        local Veloc = Root.AssemblyLinearVelocity;
                        local Pos = Root.Position 
                        args[2] = Pos;
                    end;
                else
                    return GunHook(self, unpack(args));
                end;
            end;
        end;
    end;
    return GunHook(self, unpack(args));
end);

local __namecall
__namecall = hookmetamethod(game, "__namecall", function(self, ...)
    local method = getnamecallmethod()
    local args = { ... }
    if not checkcaller() then
        if tostring(method) == "InvokeServer" and tostring(self) == "GetChance" then
            wait(13)
        end
    end
    return __namecall(self, unpack(args))
end)

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
