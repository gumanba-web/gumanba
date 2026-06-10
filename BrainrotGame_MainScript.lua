-- ============================================================
--   BRAINROT UNIVERSE - COMPLETE GAME SCRIPT
--   Script by: Claude AI untuk Roblox Studio
--   Versi: 1.0 | LocalScript (masukkan ke StarterPlayerScripts)
-- ============================================================

-- ===================== SERVICES =====================
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local SoundService = game:GetService("SoundService")
local MarketplaceService = game:GetService("MarketplaceService")
local DataStoreService = game:GetService("DataStoreService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local camera = workspace.CurrentCamera

-- ===================== DATA & CONFIG =====================
local GameData = {
    Version = "1.0",
    GameName = "🧠 BRAINROT UNIVERSE",
    MaxRebirths = 999,
    CashPerSecond = 1,
    RebornMultiplier = 1.5,
}

-- Player Stats (disimpan lokal, gunakan DataStore di server)
local PlayerStats = {
    Cash = 0,
    Rebirths = 0,
    OwnedBrainrots = {},
    EquippedBrainrot = nil,
    SpectateTarget = nil,
    TotalCashEarned = 0,
    PlayTime = 0,
    Level = 1,
}

-- ===================== BRAINROT DATABASE =====================
-- Semua brainrot dengan harga, rarity, dan deskripsi
local BrainrotDB = {
    {
        id = 1,
        name = "Tralalero Tralala",
        emoji = "🦈",
        price = 0,
        rarity = "FREE",
        rarityColor = Color3.fromRGB(150,150,150),
        description = "Hiu Italia yang suka joget! Brainrot starter terbaik.",
        power = 1,
        cashBonus = 0,
        modelId = "rbxassetid://0", -- ganti dengan asset ID nyata
        unlockRebirth = 0,
    },
    {
        id = 2,
        name = "Bombardiro Crocodilo",
        emoji = "🐊",
        price = 500,
        rarity = "COMMON",
        rarityColor = Color3.fromRGB(100,200,100),
        description = "Buaya pesawat bom dari Italia. Siap membom musuh!",
        power = 3,
        cashBonus = 5,
        modelId = "rbxassetid://0",
        unlockRebirth = 0,
    },
    {
        id = 3,
        name = "Cappuccino Assassino",
        emoji = "☕",
        price = 1500,
        rarity = "UNCOMMON",
        rarityColor = Color3.fromRGB(100,150,255),
        description = "Kopi pembunuh berbahaya dari Roma. +5 Cash/sec",
        power = 5,
        cashBonus = 5,
        modelId = "rbxassetid://0",
        unlockRebirth = 0,
    },
    {
        id = 4,
        name = "Tung Tung Tung Sahur",
        emoji = "🥁",
        price = 3000,
        rarity = "RARE",
        rarityColor = Color3.fromRGB(255,215,0),
        description = "Brainrot India paling viral! Bunyi drum sahur tiada henti.",
        power = 8,
        cashBonus = 10,
        modelId = "rbxassetid://0",
        unlockRebirth = 1,
    },
    {
        id = 5,
        name = "Ballerina Cappuccina",
        emoji = "💃",
        price = 7500,
        rarity = "RARE",
        rarityColor = Color3.fromRGB(255,215,0),
        description = "Penari balet kopi yang anggun dan berbahaya!",
        power = 12,
        cashBonus = 15,
        modelId = "rbxassetid://0",
        unlockRebirth = 1,
    },
    {
        id = 6,
        name = "Frigo Camelo",
        emoji = "🐪",
        price = 15000,
        rarity = "EPIC",
        rarityColor = Color3.fromRGB(200,100,255),
        description = "Unta kulkas misterius dari padang pasir Italia.",
        power = 20,
        cashBonus = 25,
        modelId = "rbxassetid://0",
        unlockRebirth = 2,
    },
    {
        id = 7,
        name = "La Vaca Saturno",
        emoji = "🐄",
        price = 30000,
        rarity = "EPIC",
        rarityColor = Color3.fromRGB(200,100,255),
        description = "Sapi Saturnus dengan cincin planet. Out of this world!",
        power = 30,
        cashBonus = 40,
        modelId = "rbxassetid://0",
        unlockRebirth = 3,
    },
    {
        id = 8,
        name = "Brr Brr Patapim",
        emoji = "❄️",
        price = 75000,
        rarity = "LEGENDARY",
        rarityColor = Color3.fromRGB(255,140,0),
        description = "Makhluk dingin misterius. Siapapun yang melihatnya akan membeku!",
        power = 50,
        cashBonus = 75,
        modelId = "rbxassetid://0",
        unlockRebirth = 5,
    },
    {
        id = 9,
        name = "Lirilì Larilà",
        emoji = "🌵",
        price = 150000,
        rarity = "LEGENDARY",
        rarityColor = Color3.fromRGB(255,140,0),
        description = "Kaktus gajah yang menyanyikan lagu Italia kuno.",
        power = 75,
        cashBonus = 100,
        modelId = "rbxassetid://0",
        unlockRebirth = 7,
    },
    {
        id = 10,
        name = "Il Cacto Pensatore",
        emoji = "🤔",
        price = 350000,
        rarity = "MYTHIC",
        rarityColor = Color3.fromRGB(255,50,50),
        description = "Kaktus filsuf. Berfikir keras tentang brainrot dunia.",
        power = 120,
        cashBonus = 200,
        modelId = "rbxassetid://0",
        unlockRebirth = 10,
    },
    {
        id = 11,
        name = "Glorbo Fruttodrillo",
        emoji = "🐉",
        price = 1000000,
        rarity = "SECRET",
        rarityColor = Color3.fromRGB(255,0,128),
        description = "RAHASIA! Buah naga Italia yang melegendaris!",
        power = 300,
        cashBonus = 500,
        modelId = "rbxassetid://0",
        unlockRebirth = 15,
    },
    {
        id = 12,
        name = "Σ SIGMA BRAINROT",
        emoji = "⚡",
        price = 5000000,
        rarity = "GODLY",
        rarityColor = Color3.fromRGB(255,255,0),
        description = "GODLY! Brainrot paling sigma di seluruh alam semesta!",
        power = 1000,
        cashBonus = 2000,
        modelId = "rbxassetid://0",
        unlockRebirth = 25,
    },
}

-- ===================== MAP DATABASE =====================
local Maps = {
    {
        id = 1,
        name = "🇮🇹 Italia Brainrot",
        description = "Kota Italia penuh brainrot! Tempat lahirnya semua brainrot.",
        color = Color3.fromRGB(0,150,255),
        position = Vector3.new(0, 5, 0),
        unlockPrice = 0,
        cashMultiplier = 1.0,
        icon = "🏛️",
    },
    {
        id = 2,
        name = "🇮🇳 India Brainrot",
        description = "Padang sahur penuh drum dan tari. Sangat brainrot!",
        color = Color3.fromRGB(255,140,0),
        position = Vector3.new(200, 5, 0),
        unlockPrice = 5000,
        cashMultiplier = 1.5,
        icon = "🎪",
    },
    {
        id = 3,
        name = "🌌 Space Brainrot",
        description = "Luar angkasa penuh sapi dan kaktus alien!",
        color = Color3.fromRGB(100,0,200),
        position = Vector3.new(400, 5, 0),
        unlockPrice = 50000,
        cashMultiplier = 2.5,
        icon = "🚀",
    },
    {
        id = 4,
        name = "🔥 Brainrot Hell",
        description = "Dunia terbalik brainrot. Hanya yang kuat bertahan!",
        color = Color3.fromRGB(200,0,0),
        position = Vector3.new(600, 5, 0),
        unlockPrice = 500000,
        cashMultiplier = 5.0,
        icon = "💀",
    },
    {
        id = 5,
        name = "👑 Brainrot Heaven",
        description = "Surga brainrot. Hanya Rebirth 25+ bisa masuk!",
        color = Color3.fromRGB(255,215,0),
        position = Vector3.new(800, 5, 0),
        unlockPrice = 9999999,
        cashMultiplier = 10.0,
        icon = "✨",
    },
}

-- ===================== COLORS & THEME =====================
local Theme = {
    Primary = Color3.fromRGB(15, 10, 35),
    Secondary = Color3.fromRGB(25, 18, 55),
    Accent = Color3.fromRGB(120, 60, 255),
    AccentGlow = Color3.fromRGB(180, 100, 255),
    Gold = Color3.fromRGB(255, 200, 50),
    Green = Color3.fromRGB(80, 220, 120),
    Red = Color3.fromRGB(255, 80, 80),
    White = Color3.fromRGB(240, 240, 255),
    TextDim = Color3.fromRGB(160, 150, 200),
    CardBg = Color3.fromRGB(30, 22, 65),
    Border = Color3.fromRGB(80, 60, 140),
}

-- ===================== UTILITY FUNCTIONS =====================
local function formatCash(amount)
    if amount >= 1e12 then return string.format("%.1fT", amount/1e12)
    elseif amount >= 1e9 then return string.format("%.1fB", amount/1e9)
    elseif amount >= 1e6 then return string.format("%.1fM", amount/1e6)
    elseif amount >= 1e3 then return string.format("%.1fK", amount/1e3)
    else return tostring(math.floor(amount)) end
end

local function getRarityGradient(rarity)
    local colors = {
        FREE = {Color3.fromRGB(150,150,150), Color3.fromRGB(200,200,200)},
        COMMON = {Color3.fromRGB(80,200,80), Color3.fromRGB(120,255,120)},
        UNCOMMON = {Color3.fromRGB(80,120,255), Color3.fromRGB(120,180,255)},
        RARE = {Color3.fromRGB(200,160,0), Color3.fromRGB(255,220,50)},
        EPIC = {Color3.fromRGB(150,50,255), Color3.fromRGB(200,120,255)},
        LEGENDARY = {Color3.fromRGB(255,100,0), Color3.fromRGB(255,180,50)},
        MYTHIC = {Color3.fromRGB(255,0,50), Color3.fromRGB(255,100,100)},
        SECRET = {Color3.fromRGB(200,0,100), Color3.fromRGB(255,100,200)},
        GODLY = {Color3.fromRGB(200,200,0), Color3.fromRGB(255,255,100)},
    }
    return colors[rarity] or colors["COMMON"]
end

local function createTween(obj, props, duration, style, direction)
    local info = TweenInfo.new(
        duration or 0.3,
        style or Enum.EasingStyle.Quart,
        direction or Enum.EasingDirection.Out
    )
    return TweenService:Create(obj, info, props)
end

local function addCorner(parent, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius or 12)
    corner.Parent = parent
    return corner
end

local function addStroke(parent, color, thickness)
    local stroke = Instance.new("UIStroke")
    stroke.Color = color or Theme.Border
    stroke.Thickness = thickness or 1.5
    stroke.Parent = parent
    return stroke
end

local function addGlow(frame, color)
    -- Simulasi glow dengan shadow
    local shadow = Instance.new("Frame")
    shadow.Size = UDim2.new(1, 16, 1, 16)
    shadow.Position = UDim2.new(0, -8, 0, -8)
    shadow.BackgroundColor3 = color or Theme.Accent
    shadow.BackgroundTransparency = 0.7
    shadow.ZIndex = frame.ZIndex - 1
    shadow.Parent = frame.Parent
    addCorner(shadow, 16)
    return shadow
end

-- ===================== SOUND SYSTEM =====================
local Sounds = {}
local function playSound(soundId, volume, pitch)
    local sound = Instance.new("Sound")
    sound.SoundId = soundId or "rbxassetid://9120386446"
    sound.Volume = volume or 0.5
    sound.PlaybackSpeed = pitch or 1
    sound.Parent = SoundService
    sound:Play()
    game:GetService("Debris"):AddItem(sound, 3)
end

-- ===================== MAIN GUI CREATION =====================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "BrainrotUniverseGui"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = playerGui

-- ===================== TOP HUD BAR =====================
local TopHUD = Instance.new("Frame")
TopHUD.Name = "TopHUD"
TopHUD.Size = UDim2.new(1, 0, 0, 70)
TopHUD.Position = UDim2.new(0, 0, 0, 0)
TopHUD.BackgroundColor3 = Theme.Primary
TopHUD.BackgroundTransparency = 0.1
TopHUD.ZIndex = 10
TopHUD.Parent = ScreenGui
addStroke(TopHUD, Theme.Accent, 2)

-- Cash Display
local CashFrame = Instance.new("Frame")
CashFrame.Size = UDim2.new(0, 180, 0, 50)
CashFrame.Position = UDim2.new(0, 10, 0.5, -25)
CashFrame.BackgroundColor3 = Theme.CardBg
CashFrame.ZIndex = 11
CashFrame.Parent = TopHUD
addCorner(CashFrame, 10)
addStroke(CashFrame, Theme.Gold, 1.5)

local CashEmoji = Instance.new("TextLabel")
CashEmoji.Size = UDim2.new(0, 40, 1, 0)
CashEmoji.Position = UDim2.new(0, 5, 0, 0)
CashEmoji.BackgroundTransparency = 1
CashEmoji.Text = "💰"
CashEmoji.TextSize = 22
CashEmoji.ZIndex = 12
CashEmoji.Parent = CashFrame

local CashLabel = Instance.new("TextLabel")
CashLabel.Name = "CashLabel"
CashLabel.Size = UDim2.new(1, -50, 1, 0)
CashLabel.Position = UDim2.new(0, 42, 0, 0)
CashLabel.BackgroundTransparency = 1
CashLabel.Text = "$0"
CashLabel.TextColor3 = Theme.Gold
CashLabel.TextSize = 18
CashLabel.Font = Enum.Font.GothamBold
CashLabel.TextXAlignment = Enum.TextXAlignment.Left
CashLabel.ZIndex = 12
CashLabel.Parent = CashFrame

-- Rebirth Display
local RebirthFrame = Instance.new("Frame")
RebirthFrame.Size = UDim2.new(0, 160, 0, 50)
RebirthFrame.Position = UDim2.new(0, 200, 0.5, -25)
RebirthFrame.BackgroundColor3 = Theme.CardBg
RebirthFrame.ZIndex = 11
RebirthFrame.Parent = TopHUD
addCorner(RebirthFrame, 10)
addStroke(RebirthFrame, Color3.fromRGB(255,100,200), 1.5)

local RebirthEmoji = Instance.new("TextLabel")
RebirthEmoji.Size = UDim2.new(0, 40, 1, 0)
RebirthEmoji.Position = UDim2.new(0, 5, 0, 0)
RebirthEmoji.BackgroundTransparency = 1
RebirthEmoji.Text = "🔄"
RebirthEmoji.TextSize = 22
RebirthEmoji.ZIndex = 12
RebirthEmoji.Parent = RebirthFrame

local RebirthLabel = Instance.new("TextLabel")
RebirthLabel.Name = "RebirthLabel"
RebirthLabel.Size = UDim2.new(1, -50, 1, 0)
RebirthLabel.Position = UDim2.new(0, 42, 0, 0)
RebirthLabel.BackgroundTransparency = 1
RebirthLabel.Text = "Rebirth: 0"
RebirthLabel.TextColor3 = Color3.fromRGB(255,150,255)
RebirthLabel.TextSize = 16
RebirthLabel.Font = Enum.Font.GothamBold
RebirthLabel.TextXAlignment = Enum.TextXAlignment.Left
RebirthLabel.ZIndex = 12
RebirthLabel.Parent = RebirthFrame

-- Level Display
local LevelFrame = Instance.new("Frame")
LevelFrame.Size = UDim2.new(0, 140, 0, 50)
LevelFrame.Position = UDim2.new(0, 370, 0.5, -25)
LevelFrame.BackgroundColor3 = Theme.CardBg
LevelFrame.ZIndex = 11
LevelFrame.Parent = TopHUD
addCorner(LevelFrame, 10)
addStroke(LevelFrame, Theme.Green, 1.5)

local LevelLabel = Instance.new("TextLabel")
LevelLabel.Name = "LevelLabel"
LevelLabel.Size = UDim2.new(1, 0, 1, 0)
LevelLabel.BackgroundTransparency = 1
LevelLabel.Text = "⭐ LVL 1"
LevelLabel.TextColor3 = Theme.Green
LevelLabel.TextSize = 18
LevelLabel.Font = Enum.Font.GothamBold
LevelLabel.ZIndex = 12
LevelLabel.Parent = LevelFrame

-- Game Title
local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(0, 300, 1, 0)
TitleLabel.Position = UDim2.new(0.5, -150, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "🧠 BRAINROT UNIVERSE"
TitleLabel.TextColor3 = Theme.White
TitleLabel.TextSize = 22
TitleLabel.Font = Enum.Font.GothamBlack
TitleLabel.ZIndex = 11
TitleLabel.Parent = TopHUD

-- Cash per second label
local CashPerSecLabel = Instance.new("TextLabel")
CashPerSecLabel.Name = "CashPerSecLabel"
CashPerSecLabel.Size = UDim2.new(0, 200, 0, 30)
CashPerSecLabel.Position = UDim2.new(1, -210, 0.5, -15)
CashPerSecLabel.BackgroundTransparency = 1
CashPerSecLabel.Text = "+$1/sec"
CashPerSecLabel.TextColor3 = Theme.Green
CashPerSecLabel.TextSize = 15
CashPerSecLabel.Font = Enum.Font.GothamBold
CashPerSecLabel.TextXAlignment = Enum.TextXAlignment.Right
CashPerSecLabel.ZIndex = 11
CashPerSecLabel.Parent = TopHUD

-- ===================== BUTTON BAR (BOTTOM) =====================
local ButtonBar = Instance.new("Frame")
ButtonBar.Name = "ButtonBar"
ButtonBar.Size = UDim2.new(0, 600, 0, 65)
ButtonBar.Position = UDim2.new(0.5, -300, 1, -80)
ButtonBar.BackgroundColor3 = Theme.Primary
ButtonBar.BackgroundTransparency = 0.1
ButtonBar.ZIndex = 10
ButtonBar.Parent = ScreenGui
addCorner(ButtonBar, 20)
addStroke(ButtonBar, Theme.Accent, 2)

local ButtonLayout = Instance.new("UIListLayout")
ButtonLayout.FillDirection = Enum.FillDirection.Horizontal
ButtonLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
ButtonLayout.VerticalAlignment = Enum.VerticalAlignment.Center
ButtonLayout.Padding = UDim.new(0, 8)
ButtonLayout.Parent = ButtonBar

local function createNavButton(emoji, label, color)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 100, 0, 50)
    btn.BackgroundColor3 = Theme.CardBg
    btn.Text = emoji.."\n"..label
    btn.TextColor3 = color or Theme.White
    btn.TextSize = 12
    btn.Font = Enum.Font.GothamBold
    btn.ZIndex = 11
    btn.Parent = ButtonBar
    addCorner(btn, 12)
    addStroke(btn, color or Theme.Border, 1.5)

    btn.MouseEnter:Connect(function()
        createTween(btn, {BackgroundColor3 = color or Theme.Accent}, 0.2):Play()
        createTween(btn, {TextColor3 = Theme.White}, 0.2):Play()
    end)
    btn.MouseLeave:Connect(function()
        createTween(btn, {BackgroundColor3 = Theme.CardBg}, 0.2):Play()
    end)
    return btn
end

local ShopBtn = createNavButton("🛒", "SHOP", Color3.fromRGB(80,200,255))
local MapBtn = createNavButton("🗺️", "MAPS", Color3.fromRGB(100,255,150))
local IndexBtn = createNavButton("📖", "INDEX", Color3.fromRGB(255,200,80))
local SpectateBtn = createNavButton("👁️", "SPECTATE", Color3.fromRGB(200,100,255))
local RebirthBtn = createNavButton("🔄", "REBIRTH", Color3.fromRGB(255,100,200))

-- ===================== HELP / TUTORIAL PANEL =====================
local HelpPanel = Instance.new("Frame")
HelpPanel.Name = "HelpPanel"
HelpPanel.Size = UDim2.new(0, 420, 0, 520)
HelpPanel.Position = UDim2.new(0.5, -210, 0.5, -280)
HelpPanel.BackgroundColor3 = Theme.Primary
HelpPanel.Visible = true -- Tampil saat pertama kali
HelpPanel.ZIndex = 100
HelpPanel.Parent = ScreenGui
addCorner(HelpPanel, 18)
addStroke(HelpPanel, Theme.Accent, 2)

local HelpTitle = Instance.new("TextLabel")
HelpTitle.Size = UDim2.new(1, 0, 0, 60)
HelpTitle.BackgroundColor3 = Theme.Accent
HelpTitle.Text = "🧠 CARA BERMAIN BRAINROT UNIVERSE!"
HelpTitle.TextColor3 = Theme.White
HelpTitle.TextSize = 18
HelpTitle.Font = Enum.Font.GothamBlack
HelpTitle.ZIndex = 101
HelpTitle.Parent = HelpPanel
addCorner(HelpTitle, 18)

local HelpScroll = Instance.new("ScrollingFrame")
HelpScroll.Size = UDim2.new(1, -20, 1, -130)
HelpScroll.Position = UDim2.new(0, 10, 0, 65)
HelpScroll.BackgroundTransparency = 1
HelpScroll.ScrollBarThickness = 4
HelpScroll.ScrollBarImageColor3 = Theme.Accent
HelpScroll.ZIndex = 101
HelpScroll.Parent = HelpPanel

local HelpLayout = Instance.new("UIListLayout")
HelpLayout.Padding = UDim.new(0, 8)
HelpLayout.Parent = HelpScroll

local helpTexts = {
    {"💰 CARA DAPAT UANG", "Cash otomatis bertambah setiap detik! Makin banyak Rebirth & Brainrot, makin besar income kamu.", Color3.fromRGB(255,200,50)},
    {"🛒 BELI BRAINROT", "Buka Shop (🛒) untuk beli karakter Brainrot. Tiap Brainrot punya power & bonus cash berbeda!", Color3.fromRGB(80,200,255)},
    {"🗺️ TELEPORT MAP", "Jelajahi 5 map berbeda! Tiap map punya Cash Multiplier berbeda. Map mahal = lebih banyak cash!", Color3.fromRGB(100,255,150)},
    {"🔄 REBIRTH", "Jika sudah kaya, lakukan Rebirth! Reset cash tapi dapat permanen multiplier bonus. Makin banyak Rebirth = Makin kuat!", Color3.fromRGB(255,100,200)},
    {"📖 INDEX BRAINROT", "Lihat semua Brainrot yang ada di game! Track koleksi kamu disini.", Color3.fromRGB(255,200,80)},
    {"👁️ SPECTATE", "Tonton pemain lain bermain! Klik nama pemain untuk mulai spectate.", Color3.fromRGB(200,100,255)},
    {"🏪 NPC PEDAGANG", "Cari NPC bernamae 'Pak Brainrot' di setiap map untuk beli item spesial!", Color3.fromRGB(255,150,100)},
    {"⭐ LEVEL UP", "Kumpulkan cash untuk naik level! Tiap level memberikan bonus passive income.", Color3.fromRGB(150,255,150)},
    {"🏆 TIPS PRO", "Equip Brainrot terkuat, jelajahi map dengan multiplier tinggi, dan lakukan Rebirth sesering mungkin!", Color3.fromRGB(255,255,100)},
}

for _, data in ipairs(helpTexts) do
    local card = Instance.new("Frame")
    card.Size = UDim2.new(1, -10, 0, 80)
    card.BackgroundColor3 = Theme.CardBg
    card.ZIndex = 102
    card.Parent = HelpScroll
    addCorner(card, 10)
    addStroke(card, data[3], 1.5)

    local titleLbl = Instance.new("TextLabel")
    titleLbl.Size = UDim2.new(1, -10, 0, 28)
    titleLbl.Position = UDim2.new(0, 8, 0, 5)
    titleLbl.BackgroundTransparency = 1
    titleLbl.Text = data[1]
    titleLbl.TextColor3 = data[3]
    titleLbl.TextSize = 14
    titleLbl.Font = Enum.Font.GothamBold
    titleLbl.TextXAlignment = Enum.TextXAlignment.Left
    titleLbl.ZIndex = 103
    titleLbl.Parent = card

    local descLbl = Instance.new("TextLabel")
    descLbl.Size = UDim2.new(1, -10, 0, 40)
    descLbl.Position = UDim2.new(0, 8, 0, 33)
    descLbl.BackgroundTransparency = 1
    descLbl.Text = data[2]
    descLbl.TextColor3 = Theme.TextDim
    descLbl.TextSize = 12
    descLbl.Font = Enum.Font.Gotham
    descLbl.TextXAlignment = Enum.TextXAlignment.Left
    descLbl.TextWrapped = true
    descLbl.ZIndex = 103
    descLbl.Parent = card
end

HelpScroll.CanvasSize = UDim2.new(0, 0, 0, #helpTexts * 92)

local CloseHelpBtn = Instance.new("TextButton")
CloseHelpBtn.Size = UDim2.new(1, -20, 0, 45)
CloseHelpBtn.Position = UDim2.new(0, 10, 1, -55)
CloseHelpBtn.BackgroundColor3 = Theme.Accent
CloseHelpBtn.Text = "✅ MENGERTI! MULAI BERMAIN"
CloseHelpBtn.TextColor3 = Theme.White
CloseHelpBtn.TextSize = 16
CloseHelpBtn.Font = Enum.Font.GothamBold
CloseHelpBtn.ZIndex = 101
CloseHelpBtn.Parent = HelpPanel
addCorner(CloseHelpBtn, 12)

CloseHelpBtn.MouseButton1Click:Connect(function()
    createTween(HelpPanel, {Size = UDim2.new(0, 0, 0, 0), Position = UDim2.new(0.5, 0, 0.5, 0)}, 0.4):Play()
    task.wait(0.4)
    HelpPanel.Visible = false
    -- Show a welcome notification
    showNotification("🧠 Selamat bermain Brainrot Universe!", "Kumpulkan semua Brainrot dan jadi yang terkuat!", Theme.Accent)
end)

-- ===================== NOTIFICATION SYSTEM =====================
local NotifContainer = Instance.new("Frame")
NotifContainer.Name = "NotifContainer"
NotifContainer.Size = UDim2.new(0, 350, 1, -200)
NotifContainer.Position = UDim2.new(1, -360, 0, 100)
NotifContainer.BackgroundTransparency = 1
NotifContainer.ZIndex = 200
NotifContainer.Parent = ScreenGui

local NotifLayout = Instance.new("UIListLayout")
NotifLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
NotifLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
NotifLayout.Padding = UDim.new(0, 8)
NotifLayout.Parent = NotifContainer

function showNotification(title, message, color)
    local notif = Instance.new("Frame")
    notif.Size = UDim2.new(1, 0, 0, 70)
    notif.BackgroundColor3 = Theme.CardBg
    notif.Position = UDim2.new(1, 0, 0, 0)
    notif.ZIndex = 201
    notif.Parent = NotifContainer
    addCorner(notif, 12)
    addStroke(notif, color or Theme.Accent, 2)

    local notifBar = Instance.new("Frame")
    notifBar.Size = UDim2.new(0, 5, 1, 0)
    notifBar.BackgroundColor3 = color or Theme.Accent
    notifBar.ZIndex = 202
    notifBar.Parent = notif
    addCorner(notifBar, 5)

    local notifTitle = Instance.new("TextLabel")
    notifTitle.Size = UDim2.new(1, -20, 0, 30)
    notifTitle.Position = UDim2.new(0, 12, 0, 5)
    notifTitle.BackgroundTransparency = 1
    notifTitle.Text = title
    notifTitle.TextColor3 = color or Theme.Accent
    notifTitle.TextSize = 14
    notifTitle.Font = Enum.Font.GothamBold
    notifTitle.TextXAlignment = Enum.TextXAlignment.Left
    notifTitle.ZIndex = 202
    notifTitle.Parent = notif

    local notifMsg = Instance.new("TextLabel")
    notifMsg.Size = UDim2.new(1, -20, 0, 28)
    notifMsg.Position = UDim2.new(0, 12, 0, 35)
    notifMsg.BackgroundTransparency = 1
    notifMsg.Text = message
    notifMsg.TextColor3 = Theme.TextDim
    notifMsg.TextSize = 12
    notifMsg.Font = Enum.Font.Gotham
    notifMsg.TextXAlignment = Enum.TextXAlignment.Left
    notifMsg.TextTruncate = Enum.TextTruncate.AtEnd
    notifMsg.ZIndex = 202
    notifMsg.Parent = notif

    createTween(notif, {Position = UDim2.new(0, 0, 0, 0)}, 0.3):Play()

    task.delay(4, function()
        createTween(notif, {Position = UDim2.new(1.2, 0, 0, 0), BackgroundTransparency = 1}, 0.4):Play()
        task.wait(0.5)
        notif:Destroy()
    end)
end

-- ===================== SHOP GUI =====================
local ShopPanel = Instance.new("Frame")
ShopPanel.Name = "ShopPanel"
ShopPanel.Size = UDim2.new(0, 700, 0, 550)
ShopPanel.Position = UDim2.new(0.5, -350, 0.5, -290)
ShopPanel.BackgroundColor3 = Theme.Primary
ShopPanel.Visible = false
ShopPanel.ZIndex = 50
ShopPanel.Parent = ScreenGui
addCorner(ShopPanel, 18)
addStroke(ShopPanel, Color3.fromRGB(80,200,255), 2.5)

-- Shop Header
local ShopHeader = Instance.new("Frame")
ShopHeader.Size = UDim2.new(1, 0, 0, 65)
ShopHeader.BackgroundColor3 = Color3.fromRGB(20,80,120)
ShopHeader.ZIndex = 51
ShopHeader.Parent = ShopPanel
addCorner(ShopHeader, 18)

local ShopTitle = Instance.new("TextLabel")
ShopTitle.Size = UDim2.new(1, -60, 1, 0)
ShopTitle.Position = UDim2.new(0, 15, 0, 0)
ShopTitle.BackgroundTransparency = 1
ShopTitle.Text = "🛒 BRAINROT SHOP — Koleksi Semua Brainrot!"
ShopTitle.TextColor3 = Theme.White
ShopTitle.TextSize = 20
ShopTitle.Font = Enum.Font.GothamBlack
ShopTitle.TextXAlignment = Enum.TextXAlignment.Left
ShopTitle.ZIndex = 52
ShopTitle.Parent = ShopHeader

local CloseShopBtn = Instance.new("TextButton")
CloseShopBtn.Size = UDim2.new(0, 40, 0, 40)
CloseShopBtn.Position = UDim2.new(1, -50, 0.5, -20)
CloseShopBtn.BackgroundColor3 = Theme.Red
CloseShopBtn.Text = "✕"
CloseShopBtn.TextColor3 = Theme.White
CloseShopBtn.TextSize = 20
CloseShopBtn.Font = Enum.Font.GothamBold
CloseShopBtn.ZIndex = 52
CloseShopBtn.Parent = ShopHeader
addCorner(CloseShopBtn, 10)

-- Shop Cash Display
local ShopCashBar = Instance.new("Frame")
ShopCashBar.Size = UDim2.new(1, -20, 0, 40)
ShopCashBar.Position = UDim2.new(0, 10, 0, 70)
ShopCashBar.BackgroundColor3 = Theme.CardBg
ShopCashBar.ZIndex = 51
ShopCashBar.Parent = ShopPanel
addCorner(ShopCashBar, 8)
addStroke(ShopCashBar, Theme.Gold, 1)

local ShopCashLabel = Instance.new("TextLabel")
ShopCashLabel.Name = "ShopCashLabel"
ShopCashLabel.Size = UDim2.new(1, 0, 1, 0)
ShopCashLabel.BackgroundTransparency = 1
ShopCashLabel.Text = "💰 Cash kamu: $0  |  🔄 Rebirth: 0"
ShopCashLabel.TextColor3 = Theme.Gold
ShopCashLabel.TextSize = 15
ShopCashLabel.Font = Enum.Font.GothamBold
ShopCashLabel.ZIndex = 52
ShopCashLabel.Parent = ShopCashBar

-- Shop Scroll
local ShopScroll = Instance.new("ScrollingFrame")
ShopScroll.Size = UDim2.new(1, -20, 1, -130)
ShopScroll.Position = UDim2.new(0, 10, 0, 118)
ShopScroll.BackgroundTransparency = 1
ShopScroll.ScrollBarThickness = 5
ShopScroll.ScrollBarImageColor3 = Color3.fromRGB(80,200,255)
ShopScroll.ZIndex = 51
ShopScroll.Parent = ShopPanel

local ShopGrid = Instance.new("UIGridLayout")
ShopGrid.CellSize = UDim2.new(0, 205, 0, 200)
ShopGrid.CellPadding = UDim2.new(0, 8, 0, 8)
ShopGrid.HorizontalAlignment = Enum.HorizontalAlignment.Left
ShopGrid.Parent = ShopScroll

local function refreshShopCards()
    for _, child in ipairs(ShopScroll:GetChildren()) do
        if child:IsA("Frame") then child:Destroy() end
    end

    for _, brainrot in ipairs(BrainrotDB) do
        local owned = table.find(PlayerStats.OwnedBrainrots, brainrot.id) ~= nil
        local equipped = PlayerStats.EquippedBrainrot == brainrot.id
        local locked = PlayerStats.Rebirths < brainrot.unlockRebirth

        local card = Instance.new("Frame")
        card.Size = UDim2.new(0, 205, 0, 200)
        card.BackgroundColor3 = Theme.CardBg
        card.ZIndex = 52
        card.Parent = ShopScroll
        addCorner(card, 14)
        addStroke(card, brainrot.rarityColor, equipped and 3 or 1.5)

        -- Rarity badge
        local rarityBadge = Instance.new("Frame")
        rarityBadge.Size = UDim2.new(1, 0, 0, 24)
        rarityBadge.BackgroundColor3 = brainrot.rarityColor
        rarityBadge.BackgroundTransparency = 0.3
        rarityBadge.ZIndex = 53
        rarityBadge.Parent = card
        addCorner(rarityBadge, 14)

        local rarityText = Instance.new("TextLabel")
        rarityText.Size = UDim2.new(1, 0, 1, 0)
        rarityText.BackgroundTransparency = 1
        rarityText.Text = brainrot.rarity .. (locked and " 🔒" or "")
        rarityText.TextColor3 = Theme.White
        rarityText.TextSize = 11
        rarityText.Font = Enum.Font.GothamBold
        rarityText.ZIndex = 54
        rarityText.Parent = rarityBadge

        -- Emoji display
        local emojiLabel = Instance.new("TextLabel")
        emojiLabel.Size = UDim2.new(1, 0, 0, 70)
        emojiLabel.Position = UDim2.new(0, 0, 0, 24)
        emojiLabel.BackgroundTransparency = 1
        emojiLabel.Text = brainrot.emoji
        emojiLabel.TextSize = 50
        emojiLabel.ZIndex = 53
        emojiLabel.Parent = card

        -- Name
        local nameLbl = Instance.new("TextLabel")
        nameLbl.Size = UDim2.new(1, -10, 0, 30)
        nameLbl.Position = UDim2.new(0, 5, 0, 92)
        nameLbl.BackgroundTransparency = 1
        nameLbl.Text = brainrot.name
        nameLbl.TextColor3 = Theme.White
        nameLbl.TextSize = 13
        nameLbl.Font = Enum.Font.GothamBold
        nameLbl.TextWrapped = true
        nameLbl.ZIndex = 53
        nameLbl.Parent = card

        -- Cash bonus
        local bonusLbl = Instance.new("TextLabel")
        bonusLbl.Size = UDim2.new(1, -10, 0, 20)
        bonusLbl.Position = UDim2.new(0, 5, 0, 122)
        bonusLbl.BackgroundTransparency = 1
        bonusLbl.Text = "💚 +"..brainrot.cashBonus.."/sec | ⚡ PWR "..brainrot.power
        bonusLbl.TextColor3 = Theme.Green
        bonusLbl.TextSize = 11
        bonusLbl.Font = Enum.Font.Gotham
        bonusLbl.ZIndex = 53
        bonusLbl.Parent = card

        -- Unlock requirement
        if brainrot.unlockRebirth > 0 then
            local unlockLbl = Instance.new("TextLabel")
            unlockLbl.Size = UDim2.new(1, -10, 0, 18)
            unlockLbl.Position = UDim2.new(0, 5, 0, 142)
            unlockLbl.BackgroundTransparency = 1
            unlockLbl.Text = "🔄 Perlu Rebirth "..brainrot.unlockRebirth
            unlockLbl.TextColor3 = Color3.fromRGB(255,150,255)
            unlockLbl.TextSize = 11
            unlockLbl.Font = Enum.Font.Gotham
            unlockLbl.ZIndex = 53
            unlockLbl.Parent = card
        end

        -- Buy / Equip Button
        local buyBtn = Instance.new("TextButton")
        buyBtn.Size = UDim2.new(1, -16, 0, 32)
        buyBtn.Position = UDim2.new(0, 8, 1, -40)
        buyBtn.ZIndex = 53
        buyBtn.Parent = card
        addCorner(buyBtn, 8)

        if locked then
            buyBtn.BackgroundColor3 = Color3.fromRGB(60,60,80)
            buyBtn.Text = "🔒 LOCKED"
            buyBtn.TextColor3 = Theme.TextDim
        elseif equipped then
            buyBtn.BackgroundColor3 = Theme.Green
            buyBtn.Text = "✅ EQUIPPED"
            buyBtn.TextColor3 = Theme.White
        elseif owned then
            buyBtn.BackgroundColor3 = Theme.Accent
            buyBtn.Text = "⚡ EQUIP"
            buyBtn.TextColor3 = Theme.White
        else
            local canAfford = PlayerStats.Cash >= brainrot.price
            buyBtn.BackgroundColor3 = canAfford and Theme.Gold or Color3.fromRGB(80,60,60)
            if brainrot.price == 0 then
                buyBtn.Text = "🎁 GRATIS!"
            else
                buyBtn.Text = "💰 $"..formatCash(brainrot.price)
            end
            buyBtn.TextColor3 = Theme.White
        end
        buyBtn.TextSize = 13
        buyBtn.Font = Enum.Font.GothamBold

        buyBtn.MouseButton1Click:Connect(function()
            if locked then
                showNotification("🔒 Terkunci!", "Perlu Rebirth "..brainrot.unlockRebirth.." untuk membuka ini!", Theme.Red)
                return
            end

            if equipped then
                showNotification("✅ Sudah di-equip!", brainrot.name.." sudah aktif!", Theme.Green)
                return
            end

            if owned then
                PlayerStats.EquippedBrainrot = brainrot.id
                showNotification("⚡ Equipped!", "Kamu sekarang menggunakan "..brainrot.emoji.." "..brainrot.name.."!", brainrot.rarityColor)
                refreshShopCards()
                updatePassiveIncome()
                return
            end

            if PlayerStats.Cash >= brainrot.price then
                PlayerStats.Cash = PlayerStats.Cash - brainrot.price
                table.insert(PlayerStats.OwnedBrainrots, brainrot.id)
                PlayerStats.EquippedBrainrot = brainrot.id
                showNotification("🎉 BELI SUKSES!", "Kamu mendapat "..brainrot.emoji.." "..brainrot.name.."!", brainrot.rarityColor)
                playSound("rbxassetid://9120386446", 0.7)
                refreshShopCards()
                updatePassiveIncome()
                updateHUD()
            else
                local needed = brainrot.price - PlayerStats.Cash
                showNotification("❌ Cash tidak cukup!", "Butuh $"..formatCash(needed).." lagi!", Theme.Red)
            end
        end)
    end

    -- Update canvas size
    local rows = math.ceil(#BrainrotDB / 3)
    ShopScroll.CanvasSize = UDim2.new(0, 0, 0, rows * 208)
end

-- ===================== MAP TELEPORT GUI =====================
local MapPanel = Instance.new("Frame")
MapPanel.Name = "MapPanel"
MapPanel.Size = UDim2.new(0, 650, 0, 500)
MapPanel.Position = UDim2.new(0.5, -325, 0.5, -265)
MapPanel.BackgroundColor3 = Theme.Primary
MapPanel.Visible = false
MapPanel.ZIndex = 50
MapPanel.Parent = ScreenGui
addCorner(MapPanel, 18)
addStroke(MapPanel, Color3.fromRGB(100,255,150), 2.5)

local MapHeader = Instance.new("Frame")
MapHeader.Size = UDim2.new(1, 0, 0, 65)
MapHeader.BackgroundColor3 = Color3.fromRGB(20,80,40)
MapHeader.ZIndex = 51
MapHeader.Parent = MapPanel
addCorner(MapHeader, 18)

local MapTitle = Instance.new("TextLabel")
MapTitle.Size = UDim2.new(1, -60, 1, 0)
MapTitle.Position = UDim2.new(0, 15, 0, 0)
MapTitle.BackgroundTransparency = 1
MapTitle.Text = "🗺️ MAP TELEPORT — Jelajahi Dunia Brainrot!"
MapTitle.TextColor3 = Theme.White
MapTitle.TextSize = 20
MapTitle.Font = Enum.Font.GothamBlack
MapTitle.TextXAlignment = Enum.TextXAlignment.Left
MapTitle.ZIndex = 52
MapTitle.Parent = MapHeader

local CloseMapBtn = Instance.new("TextButton")
CloseMapBtn.Size = UDim2.new(0, 40, 0, 40)
CloseMapBtn.Position = UDim2.new(1, -50, 0.5, -20)
CloseMapBtn.BackgroundColor3 = Theme.Red
CloseMapBtn.Text = "✕"
CloseMapBtn.TextColor3 = Theme.White
CloseMapBtn.TextSize = 20
CloseMapBtn.Font = Enum.Font.GothamBold
CloseMapBtn.ZIndex = 52
CloseMapBtn.Parent = MapHeader
addCorner(CloseMapBtn, 10)

local MapScroll = Instance.new("ScrollingFrame")
MapScroll.Size = UDim2.new(1, -20, 1, -80)
MapScroll.Position = UDim2.new(0, 10, 0, 70)
MapScroll.BackgroundTransparency = 1
MapScroll.ScrollBarThickness = 5
MapScroll.ScrollBarImageColor3 = Color3.fromRGB(100,255,150)
MapScroll.ZIndex = 51
MapScroll.Parent = MapPanel

local MapListLayout = Instance.new("UIListLayout")
MapListLayout.Padding = UDim.new(0, 10)
MapListLayout.Parent = MapScroll

local function buildMapCards()
    for _, mapData in ipairs(Maps) do
        local mcard = Instance.new("Frame")
        mcard.Size = UDim2.new(1, -10, 0, 90)
        mcard.BackgroundColor3 = Theme.CardBg
        mcard.ZIndex = 52
        mcard.Parent = MapScroll
        addCorner(mcard, 14)
        addStroke(mcard, mapData.color, 2)

        local iconLbl = Instance.new("TextLabel")
        iconLbl.Size = UDim2.new(0, 80, 1, 0)
        iconLbl.BackgroundColor3 = mapData.color
        iconLbl.BackgroundTransparency = 0.6
        iconLbl.Text = mapData.icon.."\n"..mapData.name:sub(1,2)
        iconLbl.TextSize = 28
        iconLbl.Font = Enum.Font.GothamBold
        iconLbl.TextColor3 = Theme.White
        iconLbl.ZIndex = 53
        iconLbl.Parent = mcard
        addCorner(iconLbl, 14)

        local mapNameLbl = Instance.new("TextLabel")
        mapNameLbl.Size = UDim2.new(1, -250, 0, 32)
        mapNameLbl.Position = UDim2.new(0, 90, 0, 8)
        mapNameLbl.BackgroundTransparency = 1
        mapNameLbl.Text = mapData.name
        mapNameLbl.TextColor3 = Theme.White
        mapNameLbl.TextSize = 18
        mapNameLbl.Font = Enum.Font.GothamBold
        mapNameLbl.TextXAlignment = Enum.TextXAlignment.Left
        mapNameLbl.ZIndex = 53
        mapNameLbl.Parent = mcard

        local mapDescLbl = Instance.new("TextLabel")
        mapDescLbl.Size = UDim2.new(1, -250, 0, 28)
        mapDescLbl.Position = UDim2.new(0, 90, 0, 38)
        mapDescLbl.BackgroundTransparency = 1
        mapDescLbl.Text = mapData.description
        mapDescLbl.TextColor3 = Theme.TextDim
        mapDescLbl.TextSize = 12
        mapDescLbl.Font = Enum.Font.Gotham
        mapDescLbl.TextXAlignment = Enum.TextXAlignment.Left
        mapDescLbl.TextWrapped = true
        mapDescLbl.ZIndex = 53
        mapDescLbl.Parent = mcard

        local multLbl = Instance.new("TextLabel")
        multLbl.Size = UDim2.new(0, 120, 0, 28)
        multLbl.Position = UDim2.new(0, 90, 0, 62)
        multLbl.BackgroundTransparency = 1
        multLbl.Text = "💸 x"..mapData.cashMultiplier.." CASH"
        multLbl.TextColor3 = Theme.Gold
        multLbl.TextSize = 13
        multLbl.Font = Enum.Font.GothamBold
        multLbl.TextXAlignment = Enum.TextXAlignment.Left
        multLbl.ZIndex = 53
        multLbl.Parent = mcard

        -- Teleport Button
        local tpBtn = Instance.new("TextButton")
        tpBtn.Size = UDim2.new(0, 140, 0, 60)
        tpBtn.Position = UDim2.new(1, -150, 0.5, -30)
        tpBtn.ZIndex = 53
        tpBtn.Parent = mcard
        addCorner(tpBtn, 10)

        local canGo = PlayerStats.Cash >= mapData.unlockPrice or mapData.unlockPrice == 0
        if canGo then
            tpBtn.BackgroundColor3 = mapData.color
            tpBtn.Text = "🚀 TELEPORT\n"..mapData.name:sub(1,12)
            tpBtn.TextColor3 = Theme.White
        else
            tpBtn.BackgroundColor3 = Color3.fromRGB(60,60,80)
            tpBtn.Text = "🔒 Unlock\n$"..formatCash(mapData.unlockPrice)
            tpBtn.TextColor3 = Theme.TextDim
        end
        tpBtn.TextSize = 12
        tpBtn.Font = Enum.Font.GothamBold

        tpBtn.MouseButton1Click:Connect(function()
            if not canGo and PlayerStats.Cash < mapData.unlockPrice then
                showNotification("🔒 Map Terkunci!", "Butuh $"..formatCash(mapData.unlockPrice).." untuk unlock map ini!", Theme.Red)
                return
            end

            -- Teleport player
            local char = player.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                char.HumanoidRootPart.CFrame = CFrame.new(mapData.position)
                -- Update cash multiplier
                GameData.CurrentMapMultiplier = mapData.cashMultiplier
                updatePassiveIncome()
                MapPanel.Visible = false
                showNotification("🚀 TELEPORT!", "Kamu tiba di "..mapData.name.." | Cash x"..mapData.cashMultiplier, mapData.color)
                playSound("rbxassetid://9120386446", 0.6)
            end
        end)
    end

    MapScroll.CanvasSize = UDim2.new(0, 0, 0, #Maps * 100)
end

buildMapCards()

-- ===================== BRAINROT INDEX GUI =====================
local IndexPanel = Instance.new("Frame")
IndexPanel.Name = "IndexPanel"
IndexPanel.Size = UDim2.new(0, 680, 0, 540)
IndexPanel.Position = UDim2.new(0.5, -340, 0.5, -290)
IndexPanel.BackgroundColor3 = Theme.Primary
IndexPanel.Visible = false
IndexPanel.ZIndex = 50
IndexPanel.Parent = ScreenGui
addCorner(IndexPanel, 18)
addStroke(IndexPanel, Color3.fromRGB(255,200,80), 2.5)

local IndexHeader = Instance.new("Frame")
IndexHeader.Size = UDim2.new(1, 0, 0, 65)
IndexHeader.BackgroundColor3 = Color3.fromRGB(80,60,10)
IndexHeader.ZIndex = 51
IndexHeader.Parent = IndexPanel
addCorner(IndexHeader, 18)

local IndexTitle = Instance.new("TextLabel")
IndexTitle.Size = UDim2.new(1, -80, 1, 0)
IndexTitle.Position = UDim2.new(0, 15, 0, 0)
IndexTitle.BackgroundTransparency = 1
IndexTitle.Text = "📖 BRAINROT INDEX — Kumpulkan Semua!"
IndexTitle.TextColor3 = Theme.Gold
IndexTitle.TextSize = 20
IndexTitle.Font = Enum.Font.GothamBlack
IndexTitle.TextXAlignment = Enum.TextXAlignment.Left
IndexTitle.ZIndex = 52
IndexTitle.Parent = IndexHeader

local CloseIndexBtn = Instance.new("TextButton")
CloseIndexBtn.Size = UDim2.new(0, 40, 0, 40)
CloseIndexBtn.Position = UDim2.new(1, -50, 0.5, -20)
CloseIndexBtn.BackgroundColor3 = Theme.Red
CloseIndexBtn.Text = "✕"
CloseIndexBtn.TextColor3 = Theme.White
CloseIndexBtn.TextSize = 20
CloseIndexBtn.Font = Enum.Font.GothamBold
CloseIndexBtn.ZIndex = 52
CloseIndexBtn.Parent = IndexHeader
addCorner(CloseIndexBtn, 10)

-- Progress bar
local IndexProgressBg = Instance.new("Frame")
IndexProgressBg.Size = UDim2.new(1, -20, 0, 28)
IndexProgressBg.Position = UDim2.new(0, 10, 0, 70)
IndexProgressBg.BackgroundColor3 = Theme.CardBg
IndexProgressBg.ZIndex = 51
IndexProgressBg.Parent = IndexPanel
addCorner(IndexProgressBg, 8)

local IndexProgressFill = Instance.new("Frame")
IndexProgressFill.Name = "ProgressFill"
IndexProgressFill.Size = UDim2.new(0, 0, 1, 0)
IndexProgressFill.BackgroundColor3 = Theme.Gold
IndexProgressFill.ZIndex = 52
IndexProgressFill.Parent = IndexProgressBg
addCorner(IndexProgressFill, 8)

local IndexProgressLabel = Instance.new("TextLabel")
IndexProgressLabel.Name = "ProgressLabel"
IndexProgressLabel.Size = UDim2.new(1, 0, 1, 0)
IndexProgressLabel.BackgroundTransparency = 1
IndexProgressLabel.Text = "0 / "..#BrainrotDB.." Brainrot dikumpulkan (0%)"
IndexProgressLabel.TextColor3 = Theme.White
IndexProgressLabel.TextSize = 13
IndexProgressLabel.Font = Enum.Font.GothamBold
IndexProgressLabel.ZIndex = 53
IndexProgressLabel.Parent = IndexProgressBg

local IndexScroll = Instance.new("ScrollingFrame")
IndexScroll.Size = UDim2.new(1, -20, 1, -115)
IndexScroll.Position = UDim2.new(0, 10, 0, 105)
IndexScroll.BackgroundTransparency = 1
IndexScroll.ScrollBarThickness = 5
IndexScroll.ScrollBarImageColor3 = Theme.Gold
IndexScroll.ZIndex = 51
IndexScroll.Parent = IndexPanel

local IndexGridLayout = Instance.new("UIGridLayout")
IndexGridLayout.CellSize = UDim2.new(0, 150, 0, 170)
IndexGridLayout.CellPadding = UDim2.new(0, 8, 0, 8)
IndexGridLayout.Parent = IndexScroll

local function refreshIndex()
    for _, child in ipairs(IndexScroll:GetChildren()) do
        if child:IsA("Frame") then child:Destroy() end
    end

    local ownedCount = #PlayerStats.OwnedBrainrots
    local pct = math.floor(ownedCount / #BrainrotDB * 100)

    IndexProgressFill.Size = UDim2.new(ownedCount/#BrainrotDB, 0, 1, 0)
    IndexProgressLabel.Text = ownedCount.." / "..#BrainrotDB.." dikumpulkan ("..pct.."%)"

    for _, brainrot in ipairs(BrainrotDB) do
        local owned = table.find(PlayerStats.OwnedBrainrots, brainrot.id) ~= nil
        local equipped = PlayerStats.EquippedBrainrot == brainrot.id

        local icard = Instance.new("Frame")
        icard.Size = UDim2.new(0, 150, 0, 170)
        icard.BackgroundColor3 = owned and Theme.CardBg or Color3.fromRGB(15,12,30)
        icard.BackgroundTransparency = owned and 0 or 0.2
        icard.ZIndex = 52
        icard.Parent = IndexScroll
        addCorner(icard, 12)
        addStroke(icard, owned and brainrot.rarityColor or Color3.fromRGB(50,50,70), owned and 2 or 1)

        local iEmoji = Instance.new("TextLabel")
        iEmoji.Size = UDim2.new(1, 0, 0, 65)
        iEmoji.Position = UDim2.new(0, 0, 0, 10)
        iEmoji.BackgroundTransparency = 1
        iEmoji.Text = owned and brainrot.emoji or "❓"
        iEmoji.TextSize = 45
        iEmoji.ZIndex = 53
        iEmoji.TextTransparency = owned and 0 or 0
        iEmoji.Parent = icard

        local iName = Instance.new("TextLabel")
        iName.Size = UDim2.new(1, -8, 0, 40)
        iName.Position = UDim2.new(0, 4, 0, 75)
        iName.BackgroundTransparency = 1
        iName.Text = owned and brainrot.name or "???"
        iName.TextColor3 = owned and Theme.White or Theme.TextDim
        iName.TextSize = 11
        iName.Font = Enum.Font.GothamBold
        iName.TextWrapped = true
        iName.ZIndex = 53
        iName.Parent = icard

        local iRarity = Instance.new("TextLabel")
        iRarity.Size = UDim2.new(1, 0, 0, 20)
        iRarity.Position = UDim2.new(0, 0, 0, 115)
        iRarity.BackgroundTransparency = 1
        iRarity.Text = owned and brainrot.rarity or "???"
        iRarity.TextColor3 = owned and brainrot.rarityColor or Theme.TextDim
        iRarity.TextSize = 11
        iRarity.Font = Enum.Font.GothamBold
        iRarity.ZIndex = 53
        iRarity.Parent = icard

        if equipped then
            local equippedBadge = Instance.new("TextLabel")
            equippedBadge.Size = UDim2.new(1, 0, 0, 20)
            equippedBadge.Position = UDim2.new(0, 0, 0, 140)
            equippedBadge.BackgroundColor3 = Theme.Green
            equippedBadge.Text = "✅ EQUIPPED"
            equippedBadge.TextColor3 = Theme.White
            equippedBadge.TextSize = 10
            equippedBadge.Font = Enum.Font.GothamBold
            equippedBadge.ZIndex = 53
            equippedBadge.Parent = icard
            addCorner(equippedBadge, 6)
        end

        if owned and not equipped then
            local priceTag = Instance.new("TextLabel")
            priceTag.Size = UDim2.new(1, 0, 0, 18)
            priceTag.Position = UDim2.new(0, 0, 0, 143)
            priceTag.BackgroundTransparency = 1
            priceTag.Text = brainrot.price == 0 and "🎁 FREE" or "💰 $"..formatCash(brainrot.price)
            priceTag.TextColor3 = Theme.Gold
            priceTag.TextSize = 11
            priceTag.Font = Enum.Font.Gotham
            priceTag.ZIndex = 53
            priceTag.Parent = icard
        end
    end

    local rows = math.ceil(#BrainrotDB / 4)
    IndexScroll.CanvasSize = UDim2.new(0, 0, 0, rows * 178)
end

-- ===================== SPECTATE GUI =====================
local SpectatePanel = Instance.new("Frame")
SpectatePanel.Name = "SpectatePanel"
SpectatePanel.Size = UDim2.new(0, 400, 0, 480)
SpectatePanel.Position = UDim2.new(0.5, -200, 0.5, -260)
SpectatePanel.BackgroundColor3 = Theme.Primary
SpectatePanel.Visible = false
SpectatePanel.ZIndex = 50
SpectatePanel.Parent = ScreenGui
addCorner(SpectatePanel, 18)
addStroke(SpectatePanel, Color3.fromRGB(200,100,255), 2.5)

local SpectateHeader = Instance.new("Frame")
SpectateHeader.Size = UDim2.new(1, 0, 0, 65)
SpectateHeader.BackgroundColor3 = Color3.fromRGB(60,20,90)
SpectateHeader.ZIndex = 51
SpectateHeader.Parent = SpectatePanel
addCorner(SpectateHeader, 18)

local SpectateTitle = Instance.new("TextLabel")
SpectateTitle.Size = UDim2.new(1, -60, 1, 0)
SpectateTitle.Position = UDim2.new(0, 15, 0, 0)
SpectateTitle.BackgroundTransparency = 1
SpectateTitle.Text = "👁️ SPECTATE PLAYERS"
SpectateTitle.TextColor3 = Color3.fromRGB(200,100,255)
SpectateTitle.TextSize = 22
SpectateTitle.Font = Enum.Font.GothamBlack
SpectateTitle.TextXAlignment = Enum.TextXAlignment.Left
SpectateTitle.ZIndex = 52
SpectateTitle.Parent = SpectateHeader

local CloseSpectateBtn = Instance.new("TextButton")
CloseSpectateBtn.Size = UDim2.new(0, 40, 0, 40)
CloseSpectateBtn.Position = UDim2.new(1, -50, 0.5, -20)
CloseSpectateBtn.BackgroundColor3 = Theme.Red
CloseSpectateBtn.Text = "✕"
CloseSpectateBtn.TextColor3 = Theme.White
CloseSpectateBtn.TextSize = 20
CloseSpectateBtn.Font = Enum.Font.GothamBold
CloseSpectateBtn.ZIndex = 52
CloseSpectateBtn.Parent = SpectateHeader
addCorner(CloseSpectateBtn, 10)

-- Currently Spectating Display
local SpectatingFrame = Instance.new("Frame")
SpectatingFrame.Size = UDim2.new(1, -20, 0, 50)
SpectatingFrame.Position = UDim2.new(0, 10, 0, 72)
SpectatingFrame.BackgroundColor3 = Theme.CardBg
SpectatingFrame.ZIndex = 51
SpectatingFrame.Parent = SpectatePanel
addCorner(SpectatingFrame, 10)
addStroke(SpectatingFrame, Color3.fromRGB(200,100,255), 1)

local SpectatingLabel = Instance.new("TextLabel")
SpectatingLabel.Name = "SpectatingLabel"
SpectatingLabel.Size = UDim2.new(1, 0, 1, 0)
SpectatingLabel.BackgroundTransparency = 1
SpectatingLabel.Text = "👁️ Tidak sedang spectate siapapun"
SpectatingLabel.TextColor3 = Theme.TextDim
SpectatingLabel.TextSize = 14
SpectatingLabel.Font = Enum.Font.GothamBold
SpectatingLabel.ZIndex = 52
SpectatingLabel.Parent = SpectatingFrame

-- Stop Spectate Button
local StopSpectateBtn = Instance.new("TextButton")
StopSpectateBtn.Size = UDim2.new(1, -20, 0, 40)
StopSpectateBtn.Position = UDim2.new(0, 10, 0, 128)
StopSpectateBtn.BackgroundColor3 = Theme.Red
StopSpectateBtn.Text = "⛔ Stop Spectate"
StopSpectateBtn.TextColor3 = Theme.White
StopSpectateBtn.TextSize = 15
StopSpectateBtn.Font = Enum.Font.GothamBold
StopSpectateBtn.ZIndex = 51
StopSpectateBtn.Parent = SpectatePanel
addCorner(StopSpectateBtn, 10)

local PlayerListTitle = Instance.new("TextLabel")
PlayerListTitle.Size = UDim2.new(1, -20, 0, 30)
PlayerListTitle.Position = UDim2.new(0, 10, 0, 175)
PlayerListTitle.BackgroundTransparency = 1
PlayerListTitle.Text = "👥 Pemain Online:"
PlayerListTitle.TextColor3 = Theme.White
PlayerListTitle.TextSize = 15
PlayerListTitle.Font = Enum.Font.GothamBold
PlayerListTitle.TextXAlignment = Enum.TextXAlignment.Left
PlayerListTitle.ZIndex = 51
PlayerListTitle.Parent = SpectatePanel

local PlayerListScroll = Instance.new("ScrollingFrame")
PlayerListScroll.Size = UDim2.new(1, -20, 1, -215)
PlayerListScroll.Position = UDim2.new(0, 10, 0, 210)
PlayerListScroll.BackgroundTransparency = 1
PlayerListScroll.ScrollBarThickness = 4
PlayerListScroll.ScrollBarImageColor3 = Color3.fromRGB(200,100,255)
PlayerListScroll.ZIndex = 51
PlayerListScroll.Parent = SpectatePanel

local PlayerListLayout = Instance.new("UIListLayout")
PlayerListLayout.Padding = UDim.new(0, 6)
PlayerListLayout.Parent = PlayerListScroll

local function refreshPlayerList()
    for _, child in ipairs(PlayerListScroll:GetChildren()) do
        if child:IsA("Frame") then child:Destroy() end
    end

    local allPlayers = Players:GetPlayers()
    for _, plr in ipairs(allPlayers) do
        if plr ~= player then
            local pcard = Instance.new("Frame")
            pcard.Size = UDim2.new(1, -5, 0, 60)
            pcard.BackgroundColor3 = Theme.CardBg
            pcard.ZIndex = 52
            pcard.Parent = PlayerListScroll
            addCorner(pcard, 10)
            addStroke(pcard, Color3.fromRGB(200,100,255), 1)

            local pAvatar = Instance.new("ImageLabel")
            pAvatar.Size = UDim2.new(0, 45, 0, 45)
            pAvatar.Position = UDim2.new(0, 7, 0.5, -22)
            pAvatar.Image = "https://www.roblox.com/headshot-thumbnail/image?userId="..plr.UserId.."&width=48&height=48&format=png"
            pAvatar.ZIndex = 53
            pAvatar.Parent = pcard
            addCorner(pAvatar, 22)

            local pName = Instance.new("TextLabel")
            pName.Size = UDim2.new(1, -130, 0, 28)
            pName.Position = UDim2.new(0, 60, 0, 8)
            pName.BackgroundTransparency = 1
            pName.Text = "👤 "..plr.DisplayName
            pName.TextColor3 = Theme.White
            pName.TextSize = 14
            pName.Font = Enum.Font.GothamBold
            pName.TextXAlignment = Enum.TextXAlignment.Left
            pName.ZIndex = 53
            pName.Parent = pcard

            local pUser = Instance.new("TextLabel")
            pUser.Size = UDim2.new(1, -130, 0, 20)
            pUser.Position = UDim2.new(0, 60, 0, 33)
            pUser.BackgroundTransparency = 1
            pUser.Text = "@"..plr.Name
            pUser.TextColor3 = Theme.TextDim
            pUser.TextSize = 11
            pUser.Font = Enum.Font.Gotham
            pUser.TextXAlignment = Enum.TextXAlignment.Left
            pUser.ZIndex = 53
            pUser.Parent = pcard

            local spectatePlayerBtn = Instance.new("TextButton")
            spectatePlayerBtn.Size = UDim2.new(0, 90, 0, 38)
            spectatePlayerBtn.Position = UDim2.new(1, -100, 0.5, -19)
            spectatePlayerBtn.BackgroundColor3 = Color3.fromRGB(200,100,255)
            spectatePlayerBtn.Text = "👁️ Lihat"
            spectatePlayerBtn.TextColor3 = Theme.White
            spectatePlayerBtn.TextSize = 13
            spectatePlayerBtn.Font = Enum.Font.GothamBold
            spectatePlayerBtn.ZIndex = 53
            spectatePlayerBtn.Parent = pcard
            addCorner(spectatePlayerBtn, 8)

            spectatePlayerBtn.MouseButton1Click:Connect(function()
                PlayerStats.SpectateTarget = plr
                SpectatingLabel.Text = "👁️ Spectating: "..plr.DisplayName
                SpectatePanel.Visible = false
                showNotification("👁️ SPECTATE", "Kamu sekarang menonton "..plr.DisplayName.."!", Color3.fromRGB(200,100,255))
                -- Camera follow
                local targetChar = plr.Character
                if targetChar and targetChar:FindFirstChild("HumanoidRootPart") then
                    camera.CameraSubject = targetChar.Humanoid
                end
            end)
        end
    end

    PlayerListScroll.CanvasSize = UDim2.new(0, 0, 0, (#allPlayers - 1) * 66)
end

StopSpectateBtn.MouseButton1Click:Connect(function()
    PlayerStats.SpectateTarget = nil
    SpectatingLabel.Text = "👁️ Tidak sedang spectate siapapun"
    -- Return camera to self
    local ownChar = player.Character
    if ownChar and ownChar:FindFirstChild("Humanoid") then
        camera.CameraSubject = ownChar.Humanoid
    end
    showNotification("⛔ Stop Spectate", "Kamera kembali ke karakter kamu!", Theme.Red)
end)

-- ===================== REBIRTH GUI =====================
local RebirthPanel = Instance.new("Frame")
RebirthPanel.Name = "RebirthPanel"
RebirthPanel.Size = UDim2.new(0, 480, 0, 380)
RebirthPanel.Position = UDim2.new(0.5, -240, 0.5, -210)
RebirthPanel.BackgroundColor3 = Theme.Primary
RebirthPanel.Visible = false
RebirthPanel.ZIndex = 50
RebirthPanel.Parent = ScreenGui
addCorner(RebirthPanel, 18)
addStroke(RebirthPanel, Color3.fromRGB(255,100,200), 2.5)

local RebirthHeader = Instance.new("Frame")
RebirthHeader.Size = UDim2.new(1, 0, 0, 65)
RebirthHeader.BackgroundColor3 = Color3.fromRGB(80,20,50)
RebirthHeader.ZIndex = 51
RebirthHeader.Parent = RebirthPanel
addCorner(RebirthHeader, 18)

local RebirthTitle = Instance.new("TextLabel")
RebirthTitle.Size = UDim2.new(1, -60, 1, 0)
RebirthTitle.Position = UDim2.new(0, 15, 0, 0)
RebirthTitle.BackgroundTransparency = 1
RebirthTitle.Text = "🔄 REBIRTH — Reset & Jadi Lebih Kuat!"
RebirthTitle.TextColor3 = Color3.fromRGB(255,150,255)
RebirthTitle.TextSize = 19
RebirthTitle.Font = Enum.Font.GothamBlack
RebirthTitle.TextXAlignment = Enum.TextXAlignment.Left
RebirthTitle.ZIndex = 52
RebirthTitle.Parent = RebirthHeader

local CloseRebirthBtn = Instance.new("TextButton")
CloseRebirthBtn.Size = UDim2.new(0, 40, 0, 40)
CloseRebirthBtn.Position = UDim2.new(1, -50, 0.5, -20)
CloseRebirthBtn.BackgroundColor3 = Theme.Red
CloseRebirthBtn.Text = "✕"
CloseRebirthBtn.TextColor3 = Theme.White
CloseRebirthBtn.TextSize = 20
CloseRebirthBtn.Font = Enum.Font.GothamBold
CloseRebirthBtn.ZIndex = 52
CloseRebirthBtn.Parent = RebirthHeader
addCorner(CloseRebirthBtn, 10)

-- Rebirth info cards
local rebirthInfos = {
    {"🔄 Rebirth Sekarang", "RebirthCount", Color3.fromRGB(255,150,255)},
    {"💰 Cash Sekarang", "RebirthCash", Theme.Gold},
    {"⚡ Multiplier Saat ini", "RebirthMult", Theme.Green},
    {"📈 Multiplier Setelah Rebirth", "RebirthNextMult", Color3.fromRGB(100,200,255)},
}

local infoFrameYPos = 75
for i, info in ipairs(rebirthInfos) do
    local infoF = Instance.new("Frame")
    infoF.Size = UDim2.new(0.45, -10, 0, 55)
    infoF.Position = UDim2.new(
        i % 2 == 1 and 0.02 or 0.52,
        0,
        0,
        infoFrameYPos + math.floor((i-1)/2) * 62
    )
    infoF.BackgroundColor3 = Theme.CardBg
    infoF.ZIndex = 51
    infoF.Parent = RebirthPanel
    addCorner(infoF, 10)
    addStroke(infoF, info[3], 1.5)

    local infoTitle = Instance.new("TextLabel")
    infoTitle.Size = UDim2.new(1, 0, 0, 24)
    infoTitle.BackgroundTransparency = 1
    infoTitle.Text = info[1]
    infoTitle.TextColor3 = Theme.TextDim
    infoTitle.TextSize = 11
    infoTitle.Font = Enum.Font.Gotham
    infoTitle.ZIndex = 52
    infoTitle.Parent = infoF

    local infoVal = Instance.new("TextLabel")
    infoVal.Name = info[2]
    infoVal.Size = UDim2.new(1, 0, 0, 28)
    infoVal.Position = UDim2.new(0, 0, 0, 24)
    infoVal.BackgroundTransparency = 1
    infoVal.Text = "..."
    infoVal.TextColor3 = info[3]
    infoVal.TextSize = 18
    infoVal.Font = Enum.Font.GothamBold
    infoVal.ZIndex = 52
    infoVal.Parent = infoF
end

local RebirthRequirements = Instance.new("Frame")
RebirthRequirements.Size = UDim2.new(1, -20, 0, 55)
RebirthRequirements.Position = UDim2.new(0, 10, 0, 210)
RebirthRequirements.BackgroundColor3 = Theme.CardBg
RebirthRequirements.ZIndex = 51
RebirthRequirements.Parent = RebirthPanel
addCorner(RebirthRequirements, 10)
addStroke(RebirthRequirements, Theme.Gold, 1.5)

local RebirthReqLabel = Instance.new("TextLabel")
RebirthReqLabel.Name = "RebirthReqLabel"
RebirthReqLabel.Size = UDim2.new(1, 0, 1, 0)
RebirthReqLabel.BackgroundTransparency = 1
RebirthReqLabel.Text = "⚠️ Butuh $10,000 untuk Rebirth pertama"
RebirthReqLabel.TextColor3 = Theme.Gold
RebirthReqLabel.TextSize = 14
RebirthReqLabel.Font = Enum.Font.GothamBold
RebirthReqLabel.TextWrapped = true
RebirthReqLabel.ZIndex = 52
RebirthReqLabel.Parent = RebirthRequirements

-- Warning
local RebirthWarning = Instance.new("TextLabel")
RebirthWarning.Size = UDim2.new(1, -20, 0, 40)
RebirthWarning.Position = UDim2.new(0, 10, 0, 272)
RebirthWarning.BackgroundTransparency = 1
RebirthWarning.Text = "⚠️ Rebirth akan MERESET cash kamu ke $0!\nNamun kamu dapat bonus multiplier permanen!"
RebirthWarning.TextColor3 = Theme.Red
RebirthWarning.TextSize = 12
RebirthWarning.Font = Enum.Font.Gotham
RebirthWarning.TextWrapped = true
RebirthWarning.ZIndex = 51
RebirthWarning.Parent = RebirthPanel

local DoRebirthBtn = Instance.new("TextButton")
DoRebirthBtn.Size = UDim2.new(1, -20, 0, 48)
DoRebirthBtn.Position = UDim2.new(0, 10, 1, -58)
DoRebirthBtn.BackgroundColor3 = Color3.fromRGB(255,100,200)
DoRebirthBtn.Text = "🔄 LAKUKAN REBIRTH!"
DoRebirthBtn.TextColor3 = Theme.White
DoRebirthBtn.TextSize = 18
DoRebirthBtn.Font = Enum.Font.GothamBlack
DoRebirthBtn.ZIndex = 51
DoRebirthBtn.Parent = RebirthPanel
addCorner(DoRebirthBtn, 12)

local function getRebirthCost()
    return math.floor(10000 * math.pow(GameData.RebornMultiplier, PlayerStats.Rebirths))
end

local function updateRebirthPanel()
    local cost = getRebirthCost()
    local multNow = 1 + PlayerStats.Rebirths * 0.25
    local multNext = 1 + (PlayerStats.Rebirths + 1) * 0.25

    local countLabel = RebirthPanel:FindFirstChild("RebirthCount", true)
    local cashLabel = RebirthPanel:FindFirstChild("RebirthCash", true)
    local multLabel = RebirthPanel:FindFirstChild("RebirthMult", true)
    local nextLabel = RebirthPanel:FindFirstChild("RebirthNextMult", true)

    if countLabel then countLabel.Text = PlayerStats.Rebirths end
    if cashLabel then cashLabel.Text = "$"..formatCash(PlayerStats.Cash) end
    if multLabel then multLabel.Text = "x"..string.format("%.2f", multNow) end
    if nextLabel then nextLabel.Text = "x"..string.format("%.2f", multNext) end

    RebirthReqLabel.Text = "💰 Butuh: $"..formatCash(cost).." | Kamu: $"..formatCash(PlayerStats.Cash)

    if PlayerStats.Cash >= cost then
        DoRebirthBtn.BackgroundColor3 = Color3.fromRGB(255,100,200)
        DoRebirthBtn.Text = "🔄 REBIRTH SEKARANG! (-$"..formatCash(cost)..")"
    else
        DoRebirthBtn.BackgroundColor3 = Color3.fromRGB(80,50,70)
        DoRebirthBtn.Text = "❌ Cash tidak cukup ($"..formatCash(cost - PlayerStats.Cash).." lagi)"
    end
end

DoRebirthBtn.MouseButton1Click:Connect(function()
    local cost = getRebirthCost()
    if PlayerStats.Cash >= cost then
        PlayerStats.Cash = 0
        PlayerStats.Rebirths = PlayerStats.Rebirths + 1
        PlayerStats.OwnedBrainrots = {}
        PlayerStats.EquippedBrainrot = nil
        updatePassiveIncome()
        updateHUD()
        updateRebirthPanel()
        showNotification("🔄 REBIRTH!", "Kamu sekarang Rebirth "..PlayerStats.Rebirths.."! Multiplier x"..string.format("%.2f", 1 + PlayerStats.Rebirths * 0.25), Color3.fromRGB(255,100,200))
        playSound("rbxassetid://9120386446", 1, 1.2)

        -- Floating rebirth effect
        local floatLabel = Instance.new("TextLabel")
        floatLabel.Size = UDim2.new(0, 400, 0, 80)
        floatLabel.Position = UDim2.new(0.5, -200, 0.5, -40)
        floatLabel.BackgroundTransparency = 1
        floatLabel.Text = "🔄 REBIRTH "..PlayerStats.Rebirths.."! 🔄"
        floatLabel.TextColor3 = Color3.fromRGB(255,100,200)
        floatLabel.TextSize = 50
        floatLabel.Font = Enum.Font.GothamBlack
        floatLabel.ZIndex = 500
        floatLabel.Parent = ScreenGui
        createTween(floatLabel, {Position = UDim2.new(0.5, -200, 0.2, 0), TextTransparency = 1}, 2):Play()
        task.delay(2.1, function() floatLabel:Destroy() end)
    else
        showNotification("❌ Belum cukup!", "Kumpulkan lebih banyak cash dulu!", Theme.Red)
    end
end)

-- ===================== NPC SHOP (PEDAGANG) =====================
local NPCPanel = Instance.new("Frame")
NPCPanel.Name = "NPCPanel"
NPCPanel.Size = UDim2.new(0, 420, 0, 400)
NPCPanel.Position = UDim2.new(0.5, -210, 0.5, -220)
NPCPanel.BackgroundColor3 = Theme.Primary
NPCPanel.Visible = false
NPCPanel.ZIndex = 50
NPCPanel.Parent = ScreenGui
addCorner(NPCPanel, 18)
addStroke(NPCPanel, Color3.fromRGB(255,180,80), 2.5)

local NPCHeader = Instance.new("Frame")
NPCHeader.Size = UDim2.new(1, 0, 0, 65)
NPCHeader.BackgroundColor3 = Color3.fromRGB(80,50,10)
NPCHeader.ZIndex = 51
NPCHeader.Parent = NPCPanel
addCorner(NPCHeader, 18)

local NPCTitle = Instance.new("TextLabel")
NPCTitle.Size = UDim2.new(1, -60, 1, 0)
NPCTitle.Position = UDim2.new(0, 10, 0, 0)
NPCTitle.BackgroundTransparency = 1
NPCTitle.Text = "🏪 PAK BRAINROT — Pedagang Item Spesial"
NPCTitle.TextColor3 = Color3.fromRGB(255,200,80)
NPCTitle.TextSize = 17
NPCTitle.Font = Enum.Font.GothamBlack
NPCTitle.TextXAlignment = Enum.TextXAlignment.Left
NPCTitle.ZIndex = 52
NPCTitle.Parent = NPCHeader

local CloseNPCBtn = Instance.new("TextButton")
CloseNPCBtn.Size = UDim2.new(0, 40, 0, 40)
CloseNPCBtn.Position = UDim2.new(1, -50, 0.5, -20)
CloseNPCBtn.BackgroundColor3 = Theme.Red
CloseNPCBtn.Text = "✕"
CloseNPCBtn.TextColor3 = Theme.White
CloseNPCBtn.TextSize = 20
CloseNPCBtn.Font = Enum.Font.GothamBold
CloseNPCBtn.ZIndex = 52
CloseNPCBtn.Parent = NPCHeader
addCorner(CloseNPCBtn, 10)

-- NPC Dialog
local NPCDialogFrame = Instance.new("Frame")
NPCDialogFrame.Size = UDim2.new(1, -20, 0, 70)
NPCDialogFrame.Position = UDim2.new(0, 10, 0, 72)
NPCDialogFrame.BackgroundColor3 = Theme.CardBg
NPCDialogFrame.ZIndex = 51
NPCDialogFrame.Parent = NPCPanel
addCorner(NPCDialogFrame, 10)
addStroke(NPCDialogFrame, Color3.fromRGB(255,200,80), 1)

local NPCEmoji = Instance.new("TextLabel")
NPCEmoji.Size = UDim2.new(0, 55, 1, 0)
NPCEmoji.BackgroundTransparency = 1
NPCEmoji.Text = "🧑‍💼"
NPCEmoji.TextSize = 38
NPCEmoji.ZIndex = 52
NPCEmoji.Parent = NPCDialogFrame

local NPCDialog = Instance.new("TextLabel")
NPCDialog.Size = UDim2.new(1, -65, 1, 0)
NPCDialog.Position = UDim2.new(0, 60, 0, 0)
NPCDialog.BackgroundTransparency = 1
NPCDialog.Text = '"Halo! Saya Pak Brainrot! Mau beli apa nih? Ada item spesial untuk kamu!"'
NPCDialog.TextColor3 = Theme.White
NPCDialog.TextSize = 13
NPCDialog.Font = Enum.Font.Gotham
NPCDialog.TextXAlignment = Enum.TextXAlignment.Left
NPCDialog.TextWrapped = true
NPCDialog.ZIndex = 52
NPCDialog.Parent = NPCDialogFrame

-- NPC Shop Items
local npcItems = {
    {name="💊 2x Cash Boost (1 menit)", price=2000, desc="Gandakan income selama 60 detik!", color=Theme.Gold},
    {name="🛡️ Protection Shield", price=5000, desc="Protect stats selama 1 game!", color=Color3.fromRGB(100,150,255)},
    {name="⚡ Auto-Collect Bot", price=10000, desc="+50% auto income permanen!", color=Color3.fromRGB(100,255,100)},
    {name="🎰 Lucky Spin Token", price=3000, desc="Putar roda keberuntungan!", color=Color3.fromRGB(255,100,200)},
}

local NPCItemsScroll = Instance.new("ScrollingFrame")
NPCItemsScroll.Size = UDim2.new(1, -20, 1, -200)
NPCItemsScroll.Position = UDim2.new(0, 10, 0, 150)
NPCItemsScroll.BackgroundTransparency = 1
NPCItemsScroll.ScrollBarThickness = 4
NPCItemsScroll.ScrollBarImageColor3 = Color3.fromRGB(255,200,80)
NPCItemsScroll.ZIndex = 51
NPCItemsScroll.Parent = NPCPanel

local NPCItemLayout = Instance.new("UIListLayout")
NPCItemLayout.Padding = UDim.new(0, 8)
NPCItemLayout.Parent = NPCItemsScroll

for _, item in ipairs(npcItems) do
    local itemF = Instance.new("Frame")
    itemF.Size = UDim2.new(1, -5, 0, 65)
    itemF.BackgroundColor3 = Theme.CardBg
    itemF.ZIndex = 52
    itemF.Parent = NPCItemsScroll
    addCorner(itemF, 10)
    addStroke(itemF, item.color, 1.5)

    local itemName = Instance.new("TextLabel")
    itemName.Size = UDim2.new(1, -130, 0, 28)
    itemName.Position = UDim2.new(0, 10, 0, 5)
    itemName.BackgroundTransparency = 1
    itemName.Text = item.name
    itemName.TextColor3 = item.color
    itemName.TextSize = 14
    itemName.Font = Enum.Font.GothamBold
    itemName.TextXAlignment = Enum.TextXAlignment.Left
    itemName.ZIndex = 53
    itemName.Parent = itemF

    local itemDesc = Instance.new("TextLabel")
    itemDesc.Size = UDim2.new(1, -130, 0, 25)
    itemDesc.Position = UDim2.new(0, 10, 0, 33)
    itemDesc.BackgroundTransparency = 1
    itemDesc.Text = item.desc
    itemDesc.TextColor3 = Theme.TextDim
    itemDesc.TextSize = 11
    itemDesc.Font = Enum.Font.Gotham
    itemDesc.TextXAlignment = Enum.TextXAlignment.Left
    itemDesc.ZIndex = 53
    itemDesc.Parent = itemF

    local buyItemBtn = Instance.new("TextButton")
    buyItemBtn.Size = UDim2.new(0, 110, 0, 48)
    buyItemBtn.Position = UDim2.new(1, -118, 0.5, -24)
    buyItemBtn.BackgroundColor3 = item.color
    buyItemBtn.Text = "💰 $"..formatCash(item.price)
    buyItemBtn.TextColor3 = Theme.White
    buyItemBtn.TextSize = 13
    buyItemBtn.Font = Enum.Font.GothamBold
    buyItemBtn.ZIndex = 53
    buyItemBtn.Parent = itemF
    addCorner(buyItemBtn, 8)

    buyItemBtn.MouseButton1Click:Connect(function()
        if PlayerStats.Cash >= item.price then
            PlayerStats.Cash = PlayerStats.Cash - item.price
            updateHUD()
            showNotification("🛒 Beli Sukses!", "Kamu membeli "..item.name.."!", item.color)
            playSound("rbxassetid://9120386446", 0.7)
        else
            showNotification("❌ Kurang cash!", "Butuh $"..formatCash(item.price - PlayerStats.Cash).." lagi!", Theme.Red)
        end
    end)
end

NPCItemsScroll.CanvasSize = UDim2.new(0, 0, 0, #npcItems * 73)

-- NPC Button in HUD (akses dari mana saja)
local NPCAccessBtn = Instance.new("TextButton")
NPCAccessBtn.Size = UDim2.new(0, 55, 0, 55)
NPCAccessBtn.Position = UDim2.new(0, 10, 0.5, -27)
NPCAccessBtn.BackgroundColor3 = Color3.fromRGB(80,50,10)
NPCAccessBtn.Text = "🏪\nNPC"
NPCAccessBtn.TextColor3 = Color3.fromRGB(255,200,80)
NPCAccessBtn.TextSize = 11
NPCAccessBtn.Font = Enum.Font.GothamBold
NPCAccessBtn.ZIndex = 10
NPCAccessBtn.Parent = ScreenGui
addCorner(NPCAccessBtn, 10)
addStroke(NPCAccessBtn, Color3.fromRGB(255,200,80), 1.5)

NPCAccessBtn.MouseButton1Click:Connect(function()
    NPCPanel.Visible = not NPCPanel.Visible
    if NPCPanel.Visible then refreshPlayerList() end
end)

-- ===================== LUCKY SPIN GUI =====================
local SpinPanel = Instance.new("Frame")
SpinPanel.Name = "SpinPanel"
SpinPanel.Size = UDim2.new(0, 400, 0, 350)
SpinPanel.Position = UDim2.new(0.5, -200, 0.5, -200)
SpinPanel.BackgroundColor3 = Theme.Primary
SpinPanel.Visible = false
SpinPanel.ZIndex = 150
SpinPanel.Parent = ScreenGui
addCorner(SpinPanel, 18)
addStroke(SpinPanel, Color3.fromRGB(255,200,80), 3)

local SpinTitle = Instance.new("TextLabel")
SpinTitle.Size = UDim2.new(1, 0, 0, 55)
SpinTitle.BackgroundColor3 = Color3.fromRGB(80,60,10)
SpinTitle.Text = "🎰 LUCKY SPIN!"
SpinTitle.TextColor3 = Theme.Gold
SpinTitle.TextSize = 28
SpinTitle.Font = Enum.Font.GothamBlack
SpinTitle.ZIndex = 151
SpinTitle.Parent = SpinPanel
addCorner(SpinTitle, 18)

local SpinWheel = Instance.new("TextLabel")
SpinWheel.Size = UDim2.new(0, 180, 0, 180)
SpinWheel.Position = UDim2.new(0.5, -90, 0, 65)
SpinWheel.BackgroundColor3 = Theme.CardBg
SpinWheel.Text = "🎰"
SpinWheel.TextSize = 80
SpinWheel.ZIndex = 151
SpinWheel.Parent = SpinPanel
addCorner(SpinWheel, 90)
addStroke(SpinWheel, Theme.Gold, 3)

local SpinBtn = Instance.new("TextButton")
SpinBtn.Size = UDim2.new(0.7, 0, 0, 48)
SpinBtn.Position = UDim2.new(0.15, 0, 1, -60)
SpinBtn.BackgroundColor3 = Theme.Gold
SpinBtn.Text = "🎰 SPIN! ($500)"
SpinBtn.TextColor3 = Theme.Primary
SpinBtn.TextSize = 18
SpinBtn.Font = Enum.Font.GothamBlack
SpinBtn.ZIndex = 151
SpinBtn.Parent = SpinPanel
addCorner(SpinBtn, 12)

local spinPrizes = {"💰 $1,000", "💰 $5,000", "💰 $500", "💸 Zonk!", "💎 $10,000", "🎁 FREE Brainrot!", "💰 $2,500", "🌟 $25,000"}

SpinBtn.MouseButton1Click:Connect(function()
    if PlayerStats.Cash < 500 then
        showNotification("❌ Kurang Cash!", "Butuh $500 untuk spin!", Theme.Red)
        return
    end
    PlayerStats.Cash = PlayerStats.Cash - 500

    -- Animate spin
    local spinEmojis = {"🎰","🎲","🎯","🎪","💫","⭐","🌟","✨"}
    local spinCount = 0
    local spinInterval = 0.05
    local conn
    conn = RunService.Heartbeat:Connect(function()
        spinCount += 1
        SpinWheel.Text = spinEmojis[(spinCount % #spinEmojis) + 1]
        if spinCount >= 30 then
            conn:Disconnect()
            local prize = spinPrizes[math.random(1, #spinPrizes)]
            SpinWheel.Text = "🎉"
            if prize:find("$") then
                local amount = tonumber(prize:match("%d+,?%d*"):gsub(",","")) or 1000
                PlayerStats.Cash += amount
                showNotification("🎰 MENANG!", "Kamu dapat "..prize.."!", Theme.Gold)
            else
                showNotification("🎰 SPIN RESULT", prize, Theme.Accent)
            end
            updateHUD()
        end
    end)
end)

local CloseSpinBtn = Instance.new("TextButton")
CloseSpinBtn.Size = UDim2.new(0.25, -10, 0, 48)
CloseSpinBtn.Position = UDim2.new(0.76, 0, 1, -60)
CloseSpinBtn.BackgroundColor3 = Theme.Red
CloseSpinBtn.Text = "✕ Tutup"
CloseSpinBtn.TextColor3 = Theme.White
CloseSpinBtn.TextSize = 14
CloseSpinBtn.Font = Enum.Font.GothamBold
CloseSpinBtn.ZIndex = 151
CloseSpinBtn.Parent = SpinPanel
addCorner(CloseSpinBtn, 12)
CloseSpinBtn.MouseButton1Click:Connect(function() SpinPanel.Visible = false end)

-- ===================== UPDATE FUNCTIONS =====================
function updateHUD()
    CashLabel.Text = "$"..formatCash(PlayerStats.Cash)
    RebirthLabel.Text = "Rebirth: "..PlayerStats.Rebirths
    LevelLabel.Text = "⭐ LVL "..PlayerStats.Level

    local shopCashLbl = ShopPanel:FindFirstChild("ShopCashLabel", true)
    if shopCashLbl then
        shopCashLbl.Text = "💰 Cash: $"..formatCash(PlayerStats.Cash).."  |  🔄 Rebirth: "..PlayerStats.Rebirths
    end
end

local passiveIncome = 1
function updatePassiveIncome()
    passiveIncome = GameData.CashPerSecond
    -- Add bonuses from equipped brainrot
    if PlayerStats.EquippedBrainrot then
        for _, br in ipairs(BrainrotDB) do
            if br.id == PlayerStats.EquippedBrainrot then
                passiveIncome += br.cashBonus
                break
            end
        end
    end
    -- Rebirth multiplier
    local mult = 1 + PlayerStats.Rebirths * 0.25
    passiveIncome = passiveIncome * mult
    -- Map multiplier
    passiveIncome = passiveIncome * (GameData.CurrentMapMultiplier or 1)

    CashPerSecLabel.Text = "+$"..string.format("%.1f", passiveIncome).."/sec"
end

-- ===================== PANEL CLOSE BUTTONS =====================
CloseShopBtn.MouseButton1Click:Connect(function() ShopPanel.Visible = false end)
CloseMapBtn.MouseButton1Click:Connect(function() MapPanel.Visible = false end)
CloseIndexBtn.MouseButton1Click:Connect(function() IndexPanel.Visible = false end)
CloseSpectateBtn.MouseButton1Click:Connect(function() SpectatePanel.Visible = false end)
CloseRebirthBtn.MouseButton1Click:Connect(function() RebirthPanel.Visible = false end)
CloseNPCBtn.MouseButton1Click:Connect(function() NPCPanel.Visible = false end)

-- ===================== NAV BUTTON ACTIONS =====================
local function closeAllPanels()
    ShopPanel.Visible = false
    MapPanel.Visible = false
    IndexPanel.Visible = false
    SpectatePanel.Visible = false
    RebirthPanel.Visible = false
    NPCPanel.Visible = false
end

ShopBtn.MouseButton1Click:Connect(function()
    local wasVisible = ShopPanel.Visible
    closeAllPanels()
    if not wasVisible then
        ShopPanel.Visible = true
        refreshShopCards()
    end
end)

MapBtn.MouseButton1Click:Connect(function()
    local wasVisible = MapPanel.Visible
    closeAllPanels()
    if not wasVisible then MapPanel.Visible = true end
end)

IndexBtn.MouseButton1Click:Connect(function()
    local wasVisible = IndexPanel.Visible
    closeAllPanels()
    if not wasVisible then
        IndexPanel.Visible = true
        refreshIndex()
    end
end)

SpectateBtn.MouseButton1Click:Connect(function()
    local wasVisible = SpectatePanel.Visible
    closeAllPanels()
    if not wasVisible then
        SpectatePanel.Visible = true
        refreshPlayerList()
    end
end)

RebirthBtn.MouseButton1Click:Connect(function()
    local wasVisible = RebirthPanel.Visible
    closeAllPanels()
    if not wasVisible then
        RebirthPanel.Visible = true
        updateRebirthPanel()
    end
end)

-- ===================== INCOME LOOP =====================
GameData.CurrentMapMultiplier = 1.0
updatePassiveIncome()

-- Give free starter brainrot
table.insert(PlayerStats.OwnedBrainrots, 1)
PlayerStats.EquippedBrainrot = 1

local incomeTimer = 0
RunService.Heartbeat:Connect(function(dt)
    incomeTimer += dt
    if incomeTimer >= 1 then
        incomeTimer = 0
        PlayerStats.Cash += passiveIncome
        PlayerStats.TotalCashEarned += passiveIncome
        PlayerStats.PlayTime += 1

        -- Level system
        local newLevel = math.floor(math.log(PlayerStats.TotalCashEarned / 100 + 1) / math.log(2)) + 1
        if newLevel > PlayerStats.Level then
            PlayerStats.Level = newLevel
            showNotification("⭐ LEVEL UP!", "Kamu naik ke Level "..newLevel.."! Bonus income bertambah!", Theme.Green)
            GameData.CashPerSecond = newLevel * 0.5
            updatePassiveIncome()
        end

        updateHUD()
    end
end)

-- ===================== FLOATING CASH POPUP (visual) =====================
local function spawnCashFloat()
    local fl = Instance.new("TextLabel")
    fl.Size = UDim2.new(0, 120, 0, 35)
    fl.Position = UDim2.new(0, math.random(10, 300), 0, math.random(80, 400))
    fl.BackgroundTransparency = 1
    fl.Text = "+$"..formatCash(passiveIncome)
    fl.TextColor3 = Theme.Green
    fl.TextSize = 18
    fl.Font = Enum.Font.GothamBold
    fl.ZIndex = 5
    fl.Parent = ScreenGui
    createTween(fl, {Position = UDim2.new(0, fl.Position.X.Offset, 0, fl.Position.Y.Offset - 60), TextTransparency = 1}, 1.5):Play()
    task.delay(1.6, function() fl:Destroy() end)
end

-- Spawn float occasionally
task.spawn(function()
    while true do
        task.wait(3)
        if not HelpPanel.Visible then
            spawnCashFloat()
        end
    end
end)

-- ===================== LEADERBOARD SIDE PANEL =====================
local LeaderboardFrame = Instance.new("Frame")
LeaderboardFrame.Name = "Leaderboard"
LeaderboardFrame.Size = UDim2.new(0, 200, 0, 220)
LeaderboardFrame.Position = UDim2.new(1, -210, 0, 80)
LeaderboardFrame.BackgroundColor3 = Theme.Primary
LeaderboardFrame.BackgroundTransparency = 0.1
LeaderboardFrame.ZIndex = 10
LeaderboardFrame.Parent = ScreenGui
addCorner(LeaderboardFrame, 14)
addStroke(LeaderboardFrame, Theme.Gold, 1.5)

local LBTitle = Instance.new("TextLabel")
LBTitle.Size = UDim2.new(1, 0, 0, 35)
LBTitle.BackgroundColor3 = Color3.fromRGB(50,40,10)
LBTitle.Text = "🏆 LEADERBOARD"
LBTitle.TextColor3 = Theme.Gold
LBTitle.TextSize = 13
LBTitle.Font = Enum.Font.GothamBold
LBTitle.ZIndex = 11
LBTitle.Parent = LeaderboardFrame
addCorner(LBTitle, 14)

local LBScroll = Instance.new("ScrollingFrame")
LBScroll.Size = UDim2.new(1, -10, 1, -45)
LBScroll.Position = UDim2.new(0, 5, 0, 40)
LBScroll.BackgroundTransparency = 1
LBScroll.ScrollBarThickness = 3
LBScroll.ScrollBarImageColor3 = Theme.Gold
LBScroll.ZIndex = 11
LBScroll.Parent = LeaderboardFrame

local LBLayout = Instance.new("UIListLayout")
LBLayout.Padding = UDim.new(0, 4)
LBLayout.Parent = LBScroll

local function updateLeaderboard()
    for _, child in ipairs(LBScroll:GetChildren()) do
        if child:IsA("Frame") then child:Destroy() end
    end

    local plrs = Players:GetPlayers()
    -- Sort by rebirths (simulated)
    for i, plr in ipairs(plrs) do
        local lbCard = Instance.new("Frame")
        lbCard.Size = UDim2.new(1, -5, 0, 36)
        lbCard.BackgroundColor3 = plr == player and Color3.fromRGB(30,60,30) or Theme.CardBg
        lbCard.ZIndex = 12
        lbCard.Parent = LBScroll
        addCorner(lbCard, 6)

        local medals = {"🥇","🥈","🥉"}
        local rankLbl = Instance.new("TextLabel")
        rankLbl.Size = UDim2.new(0, 26, 1, 0)
        rankLbl.BackgroundTransparency = 1
        rankLbl.Text = medals[i] or tostring(i)
        rankLbl.TextSize = 14
        rankLbl.ZIndex = 13
        rankLbl.Parent = lbCard

        local nameLbl = Instance.new("TextLabel")
        nameLbl.Size = UDim2.new(1, -30, 1, 0)
        nameLbl.Position = UDim2.new(0, 28, 0, 0)
        nameLbl.BackgroundTransparency = 1
        nameLbl.Text = plr.DisplayName
        nameLbl.TextColor3 = plr == player and Theme.Green or Theme.White
        nameLbl.TextSize = 12
        nameLbl.Font = Enum.Font.GothamBold
        nameLbl.TextXAlignment = Enum.TextXAlignment.Left
        nameLbl.TextTruncate = Enum.TextTruncate.AtEnd
        nameLbl.ZIndex = 13
        nameLbl.Parent = lbCard
    end

    LBScroll.CanvasSize = UDim2.new(0, 0, 0, #plrs * 40)
end

updateLeaderboard()
Players.PlayerAdded:Connect(updateLeaderboard)
Players.PlayerRemoving:Connect(updateLeaderboard)

-- ===================== INITIAL SETUP =====================
updateHUD()
updatePassiveIncome()

-- Show welcome notification after tutorial closed
task.delay(1, function()
    showNotification("🧠 Brainrot Universe v1.0", "Script by Claude AI — Selamat Brainrot!", Theme.Accent)
end)

print("🧠 BRAINROT UNIVERSE loaded successfully!")
print("Features: Shop, Map Teleport, Brainrot Index, Spectate, Rebirth, NPC Trader, Lucky Spin, Leaderboard")
