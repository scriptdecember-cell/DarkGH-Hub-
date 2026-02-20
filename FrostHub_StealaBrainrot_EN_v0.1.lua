local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")
local StarterGui = game:GetService("StarterGui")
local Camera = Workspace.CurrentCamera
local LP = Players.LocalPlayer
local character = LP.Character or LP.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local hrp = character:WaitForChild("HumanoidRootPart")
local function getChar()
    return LP.Character
end
local function getRoot()
    return getChar() and getChar():FindFirstChild("HumanoidRootPart")
end
local function getHum()
    return getChar() and getChar():FindFirstChildOfClass("Humanoid")
end
local toggles = {}
local loops = {}
local flyBV, flyBG
local isMobile = UserInputService.TouchEnabled
if LP.PlayerGui:FindFirstChild("FrostHub") then
    LP.PlayerGui.FrostHub:Destroy()
end
if Workspace:FindFirstChild("FrostESP") then
    Workspace.FrostESP:Destroy()
end
local ESPFolder = Instance.new("Folder")
ESPFolder.Name = "FrostESP"
ESPFolder.Parent = Workspace
local SG = Instance.new("ScreenGui")
SG.Name = "FrostHub"
SG.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
SG.ResetOnSpawn = false
SG.IgnoreGuiInset = true
SG.Parent = LP:WaitForChild("PlayerGui")
local BASE_W = 700
local BASE_H = 850
local REF_W = 1920
local REF_H = 1080
local menuVisible = true
local menuLateral = false
local Main = Instance.new("Frame")
Main.AnchorPoint = Vector2.new(0.5, 0.5)
Main.BackgroundColor3 = Color3.fromRGB(12, 15, 35)
Main.BorderSizePixel = 0
Main.Active = true
Main.Parent = SG
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 18)
local UIScale = Instance.new("UIScale")
UIScale.Parent = Main
local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(60, 130, 255)
MainStroke.Thickness = 3
MainStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
MainStroke.Parent = Main
local function applyScale()
    local vp = Camera.ViewportSize
    local sc = math.clamp(math.min(vp.X / REF_W, vp.Y / REF_H), 0.5, 1.6)
    UIScale.Scale = sc
    Main.Size = UDim2.new(0, BASE_W, 0, BASE_H)
    if menuLateral then
        Main.AnchorPoint = Vector2.new(0, 0.5)
        Main.Position = UDim2.new(0, 20, 0.5, 0)
    else
        Main.AnchorPoint = Vector2.new(0.5, 0.5)
        Main.Position = UDim2.new(0.5, 0, 0.5, 0)
    end
end
applyScale()
Camera:GetPropertyChangedSignal("ViewportSize"):Connect(applyScale)
local Top = Instance.new("Frame")
Top.Size = UDim2.new(1, 0, 0, 60)
Top.BackgroundColor3 = Color3.fromRGB(20, 40, 140)
Top.BorderSizePixel = 0
Top.Parent = Main
Instance.new("UICorner", Top).CornerRadius = UDim.new(0, 18)
local TopFix = Instance.new("Frame")
TopFix.Size = UDim2.new(1, 0, 0.5, 0)
TopFix.Position = UDim2.new(0, 0, 0.5, 0)
TopFix.BackgroundColor3 = Color3.fromRGB(20, 40, 140)
TopFix.BorderSizePixel = 0
TopFix.Parent = Top
local TitleLbl = Instance.new("TextLabel")
TitleLbl.Size = UDim2.new(1, -60, 1, 0)
TitleLbl.Position = UDim2.new(0, 18, 0, 0)
TitleLbl.BackgroundTransparency = 1
TitleLbl.Text = "❄️ FROST HUB v0.1.0 | Steal a Brainrot | [RShift] Hide"
TitleLbl.TextColor3 = Color3.fromRGB(220, 240, 255)
TitleLbl.Font = Enum.Font.GothamBold
TitleLbl.TextSize = 16
TitleLbl.TextXAlignment = Enum.TextXAlignment.Left
TitleLbl.Parent = Top
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 40, 0, 40)
CloseBtn.Position = UDim2.new(1, -48, 0, 10)
CloseBtn.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = Color3.new(1, 1, 1)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 18
CloseBtn.BorderSizePixel = 0
CloseBtn.Parent = Top
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 10)
CloseBtn.MouseEnter:Connect(function()
    TweenService:Create(CloseBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(255, 80, 80)}):Play()
end)
CloseBtn.MouseLeave:Connect(function()
    TweenService:Create(CloseBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(220, 50, 50)}):Play()
end)
CloseBtn.MouseButton1Click:Connect(function()
    SG:Destroy()
end)
do
    local dragging, dStart, sPos
    Top.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            dragging = true
dStart = i.Position
            sPos = Main.Position
        end
    end)
    UserInputService.InputChanged:Connect(function(i)
        if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
            local d = i.Position - dStart
            local sc = UIScale.Scale
            Main.Position = UDim2.new(sPos.X.Scale, sPos.X.Offset + d.X / sc, sPos.Y.Scale, sPos.Y.Offset + d.Y / sc)
        end
    end)
    UserInputService.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
end
UserInputService.InputBegan:Connect(function(i, gp)
    if not gp and i.KeyCode == Enum.KeyCode.RightShift then
        menuVisible = not menuVisible
        Main.Visible = menuVisible
    end
end)
local Scroll = Instance.new("ScrollingFrame")
Scroll.Size = UDim2.new(1, -14, 1, -76)
Scroll.Position = UDim2.new(0, 7, 0, 66)
Scroll.BackgroundTransparency = 1
Scroll.ScrollBarThickness = 7
Scroll.ScrollBarImageColor3 = Color3.fromRGB(60, 130, 255)
Scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
Scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
Scroll.Parent = Main
local Grid = Instance.new("UIGridLayout")
Grid.CellSize = UDim2.new(0, 210, 0, 60)
Grid.CellPadding = UDim2.new(0, 10, 0, 10)
Grid.HorizontalAlignment = Enum.HorizontalAlignment.Center
Grid.SortOrder = Enum.SortOrder.LayoutOrder
Grid.Parent = Scroll
local UIPad = Instance.new("UIPadding")
UIPad.PaddingTop = UDim.new(0, 10)
UIPad.Parent = Scroll
local ON_BG   = Color3.fromRGB(35, 75, 220)
local OFF_BG  = Color3.fromRGB(25, 28, 50)
local ON_TXT  = Color3.fromRGB(220, 240, 255)
local OFF_TXT = Color3.fromRGB(140, 150, 180)
local ON_STR  = Color3.fromRGB(100, 150, 255)
local OFF_STR = Color3.fromRGB(50, 60, 120)
print("✅ Frost Hub v0.1.0 Successfully Loaded on GitHub!")