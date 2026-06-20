--[[
	AdminPanelGui.lua  (FILE 2 dari 2 — GUI / Client)
	Lokasi: StarterGui > AdminPanelGui (LocalScript)

	Cara pasang:
	1. Buat LocalScript baru di StarterGui, kasih nama "AdminPanelGui"
	2. Copy semua isi file ini ke dalamnya
	3. GUI dibuat 100% lewat kode, tidak perlu rakit manual
	4. Pastikan FILE 1 (AdminServer.lua) sudah dipasang di ServerScriptService dulu

	FITUR GUI:
	- Tombol palu mengambang (toggle buka/tutup panel) - hanya muncul untuk admin
	- Panel admin dengan tab: Players, Moderasi, Chat Server, Chat Global, Tools
	- Brick icon dekoratif di header (sesuai request "ada brick brick nya")
	- Badge centang biru otomatis di nama admin pada chat
	- Tombol minimize (panel mengecil jadi bar kecil, klik lagi untuk buka)
	- Efek shimmer (kilau bergerak) di header panel
	- Search/filter player, ban/kick by username manual (tidak harus online untuk ban)
]]

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local Remotes = ReplicatedStorage:WaitForChild("AdminRemotes")
local CommandRemote = Remotes:WaitForChild("CommandRemote")
local ChatRemote = Remotes:WaitForChild("ChatRemote")
local GlobalChatRemote = Remotes:WaitForChild("GlobalChatRemote")
local ChatUpdateRemote = Remotes:WaitForChild("ChatUpdateRemote")
local NotifyRemote = Remotes:WaitForChild("NotifyRemote")
local PanelInitRemote = Remotes:WaitForChild("PanelInitRemote")

-- Dulu di sini ada require(AdminConfig), sekarang AdminConfig digabung ke
-- dalam Script server (bukan ModuleScript terpisah lagi), jadi client
-- cukup terima daftar admin dari server lewat PanelInitRemote di bawah.
local AdminUsernamesLower = {}

-- =========================================================
-- COLOR PALETTE (tema gelap modern)
-- =========================================================
local COL_BG        = Color3.fromRGB(24, 26, 32)
local COL_BG2       = Color3.fromRGB(31, 34, 41)
local COL_BG3       = Color3.fromRGB(40, 44, 53)
local COL_ACCENT    = Color3.fromRGB(88, 142, 255)
local COL_ACCENT_2  = Color3.fromRGB(255, 90, 90)
local COL_TEXT      = Color3.fromRGB(235, 237, 240)
local COL_SUBTEXT   = Color3.fromRGB(150, 155, 165)
local COL_GREEN     = Color3.fromRGB(110, 220, 140)
local COL_GLOBAL    = Color3.fromRGB(190, 130, 255)

local VERIFIED_BADGE = "✔"

-- =========================================================
-- STATE
-- =========================================================
local myRank = nil
local isAdmin = false
local isMinimized = false
local localHistory = {}
local globalHistory = {}
local currentChatTab = "local" -- "local" atau "global"

-- =========================================================
-- ROOT GUI
-- =========================================================
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AdminPanelGui"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.DisplayOrder = 50
screenGui.Parent = PlayerGui

-- util corner
local function corner(parent, radius)
	local c = Instance.new("UICorner")
	c.CornerRadius = UDim.new(0, radius or 10)
	c.Parent = parent
	return c
end

local function stroke(parent, color, thickness)
	local s = Instance.new("UIStroke")
	s.Color = color or Color3.fromRGB(60, 64, 74)
	s.Thickness = thickness or 1
	s.Parent = parent
	return s
end

local function padding(parent, all)
	local p = Instance.new("UIPadding")
	p.PaddingTop = UDim.new(0, all)
	p.PaddingBottom = UDim.new(0, all)
	p.PaddingLeft = UDim.new(0, all)
	p.PaddingRight = UDim.new(0, all)
	p.Parent = parent
	return p
end

-- =========================================================
-- ICON DRAWER (semua icon dibuat manual pakai Frame/UIGradient, bukan gambar external,
-- supaya langsung jalan tanpa perlu upload asset)
-- =========================================================

-- ICON PALU (hammer) - dipakai sebagai tombol toggle utama
local function createHammerIcon(parentBtn)
	local container = Instance.new("Frame")
	container.Name = "HammerIcon"
	container.Size = UDim2.fromScale(1, 1)
	container.BackgroundTransparency = 1
	container.Parent = parentBtn

	-- gagang palu
	local handle = Instance.new("Frame")
	handle.Size = UDim2.fromOffset(8, 26)
	handle.AnchorPoint = Vector2.new(0.5, 1)
	handle.Position = UDim2.fromScale(0.5, 0.82)
	handle.Rotation = 45
	handle.BackgroundColor3 = Color3.fromRGB(150, 105, 65)
	handle.BorderSizePixel = 0
	handle.Parent = container
	corner(handle, 3)

	-- kepala palu
	local head = Instance.new("Frame")
	head.Size = UDim2.fromOffset(26, 16)
	head.AnchorPoint = Vector2.new(0.5, 0.5)
	head.Position = UDim2.fromScale(0.40, 0.30)
	head.Rotation = 45
	head.BackgroundColor3 = Color3.fromRGB(200, 205, 212)
	head.BorderSizePixel = 0
	head.Parent = container
	corner(head, 4)
	stroke(head, Color3.fromRGB(140, 145, 155), 1)

	return container
