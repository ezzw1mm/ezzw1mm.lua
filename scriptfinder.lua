-- ScriptFinder: Polished GUI with Hover & Gradient Effects
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Cleanup old copies
for _,c in pairs(playerGui:GetChildren()) do
    if c.Name=="ScriptFinderGUI" then c:Destroy() end
end

-- Colors
local neonA = Color3.fromRGB(79,70,255)
local neonB = Color3.fromRGB(64,224,208)
local darkA  = Color3.fromRGB(9,12,33)
local darkB  = Color3.fromRGB(17,20,54)

local function tween(inst,props,time,style,dir)
    return TweenService:Create(inst,TweenInfo.new(time or 0.25,style or Enum.EasingStyle.Sine,dir or Enum.EasingDirection.Out),props)
end

-- GUI
local gui = Instance.new("ScreenGui")
gui.Name = "ScriptFinderGUI"
gui.ResetOnSpawn = false
gui.Parent = playerGui

-- Main frame
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0,620,0,380)
frame.AnchorPoint = Vector2.new(0.5,0.5)
frame.Position = UDim2.new(0.5,0,0.5,0)
frame.BackgroundTransparency = 1
frame.Parent = gui

-- Outer + border
local outer = Instance.new("Frame",frame)
outer.Size = UDim2.fromScale(1,1)
outer.BackgroundColor3 = darkA
outer.BorderSizePixel = 0
local outerCorner = Instance.new("UICorner",outer)
outerCorner.CornerRadius = UDim.new(0,18)

local border = Instance.new("UIStroke",outer)
border.Thickness = 3
border.LineJoinMode = Enum.LineJoinMode.Round
border.Color = neonA
border.Transparency = 0.35

-- Inner gradient
local inner = Instance.new("Frame",outer)
inner.Size = UDim2.new(1,-10,1,-10)
inner.Position = UDim2.new(0,5,0,5)
inner.BackgroundColor3 = darkA
inner.BorderSizePixel = 0
local innerCorner = Instance.new("UICorner",inner)
innerCorner.CornerRadius = UDim.new(0,14)
local grad = Instance.new("UIGradient",inner)
grad.Color = ColorSequence.new{ColorSequenceKeypoint.new(0,darkA),ColorSequenceKeypoint.new(1,darkB)}
grad.Rotation = 90

-- Top bar
local topBar = Instance.new("Frame",inner)
topBar.Size = UDim2.new(1,0,0,48)
topBar.BackgroundTransparency = 1

local title = Instance.new("TextLabel",topBar)
title.Size = UDim2.new(1,0,1,0)
title.BackgroundTransparency = 1
title.Text = "SCRIPT FINDER"
title.Font = Enum.Font.GothamBold
title.TextSize = 18
title.TextColor3 = Color3.fromRGB(240,240,255)
title.TextXAlignment = Enum.TextXAlignment.Left
title.TextYAlignment = Enum.TextYAlignment.Center
title.Position = UDim2.new(0,16,0,0)

-- Minimize button
local minBtn = Instance.new("TextButton",topBar)
minBtn.Size = UDim2.new(0,38,0,28)
minBtn.Position = UDim2.new(1,-52,0.5,-14)
minBtn.BackgroundColor3 = darkB
minBtn.Text = "—"
minBtn.Font = Enum.Font.GothamBold
minBtn.TextSize = 20
minBtn.TextColor3 = Color3.fromRGB(230,230,255)
minBtn.BorderSizePixel = 0
minBtn.AutoButtonColor = false
minBtn.Active = true
local minCorner = Instance.new("UICorner", minBtn)
minCorner.CornerRadius = UDim.new(0,8)
local minGrad = Instance.new("UIGradient", minBtn)
minGrad.Color = ColorSequence.new{ ColorSequenceKeypoint.new(0,neonA), ColorSequenceKeypoint.new(1,neonB) }
minGrad.Rotation = 90

