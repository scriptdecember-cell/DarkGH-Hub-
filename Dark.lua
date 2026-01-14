wait(1)

local Library = loadstring(game:HttpGet("https://pastefy.app/XKsCQo5n/raw"))()
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Player = Players.LocalPlayer
repeat wait() until Player.Character
local Character = Player.Character
local Humanoid = Character:WaitForChild("Humanoid")
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")

local Settings = {
    AutoBreakBlock = false,
    AutoCollectBrainrots = false,
    FilterGod = false,
    FilterSecret = false,
    FilterMythic = false,
    AutoRebirth = false,
    AutoBuyPickaxe = false,
    SelectedPickaxe = "Rainbow",
    AutoBuyGear = false,
    SelectedGear = "Speed Coil",
    AutoPlaceBrainrot = false,
    BrainrotSlot = "1",
    BrainrotType = "Pipi_Potato",
    FreezeSammy = false,
    Speed = false,
    SpeedAmount = 100,
    InfiniteJump = false,
    NoClip = false,
    SavedPosition = nil
}

local Connections = {}
local C1, C2, C3, C4, C5, C6, C7, C8, C9

local Remotes = ReplicatedStorage:WaitForChild("Remotes")

local Pickaxes = {
    Common = {"Wood", "Stone"},
    Rare = {"Iron", "Gold"},
    Epic = {"Diamond", "Emerald"},
    Legendary = {"Sapphire", "Ruby"},
    Mythic = {"Amethyst", "Obsidian"},
    Secret = {"Galaxy", "Nebula"},
    God = {"Celestial", "Divine"},
    OP = {"Disco", "Rainbow"}
}

local Gears = {
    "Speed Coil",
    "Jump Coil",
    "Double Jump",
    "Glider",
    "Jetpack",
    "Teleporter",
    "Magnet",
    "Auto Collector"
}

local function FindNearestBlock()
    local nearestBlock = nil
    local shortestDistance = math.huge
    
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj:IsA("Model") or obj:IsA("Part") then
            local name = string.lower(obj.Name)
            if string.find(name, "block") or string.find(name, "lucky") then
                local distance = 0
                if obj:IsA("Model") and obj:FindFirstChild("HumanoidRootPart") then
                    distance = (HumanoidRootPart.Position - obj.HumanoidRootPart.Position).Magnitude
                elseif obj:IsA("Part") then
                    distance = (HumanoidRootPart.Position - obj.Position).Magnitude
                end
                
                if distance < shortestDistance and distance < 50 then
                    shortestDistance = distance
                    nearestBlock = obj
                end
            end
        end
    end
    
    return nearestBlock
end

local function BreakBlock()
    spawn(function()
        pcall(function()
            local block = FindNearestBlock()
            if block then
                if block:IsA("Model") then
                    local clickDetector = block:FindFirstChildOfClass("ClickDetector", true)
                    if clickDetector then
                        fireclickdetector(clickDetector)
                    end
                elseif block:IsA("Part") then
                    local clickDetector = block:FindFirstChildOfClass("ClickDetector")
                    if clickDetector then
                        fireclickdetector(clickDetector)
                    end
                end
            end
        end)
    end)
end

local function StartAutoBreak()
    if C1 then return end
    C1 = RunService.Heartbeat:Connect(function()
        if Settings.AutoBreakBlock then
            BreakBlock()
            wait(0.1)
        end
    end)
end

local function StopAutoBreak()
    if C1 then C1:Disconnect() C1 = nil end
end

local function FindBrainrots()
    local brainrots = {}
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj:IsA("Model") or obj:IsA("Part") then
            local name = string.lower(obj.Name)
            if string.find(name, "brain") or string.find(name, "drop") then
                local rarity = string.lower(tostring(obj:GetAttribute("Rarity") or ""))
                local shouldCollect = true
                
                if Settings.FilterGod and not string.find(rarity, "god") then
                    shouldCollect = false
                elseif Settings.FilterSecret and not string.find(rarity, "secret") then
                    shouldCollect = false
                elseif Settings.FilterMythic and not string.find(rarity, "mythic") then
                    shouldCollect = false
                end
                
                if shouldCollect then
                    table.insert(brainrots, obj)
                end
            end
        end
    end
    return brainrots