end

-- ICON BRICK (kotak bata kecil bertumpuk) - dekorasi sesuai request "brick brick nya"
local function createBrickIcon(parentFrame, sizeOffset, col1, col2)
	sizeOffset = sizeOffset or 18
	col1 = col1 or Color3.fromRGB(200, 90, 70)
	col2 = col2 or Color3.fromRGB(170, 75, 58)

	local holder = Instance.new("Frame")
	holder.Name = "BrickIcon"
	holder.BackgroundTransparency = 1
	holder.Size = UDim2.fromOffset(sizeOffset * 2 + 4, sizeOffset + 6)
	holder.Parent = parentFrame

	local brick1 = Instance.new("Frame")
	brick1.Size = UDim2.fromOffset(sizeOffset, sizeOffset * 0.6)
	brick1.Position = UDim2.fromOffset(0, sizeOffset * 0.4)
	brick1.BackgroundColor3 = col1
	brick1.BorderSizePixel = 0
	brick1.Parent = holder
	corner(brick1, 3)
	stroke(brick1, Color3.fromRGB(0,0,0), 1)

	local brick2 = Instance.new("Frame")
	brick2.Size = UDim2.fromOffset(sizeOffset, sizeOffset * 0.6)
	brick2.Position = UDim2.fromOffset(sizeOffset * 0.7, 0)
	brick2.BackgroundColor3 = col2
	brick2.BorderSizePixel = 0
	brick2.Parent = holder
	corner(brick2, 3)
	stroke(brick2, Color3.fromRGB(0,0,0), 1)

	return holder
end

-- BADGE CENTANG BIRU (verified checkmark)
local function createVerifiedBadge(parent, size)
	size = size or 16
	local badge = Instance.new("Frame")
	badge.Name = "VerifiedBadge"
	badge.Size = UDim2.fromOffset(size, size)
	badge.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
	badge.BorderSizePixel = 0
	badge.Parent = parent
	corner(badge, size) -- bulat penuh

	local grad = Instance.new("UIGradient")
	grad.Color = ColorSequence.new(Color3.fromRGB(70, 170, 255), Color3.fromRGB(0, 120, 230))
	grad.Rotation = 90
	grad.Parent = badge

	local check = Instance.new("TextLabel")
	check.Size = UDim2.fromScale(1, 1)
	check.BackgroundTransparency = 1
	check.Text = "✓"
	check.TextColor3 = Color3.fromRGB(255, 255, 255)
	check.Font = Enum.Font.GothamBold
	check.TextScaled = true
	check.Parent = badge
	local cp = Instance.new("UIPadding")
	cp.PaddingTop = UDim.new(0, 2)
	cp.PaddingBottom = UDim.new(0, 2)
	cp.PaddingLeft = UDim.new(0, 2)
	cp.PaddingRight = UDim.new(0, 2)
	cp.Parent = check

	return badge
end

-- =========================================================
-- SHIMMER EFFECT (kilau bergerak melintasi header panel)
-- =========================================================
local function applyShimmer(targetFrame)
	local shimmer = Instance.new("Frame")
	shimmer.Name = "Shimmer"
	shimmer.Size = UDim2.new(0.4, 0, 1, 0)
	shimmer.Position = UDim2.new(-0.5, 0, 0, 0)
	shimmer.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	shimmer.BorderSizePixel = 0
	shimmer.ZIndex = targetFrame.ZIndex + 5
	shimmer.Parent = targetFrame

	local grad = Instance.new("UIGradient")
	grad.Transparency = NumberSequence.new({
		NumberSequenceKeypoint.new(0, 1),
		NumberSequenceKeypoint.new(0.5, 0.55),
		NumberSequenceKeypoint.new(1, 1),
	})
	grad.Parent = shimmer

	local clip = Instance.new("UICorner")
	clip.CornerRadius = UDim.new(0, 14)
	-- shimmer butuh masking; pakai parent ClipsDescendants
	targetFrame.ClipsDescendants = true

	task.spawn(function()
		while shimmer.Parent do
			shimmer.Position = UDim2.new(-0.5, 0, 0, 0)
			local tween = TweenService:Create(shimmer, TweenInfo.new(2.2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
				Position = UDim2.new(1.1, 0, 0, 0)
			})
			tween:Play()
			tween.Completed:Wait()
			task.wait(1.4)
		end
	end)
