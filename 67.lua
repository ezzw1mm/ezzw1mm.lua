-- PRISON LIFE SCRIPT | FINAL COMPLETE VERSION (HITBOX & AIMBOT FIXED)
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")
local camera = workspace.CurrentCamera

-- === COORDINATES ===
local mp5Pos = Vector3.new(813.479187, 100.940002, 2229.177734)
local remingtonPos = Vector3.new(820.248108, 100.795319, 2229.695557)
local newPos = Vector3.new(920.982300, 99.989952, 2282.098633)
local criminalBasePos = Vector3.new(-930.568298, 94.128868, 2053.593018)
local undergroundOffset = Vector3.new(0, -25, 0)

-- Update HRP on respawn
player.CharacterAdded:Connect(function(newChar)
	char = newChar
	hrp = char:WaitForChild("HumanoidRootPart")
end)

-- === GUI SETUP ===
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "PRISON_LIFE_GUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 400, 0, 500)
mainFrame.Position = UDim2.new(0, 50, 0, 100)
mainFrame.BackgroundColor3 = Color3.fromRGB(25,25,25)
mainFrame.BorderSizePixel = 2
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

-- Title
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 40)
title.Position = UDim2.new(0,0,0,0)
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBold
title.TextScaled = true
title.TextColor3 = Color3.fromRGB(255,255,255)
title.Text = "PRISON LIFE SCRIPT"
title.Parent = mainFrame

-- === MINIMIZER ===
local buttonMinimize = Instance.new("TextButton")
buttonMinimize.Size = UDim2.new(0,35,0,35)
buttonMinimize.Position = UDim2.new(1,-40,0,0)
buttonMinimize.BackgroundColor3 = Color3.fromRGB(70,70,70)
buttonMinimize.TextColor3 = Color3.fromRGB(255,255,255)
buttonMinimize.Text = "_"
buttonMinimize.Font = Enum.Font.GothamBold
buttonMinimize.TextScaled = true
buttonMinimize.Parent = mainFrame

local minimized = false
buttonMinimize.MouseButton1Click:Connect(function()
	minimized = not minimized
	for _, f in pairs(tabFrames) do
		f.Visible = not minimized
	end
	for _, t in pairs(tabs) do
		t.Visible = not minimized
	end
	title.Visible = true
	buttonMinimize.Visible = true
end)

-- === TABS ===
local tabNames = {"Home", "Teleports and Tweens", "HITBOX and ESP"}
local tabs = {}
local tabFrames = {}

for i, name in ipairs(tabNames) do
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(1/3,0,0,40)
	btn.Position = UDim2.new((i-1)/3,0,0,40)
	btn.BackgroundColor3 = Color3.fromRGB(60,60,60)
	btn.Font = Enum.Font.GothamBold
	btn.TextScaled = true
	btn.TextColor3 = Color3.new(1,1,1)
	btn.Text = name
	btn.Parent = mainFrame
	tabs[name] = btn

	local tabFrame = Instance.new("Frame")
	tabFrame.Size = UDim2.new(1, -20, 1, -90)
	tabFrame.Position = UDim2.new(0, 10, 0, 90)
	tabFrame.BackgroundColor3 = Color3.fromRGB(40,40,40)
	tabFrame.Visible = false
	tabFrame.Parent = mainFrame
	tabFrames[name] = tabFrame

	btn.MouseButton1Click:Connect(function()
		for _, f in pairs(tabFrames) do
			f.Visible = false
		end
		tabFrame.Visible = true
		updateTabColors(name)
	end)
end

tabFrames["Home"].Visible = true

local function updateTabColors(activeTab)
	for name, btn in pairs(tabs) do
		if name == activeTab then
			btn.BackgroundColor3 = Color3.fromRGB(100,100,255)
		else
			btn.BackgroundColor3 = Color3.fromRGB(60,60,60)
		end
	end
end
updateTabColors("Home")

-- === HOME TAB ===
local homeLabel = Instance.new("TextLabel")
homeLabel.Size = UDim2.new(1, -20, 0, 100)
homeLabel.Position = UDim2.new(0,10,0,10)
homeLabel.BackgroundTransparency = 1
homeLabel.TextColor3 = Color3.fromRGB(255,255,255)
homeLabel.TextScaled = true
homeLabel.TextWrapped = true
homeLabel.Text = "Welcome to PRISON LIFE SCRIPT!\nUse the tabs to access Teleports, Tweens, and HITBOX ESP."
homeLabel.Parent = tabFrames["Home"]

