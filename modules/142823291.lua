--[[
`7MN.   `7MF' .g8""8q.  MMP""CP""YMM `7MM"""YMM         
  MMN.    M .dP'    `YM.P'   CP   `7   CP    `7         
  M YMb   M dM'      `MM     CP        CP   d        
  M  `MN. M MM        MM     CP        MMmmMM        
  M   `MM.M MM.      ,MP     CP        CP   Y  ,        
  M     YMM `Mb.    ,dP'     CP        CP     ,M     
.JML.    YM   `"bmmd"'     .JMML.    .JMMmmmmMMM     
                                                        
Please be aware that this code is outdated and may not represent the best coding practices.
Please do not rename my things into your name and take credit for my code. [ DMCA PROTECTED ]
Created Using Nexus AI created by : SMOKEY
Discord : https://discord.gg/gmWhudrAkN
]]--

if not game:IsLoaded()then game.Loaded:Wait()end;Services.Players.LocalPlayer.Idled:Connect(function()Services.VirtualUser:Button2Down(Vector2.new(0,0),workspace.CurrentCamera.CFrame)wait(1)Services.VirtualUser:Button2Up(Vector2.new(0,0),workspace.CurrentCamera.CFrame)end)local a=Services.HttpService;local a=Services.TeleportService;local a=Services.TextChatService;local a=Services.Players;local b=a.LocalPlayer;local c=Services.Workspace;local d=b:GetMouse()local d=Services.UserInputService;local e=Services.ReplicatedStorage:FindFirstChild("GetPlayerData",true)local f,g=false,false;local h,i=nil,nil;local j,k=false,nil;local l,l=nil,false;local l=2.8;local m,n=false,nil;local o=loadstring(game:HttpGet("https://raw.githubusercontent.com/s-o-a-b/test/main/aaa"))()local p=loadstring(game:HttpGet("https://raw.githubusercontent.com/s-o-a-b/nexus/main/assets/SaveManager"))()local q=loadstring(game:HttpGet("https://raw.githubusercontent.com/s-o-a-b/nexus/main/assets/InterfaceManager"))()local r=o.Options;p:SetLibrary(o)local s=o:CreateWindow({Title="skid","",TabWidth=160,Size=UDim2.fromOffset(580,460),Acrylic=true,Theme="Dark"})local t={Main=s:AddTab({Title="Main",Icon="rbxassetid://10734934585"}),Visual=s:AddTab({Title="Visual",Icon="rbxassetid://10723346959"}),Sheriff=s:AddTab({Title="Roles",Icon="rbxassetid://10747372702"}),Player=s:AddTab({Title="Player",Icon="rbxassetid://10747373176"}),Emotes=s:AddTab({Title="Emotes",Icon="rbxassetid://4335480896"}),Server=s:AddTab({Title="Server",Icon="rbxassetid://10734949856"}),Settings=s:AddTab({Title="Settings",Icon="settings"})}if d.TouchEnabled and not d.KeyboardEnabled and not d.MouseEnabled then k="MOBILE"end;local function u()for a,a in pairs(workspace:GetChildren())do if a:FindFirstChild("CoinContainer")then return a.CoinContainer end end;return nil end;local function v()if u()then return u().Parent:FindFirstChild("GunDrop")or false end end;local function w(a,b)local a,b=pcall(function()local a=b and b[a.Name]return a and not a.Killed and not a.Dead end)if not a then return false end;return b end;local function x()if e then return e:InvokeServer()end end;local function e()for a,a in pairs(Services.Players:GetChildren())do if a~=b then if a.Character and not a.Character:FindFirstChild("Highlight")then Instance.new("Highlight",a.Character)end end end end;local function y()for a,a in pairs(a:GetChildren())do local b=a.Character and a.Character:FindFirstChild("Highlight")if b then if w(a,roles)then local a=roles[a.Name]if a then if a.Role=="Murderer"then b.FillColor=Color3.fromRGB(225,0,0)elseif a.Role=='Sheriff'then b.FillColor=Color3.fromRGB(0,0,225)elseif a.Role=='Hero'then b.FillColor=Color3.fromRGB(0,0,225)else b.FillColor=Color3.fromRGB(76,215,134)end else b.FillColor=Color3.fromRGB(76,215,134)end else b.FillColor=Color3.fromRGB(255,255,255)end end end end;local function z()for a,a in next,a:GetPlayers()do if a~=b then local a=a.Character;if a then local a=a:FindFirstChild("Highlight")if a then a:Destroy()end end end end end;local function A()local a=roles and roles[b.Name]if b.PlayerGui.MainGUI.Game.CoinBags.Container.Coin.Full.Visible then return true end;if a and(a.Role=="Innocent"or a.Role=="Sheriff"or a.Role=="Hero"or a.Role=="Murderer")then return true end;return false end;local function B()for a,a in ipairs(game.Players:GetPlayers())do if a.Backpack:FindFirstChild("Knife")or(a.Character and a.Character:FindFirstChild("Knife"))then return a.Name end end;return nil end;local function C(a,b)local a=game.Players:FindFirstChild(a)if not a then return Vector3.new(0,0,0),"No murderer found."end;local a=a.Character;if not a then return Vector3.new(0,0,0),"Murderer has no character."end;local c=a:FindFirstChild("HumanoidRootPart")local a=a:FindFirstChild("Humanoid")if not c or not a then return Vector3.new(0,0,0),"Could not find murderer's HumanoidRootPart or Humanoid."end;local d=c.AssemblyLinearVelocity;local a=a.MoveDirection;local a=c.Position+(d*Vector3.new(0,0.5,0))*(b/15)+a*b;return a end;local function D()for a,a in ipairs(game.Players:GetPlayers())do if a.Backpack:FindFirstChild("Gun")or(a.Character and a.Character:FindFirstChild("Gun"))then return a.Name end end;return nil end;local function E(a)local b=b.Character and b.Character:FindFirstChild("Humanoid")if b then b.WalkSpeed=a end end;local function F(a)local b=b.Character and b.Character:FindFirstChild("Humanoid")if b then b.JumpPower=a end end;local function G(a,c)local b=b.Character;local b=b and b:FindFirstChild("HumanoidRootPart")if b then local d=(b.Position-a.p).Magnitude;local c=c;local c=d/c;c=c;local c=TweenInfo.new(c,Enum.EasingStyle.Linear,Enum.EasingDirection.In)local a=Services.TweenService:Create(b,c,{CFrame=a})a:Play()a.Completed:Wait()end end;local function H()if r.AutoFarm.Value and b.PlayerGui.MainGUI.Game.CoinBags.Container.Coin.Full.Visible and b.PlayerGui.MainGUI.Game.CoinBags.Container.BeachBall.Full.Visible then return true elseif r.AutoFarmBeachBalls.Value and b.PlayerGui.MainGUI.Game.CoinBags.Container.BeachBall.Full.Visible then return true elseif not r.AutoFarmBeachBalls.Value and not r.AutoFarm.Value then return true end;return false end;function CoinAttribute(a,b)if not a:FindFirstChild("CoinVisual")then return end;if a:GetAttribute("Collected")==nil and b and a:GetAttribute("CoinID")=="BeachBall"then return true elseif a:GetAttribute("Collected")==nil and not b and(a:GetAttribute("CoinID")=="Coin"or a:GetAttribute("CoinID")=="BeachBall")then return true end;return false end;local function I(a)local b=game.Players.LocalPlayer.Character;if b and b:FindFirstChild("Humanoid")then local b=b.HumanoidRootPart;if b then b.CFrame=CFrame.new(a)end end end;local function J()local a,a=pcall(function()for a,a in pairs(b.Character:GetDescendants())do if a:IsA("BasePart")and a.CanCollide==true and a.Name~=floatName then a.CanCollide=false end end end)end;local function K(a)local c=b.Character or b.CharacterAdded:Wait()local c=c:FindFirstChild("HumanoidRootPart")if a~=b and a.Character and a.Character:FindFirstChild("HumanoidRootPart")then local d=a.Character.HumanoidRootPart;local d=(d.Position-c.Position).Unit*50;local e=RaycastParams.new()e.FilterType=Enum.RaycastFilterType.Exclude;e.FilterDescendantsInstances={b.Character}local b=workspace:Raycast(c.Position,d,e)return not b or b.Instance.Parent==a.Character end;return false end;function ShootMurderer()local a,a=pcall(function()local a=h;local c=b.Backpack:FindFirstChild("Gun")or b.Character:FindFirstChild("Gun")if a then local a=C(a,l)local a={[1]=1,[2]=a,[3]="AH2"}if b.Character:FindFirstChild("Gun")and c and not c.Handle.Reload.Playing then b.Character:FindFirstChild("Gun").KnifeLocal.CreateBeam.RemoteFunction:InvokeServer(unpack(a))else warn("Gun not found or currently reloading.")end else warn("Murderer not found.")end end)end;local function l()local a=b.Character or b.CharacterAdded:Wait()local b=a:FindFirstChild("Humanoid")local c=a:FindFirstChild("HumanoidRootPart")local d=c:FindFirstChild("BodyPosition")if d then d:Destroy()end;local d=Instance.new("BodyPosition")d.Name="BodyPosition"d.MaxForce=Vector3.new(0,math.huge,0)d.D=1000;d.P=10000;d.Parent=c;local e=5;b:ChangeState(Enum.HumanoidStateType.Freefall)while a and a.Parent and c and not m do b:ChangeState(Enum.HumanoidStateType.Freefall)local b=Ray.new(c.Position,Vector3.new(0,-10,0))local a,b=workspace:FindPartOnRay(b,a)if a then local a=(c.Position-b).Magnitude;d.Position=c.Position+Vector3.new(0,e-a,0)end;wait()end;d:Destroy()end;local function C()m=true;if n then repeat wait()until coroutine.status(n)=="dead"n=nil end;local a=b.Character or b.CharacterAdded:Wait()local b=a:WaitForChild("HumanoidRootPart")local b=b:FindFirstChild("BodyPosition")if b then b:Destroy()end;local a=a:WaitForChild("Humanoid")end;local function L()if#a:GetPlayers()==2 then return true else return false end end;a.PlayerAdded:Connect(L)a.PlayerRemoving:Connect(L)local function M()m=false;n=coroutine.create(l)coroutine.resume(n)end;local function l()local a,a=pcall(function()local a=b.Character:FindFirstChild('Humanoid')if u()and c.Normal:FindFirstChild("IconSq")and b.PlayerGui.MainGUI.Game.CoinBags.Container.Coin.Visible then if c.Normal.IconSq.Texture=="rbxassetid://3214477063"then b.Character.Humanoid.Health=0;return end end;if g then C()return elseif not n or coroutine.status(n)=="dead"then M()end;local a=roles[b.Name]if H()and h==b.Name and b.PlayerGui.MainGUI.Game.CoinBags.Container.Coin.Visible then b.Character.Humanoid.Health=0;return end;if w(b,roles)and not h and a and a.Role~="Murderer"and b.Character.Humanoid.Health>0 and not L()then o:Notify({Title='Notification',Content="Reset Character Anti-Spectate Mode",Duration=5})b.Character.Humanoid.Health=0 end;if a and a.Role=="Murderer"and not u()then I(Vector3.new(-108,150,-11))end;if not b.PlayerGui.MainGUI.Game.CoinBags.Container.Coin.Visible then return end;if not b.PlayerGui.MainGUI.Game.CoinBags.Container.Coin.Visible and w(b,roles)and h then b.Character.Humanoid.Health=0;o:Notify({Title='Notification',Content="Reset Character Error Farming",Duration=5})return end;if H()then I(Vector3.new(-108,150,-11))return end;local a=b.Character;local b=a:FindFirstChild("HumanoidRootPart")local a=a:FindFirstChild("Head")J()if r.AutoFarm.Value or r.AutoFarmBeachBalls.Value then local a=math.huge;local c=nil;local d=math.huge;local e=nil;for f,f in pairs(u():GetChildren())do if((r.AutoFarm.Value and CoinAttribute(f,false))or(r.AutoFarmBeachBalls.Value and CoinAttribute(f,true)))and f.Name=="Coin_Server"then local g=f.CoinVisual.Position;local b=(b.Position-g).Magnitude;if b<a then a=b;c=f end;if b<d then d=b;e=f end end end;local a=c or e;if a and not f and not g then local c=a:FindFirstChild("CoinVisual")and a.CoinVisual.Position or a.Position;local b=(b.Position-c).Magnitude;local c=a:FindFirstChild("CoinVisual")and a.CoinVisual.CFrame or a.CFrame;local c=CFrame.new(c.Position.X,c.Position.Y,c.Position.Z)c=c*CFrame.new(0,0.1,0)if b>200 then G(c,1500)wait(0.1)G(c,1500)wait(0.1)else G(c,24)a.Name='False_Coin'wait(0.1)end end end end)end;local f=t.Main:AddToggle("AutoFarm",{Title="Auto Farm [ Coins / BeachBalls]",Default=false,Callback=function(a)if a then repeat task.wait()l()until not r.AutoFarm.Value;C()end end})local f=t.Main:AddToggle("AutoFarmBeachBalls",{Title="Auto Farm [ BeachBalls ]",Default=false,Callback=function(a)if a then repeat task.wait()l()until not r.AutoFarmBeachBalls.Value;C()end end})local f=t.Main:AddToggle("CollectNear",{Title="Coin Magnet",Default=false,Callback=function(a)if a then if identifyexecutor()=="Wave"then o:Notify({Title='Notification',Content='Coin Magnet is not supported on Wave',Duration=5})return end;local function a()local a=b.character:FindFirstChild("Head")local c=b.Character and b.character:FindFirstChild("HumanoidRootPart")if u()and a and c then for d,d in pairs(u():GetChildren())do if d:IsA("Part")then local c=(d.Position-c.Position).magnitude;if c<=20 then local c=d:FindFirstChild("TouchInterest")if c and w(b,roles)then coroutine.wrap(function()firetouchinterest(a,d,0)firetouchinterest(a,d,1)end)()end end end end end end;local function b()while r.CollectNear.Value do task.wait()local a,b=pcall(a)if not a then warn("Error in CollectNear toggle callback:",b)end end end;spawn(b)end end})local f=t.Main:AddToggle("GrabbingGun",{Title="Automatically Grab Gun",Default=false,Callback=function(a)if a then repeat task.wait()local a,b=pcall(function()if not(v()and h)then g=false;return end;local a=game.Players:FindFirstChild(h)local a=a.Character and a.Character:FindFirstChild("HumanoidRootPart")local c=b.Character and b.Character:FindFirstChild("HumanoidRootPart")if A()and h~=b.Name and c and v()and H()then local a=(a.Position-v().Position).magnitude;if a<11 then g=false;return end;g=true;if v()then local a=b.Character.HumanoidRootPart.CFrame;local b=v().Position+Vector3.new(0,5,0)c.CFrame=CFrame.new(b)task.wait(0.5)c.CFrame=a;task.wait(0.3)end end end)if not a then warn("Error in ToggleGrabbingGun callback:",b)g=false end until not r.GrabbingGun.Value;g=false;wait(1)else g=false end end})local f=t.Main:AddToggle("EndRound",{Title="End Round",Default=false,Callback=function(a)if a then o:Notify({Title='Notification',Content='Flings Murderer when you are not in the round.',Duration=5})repeat task.wait()local a,a=pcall(function()local a=game.Players:FindFirstChild(h)if H()and h~=b.Name then wait(3)module:fling(a)elseif not A()and not w(b,roles)and h then wait(3)module:fling(a)end end)until not r.EndRound.Value end end})local e=t.Visual:AddToggle("PlayerESP",{Title="Player Chams",Default=false,Callback=function(a)if a then repeat task.wait()e()y()until not r.PlayerESP.Value;z()end end})local e=t.Visual:AddToggle("GunCham",{Title="Gun Dropped ESP",Default=false,Callback=function(a)if a then local a,b=pcall(function()repeat task.wait()if v()then local a=v():FindFirstChild("GunESP")if not a then a=Instance.new("Highlight")a.Name="GunESP"a.FillTransparency=0.5;a.FillColor=Color3.new(128,225,0)a.OutlineColor=Color3.new(0,163,0)a.OutlineTransparency=0;a.Parent=v()end end until not r.GunCham.Value;if v()then local a=v():FindFirstChild("GunESP")if a then a:Destroy()end end end)if not a then warn("Error in ToggleGunCham callback:",b)end end end})t.Main:AddSection("Teleports")t.Main:AddButton({Title="Teleport To Lobby",Callback=function()I(Vector3.new(-108,140,-11))end})t.Main:AddButton({Title="Teleport To Map",Callback=function()if not u()then o:Notify({Title='Notification',Content='Map does not exist.',Duration=5})return end;for a,a in ipairs(c.Normal.Spawns:GetDescendants())do I(a.Position)return end end})t.Visual:AddSection("Target")local c=t.Visual:AddToggle("Fling",{Title="Fling Target",Default=false,Callback=function(a)if a then repeat task.wait()local a=game.Players:FindFirstChild(r.SelectedPlayer.Value)if a then wait(2)module:fling(a)end until not r.Fling.Value end end})local c=t.Visual:AddDropdown("SelectedPlayer",{Title="Select Player",Values={},Multi=false,Default=false,Callback=function(a)end})local function e()local a={}for b,b in pairs(game.Players:GetPlayers())do if b~=game.Players.LocalPlayer then table.insert(a,b.Name)end end;c:SetValues(a)end;game.Players.PlayerAdded:Connect(e)game.Players.PlayerRemoving:Connect(e)e()local c=t.Sheriff:AddToggle("KillAura",{Title="Kill Aura",Default=false,Callback=function(a)if a then repeat task.wait()local a,a=pcall(function()local a=b.Backpack:FindFirstChild("Knife")or b.Character:FindFirstChild("Knife")local c=b.Character:FindFirstChild("Humanoid")for d,d in ipairs(game.Players:GetPlayers())do if d~=b and d.Character and a and w(d,roles)then local d=d.Character:FindFirstChild("HumanoidRootPart")if d then local e=d.Position;local e=(e-b.Character.HumanoidRootPart.Position).Magnitude;if e<=tonumber(r.Distance.Value)and a and h==b.Name then c:EquipTool(a)wait(0.1)local a=b.Character.HumanoidRootPart.Position+b.Character.HumanoidRootPart.CFrame.LookVector*3;d.CFrame=CFrame.new(a)if k~="MOBILE"then b.Character.Knife.Stab:FireServer('Down')firetouchinterest(d,myKnife.Handle,1)wait(0.1)firetouchinterest(d,myKnife.Handle,0)end end end end end end)until not r.KillAura.Value end end})local c=t.Sheriff:AddSlider("Distance",{Title="Aura Distance",Default=5,Min=5,Max=50,Rounding=0,Callback=function(a)end})function KillAll()local a,b=pcall(function()if(h~=b.Name or not H())then return end;local c=b.Backpack:FindFirstChild("Knife")or b.Character:FindFirstChild("Knife")local d=b.Character:FindFirstChild("Humanoid")if not c or not d then print("Knife or Humanoid not found")return end;d:EquipTool(c)for a,a in pairs(a:GetChildren())do local d=a.Character and a.Character:FindFirstChild("HumanoidRootPart")local e=roles[a.Name]if a~=b and A()and k=="MOBILE"then a.Character.HumanoidRootPart.CFrame=b.Character.HumanoidRootPart.CFrame*CFrame.new(0,0,-2)else b.Character.Knife.Stab:FireServer('Down')firetouchinterest(d,c.Handle,1)wait(0.1)firetouchinterest(d,c.Handle,0)end end end)if not a then print("Error occurred in KillAll: "..tostring(b))end end;local c=t.Sheriff:AddToggle("AutoKilkl",{Title="Auto Kill All",Default=false,Callback=function(a)if a then if identifyexecutor()=="Wave"then o:Notify({Title='Notification',Content='Coin Magnet is not supported on Wave',Duration=5})return end;repeat task.wait()KillAll()until not r.AutoKilkl.Value end end})t.Sheriff:AddSection("Sheriff")local c=t.Sheriff:AddToggle("SilentAim",{Title="Silent Aim",Default=false,Callback=function(a)end})local c=t.Sheriff:AddToggle("AutoShoot",{Title="Auto Shoot Murderer",Default=false,Callback=function(a)if a then repeat task.wait()local a,b=pcall(function()if h and i and i==b.Name then local a=b.Character:FindFirstChild("Humanoid")local b=b.Backpack:FindFirstChild("Gun")local c=game.Players:FindFirstChild(h)if a and c and K(c)then a:EquipTool(b)ShootMurderer()end end end)if not a then warn("Error in AutoShoot:",b)end until not r.AutoShoot.Value end end})t.Sheriff:AddButton({Title="Shoot Murder ( mobile support )",Callback=function()local a,b=pcall(function()if h and i==b.Name then local a=b.Character and b.Character:FindFirstChildOfClass("Humanoid")local b=b.Backpack:FindFirstChild("Gun")if a and h then a:EquipTool(b)ShootMurderer()end end end)if not a then warn("Error in AutoShoott:",b)end end})local c=t.Sheriff:AddKeybind("Keybind",{Title="Shoot Murderer ( pc support )",Mode="Toggle",Default="E",Callback=function(a)ShootMurderer()end})local c=t.Player:AddToggle("WalkSpeed",{Title="Walkspeed",Default=false,Callback=function(a)if a then repeat task.wait()E(r.Walk.Value)until not r.WalkSpeed.Value;E(16)end end})local c=t.Player:AddSlider("Walk",{Title="Walk Speed",Default=16,Min=16,Max=25,Rounding=0,Callback=function(a)end})local c=t.Player:AddToggle("JumpPower",{Title="Jump Power",Default=false,Callback=function(a)if a then repeat task.wait()F(r.Jump.Value)until not r.JumpPower.Value;F(50)end end})local c=t.Player:AddSlider("Jump",{Title="Jump Power",Default=50,Min=50,Max=200,Rounding=0,Callback=function(a)end})local c=t.Player:AddToggle("InfiniteJump",{Title="Infinite Jump",Default=false,Callback=function(a)if a then j=d.JumpRequest:Connect(function()b.Character:FindFirstChildOfClass("Humanoid"):ChangeState(Enum.HumanoidStateType.Jumping)end)repeat task.wait()until not r.InfiniteJump.Value;j:Disconnect()end end})local c=t.Player:AddToggle("NoFling",{Title="Anti Fling",Default=false,Callback=function(a)if a then o:Notify({Title='Notification',Content="You won't be able to fling people while Anti-Fling is Enabled",Duration=5})local function a(a)local b=false;local c;local d;local function e(a)c=a;repeat wait()d=a:FindFirstChild("HumanoidRootPart")until d;b=false end;e(a.Character or a.CharacterAdded:Wait())AntiFlingCharacterAdded=a.CharacterAdded:Connect(e)AntiFlingConnection=Services.RunService.Heartbeat:Connect(function()if(c and c:IsDescendantOf(workspace))and(d and d:IsDescendantOf(c))then if d.AssemblyAngularVelocity.Magnitude>50 or d.AssemblyLinearVelocity.Magnitude>100 then b=true;for a,a in ipairs(c:GetDescendants())do if a:IsA("BasePart")then a.CanCollide=false;a.AssemblyAngularVelocity=Vector3.new(0,0,0)a.AssemblyLinearVelocity=Vector3.new(0,0,0)a.CustomPhysicalProperties=PhysicalProperties.new(0,0,0)end end;d.CanCollide=false;d.AssemblyAngularVelocity=Vector3.new(0,0,0)d.AssemblyLinearVelocity=Vector3.new(0,0,0)d.CustomPhysicalProperties=PhysicalProperties.new(0,0,0)end end end)end;for c,c in ipairs(Services.Players:GetPlayers())do if c~=b then a(c)end end;AntiFlingPlayerAdded=Services.Players.PlayerAdded:Connect(a)local a=nil;AntiFlingConnection2=Services.RunService.Heartbeat:Connect(function()pcall(function()local b=b.Character.PrimaryPart;if b.AssemblyLinearVelocity.Magnitude>250 or b.AssemblyAngularVelocity.Magnitude>250 then b.AssemblyAngularVelocity=Vector3.new(0,0,0)b.AssemblyLinearVelocity=Vector3.new(0,0,0)b.CFrame=a elseif b.AssemblyLinearVelocity.Magnitude<50 or b.AssemblyAngularVelocity.Magnitude>50 then a=b.CFrame end end)end)repeat task.wait()until not r.NoFling.Value;AntiFlingPlayerAdded:Disconnect()AntiFlingCharacterAdded:Disconnect()AntiFlingConnection:Disconnect()AntiFlingConnection2:Disconnect()end end})t.Emotes:AddButton({Title="Ninja",Callback=function()module:emote("ninja")end})t.Emotes:AddButton({Title="Dab",Callback=function()module:emote("dab")end})t.Emotes:AddButton({Title="Floss",Callback=function()module:emote("floss")end})t.Emotes:AddButton({Title="Headless",Callback=function()module:emote("headless")end})t.Emotes:AddButton({Title="Zen",Callback=function()module:emote("zen")end})t.Emotes:AddButton({Title="Zombie",Callback=function()module:emote("zombie")end})t.Emotes:AddButton({Title="Sit",Callback=function()module:emote("sit")end})local c=t.Settings:AddToggle("Settings",{Title="Save Settings",Default=false,Callback=function(a)if a then repeat task.wait(.1)if _G.FB35D==true then print("return")return end;p:Save(game.PlaceId)until not r.Settings.Value end end})t.Settings:AddButton({Title="Delete Setting Config",Callback=function()delfile("nexus-001/settings/"..game.PlaceId..".json")end})local c=t.Server:AddToggle("AutoRejoin",{Title="Auto Rejoin",Default=false,Callback=function(a)if a then o:Notify({Title='Auto Rejoin',Content='You will rejoin if you are kicked or disconnected from the game',Duration=5})repeat task.wait()game.CoreGui.RobloxPromptGui.promptOverlay.ChildAdded:connect(function(a)if a.Name=='ErrorPrompt'then Services.TeleportService:Teleport(game.PlaceId)task.wait(2)end end)until r.AutoRejoin.Value end end})local a=t.Server:AddToggle("ReExecute",{Title="Auto ReExecute",Default=false,Callback=function(b)local b=b;local c=(syn and syn.queue_on_teleport)or queue_on_teleport or(fluxus and fluxus.queue_on_teleport)a.LocalPlayer.OnTeleport:Connect(function(a)if b and(not TeleportCheck)and c then TeleportCheck=true;c("loadstring(game:HttpGet('https://raw.githubusercontent.com/s-o-a-b/nexus/main/loadstring'))()")end end)end})t.Server:AddButton({Title="Rejoin-Server",Callback=function()Services.TeleportService:Teleport(game.PlaceId,Player)end})t.Server:AddButton({Title="Server-Hop",Callback=function()local a=Services.HttpService;local b=Services.TeleportService;local c="https://games.roblox.com/v1/games/"local d,e=game.PlaceId,game.JobId;local c=c..d.."/servers/Public?sortOrder=Desc&limit=100"local function f(b)local b=game:HttpGet(c..((b and"&cursor="..b)or""))return a:JSONDecode(b)end;local a;repeat local c=f(a)for a,a in next,c.data do if a.playing<a.maxPlayers and a.id~=e then local a,b=pcall(b.TeleportToPlaceInstance,b,d,a.id,Player)if a then break end end end;a=c.nextPageCursor until not a end})coroutine.wrap(function()while true do task.wait(.1)if _G.FB35D==true then return end;local a,a=pcall(function()if r.AutoFarm.Value and not H()and(b.PlayerGui.MainGUI.Game.CoinBags.Container.Coin.Visible or b.PlayerGui.MainGUI.Game.CoinBags.Container.BeachBall.Visible)then for a,a in ipairs(b.Character:GetDescendants())do if a:IsA("BasePart")then a.Velocity,a.RotVelocity=Vector3.new(0,0,0),Vector3.new(0,0,0)end end end end)local a,a=pcall(function()h=B()i=D()roles=x()end)end end)()local a;local a,b=pcall(function()a=hookmetamethod(game,"__namecall",function(b,...)local c=getnamecallmethod()local d={...}if not checkcaller()then if typeof(b)=="Instance"then if b.Name=="ShootGun"and c=="InvokeServer"then if r.SilentAim.Value then if h then local a=workspace[tostring(h)].HumanoidRootPart;local b=a.AssemblyLinearVelocity;local a=a.Position;d[2]=a end else return a(b,unpack(d))end end end end;return a(b,unpack(d))end)end)if not a then o:Notify({Title='Notification',Content="Silent Aim is not supported",Duration=5})end;p:SetLibrary(o)q:SetLibrary(o)p:SetIgnoreIndexes({})p:IgnoreThemeSettings()q:SetFolder("nexus-001")p:SetFolder("nexus-001")q:BuildInterfaceSection(t.Settings)p:Load(game.PlaceId)s:SelectTab(1)