end

-- =========================================================
-- TOMBOL TOGGLE PALU (mengambang, drag-able)
-- =========================================================
local toggleBtn = Instance.new("TextButton")
toggleBtn.Name = "ToggleButton"
toggleBtn.Size = UDim2.fromOffset(54, 54)
toggleBtn.Position = UDim2.new(0, 20, 0.5, -27)
toggleBtn.BackgroundColor3 = COL_BG3
toggleBtn.AutoButtonColor = false
toggleBtn.Text = ""
toggleBtn.Visible = false -- baru muncul kalau admin
toggleBtn.ZIndex = 100
toggleBtn.Parent = screenGui
corner(toggleBtn, 27)
stroke(toggleBtn, COL_ACCENT, 2)
createHammerIcon(toggleBtn)

-- drag logic untuk tombol palu
do
	local dragging, dragStart, startPos
	toggleBtn.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			dragStart = input.Position
			startPos = toggleBtn.Position
		end
	end)
	toggleBtn.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = false
		end
	end)
	game:GetService("UserInputService").InputChanged:Connect(function(input)
		if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			local delta = input.Position - dragStart
			toggleBtn.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
		end
	end)
end

-- =========================================================
-- MAIN PANEL
-- =========================================================
local mainPanel = Instance.new("Frame")
mainPanel.Name = "MainPanel"
mainPanel.Size = UDim2.fromOffset(560, 420)
mainPanel.Position = UDim2.new(0.5, -280, 0.5, -210)
mainPanel.BackgroundColor3 = COL_BG
mainPanel.Visible = false
mainPanel.ZIndex = 50
mainPanel.Parent = screenGui
corner(mainPanel, 14)
stroke(mainPanel, Color3.fromRGB(55, 59, 70), 1)

-- shadow halus
local shadow = Instance.new("ImageLabel")
shadow.Name = "Shadow"
shadow.BackgroundTransparency = 1
shadow.Image = "rbxassetid://1316045217"
shadow.ImageColor3 = Color3.new(0,0,0)
shadow.ImageTransparency = 0.5
shadow.ScaleType = Enum.ScaleType.Slice
shadow.SliceCenter = Rect.new(10,10,118,118)
shadow.Size = UDim2.new(1, 60, 1, 60)
shadow.Position = UDim2.new(0, -30, 0, -20)
shadow.ZIndex = 49
shadow.Parent = mainPanel

-- ===== HEADER =====
local header = Instance.new("Frame")
header.Name = "Header"
header.Size = UDim2.new(1, 0, 0, 50)
header.BackgroundColor3 = COL_BG2
header.ZIndex = 51
header.Parent = mainPanel
corner(header, 14)
-- tutup corner bawah header biar nyatu sama body
local headerFix = Instance.new("Frame")
headerFix.Size = UDim2.new(1, 0, 0, 14)
headerFix.Position = UDim2.new(0, 0, 1, -14)
headerFix.BackgroundColor3 = COL_BG2
headerFix.BorderSizePixel = 0
headerFix.ZIndex = 51
headerFix.Parent = header

applyShimmer(header)

local headerBrick = createBrickIcon(header, 14, Color3.fromRGB(200, 90, 70), Color3.fromRGB(170, 75, 58))
headerBrick.Position = UDim2.fromOffset(14, 8)
headerBrick.ZIndex = 53

local headerHammer = Instance.new("Frame")
headerHammer.Size = UDim2.fromOffset(26, 26)
headerHammer.Position = UDim2.fromOffset(46, 12)
headerHammer.BackgroundTransparency = 1
headerHammer.ZIndex = 53
headerHammer.Parent = header
createHammerIcon(headerHammer)

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.fromOffset(250, 30)
titleLabel.Position = UDim2.fromOffset(82, 10)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "Studio Lite — Admin Panel"
titleLabel.TextColor3 = COL_TEXT
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextSize = 17
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.ZIndex = 53
titleLabel.Parent = header

-- badge centang biru di header, menandakan panel ini milik akun admin terverifikasi
local headerBadge = createVerifiedBadge(header, 16)
headerBadge.Position = UDim2.fromOffset(252, 18)
headerBadge.ZIndex = 53

-- tombol minimize
local minimizeBtn = Instance.new("TextButton")
minimizeBtn.Size = UDim2.fromOffset(30, 30)
minimizeBtn.Position = UDim2.new(1, -86, 0, 10)
minimizeBtn.BackgroundColor3 = COL_BG3
minimizeBtn.Text = "—"
minimizeBtn.TextColor3 = COL_TEXT
minimizeBtn.Font = Enum.Font.GothamBold
minimizeBtn.TextSize = 18
minimizeBtn.AutoButtonColor = false
minimizeBtn.ZIndex = 53
minimizeBtn.Parent = header
corner(minimizeBtn, 8)