-- Tabs column
local tabsCol = Instance.new("Frame",inner)
tabsCol.Size = UDim2.new(0,120,1,-68)
tabsCol.Position = UDim2.new(0,12,0,56)
tabsCol.BackgroundTransparency = 1
local tabsList = Instance.new("UIListLayout",tabsCol)
tabsList.SortOrder = Enum.SortOrder.LayoutOrder
tabsList.Padding = UDim.new(0,12)
tabsList.FillDirection = Enum.FillDirection.Vertical
tabsList.HorizontalAlignment = Enum.HorizontalAlignment.Center

-- Content area
local content = Instance.new("Frame",inner)
content.Size = UDim2.new(1,-164,1,-72)
content.Position = UDim2.new(0,148,0,56)
content.BackgroundTransparency = 1

-- Scrolling frame for script buttons
local contentHolder = Instance.new("ScrollingFrame", content)
contentHolder.Size = UDim2.new(1,0,1,0)
contentHolder.Position = UDim2.new(0,0,0,0)
contentHolder.BackgroundTransparency = 1
contentHolder.ScrollBarThickness = 6
contentHolder.AutomaticCanvasSize = Enum.AutomaticSize.Y

-- Divider
local divider = Instance.new("Frame",inner)
divider.Size = UDim2.new(0,2,1,-72)
divider.Position = UDim2.new(0,140,0,56)
divider.BackgroundColor3 = Color3.fromRGB(40,40,60)
local divGrad = Instance.new("UIGradient",divider)
divGrad.Color = ColorSequence.new{ColorSequenceKeypoint.new(0,Color3.fromRGB(40,40,60)),ColorSequenceKeypoint.new(1,Color3.fromRGB(18,18,40))}
divGrad.Rotation = 90

-- Status label
local statusLabel = Instance.new("TextLabel",inner)
statusLabel.Size = UDim2.new(0,360,0,18)
statusLabel.Position = UDim2.new(0,14,1,-28)
statusLabel.BackgroundTransparency = 1
statusLabel.Font = Enum.Font.Gotham
statusLabel.TextSize = 13
statusLabel.TextColor3 = Color3.fromRGB(200,200,255)
statusLabel.Text = ""
statusLabel.TextXAlignment = Enum.TextXAlignment.Left

-- Tabs table
local Tabs = {}

-- Create tab helper
local function makeTab(name, icon)
    local btn = Instance.new("TextButton", tabsCol)
    btn.Size = UDim2.new(0,96,0,48)
    btn.BackgroundColor3 = Color3.fromRGB(22,22,40)
    btn.BorderSizePixel = 0
    btn.AutoButtonColor = false
    btn.Active = true
    local corner = Instance.new("UICorner", btn)
    corner.CornerRadius = UDim.new(0,10)
    local grad = Instance.new("UIGradient", btn)
    grad.Color = ColorSequence.new{ColorSequenceKeypoint.new(0,Color3.fromRGB(22,22,40)),ColorSequenceKeypoint.new(1,Color3.fromRGB(34,34,56))}
    grad.Rotation = 90

    local iconLbl = Instance.new("TextLabel", btn)
    iconLbl.Size = UDim2.new(0,28,0,28)
    iconLbl.Position = UDim2.new(0,8,0.5,-14)
    iconLbl.BackgroundTransparency = 1
    iconLbl.Text = icon or "•"
    iconLbl.Font = Enum.Font.GothamBold
    iconLbl.TextSize = 18
    iconLbl.TextColor3 = neonB
    iconLbl.TextXAlignment = Enum.TextXAlignment.Center

    local label = Instance.new("TextLabel", btn)
    label.Size = UDim2.new(1,-44,0,20)
    label.Position = UDim2.new(0,44,0.5,-10)
    label.BackgroundTransparency = 1
    label.Text = name
    label.Font = Enum.Font.Gotham
    label.TextSize = 13
    label.TextColor3 = Color3.fromRGB(210,210,255)
    label.TextXAlignment = Enum.TextXAlignment.Left

    btn.MouseEnter:Connect(function()
        tween(iconLbl,{TextColor3=neonA},0.12):Play()
        tween(btn,{Size=UDim2.new(0,100,0,52)},0.12):Play()
    end)
    btn.MouseLeave:Connect(function()
        tween(iconLbl,{TextColor3=neonB},0.12):Play()
        tween(btn,{Size=UDim2.new(0,96,0,48)},0.12):Play()
    end)

    Tabs[name] = {button=btn}

    btn.MouseButton1Click:Connect(function()
        if type(showTab) == "function" then
            showTab(name)
        end
    end)

    return Tabs[name]
