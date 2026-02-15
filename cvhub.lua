--==================================================
-- CV HUB v2.6.1 FINAL
-- Bright UI + Scroll + Roll Menu
-- ORIGINAL SMART PUSH + ANTI TOUCH LOGIC (FIXED)
--==================================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local lp = Players.LocalPlayer

--================= SETTINGS =================
local PUSH_RANGE = 10
local SAFE_DISTANCE = 7

local PUSH_DISTANCE = 8
local PUSH_COOLDOWN = 0.08
local STEP_BACK = 0.9

local pushOn = false
local antiOn = false
local invisOn = false
local lastPush = 0

--================= VISUAL BUBBLES =================
local function makeBubble(color, transparency)
	local p = Instance.new("Part")
	p.Shape = Enum.PartType.Ball
	p.Anchored = true
	p.CanCollide = false
	p.Material = Enum.Material.ForceField
	p.Color = color
	p.Transparency = transparency
	p.CastShadow = false
	p.Parent = workspace
	return p
end

local pushBubble = makeBubble(Color3.fromRGB(0,170,255), 0.6)
local antiBubble = makeBubble(Color3.fromRGB(0,255,120), 0.7)

--================= GUI =================
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.ResetOnSpawn = false

local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0,320,0,440)
main.Position = UDim2.new(0,20,0.5,-220)
main.BackgroundColor3 = Color3.fromRGB(32,32,40)
main.Active = true
main.Draggable = true
Instance.new("UICorner", main).CornerRadius = UDim.new(0,18)

--================= TOP BAR =================
local top = Instance.new("Frame", main)
top.Size = UDim2.new(1,0,0,46)
top.BackgroundColor3 = Color3.fromRGB(150,90,255)
Instance.new("UICorner", top).CornerRadius = UDim.new(0,18)

local title = Instance.new("TextLabel", top)
title.Size = UDim2.new(1,-60,1,0)
title.Position = UDim2.new(0,14,0,0)
title.Text = "⚡ CV HUB v2.6"
title.Font = Enum.Font.GothamBold
title.TextSize = 15
title.TextColor3 = Color3.new(1,1,1)
title.BackgroundTransparency = 1
title.TextXAlignment = Enum.TextXAlignment.Left

local collapse = Instance.new("TextButton", top)
collapse.Size = UDim2.new(0,34,0,34)
collapse.Position = UDim2.new(1,-40,0.5,-17)
collapse.Text = "🔽"
collapse.Font = Enum.Font.GothamBold
collapse.TextSize = 16
collapse.TextColor3 = Color3.new(1,1,1)
collapse.BackgroundColor3 = Color3.fromRGB(110,70,200)
Instance.new("UICorner", collapse)

--================= SCROLL BODY =================
local scroll = Instance.new("ScrollingFrame", main)
scroll.Position = UDim2.new(0,0,0,46)
scroll.Size = UDim2.new(1,0,1,-46)
scroll.CanvasSize = UDim2.new(0,0,0,520)
scroll.ScrollBarThickness = 6
scroll.ScrollBarImageTransparency = 0.3
scroll.BackgroundTransparency = 1

--================= UI HELPERS =================
local function label(text,y)
	local l = Instance.new("TextLabel", scroll)
	l.Size = UDim2.new(1,-20,0,22)
	l.Position = UDim2.new(0,10,0,y)
	l.Text = text
	l.Font = Enum.Font.GothamBold
	l.TextSize = 13
	l.TextColor3 = Color3.fromRGB(240,240,255)
	l.BackgroundTransparency = 1
	l.TextXAlignment = Enum.TextXAlignment.Left
end

local function plusMinus(y,plus,minus)
	local f = Instance.new("Frame", scroll)
	f.Size = UDim2.new(1,-20,0,40)
	f.Position = UDim2.new(0,10,0,y)
	f.BackgroundColor3 = Color3.fromRGB(55,55,70)
	Instance.new("UICorner", f)

	local function btn(x,text)
		local b = Instance.new("TextButton", f)
		b.Size = UDim2.new(0.5,-6,1,-6)
		b.Position = UDim2.new(x,4,0,3)
		b.Text = text
		b.Font = Enum.Font.GothamBold
		b.TextSize = 18
		b.TextColor3 = Color3.new(1,1,1)
		b.BackgroundColor3 = Color3.fromRGB(90,90,120)
		Instance.new("UICorner", b)
		return b
	end

	btn(0,"➕").MouseButton1Click:Connect(plus)
	btn(0.5,"➖").MouseButton1Click:Connect(minus)