-- tombol close
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.fromOffset(30, 30)
closeBtn.Position = UDim2.new(1, -46, 0, 10)
closeBtn.BackgroundColor3 = Color3.fromRGB(60, 30, 33)
closeBtn.Text = "✕"
closeBtn.TextColor3 = Color3.fromRGB(255, 130, 130)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 16
closeBtn.AutoButtonColor = false
closeBtn.ZIndex = 53
closeBtn.Parent = header
corner(closeBtn, 8)

-- ===== BODY (tab container) =====
local body = Instance.new("Frame")
body.Name = "Body"
body.Size = UDim2.new(1, 0, 1, -50)
body.Position = UDim2.fromOffset(0, 50)
body.BackgroundTransparency = 1
body.ZIndex = 51
body.Parent = mainPanel

-- tab bar kiri
local tabBar = Instance.new("Frame")
tabBar.Size = UDim2.new(0, 120, 1, 0)
tabBar.BackgroundColor3 = COL_BG2
tabBar.ZIndex = 51
tabBar.Parent = body

local tabList = Instance.new("UIListLayout")
tabList.Padding = UDim.new(0, 4)
tabList.Parent = tabBar
padding(tabBar, 8)

local tabNames = {"Players", "Moderasi", "Chat Server", "Chat Global", "Tools"}
local tabButtons = {}
local tabContents = {}

local contentArea = Instance.new("Frame")
contentArea.Size = UDim2.new(1, -120, 1, 0)
contentArea.Position = UDim2.fromOffset(120, 0)
contentArea.BackgroundTransparency = 1
contentArea.ZIndex = 51
contentArea.Parent = body
padding(contentArea, 12)

local function makeTabButton(name)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(1, 0, 0, 36)
	btn.BackgroundColor3 = COL_BG3
	btn.Text = name
	btn.TextColor3 = COL_SUBTEXT
	btn.Font = Enum.Font.GothamMedium
	btn.TextSize = 13
	btn.AutoButtonColor = false
	btn.ZIndex = 52
	btn.Parent = tabBar
	corner(btn, 8)
	return btn
end

local function setActiveTab(name)
	for n, btn in pairs(tabButtons) do
		if n == name then
			btn.BackgroundColor3 = COL_ACCENT
			btn.TextColor3 = Color3.new(1,1,1)
		else
			btn.BackgroundColor3 = COL_BG3
			btn.TextColor3 = COL_SUBTEXT
		end
	end
	for n, frame in pairs(tabContents) do
		frame.Visible = (n == name)
	end
end

for _, name in ipairs(tabNames) do
	local btn = makeTabButton(name)
	tabButtons[name] = btn

	local contentFrame = Instance.new("Frame")
	contentFrame.Size = UDim2.fromScale(1, 1)
	contentFrame.BackgroundTransparency = 1
	contentFrame.Visible = false
	contentFrame.ZIndex = 51
	contentFrame.Parent = contentArea
	tabContents[name] = contentFrame

	btn.MouseButton1Click:Connect(function()
		setActiveTab(name)
	end)
end

-- =========================================================
-- TAB: PLAYERS (list player online di server, klik untuk auto-isi username)
-- =========================================================
local playersTab = tabContents["Players"]

local playerSearchLabel = Instance.new("TextLabel")
playerSearchLabel.Size = UDim2.new(1, 0, 0, 20)
playerSearchLabel.BackgroundTransparency = 1
playerSearchLabel.Text = "Player online di server ini:"
playerSearchLabel.TextColor3 = COL_SUBTEXT
playerSearchLabel.Font = Enum.Font.Gotham
playerSearchLabel.TextSize = 12
playerSearchLabel.TextXAlignment = Enum.TextXAlignment.Left
playerSearchLabel.ZIndex = 52
playerSearchLabel.Parent = playersTab

local playerListScroll = Instance.new("ScrollingFrame")
playerListScroll.Size = UDim2.new(1, 0, 1, -28)
playerListScroll.Position = UDim2.fromOffset(0, 28)
playerListScroll.BackgroundColor3 = COL_BG2
playerListScroll.ScrollBarThickness = 4
playerListScroll.CanvasSize = UDim2.new(0,0,0,0)
playerListScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
playerListScroll.ZIndex = 52
playerListScroll.Parent = playersTab
corner(playerListScroll, 8)

local playerListLayout = Instance.new("UIListLayout")
playerListLayout.Padding = UDim.new(0, 4)
playerListLayout.Parent = playerListScroll
padding(playerListScroll, 8)

-- akan diisi di refreshPlayerList()

-- =========================================================
-- TAB: MODERASI (kick/ban/tempban/unban/mute by username manual)
-- =========================================================
local modTab = tabContents["Moderasi"]