end

local function CollectBrainrot(brainrot)
    spawn(function()
        pcall(function()
            if brainrot:IsA("Model") and brainrot:FindFirstChild("HumanoidRootPart") then
                local oldPos = HumanoidRootPart.CFrame
                HumanoidRootPart.CFrame = brainrot.HumanoidRootPart.CFrame
                wait(0.2)
                HumanoidRootPart.CFrame = oldPos
            elseif brainrot:IsA("Part") then
                local oldPos = HumanoidRootPart.CFrame
                HumanoidRootPart.CFrame = brainrot.CFrame
                wait(0.2)
                HumanoidRootPart.CFrame = oldPos
            end
        end)
    end)
end

local function StartAutoCollect()
    if C2 then return end
    C2 = RunService.Heartbeat:Connect(function()
        if Settings.AutoCollectBrainrots then
            local brainrots = FindBrainrots()
            for _, brainrot in pairs(brainrots) do
                CollectBrainrot(brainrot)
                wait(0.3)
            end
            wait(0.5)
        end
    end)
end

local function StopAutoCollect()
    if C2 then C2:Disconnect() C2 = nil end
end

local function BuyPickaxe(pickaxeName)
    spawn(function()
        pcall(function()
            Remotes.BuyPickaxeEvent:FireServer(pickaxeName)
        end)
    end)
end

local function StartAutoBuyPickaxe()
    if C3 then return end
    C3 = RunService.Heartbeat:Connect(function()
        if Settings.AutoBuyPickaxe then
            BuyPickaxe(Settings.SelectedPickaxe)
            wait(2)
        end
    end)
end

local function StopAutoBuyPickaxe()
    if C3 then C3:Disconnect() C3 = nil end
end

local function BuyGear(gearName)
    spawn(function()
        pcall(function()
            Remotes.BuyGearEvent:FireServer(gearName)
        end)
    end)
end

local function StartAutoBuyGear()
    if C4 then return end
    C4 = RunService.Heartbeat:Connect(function()
        if Settings.AutoBuyGear then
            BuyGear(Settings.SelectedGear)
            wait(2)
        end
    end)
end

local function StopAutoBuyGear()
    if C4 then C4:Disconnect() C4 = nil end
end

local function PlaceBrainrot()
    spawn(function()
        pcall(function()
            Remotes.PlaceBrainrotEvent:FireServer(Settings.BrainrotSlot, Settings.BrainrotType)
        end)
    end)
end

local function StartAutoPlaceBrainrot()
    if C5 then return end
    C5 = RunService.Heartbeat:Connect(function()
        if Settings.AutoPlaceBrainrot then
            PlaceBrainrot()
            wait(0.5)
        end
    end)
end

local function StopAutoPlaceBrainrot()
    if C5 then C5:Disconnect() C5 = nil end
end

local function DoRebirth()
    spawn(function()
        pcall(function()
            if Remotes:FindFirstChild("RebirthEvent") then
                Remotes.RebirthEvent:FireServer()
            elseif Remotes:FindFirstChild("Rebirth") then
                Remotes.Rebirth:FireServer()
            end
        end)
    end)
end

local function StartAutoRebirth()
    if C6 then return end
    C6 = RunService.Heartbeat:Connect(function()
        if Settings.AutoRebirth then
            DoRebirth()
            wait(3)
        end
    end)
end

local function StopAutoRebirth()
    if C6 then C6:Disconnect() C6 = nil end
end