-- === TELEPORTS AND TWEENS ===
local function createButton(parent,text,posY)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(1,-20,0,50)
	btn.Position = UDim2.new(0,10,0,posY)
	btn.BackgroundColor3 = Color3.fromRGB(60,60,60)
	btn.Font = Enum.Font.GothamBold
	btn.TextScaled = true
	btn.TextColor3 = Color3.new(1,1,1)
	btn.Text = text
	btn.Parent = parent
	return btn
end

local buttonMP5 = createButton(tabFrames["Teleports and Tweens"], "Get MP5", 10)
local buttonRem = createButton(tabFrames["Teleports and Tweens"], "Get Remington", 70)
local buttonCrim = createButton(tabFrames["Teleports and Tweens"], "Teleport to Criminal Base", 130)

local function makeTween(target, time)
	return TweenService:Create(hrp, TweenInfo.new(time, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {CFrame = CFrame.new(target)})
end

local function tweenMP5()
	if not hrp then return end
	makeTween(hrp.Position + undergroundOffset,2):Play()
	task.wait(2)
	makeTween(mp5Pos,3):Play()
	task.wait(3)
	makeTween(mp5Pos + undergroundOffset,2):Play()
	task.wait(2)
	makeTween(newPos,4):Play()
end

local function tweenRemington()
	if not hrp then return end
	makeTween(hrp.Position + undergroundOffset,2):Play()
	task.wait(2)
	makeTween(remingtonPos,3):Play()
	task.wait(3)
	makeTween(remingtonPos + undergroundOffset,2):Play()
	task.wait(2)
	makeTween(newPos,4):Play()
end

-- TELEPORT CRIMINAL BASE
local teleportFlag = false
local function teleportAfterRespawn()
	if not teleportFlag then return end
	local newHRP = char:WaitForChild("HumanoidRootPart")
	task.wait(0.1)
	newHRP.CFrame = CFrame.new(criminalBasePos)
	teleportFlag = false
	buttonCrim.Active = true
	buttonCrim.Text = "Teleport to Criminal Base"
end

local function blinkButton(btn)
	spawn(function()
		while teleportFlag do
			btn.TextColor3 = Color3.fromRGB(255,0,0)
			task.wait(0.5)
			btn.TextColor3 = Color3.new(1,1,1)
			task.wait(0.5)
		end
	end)
end

buttonCrim.MouseButton1Click:Connect(function()
	if teleportFlag then return end
	teleportFlag = true
	buttonCrim.Active = false
	buttonCrim.Text = "Please reset your character"
	blinkButton(buttonCrim)
end)

player.CharacterAdded:Connect(function(newChar)
	char = newChar
	task.wait(0.1)
	teleportAfterRespawn()
end)

buttonMP5.MouseButton1Click:Connect(tweenMP5)
buttonRem.MouseButton1Click:Connect(tweenRemington)

-- === HITBOX AND AIMBOT ===
local hitboxButton = createButton(tabFrames["HITBOX and ESP"], "HITBOX ESP", 10)
local aimbotButton = createButton(tabFrames["HITBOX and ESP"], "AIMBOT", 70)

-- HITBOX DROPDOWN
local dropdownFrame = Instance.new("Frame")
dropdownFrame.Size = UDim2.new(1,-20,0,0)
dropdownFrame.Position = UDim2.new(0,10,0,60)
dropdownFrame.BackgroundColor3 = Color3.fromRGB(50,50,50)
dropdownFrame.Visible = false
dropdownFrame.Parent = tabFrames["HITBOX and ESP"]

local boxes = {}
local selectedTeams = {}
local teamColors = {Criminals = Color3.fromRGB(255,0,0), Guards = Color3.fromRGB(0,0,255), Inmates = Color3.fromRGB(255,165,0)}

local function createBox(hrp,color)
	local box = Instance.new("BoxHandleAdornment")
	box.Adornee = hrp
	box.AlwaysOnTop = true
	box.Size = Vector3.new(4,5,2)
	box.Color3 = color
	box.Transparency = 0.5
	box.ZIndex = 10
	box.Parent = hrp
	return box
end

local function updateESP()
	for _, plr in pairs(Players:GetPlayers()) do
		if plr ~= player and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
			local hrp = plr.Character.HumanoidRootPart
			if plr.Team and selectedTeams[plr.Team.Name] then
				if not boxes[plr] then
					boxes[plr] = createBox(hrp, teamColors[plr.Team.Name])
				end
			else
				if boxes[plr] then
					boxes[plr]:Destroy()
					boxes[plr] = nil
				end
			end
		end
	end
end

-- HITBOX BUTTON opens dropdown only
hitboxButton.MouseButton1Click:Connect(function()
	dropdownFrame.Visible = not dropdownFrame.Visible
	if dropdownFrame.Visible then
		dropdownFrame.Size = UDim2.new(1,-20,0,135)
		aimbotButton.Position = UDim2.new(0,10,0,dropdownFrame.Position.Y.Offset + dropdownFrame.Size.Y.Offset + 10)
	else
		dropdownFrame.Size = UDim2.new(1,-20,0,0)
		aimbotButton.Position = UDim2.new(0,10,0,70)
	end
	updateESP()
end)

-- Multi-team hitbox buttons
for i, teamName in ipairs({"Criminals","Guards","Inmates"}) do
	local option = Instance.new("TextButton")
	option.Size = UDim2.new(1,-10,0,40)
	option.Position = UDim2.new(0,5,0,(i-1)*45)
	option.BackgroundColor3 = Color3.fromRGB(70,70,70)
	option.TextColor3 = Color3.new(1,1,1)
	option.Font = Enum.Font.GothamBold
	option.TextScaled = true
	option.Text = teamName
	option.Parent = dropdownFrame

	option.MouseButton1Click:Connect(function()
		if selectedTeams[teamName] then
			selectedTeams[teamName] = nil
			option.BackgroundColor3 = Color3.fromRGB(70,70,70)
		else
			selectedTeams[teamName] = true
			option.BackgroundColor3 = Color3.fromRGB(0,255,0)
		end
		updateESP()
	end)
end

-- === AIMBOT DROPDOWN ===
local aimbotDropdown = Instance.new("Frame")
aimbotDropdown.Size = UDim2.new(1,-20,0,0)
aimbotDropdown.Position = UDim2.new(0,10,0,aimbotButton.Position.Y.Offset + 55)
aimbotDropdown.BackgroundColor3 = Color3.fromRGB(50,50,50)
aimbotDropdown.Visible = false
aimbotDropdown.Parent = tabFrames["HITBOX and ESP"]

local aimbotTargetTeam = nil

for i, teamName in ipairs({"Criminals","Guards","Inmates"}) do
	local option = Instance.new("TextButton")
	option.Size = UDim2.new(1,-10,0,40)
	option.Position = UDim2.new(0,5,0,(i-1)*45)
	option.BackgroundColor3 = Color3.fromRGB(70,70,70)
	option.TextColor3 = Color3.new(1,1,1)
	option.Font = Enum.Font.GothamBold
	option.TextScaled = true
	option.Text = teamName
	option.Parent = aimbotDropdown

	option.MouseButton1Click:Connect(function()
		aimbotTargetTeam = teamName
		for _, child in ipairs(aimbotDropdown:GetChildren()) do
			if child:IsA("TextButton") then
				child.BackgroundColor3 = (child.Text == teamName) and Color3.fromRGB(0,255,0) or Color3.fromRGB(70,70,70)
			end
		end
	end)
end

-- AIMBOT BUTTON opens dropdown only
aimbotButton.MouseButton1Click:Connect(function()
	aimbotDropdown.Visible = not aimbotDropdown.Visible
	if aimbotDropdown.Visible then
		aimbotDropdown.Size = UDim2.new(1,-20,0,135)
	else
		aimbotDropdown.Size = UDim2.new(1,-20,0,0)
	end
	aimbotDropdown.Position = UDim2.new(0,10,0,aimbotButton.Position.Y.Offset + 55)
end)

-- === RunService loop ===
RunService.RenderStepped:Connect(function()
	updateESP()
	if aimbotTargetTeam then
		local nearest = nil
		local shortestDist = math.huge
		for _, plr in pairs(Players:GetPlayers()) do
			if plr ~= player and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") and plr.Team and plr.Team.Name == aimbotTargetTeam then
				local hrp = plr.Character.HumanoidRootPart
				local screenPos, onScreen = camera:WorldToViewportPoint(hrp.Position)
				if onScreen then
					local center = Vector2.new(camera.ViewportSize.X/2, camera.ViewportSize.Y/2)
					local dist = (Vector2.new(screenPos.X,screenPos.Y)-center).Magnitude
					if dist < shortestDist then
						shortestDist = dist
						nearest = hrp
					end
				end
			end
		end
		if nearest then
			camera.CFrame = CFrame.new(camera.CFrame.Position, nearest.Position)
		end
	end
end)