local function makeInputRow(parent, labelText, placeholder, yPos)
	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(1, 0, 0, 16)
	label.Position = UDim2.fromOffset(0, yPos)
	label.BackgroundTransparency = 1
	label.Text = labelText
	label.TextColor3 = COL_SUBTEXT
	label.Font = Enum.Font.Gotham
	label.TextSize = 11
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.ZIndex = 52
	label.Parent = parent

	local box = Instance.new("TextBox")
	box.Size = UDim2.new(1, 0, 0, 32)
	box.Position = UDim2.fromOffset(0, yPos + 18)
	box.BackgroundColor3 = COL_BG2
	box.Text = ""
	box.PlaceholderText = placeholder
	box.PlaceholderColor3 = Color3.fromRGB(110,114,124)
	box.TextColor3 = COL_TEXT
	box.Font = Enum.Font.Gotham
	box.TextSize = 13
	box.ClearTextOnFocus = false
	box.ZIndex = 52
	box.Parent = parent
	corner(box, 8)
	padding(box, 8)

	return box
end

local usernameBox = makeInputRow(modTab, "Username Target", "Masukkan username (bukan display name)...", 0)
local reasonBox = makeInputRow(modTab, "Alasan (opsional)", "Contoh: cheating, spam, toxic...", 58)

local modButtonsFrame = Instance.new("Frame")
modButtonsFrame.Size = UDim2.new(1, 0, 0, 140)
modButtonsFrame.Position = UDim2.fromOffset(0, 122)
modButtonsFrame.BackgroundTransparency = 1
modButtonsFrame.ZIndex = 52
modButtonsFrame.Parent = modTab

local modGrid = Instance.new("UIGridLayout")
modGrid.CellSize = UDim2.new(0.32, 0, 0, 34)
modGrid.CellPadding = UDim2.fromOffset(6, 6)
modGrid.Parent = modButtonsFrame

local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(1, 0, 0, 40)
statusLabel.Position = UDim2.fromOffset(0, 270)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = ""
statusLabel.TextColor3 = COL_GREEN
statusLabel.Font = Enum.Font.GothamMedium
statusLabel.TextSize = 12
statusLabel.TextWrapped = true
statusLabel.TextXAlignment = Enum.TextXAlignment.Left
statusLabel.TextYAlignment = Enum.TextYAlignment.Top
statusLabel.ZIndex = 52
statusLabel.Parent = modTab

local function showStatus(msg)
	statusLabel.Text = msg
end

local function sendCommand(action)
	local uname = usernameBox.Text
	local reason = reasonBox.Text
	if uname == "" then
		showStatus("❌ Isi username target dulu.")
		return
	end
	CommandRemote:FireServer(action, uname, reason)
end

local modActionsList = {
	{"Kick", COL_ACCENT_2},
	{"TempBan", Color3.fromRGB(230, 160, 60)},
	{"Ban", Color3.fromRGB(190, 50, 50)},
	{"Unban", COL_GREEN},
	{"Mute", Color3.fromRGB(150, 150, 160)},
	{"Unmute", Color3.fromRGB(100, 200, 200)},
}

for _, data in ipairs(modActionsList) do
	local actionName, color = data[1], data[2]
	local btn = Instance.new("TextButton")
	btn.BackgroundColor3 = COL_BG3
	btn.Text = actionName
	btn.TextColor3 = color
	btn.Font = Enum.Font.GothamBold
	btn.TextSize = 12
	btn.AutoButtonColor = false
	btn.ZIndex = 52
	btn.Parent = modButtonsFrame
	corner(btn, 8)
	stroke(btn, color, 1)

	btn.MouseButton1Click:Connect(function()
		sendCommand(actionName)
	end)
end