local function FreezeSammyToggle()
    spawn(function()
        pcall(function()
            for _, npc in pairs(Workspace:GetDescendants()) do
                if npc.Name == "Sammy" or string.find(string.lower(npc.Name), "sammy") then
                    if npc:IsA("Model") and npc:FindFirstChild("HumanoidRootPart") then
                        if Settings.FreezeSammy then
                            npc.HumanoidRootPart.Anchored = true
                        else
                            npc.HumanoidRootPart.Anchored = false
                        end
                    end
                end
            end
        end)
    end)
end

local function TeleportTo(x, y, z)
    pcall(function()
        if Character and HumanoidRootPart then
            HumanoidRootPart.CFrame = CFrame.new(x, y, z)
        end
    end)
end

local function SavePosition()
    if HumanoidRootPart then
        Settings.SavedPosition = HumanoidRootPart.Position
    end
end

local function TeleportToSaved()
    if Settings.SavedPosition then
        TeleportTo(Settings.SavedPosition.X, Settings.SavedPosition.Y, Settings.SavedPosition.Z)
    end
end

local Window = Library:New({Name = "Break a Lucky Block"})

local MainTab = Window:Tab({Name = "⛏️ Auto Farm", Icon = "⛏️"})

MainTab:Toggle({
    Name = "Auto Break Blocks",
    Default = false,
    Callback = function(v)
        Settings.AutoBreakBlock = v
        if v then
            StartAutoBreak()
            Window:Notify({Title = "Auto Break", Message = "✅ Breaking blocks!", Duration = 2})
        else
            StopAutoBreak()
        end
    end
})

MainTab:Toggle({
    Name = "Auto Collect Brainrots",
    Default = false,
    Callback = function(v)
        Settings.AutoCollectBrainrots = v
        if v then
            StartAutoCollect()
            Window:Notify({Title = "Auto Collect", Message = "✅ Collecting brainrots!", Duration = 2})
        else
            StopAutoCollect()
        end
    end
})

MainTab:Toggle({Name = "Filter: God Only", Default = false, Callback = function(v) Settings.FilterGod = v end})
MainTab:Toggle({Name = "Filter: Secret Only", Default = false, Callback = function(v) Settings.FilterSecret = v end})
MainTab:Toggle({Name = "Filter: Mythic Only", Default = false, Callback = function(v) Settings.FilterMythic = v end})

MainTab:Toggle({
    Name = "Auto Rebirth",
    Default = false,
    Callback = function(v)
        Settings.AutoRebirth = v
        if v then
            StartAutoRebirth()
            Window:Notify({Title = "Auto Rebirth", Message = "✅ Enabled!", Duration = 2})
        else
            StopAutoRebirth()
        end
    end
})

MainTab:Button({Name = "Rebirth Once", Callback = function() DoRebirth() Window:Notify({Title = "Rebirth", Message = "✅ Triggered!", Duration = 2}) end})

MainTab:Toggle({
    Name = "Freeze Sammy",
    Default = false,
    Callback = function(v)
        Settings.FreezeSammy = v
        FreezeSammyToggle()
        Window:Notify({Title = "Sammy", Message = v and "✅ Frozen!" or "❌ Unfrozen", Duration = 2})
    end
})

local ShopTab = Window:Tab({Name = "🛒 Shop", Icon = "🛒"})

ShopTab:Label({Text = "⛏️ PICKAXES"})

ShopTab:Toggle({
    Name = "Auto Buy Pickaxe",
    Default = false,
    Callback = function(v)
        Settings.AutoBuyPickaxe = v
        if v then StartAutoBuyPickaxe() else StopAutoBuyPickaxe() end
    end
})

ShopTab:Dropdown({
    Name = "Select Pickaxe",
    Options = {"Wood", "Stone", "Iron", "Gold", "Diamond", "Emerald", "Sapphire", "Ruby", "Amethyst", "Obsidian", "Galaxy", "Nebula", "Celestial", "Divine", "Disco", "Rainbow"},
    Default = "Rainbow",
    Callback = function(v)
        Settings.SelectedPickaxe = v
    end
})

ShopTab:Button({Name = "Buy Pickaxe Once", Callback = function() BuyPickaxe(Settings.SelectedPickaxe) Window:Notify({Title = "Pickaxe", Message = "Bought: " .. Settings.SelectedPickaxe, Duration = 2}) end})