end

-- Script button helper with hover
local function makeScriptButton(text, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1,0,0,42)
    btn.BackgroundColor3 = Color3.fromRGB(18,18,36)
    btn.BorderSizePixel = 0
    btn.AutoButtonColor = false
    btn.Active = true
    local corner = Instance.new("UICorner", btn)
    corner.CornerRadius = UDim.new(0,10)
    local grad = Instance.new("UIGradient", btn)
    grad.Color = ColorSequence.new{ColorSequenceKeypoint.new(0,neonA),ColorSequenceKeypoint.new(1,neonB)}
    grad.Rotation = 90
    grad.Transparency = NumberSequence.new(0.85)

    local lbl = Instance.new("TextLabel", btn)
    lbl.Size = UDim2.new(1,-12,1,0)
    lbl.Position = UDim2.new(0,12,0,0)
    lbl.BackgroundTransparency = 1
    lbl.Text = text
    lbl.Font = Enum.Font.Gotham
    lbl.TextSize = 14
    lbl.TextColor3 = Color3.fromRGB(245,245,245)
    lbl.TextXAlignment = Enum.TextXAlignment.Left

    -- Hover animation
    btn.MouseEnter:Connect(function()
        tween(btn, {Size = UDim2.new(1,0,0,46)}, 0.15, Enum.EasingStyle.Sine, Enum.EasingDirection.Out):Play()
        tween(lbl, {TextColor3 = neonA}, 0.15):Play()
    end)
    btn.MouseLeave:Connect(function()
        tween(btn, {Size = UDim2.new(1,0,0,42)}, 0.15, Enum.EasingStyle.Sine, Enum.EasingDirection.Out):Play()
        tween(lbl, {TextColor3 = Color3.fromRGB(245,245,245)}, 0.15):Play()
    end)

    btn.MouseButton1Click:Connect(function()
        local ok, err = pcall(callback)
        if ok then 
            statusLabel.Text = "Loaded Successfully ✅"
        else
            statusLabel.Text = "Failed ❌: "..tostring(err)
            warn(err)
        end
        task.delay(2,function() statusLabel.Text="" end)
    end)

    return btn
end

-- Create tabs
makeTab("HOME","⌂")
makeTab("BSS","🐝")
makeTab("SAB","💀")
makeTab("EXTRA","⚡")

-- Tab content functions (with proper spacing)
local function populateTab(contentList)
    contentHolder:ClearAllChildren()
    local layout = Instance.new("UIListLayout")
    layout.Parent = contentHolder
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0,12)
    layout.FillDirection = Enum.FillDirection.Vertical
    layout.HorizontalAlignment = Enum.HorizontalAlignment.Center

    for i,v in ipairs(contentList) do
        local btn = makeScriptButton(v[1], function() loadstring(game:HttpGet(v[2]))() end)
        btn.LayoutOrder = i
        btn.Parent = contentHolder
    end
end

function showHome()
    contentHolder:ClearAllChildren()
    local layout = Instance.new("UIListLayout")
    layout.Parent = contentHolder
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0,12)
    layout.FillDirection = Enum.FillDirection.Vertical
    layout.HorizontalAlignment = Enum.HorizontalAlignment.Center

    local welcome = Instance.new("TextLabel")
    welcome.Size = UDim2.new(1,0,0,120)
    welcome.BackgroundTransparency = 1
    welcome.TextWrapped = true
    welcome.Font = Enum.Font.Gotham
    welcome.TextSize = 14
    welcome.TextColor3 = Color3.fromRGB(220,220,255)
    welcome.Text = "Hello — welcome to ScriptFinder.\nMade by carrot, isox, and wock.\nCredits to authors of scripts used. Use responsibly."
    welcome.LayoutOrder = 1
    welcome.Parent = contentHolder