-- =========================================================
-- TAB: CHAT SERVER (chat local) & TAB: CHAT GLOBAL
-- Dibuat fungsi generic biar reusable
-- =========================================================
local function buildChatTab(parentTab, isGlobal)
	local chatScroll = Instance.new("ScrollingFrame")
	chatScroll.Size = UDim2.new(1, 0, 1, -44)
	chatScroll.BackgroundColor3 = COL_BG2
	chatScroll.ScrollBarThickness = 4
	chatScroll.CanvasSize = UDim2.new(0,0,0,0)
	chatScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
	chatScroll.ZIndex = 52
	chatScroll.Parent = parentTab
	corner(chatScroll, 8)

	local chatLayout = Instance.new("UIListLayout")
	chatLayout.Padding = UDim.new(0, 3)
	chatLayout.Parent = chatScroll
	padding(chatScroll, 8)

	local inputRow = Instance.new("Frame")
	inputRow.Size = UDim2.new(1, 0, 0, 36)
	inputRow.Position = UDim2.new(0, 0, 1, -36)
	inputRow.BackgroundTransparency = 1
	inputRow.ZIndex = 52
	inputRow.Parent = parentTab

	local chatBox = Instance.new("TextBox")
	chatBox.Size = UDim2.new(1, -70, 1, 0)
	chatBox.BackgroundColor3 = COL_BG2
	chatBox.Text = ""
	chatBox.PlaceholderText = isGlobal and "Ketik pesan ke SEMUA server..." or "Ketik pesan ke server ini..."
	chatBox.PlaceholderColor3 = Color3.fromRGB(110,114,124)
	chatBox.TextColor3 = COL_TEXT
	chatBox.Font = Enum.Font.Gotham
	chatBox.TextSize = 13
	chatBox.ClearTextOnFocus = false
	chatBox.ZIndex = 52
	chatBox.Parent = inputRow
	corner(chatBox, 8)
	padding(chatBox, 8)

	local sendBtn = Instance.new("TextButton")
	sendBtn.Size = UDim2.fromOffset(60, 36)
	sendBtn.Position = UDim2.new(1, -60, 0, 0)
	sendBtn.BackgroundColor3 = isGlobal and COL_GLOBAL or COL_ACCENT
	sendBtn.Text = "Kirim"
	sendBtn.TextColor3 = Color3.new(1,1,1)
	sendBtn.Font = Enum.Font.GothamBold
	sendBtn.TextSize = 12
	sendBtn.AutoButtonColor = false
	sendBtn.ZIndex = 52
	sendBtn.Parent = inputRow
	corner(sendBtn, 8)

	local function doSend()
		local msg = chatBox.Text
		if msg == "" then return end
		if isGlobal then
			GlobalChatRemote:FireServer(msg)
		else
			ChatRemote:FireServer(msg)
		end
		chatBox.Text = ""
	end

	sendBtn.MouseButton1Click:Connect(doSend)
	chatBox.FocusLost:Connect(function(enterPressed)
		if enterPressed then doSend() end
	end)

	return chatScroll
end

local localChatScroll = buildChatTab(tabContents["Chat Server"], false)
local globalChatScroll = buildChatTab(tabContents["Chat Global"], true)

local function addChatMessage(scrollFrame, entry, isGlobal)
	local row = Instance.new("Frame")
	row.Size = UDim2.new(1, 0, 0, 0)
	row.AutomaticSize = Enum.AutomaticSize.Y
	row.BackgroundTransparency = 1
	row.ZIndex = 52
	row.Parent = scrollFrame

	local nameColor = COL_TEXT
	if entry.color then
		nameColor = Color3.new(entry.color[1], entry.color[2], entry.color[3])
	elseif isGlobal then
		nameColor = COL_GLOBAL
	end

	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(1, 0, 0, 0)
	label.AutomaticSize = Enum.AutomaticSize.Y
	label.BackgroundTransparency = 1
	label.TextWrapped = true
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Font = Enum.Font.Gotham
	label.TextSize = 13
	label.TextColor3 = COL_TEXT
	label.RichText = true
	label.ZIndex = 52
	label.Parent = row

	local serverTag = isGlobal and "<font color=\"#be82ff\">[GLOBAL]</font> " or ""
	local nameHex = string.format("#%02X%02X%02X", nameColor.R*255, nameColor.G*255, nameColor.B*255)

	label.Text = serverTag .. "<font color=\"" .. nameHex .. "\"><b>" .. entry.name .. "</b></font>: " .. entry.message
end

local function refreshChatDisplay()
	for _, c in ipairs(localChatScroll:GetChildren()) do
		if c:IsA("Frame") then c:Destroy() end
	end
	for _, c in ipairs(globalChatScroll:GetChildren()) do
		if c:IsA("Frame") then c:Destroy() end
	end
	for _, entry in ipairs(localHistory) do
		addChatMessage(localChatScroll, entry, false)
	end
	for _, entry in ipairs(globalHistory) do
		addChatMessage(globalChatScroll, entry, true)
	end
end

-- =========================================================
-- TAB: TOOLS (teleport, kill, heal, freeze, speed, give brick, announce)
-- =========================================================
local toolsTab = tabContents["Tools"]

local toolsUsernameBox = makeInputRow(toolsTab, "Username Target", "Masukkan username target...", 0)
local toolsValueBox = makeInputRow(toolsTab, "Nilai (Speed / JumpPower / Pesan Announce)", "Contoh: 30  atau  Selamat datang!", 58)

local toolsButtonsFrame = Instance.new("Frame")
toolsButtonsFrame.Size = UDim2.new(1, 0, 0, 170)
toolsButtonsFrame.Position = UDim2.fromOffset(0, 122)
toolsButtonsFrame.BackgroundTransparency = 1
toolsButtonsFrame.ZIndex = 52
toolsButtonsFrame.Parent = toolsTab