ShopTab:Label({Text = " "})
ShopTab:Label({Text = "🎒 GEAR"})

ShopTab:Toggle({
    Name = "Auto Buy Gear",
    Default = false,
    Callback = function(v)
        Settings.AutoBuyGear = v
        if v then StartAutoBuyGear() else StopAutoBuyGear() end
    end
})

ShopTab:Dropdown({
    Name = "Select Gear",
    Options = {"Speed Coil", "Jump Coil", "Double Jump", "Glider", "Jetpack", "Teleporter", "Magnet", "Auto Collector"},
    Default = "Speed Coil",
    Callback = function(v)
        Settings.SelectedGear = v
    end
})

ShopTab:Button({Name = "Buy Gear Once", Callback = function() BuyGear(Settings.SelectedGear) Window:Notify({Title = "Gear", Message = "Bought: " .. Settings.SelectedGear, Duration = 2}) end})

local BrainrotTab = Window:Tab({Name = "🧠 Brainrot", Icon = "🧠"})

BrainrotTab:Toggle({
    Name = "Auto Place Brainrot",
    Default = false,
    Callback = function(v)
        Settings.AutoPlaceBrainrot = v
        if v then StartAutoPlaceBrainrot() else StopAutoPlaceBrainrot() end
    end
})

BrainrotTab:Input({Name = "Slot (1-30)", Placeholder = "1", Callback = function(v) if v ~= "" then Settings.BrainrotSlot = v end end})
BrainrotTab:Input({Name = "Brainrot Type", Placeholder = "Pipi_Potato", Callback = function(v) if v ~= "" then Settings.BrainrotType = v end end})
BrainrotTab:Button({Name = "Place Once", Callback = function() PlaceBrainrot() end})

local TeleportTab = Window:Tab({Name = "📍 Teleport", Icon = "📍"})

TeleportTab:Button({Name = "Save Position", Callback = function() SavePosition() Window:Notify({Title = "Position", Message = "✅ Saved!", Duration = 2}) end})
TeleportTab:Button({Name = "TP to Saved", Callback = function() if Settings.SavedPosition then TeleportToSaved() else Window:Notify({Title = "Error", Message = "No position!", Duration = 2}) end end})

local MovementTab = Window:Tab({Name = "🏃 Movement", Icon = "🏃"})

MovementTab:Toggle({Name = "Speed Boost", Default = false, Callback = function(v) Settings.Speed = v Humanoid.WalkSpeed = v and Settings.SpeedAmount or 16 end})
MovementTab:Slider({Name = "Speed", Min = 16, Max = 500, Default = 100, Callback = function(v) Settings.SpeedAmount = v if Settings.Speed then Humanoid.WalkSpeed = v end end})
MovementTab:Toggle({Name = "Infinite Jump", Default = false, Callback = function(v) Settings.InfiniteJump = v if v then table.insert(Connections, UserInputService.JumpRequest:Connect(function() if Humanoid then Humanoid:ChangeState(Enum.HumanoidStateType.Jumping) end end)) end end})
MovementTab:Toggle({Name = "No Clip", Default = false, Callback = function(v) Settings.NoClip = v if v then table.insert(Connections, RunService.Stepped:Connect(function() if Character and Settings.NoClip then for _, part in pairs(Character:GetDescendants()) do if part:IsA("BasePart") then part.CanCollide = false end end end end)) end end})

Window:Notify({Title = "Break a Lucky Block", Message = "✅ Script loaded!\n⛏️ Start breaking blocks!", Duration = 3})

Player.CharacterAdded:Connect(function(char)
    wait(0.5)
    Character = char
    Humanoid = char:WaitForChild("Humanoid")
    HumanoidRootPart = char:WaitForChild("HumanoidRootPart")
    if Settings.Speed then Humanoid.WalkSpeed = Settings.SpeedAmount end
end)