end

local function toggle(y,text,offColor,onColor,callback)
	local b = Instance.new("TextButton", scroll)
	b.Size = UDim2.new(1,-20,0,48)
	b.Position = UDim2.new(0,10,0,y)
	b.Text = text.." ❌"
	b.Font = Enum.Font.GothamBold
	b.TextSize = 15
	b.TextColor3 = Color3.new(1,1,1)
	b.BackgroundColor3 = offColor
	Instance.new("UICorner", b)

	return b,function(state)
		b.Text = text.." "..(state and "✅" or "❌")
		TweenService:Create(
			b,
			TweenInfo.new(0.2,Enum.EasingStyle.Quad),
			{BackgroundColor3 = state and onColor or offColor}
		):Play()
		callback(state)
	end
end

--================= UI CONTENT =================
label("📏 Push Range",10)
plusMinus(34,function() PUSH_RANGE+=2 end,function() PUSH_RANGE=math.max(4,PUSH_RANGE-2) end)

label("🛡 Anti Touch Range",88)
plusMinus(112,function() SAFE_DISTANCE+=1 end,function() SAFE_DISTANCE=math.max(4,SAFE_DISTANCE-1) end)

local pushBtn,setPush = toggle(
	170,"💥 PUSH",
	Color3.fromRGB(70,130,255),
	Color3.fromRGB(90,170,255),
	function(v) pushOn=v end
)

local antiBtn,setAnti = toggle(
	230,"🛡 ANTI TOUCH",
	Color3.fromRGB(80,200,120),
	Color3.fromRGB(100,230,150),
	function(v) antiOn=v end
)

local invisBtn,setInvis = toggle(
	290,"👻 INVISIBLE",
	Color3.fromRGB(140,140,140),
	Color3.fromRGB(190,190,190),
	function(v)
		invisOn=v
		local c=lp.Character
		if c then
			for _,p in ipairs(c:GetDescendants()) do
				if p:IsA("BasePart") then
					p.Transparency=v and 1 or 0
				end
			end
		end
	end
)

pushBtn.MouseButton1Click:Connect(function() setPush(not pushOn) end)
antiBtn.MouseButton1Click:Connect(function() setAnti(not antiOn) end)
invisBtn.MouseButton1Click:Connect(function() setInvis(not invisOn) end)

--================= ROLL MENU =================
local closed=false
collapse.MouseButton1Click:Connect(function()
	closed=not closed
	collapse.Text = closed and "🔼" or "🔽"
	TweenService:Create(
		main,
		TweenInfo.new(0.3,Enum.EasingStyle.Quint),
		{Size = closed and UDim2.new(0,320,0,46) or UDim2.new(0,320,0,440)}
	):Play()
	scroll.Visible = not closed
end)

--================= CORE LOGIC (ORIGINAL) =================
RunService.Heartbeat:Connect(function()
	local char = lp.Character
	local hrp = char and char:FindFirstChild("HumanoidRootPart")
	if not hrp then return end

	pushBubble.Size = Vector3.new(PUSH_RANGE*2, PUSH_RANGE*2, PUSH_RANGE*2)
	pushBubble.CFrame = pushOn and hrp.CFrame or CFrame.new(0,-1000,0)

	antiBubble.Size = Vector3.new(SAFE_DISTANCE*2, SAFE_DISTANCE*2, SAFE_DISTANCE*2)
	antiBubble.CFrame = antiOn and hrp.CFrame or CFrame.new(0,-1000,0)

	if pushOn and tick() - lastPush > PUSH_COOLDOWN then
		for _,plr in ipairs(Players:GetPlayers()) do
			if plr ~= lp and plr.Character then
				local ehrp = plr.Character:FindFirstChild("HumanoidRootPart")
				if ehrp and (ehrp.Position - hrp.Position).Magnitude <= PUSH_RANGE then
					lastPush = tick()
					hrp.CFrame += (hrp.Position - ehrp.Position).Unit * PUSH_DISTANCE
					break
				end
			end
		end
	end

	if antiOn then
		for _,plr in ipairs(Players:GetPlayers()) do
			if plr ~= lp and plr.Character then
				local ehrp = plr.Character:FindFirstChild("HumanoidRootPart")
				if ehrp and (ehrp.Position - hrp.Position).Magnitude < SAFE_DISTANCE then
					hrp.CFrame += (hrp.Position - ehrp.Position).Unit * STEP_BACK
				end
			end
		end
	end
end)