local toolsGrid = Instance.new("UIGridLayout")
toolsGrid.CellSize = UDim2.new(0.32, 0, 0, 34)
toolsGrid.CellPadding = UDim2.fromOffset(6, 6)
toolsGrid.Parent = toolsButtonsFrame

local toolsStatusLabel = Instance.new("TextLabel")
toolsStatusLabel.Size = UDim2.new(1, 0, 0, 40)
toolsStatusLabel.Position = UDim2.fromOffset(0, 300)
toolsStatusLabel.BackgroundTransparency = 1
toolsStatusLabel.Text = ""
toolsStatusLabel.TextColor3 = COL_GREEN
toolsStatusLabel.Font = Enum.Font.GothamMedium
toolsStatusLabel.TextSize = 12
toolsStatusLabel.TextWrapped = true
toolsStatusLabel.TextXAlignment = Enum.TextXAlignment.Left
toolsStatusLabel.TextYAlignment = Enum.TextYAlignment.Top
toolsStatusLabel.ZIndex = 52
toolsStatusLabel.Parent = toolsTab

local toolsActionsList = {
	{"Teleport", COL_ACCENT},
	{"Kill", COL_ACCENT_2},
	{"Heal", COL_GREEN},
	{"Freeze", Color3.fromRGB(120, 200, 255)},
	{"Unfreeze", Color3.fromRGB(120, 200, 255)},
	{"GiveBrick", Color3.fromRGB(200, 130, 90)},
	{"Speed", Color3.fromRGB(230, 200, 70)},
	{"JumpPower", Color3.fromRGB(230, 200, 70)},
	{"Announce", COL_GLOBAL},
}

for _, data in ipairs(toolsActionsList) do
	local actionName, color = data[1], data[2]
	local btn = Instance.new("TextButton")
	btn.BackgroundColor3 = COL_BG3
	btn.Text = actionName
	btn.TextColor3 = color
	btn.Font = Enum.Font.GothamBold
	btn.TextSize = 11
	btn.AutoButtonColor = false
	btn.ZIndex = 52
	btn.Parent = toolsButtonsFrame
	corner(btn, 8)
	stroke(btn, color, 1)

	btn.MouseButton1Click:Connect(function()
		if actionName == "Announce" then
			CommandRemote:FireServer("Announce", nil, toolsValueBox.Text)
			toolsStatusLabel.Text = "✅ Pengumuman terkirim."
			return
		end
		local uname = toolsUsernameBox.Text
		if uname == "" then
			toolsStatusLabel.Text = "❌ Isi username target dulu."
			return
		end
		CommandRemote:FireServer(actionName, uname, toolsValueBox.Text)
		toolsStatusLabel.Text = "✅ Command '" .. actionName .. "' dikirim untuk " .. uname
	end)
end

-- =========================================================
-- REFRESH PLAYER LIST
-- =========================================================
local function refreshPlayerList()
	for _, c in ipairs(playerListScroll:GetChildren()) do
		if c:IsA("Frame") then c:Destroy() end
	end
	for _, plr in ipairs(Players:GetPlayers()) do
		local row = Instance.new("Frame")
		row.Size = UDim2.new(1, 0, 0, 34)
		row.BackgroundColor3 = COL_BG3
		row.ZIndex = 52
		row.Parent = playerListScroll
		corner(row, 6)

		local nameLbl = Instance.new("TextLabel")
		nameLbl.Size = UDim2.new(1, -90, 1, 0)
		nameLbl.Position = UDim2.fromOffset(10, 0)
		nameLbl.BackgroundTransparency = 1
		nameLbl.Text = plr.Name
		nameLbl.TextColor3 = COL_TEXT
		nameLbl.Font = Enum.Font.GothamMedium
		nameLbl.TextSize = 13
		nameLbl.TextXAlignment = Enum.TextXAlignment.Left
		nameLbl.ZIndex = 52
		nameLbl.Parent = row

		if AdminUsernamesLower[string.lower(plr.Name)] then
			local rowBadge = createVerifiedBadge(row, 14)
			rowBadge.Position = UDim2.new(1, -94, 0.5, -7)
			rowBadge.ZIndex = 52
		end

		local selectBtn = Instance.new("TextButton")
		selectBtn.Size = UDim2.fromOffset(60, 24)
		selectBtn.Position = UDim2.new(1, -66, 0.5, -12)
		selectBtn.BackgroundColor3 = COL_ACCENT
		selectBtn.Text = "Pilih"
		selectBtn.TextColor3 = Color3.new(1,1,1)
		selectBtn.Font = Enum.Font.GothamBold
		selectBtn.TextSize = 11
		selectBtn.AutoButtonColor = false
		selectBtn.ZIndex = 52
		selectBtn.Parent = row
		corner(selectBtn, 6)

		selectBtn.MouseButton1Click:Connect(function()
			usernameBox.Text = plr.Name
			toolsUsernameBox.Text = plr.Name
			setActiveTab("Moderasi")
		end)
	end