end

function populateBSS()
    populateTab({
        {"MACROWARE 👾","https://macroware.cc/loader.lua"},
        {"ATLAS 🌎","https://raw.githubusercontent.com/Chris12089/atlasbss/main/script.lua"}
    })
end

function populateSAB()
    populateTab({
        {"NAMELESS HUB 😍","https://raw.githubusercontent.com/ily123950/Vulkan/refs/heads/main/Tr"},
        {"ZZZZ HUB 💤","https://pastefy.app/FLgzUxuW/raw"},
        {"CHILI HUB 🌶️","https://raw.githubusercontent.com/tienkhanh1/spicy/main/Chilli.lua"}
    })
end

function populateExtra()
    contentHolder:ClearAllChildren()
    local layout = Instance.new("UIListLayout")
    layout.Parent = contentHolder
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0,12)
    layout.FillDirection = Enum.FillDirection.Vertical
    layout.HorizontalAlignment = Enum.HorizontalAlignment.Center

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1,0,0,40)
    lbl.BackgroundTransparency = 1
    lbl.Text = "Nothing yet..."
    lbl.Font = Enum.Font.Gotham
    lbl.TextColor3 = Color3.fromRGB(220,220,255)
    lbl.LayoutOrder = 1
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = contentHolder
end

-- showTab
function showTab(name)
    for k,v in pairs(Tabs) do
        if k==name then
            tween(v.button,{BackgroundTransparency=0},0.18):Play()
        else
            tween(v.button,{BackgroundTransparency=0.3},0.18):Play()
        end
    end

    if name=="HOME" then showHome()
    elseif name=="BSS" then populateBSS()
    elseif name=="SAB" then populateSAB()
    elseif name=="EXTRA" then populateExtra()
    end
end

-- Show HOME by default
showTab("HOME")

-- Big Gradient Unminimize Button
local unmin = Instance.new("TextButton", gui)
unmin.Size = UDim2.new(0,60,0,60)
unmin.Position = UDim2.new(0,10,0,10)
unmin.BackgroundColor3 = darkB
unmin.Text = "◧"
unmin.Font = Enum.Font.GothamBold
unmin.TextSize = 28
unmin.TextColor3 = Color3.fromRGB(230,230,255)
unmin.BorderSizePixel = 0
unmin.Visible = false
unmin.AutoButtonColor = false
unmin.Active = true

local unCorner = Instance.new("UICorner",unmin)
unCorner.CornerRadius = UDim.new(0,12)

local unGrad = Instance.new("UIGradient",unmin)
unGrad.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, neonA),
    ColorSequenceKeypoint.new(1, neonB)
}
unGrad.Rotation = 90

-- Hover animation
unmin.MouseEnter:Connect(function()
    tween(unmin, {Size = UDim2.new(0,66,0,66)}, 0.15, Enum.EasingStyle.Sine, Enum.EasingDirection.Out):Play()
end)
unmin.MouseLeave:Connect(function()
    tween(unmin, {Size = UDim2.new(0,60,0,60)}, 0.15, Enum.EasingStyle.Sine, Enum.EasingDirection.Out):Play()
end)

-- Minimize button functionality
minBtn.MouseButton1Click:Connect(function()
    tween(frame,{Position=UDim2.new(0.5,0,1.5,0)},0.25,Enum.EasingStyle.Quad,Enum.EasingDirection.In):Play()
    task.wait(0.25)
    frame.Visible = false
    unmin.Visible = true
end)

-- Click restores GUI
unmin.MouseButton1Click:Connect(function()
    frame.Visible = true
    tween(frame,{Position=UDim2.new(0.5,0,0.5,0)},0.25,Enum.EasingStyle.Quad,Enum.EasingDirection.Out):Play()
    unmin.Visible = false
end)

-- Toggle UI with RightShift
UserInputService.InputBegan:Connect(function(input,processed)
    if processed then return end
    if input.KeyCode==Enum.KeyCode.RightShift then
        frame.Visible = not frame.Visible
        unmin.Visible = not frame.Visible
    end
end)