end

Players.PlayerAdded:Connect(refreshPlayerList)
Players.PlayerRemoving:Connect(function()
	task.wait(0.1)
	refreshPlayerList()
end)

-- =========================================================
-- TOGGLE / MINIMIZE LOGIC
-- =========================================================
local panelOpen = false

local function setPanelOpen(open)
	panelOpen = open
	mainPanel.Visible = open
	if open then
		mainPanel.Size = UDim2.fromOffset(560, 20)
		local tween = TweenService:Create(mainPanel, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
			Size = UDim2.fromOffset(560, 420)
		})
		tween:Play()
		refreshPlayerList()
		setActiveTab("Players")
	end
end

toggleBtn.MouseButton1Click:Connect(function()
	setPanelOpen(not panelOpen)
end)

closeBtn.MouseButton1Click:Connect(function()
	setPanelOpen(false)
end)

local fullHeight = 420
minimizeBtn.MouseButton1Click:Connect(function()
	isMinimized = not isMinimized
	if isMinimized then
		TweenService:Create(mainPanel, TweenInfo.new(0.2), {Size = UDim2.fromOffset(560, 50)}):Play()
		body.Visible = false
		minimizeBtn.Text = "▢"
	else
		TweenService:Create(mainPanel, TweenInfo.new(0.2), {Size = UDim2.fromOffset(560, fullHeight)}):Play()
		task.delay(0.05, function() body.Visible = true end)
		minimizeBtn.Text = "—"
	end
end)

-- header bisa di-drag juga untuk pindahin panel
do
	local dragging, dragStart, startPos
	header.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			dragStart = input.Position
			startPos = mainPanel.Position
		end
	end)
	header.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = false
		end
	end)
	game:GetService("UserInputService").InputChanged:Connect(function(input)
		if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			local delta = input.Position - dragStart
			mainPanel.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
		end
	end)
end

-- =========================================================
-- NOTIFIKASI POP-UP (kanan atas)
-- =========================================================
local notifHolder = Instance.new("Frame")
notifHolder.Size = UDim2.fromOffset(300, 400)
notifHolder.Position = UDim2.new(1, -320, 0, 20)
notifHolder.BackgroundTransparency = 1
notifHolder.ZIndex = 200
notifHolder.Parent = screenGui

local notifLayout = Instance.new("UIListLayout")
notifLayout.Padding = UDim.new(0, 6)
notifLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
notifLayout.Parent = notifHolder

local function showNotification(text)
	local box = Instance.new("Frame")
	box.Size = UDim2.new(0, 280, 0, 0)
	box.AutomaticSize = Enum.AutomaticSize.Y
	box.BackgroundColor3 = COL_BG2
	box.ZIndex = 200
	box.Parent = notifHolder
	corner(box, 8)
	stroke(box, COL_ACCENT, 1)
	padding(box, 10)

	local lbl = Instance.new("TextLabel")
	lbl.Size = UDim2.new(1, 0, 0, 0)
	lbl.AutomaticSize = Enum.AutomaticSize.Y
	lbl.BackgroundTransparency = 1
	lbl.Text = text
	lbl.TextWrapped = true
	lbl.TextColor3 = COL_TEXT
	lbl.Font = Enum.Font.Gotham
	lbl.TextSize = 12
	lbl.ZIndex = 200
	lbl.Parent = box

	task.delay(4, function()
		if box and box.Parent then
			local t = TweenService:Create(box, TweenInfo.new(0.3), {BackgroundTransparency = 1})
			t:Play()
			task.wait(0.3)
			box:Destroy()
		end
	end)
end

-- =========================================================
-- REMOTE LISTENERS
-- =========================================================
PanelInitRemote.OnClientEvent:Connect(function(data)
	isAdmin = data.isAdmin
	myRank = data.rank
	localHistory = data.localHistory or {}
	globalHistory = data.globalHistory or {}
	AdminUsernamesLower = data.adminUsernamesLower or {}

	toggleBtn.Visible = isAdmin
	if isAdmin then
		showNotification("✅ Admin Panel aktif. Rank kamu: " .. tostring(myRank))
	end
	refreshChatDisplay()
end)

ChatUpdateRemote.OnClientEvent:Connect(function(chatType, entry)
	if chatType == "local" then
		table.insert(localHistory, entry)
		addChatMessage(localChatScroll, entry, false)
	else
		table.insert(globalHistory, entry)
		addChatMessage(globalChatScroll, entry, true)
	end
end)

NotifyRemote.OnClientEvent:Connect(function(text)
	showNotification(text)
	showStatus(text)
	toolsStatusLabel.Text = text
end)

print("[AdminPanel] GUI berhasil dimuat.")
