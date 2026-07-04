local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CoreGui = gethui and gethui() or game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer
local ADMINS = {["swipe_swp"] = true}

-- Limpiar interfaz previa
if CoreGui:FindFirstChild("ZengorHubV5") then
    CoreGui.ZengorHubV5:Destroy()
end

local gui = Instance.new("ScreenGui")
gui.Name = "ZengorHubV5"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.Parent = CoreGui

----------------------------------------------------
-- Función Auxiliar de Animación (Tween)
----------------------------------------------------
local function tween(obj, time, style, dir, props)
    local t = TweenService:Create(obj, TweenInfo.new(time, style, dir), props)
    t:Play()
    return t
end

----------------------------------------------------
-- Marcar al jugador local como usuario del script
----------------------------------------------------
local function markAsZengorUser(character)
    if character:FindFirstChild("ZengorUser") then return end
    local marker = Instance.new("BoolValue")
    marker.Name = "ZengorUser"
    marker.Value = true
    marker.Parent = character
end

if LocalPlayer.Character then
    markAsZengorUser(LocalPlayer.Character)
end
LocalPlayer.CharacterAdded:Connect(markAsZengorUser)

----------------------------------------------------
-- Sistema de Tags (SOLO usuarios del script)
----------------------------------------------------
local function createTag(player)
    local function applyTag(character)
        local head = character:WaitForChild("Head", 10)
        if not head or head:FindFirstChild("ZengorTag") then return end
        
        -- SOLO mostrar tag si el jugador está usando el script
        if not character:FindFirstChild("ZengorUser") then return end
        
        local billboard = Instance.new("BillboardGui", head)
        billboard.Name = "ZengorTag"
        billboard.Size = UDim2.new(0, 110, 0, 45)
        billboard.StudsOffset = Vector3.new(0, 2.5, 0)
        billboard.AlwaysOnTop = true
        local frame = Instance.new("Frame", billboard)
        frame.Size = UDim2.new(1, 0, 1, 0)
        frame.BackgroundTransparency = 0.3
        frame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
        Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 8)
        
        local isAdmin = ADMINS[player.Name]
        
        -- Borde brillante (UIStroke)
        local stroke = Instance.new("UIStroke", frame)
        stroke.Thickness = 1.5
        stroke.Color = isAdmin and Color3.fromRGB(255, 215, 0) or Color3.fromRGB(100, 100, 100)
        
        local icon = Instance.new("ImageLabel")
        icon.Parent = frame
        icon.Size = UDim2.new(0, 50, 0, 50)
        icon.AnchorPoint = Vector2.new(0.5, 0.5)
        icon.Position = UDim2.new(0, 20, 0.5, 0)
        icon.BackgroundTransparency = 1
        icon.Image = "rbxassetid://105922025873891"
        icon.ScaleType = Enum.ScaleType.Fit
        
        local title = Instance.new("TextLabel", frame)
        title.Size = UDim2.new(1, -40, 0.5, 0)
        title.Position = UDim2.new(0, 38, 0.1, 0)
        title.BackgroundTransparency = 1
        title.Text = isAdmin and "OWNER" or "ZENGOR"
        title.TextColor3 = isAdmin and Color3.fromRGB(255, 215, 0) or Color3.fromRGB(255, 255, 255)
        title.Font = Enum.Font.GothamBlack
        title.TextSize = 13
        title.TextXAlignment = Enum.TextXAlignment.Left
        
        local name = Instance.new("TextLabel", frame)
        name.Size = UDim2.new(1, -40, 0.5, 0)
        name.Position = UDim2.new(0, 38, 0.45, 0)
        name.BackgroundTransparency = 1
        name.Text = player.Name
        name.TextColor3 = Color3.fromRGB(180, 180, 180)
        name.Font = Enum.Font.GothamSemibold
        name.TextSize = 10
        name.TextXAlignment = Enum.TextXAlignment.Left
        
        -- Efecto de flote suave
        local tick = 0
        RunService.RenderStepped:Connect(function(dt)
            if billboard and billboard.Parent then
                tick = tick + (dt * 3)
                billboard.StudsOffset = Vector3.new(0, 2.5 + math.sin(tick) * 0.2, 0)
            end
        end)
    end
    
    if player.Character then applyTag(player.Character) end
    player.CharacterAdded:Connect(applyTag)
end

for _, p in pairs(Players:GetPlayers()) do
    createTag(p)
end
Players.PlayerAdded:Connect(createTag)

----------------------------------------------------
-- Intro Smooth (Pantalla Completa)
----------------------------------------------------
local introBg = Instance.new("Frame")
introBg.Size = UDim2.new(1, 0, 1, 0)
introBg.BackgroundColor3 = Color3.fromRGB(8, 8, 8)
introBg.BorderSizePixel = 0
introBg.ZIndex = 100
introBg.Parent = gui

local introText = Instance.new("TextLabel")
introText.AnchorPoint = Vector2.new(0.5, 0.5)
introText.Position = UDim2.new(0.5, 0, 0.5, 0)
introText.Size = UDim2.new(1, 0, 0, 50)
introText.BackgroundTransparency = 1
introText.Text = "Z E N G O R   H U B"
introText.TextColor3 = Color3.fromRGB(255, 255, 255)
introText.Font = Enum.Font.GothamBold
introText.TextSize = 28
introText.TextTransparency = 1
introText.ZIndex = 101
introText.Parent = introBg

task.spawn(function()
    tween(introText, 1.2, Enum.EasingStyle.Sine, Enum.EasingDirection.Out, {TextTransparency = 0}).Completed:Wait()
    task.wait(0.8)
    tween(introText, 1, Enum.EasingStyle.Sine, Enum.EasingDirection.Out, {TextTransparency = 1, Position = UDim2.new(0.5, 0, 0.45, 0)}).Completed:Wait()
    tween(introBg, 1, Enum.EasingStyle.Sine, Enum.EasingDirection.Out, {BackgroundTransparency = 1}).Completed:Wait()
    introBg:Destroy()
end)

----------------------------------------------------
-- Efecto Blur de Fondo
----------------------------------------------------
local blur = Lighting:FindFirstChild("ZengorBlur") or Instance.new("BlurEffect")
blur.Name = "ZengorBlur"
blur.Size = 0
blur.Parent = Lighting

----------------------------------------------------
-- Bloqueador de Clic
----------------------------------------------------
local clickBlocker = Instance.new("TextButton")
clickBlocker.Size = UDim2.new(1, 0, 1, 0)
clickBlocker.BackgroundTransparency = 1
clickBlocker.Text = ""
clickBlocker.Visible = false
clickBlocker.ZIndex = 1
clickBlocker.Parent = gui

----------------------------------------------------
-- Barra de Apertura Inferior
----------------------------------------------------
local barWrapper = Instance.new("Frame", gui)
barWrapper.Size = UDim2.new(0, 150, 0, 30)
barWrapper.Position = UDim2.new(0.5, -75, 1, -35)
barWrapper.BackgroundTransparency = 1
barWrapper.ZIndex = 100

local bar = Instance.new("TextButton", barWrapper)
bar.Name = "OpenBar"
bar.Size = UDim2.new(1, 0, 0, 6)
bar.Position = UDim2.new(0, 0, 0, 12)
bar.BackgroundColor3 = Color3.fromRGB(150, 150, 150)
bar.BorderSizePixel = 0
bar.Text = ""
bar.ZIndex = 101
Instance.new("UICorner", bar).CornerRadius = UDim.new(1, 0)

----------------------------------------------------
-- Panel Principal
----------------------------------------------------
local AccentColor = Color3.fromRGB(255, 255, 255) -- Color de acento por defecto

local panel = Instance.new("Frame")
panel.Name = "MainPanel"
panel.AnchorPoint = Vector2.new(0.5, 0.5)
panel.Position = UDim2.new(0.5, 0, 1.5, 0)
panel.Size = UDim2.new(0, 580, 0, 400)
panel.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
panel.BorderSizePixel = 0
panel.ClipsDescendants = true
panel.ZIndex = 10
panel.Active = true -- ¡ESTO EVITA QUE EL CLIC TRASPASE EL PANEL!
panel.Parent = gui
Instance.new("UICorner", panel).CornerRadius = UDim.new(0, 12)

local panelStroke = Instance.new("UIStroke", panel)
panelStroke.Color = Color3.fromRGB(50, 50, 50)

----------------------------------------------------
-- Sistema de Arrastre
----------------------------------------------------
local header = Instance.new("Frame")
header.Size = UDim2.new(1, 0, 0, 60)
header.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
header.BorderSizePixel = 0
header.Active = true
header.ZIndex = 11
header.Parent = panel

local dragging, dragStart, startPos
header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = panel.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then dragging = false end
        end)
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        panel.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

local headerBottomLine = Instance.new("Frame")
headerBottomLine.Size = UDim2.new(1, 0, 0, 1)
headerBottomLine.Position = UDim2.new(0, 0, 1, -1)
headerBottomLine.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
headerBottomLine.BorderSizePixel = 0
headerBottomLine.ZIndex = 11
headerBottomLine.Parent = header

local pfp = Instance.new("ImageLabel")
pfp.Size = UDim2.new(0, 40, 0, 40)
pfp.Position = UDim2.new(0, 15, 0, 10)
pfp.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
pfp.Image = Players:GetUserThumbnailAsync(LocalPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420)
pfp.ZIndex = 11
pfp.Parent = header
Instance.new("UICorner", pfp).CornerRadius = UDim.new(1, 0)

local userText = Instance.new("TextLabel")
userText.Size = UDim2.new(0, 200, 0, 20)
userText.Position = UDim2.new(0, 65, 0, 20)
userText.BackgroundTransparency = 1
userText.Text = "Welcome, " .. LocalPlayer.DisplayName
userText.TextColor3 = Color3.fromRGB(240, 240, 240)
userText.Font = Enum.Font.GothamMedium
userText.TextSize = 14
userText.TextXAlignment = Enum.TextXAlignment.Left
userText.ZIndex = 11
userText.Parent = header

----------------------------------------------------
-- Dock (Menú Inferior)
----------------------------------------------------
local dock = Instance.new("Frame")
dock.Size = UDim2.new(1, 0, 0, 50)
dock.Position = UDim2.new(0, 0, 1, -50)
dock.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
dock.BorderSizePixel = 0
dock.ZIndex = 11
dock.Parent = panel

local dockTopLine = Instance.new("Frame")
dockTopLine.Size = UDim2.new(1, 0, 0, 1)
dockTopLine.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
dockTopLine.BorderSizePixel = 0
dockTopLine.ZIndex = 11
dockTopLine.Parent = dock

local tabContainer = Instance.new("Frame")
tabContainer.Size = UDim2.new(1, -20, 1, -10)
tabContainer.Position = UDim2.new(0, 10, 0, 5)
tabContainer.BackgroundTransparency = 1
tabContainer.ZIndex = 11
tabContainer.Parent = dock

local tabLayout = Instance.new("UIListLayout", tabContainer)
tabLayout.FillDirection = Enum.FillDirection.Horizontal
tabLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
tabLayout.Padding = UDim.new(0, 5) -- Ajustado para caber más pestañas

local pagesContainer = Instance.new("Frame")
pagesContainer.Size = UDim2.new(1, -20, 1, -110)
pagesContainer.Position = UDim2.new(0, 10, 0, 60)
pagesContainer.BackgroundTransparency = 1
pagesContainer.ZIndex = 10
pagesContainer.Parent = panel

local pages = {}
local tabButtons = {}
local activeIndicators = {}

local function createTab(name)
    local tabBtn = Instance.new("TextButton")
    tabBtn.Size = UDim2.new(0, 95, 1, 0)
    tabBtn.BackgroundTransparency = 1
    tabBtn.Text = name
    tabBtn.TextColor3 = Color3.fromRGB(120, 120, 120)
    tabBtn.Font = Enum.Font.GothamSemibold
    tabBtn.TextSize = 13
    tabBtn.ZIndex = 12
    tabBtn.Parent = tabContainer

    local indicator = Instance.new("Frame")
    indicator.Size = UDim2.new(0, 0, 0, 2)
    indicator.Position = UDim2.new(0.5, 0, 1, -2)
    indicator.AnchorPoint = Vector2.new(0.5, 0)
    indicator.BackgroundColor3 = AccentColor
    indicator.BorderSizePixel = 0
    indicator.ZIndex = 12
    indicator.Parent = tabBtn

    table.insert(activeIndicators, indicator)

    local page = Instance.new("ScrollingFrame")
    page.Size = UDim2.new(1, 0, 1, -10)
    page.Position = UDim2.new(0, 0, 0, 10)
    page.BackgroundTransparency = 1
    page.BorderSizePixel = 0
    page.ScrollBarThickness = 3
    page.ScrollBarImageColor3 = Color3.fromRGB(80, 80, 80)
    page.Visible = false
    page.ZIndex = 11
    page.Parent = pagesContainer

    local pageLayout = Instance.new("UIListLayout", page)
    pageLayout.Padding = UDim.new(0, 10)
    pageLayout.SortOrder = Enum.SortOrder.LayoutOrder

    table.insert(pages, page)
    table.insert(tabButtons, {btn = tabBtn, ind = indicator})

    tabBtn.MouseButton1Click:Connect(function()
        for _, p in pairs(pages) do p.Visible = false end
        for _, b in pairs(tabButtons) do
            tween(b.btn, 0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, {TextColor3 = Color3.fromRGB(120, 120, 120)})
            tween(b.ind, 0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, {Size = UDim2.new(0, 0, 0, 2)})
        end
        page.Visible = true
        tween(tabBtn, 0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, {TextColor3 = AccentColor})
        tween(indicator, 0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, {Size = UDim2.new(0, 40, 0, 2)})
    end)

    return page
end

local trollTab = createTab("Troll")
local movementTab = createTab("Movement")
local visualsTab = createTab("Visuals")
local worldTab = createTab("World")
local settingsTab = createTab("Settings")

tabButtons[1].btn.TextColor3 = AccentColor
tabButtons[1].ind.Size = UDim2.new(0, 40, 0, 2)
trollTab.Visible = true

local function addSection(page, text)
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, 0, 0, 25)
    lbl.BackgroundTransparency = 1
    lbl.Text = text
    lbl.TextColor3 = AccentColor
    lbl.Font = Enum.Font.GothamBold
    lbl.TextSize = 12
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.ZIndex = 11
    lbl.Parent = page
    
    -- Agregar a la lista para actualizar colores
    local indicator = Instance.new("Frame")
    indicator.Size = UDim2.new(0, 0, 0, 0)
    indicator.Parent = lbl
    table.insert(activeIndicators, lbl) 
end

local function addToggle(page, text, callback)
    local state = false
    local wrapper = Instance.new("Frame")
    wrapper.Size = UDim2.new(1, -10, 0, 40)
    wrapper.BackgroundTransparency = 1
    wrapper.ZIndex = 11
    wrapper.Parent = page

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 1, 0)
    frame.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
    frame.ZIndex = 11
    frame.Parent = wrapper
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 6)

    local stroke = Instance.new("UIStroke", frame)
    stroke.Color = AccentColor
    stroke.Transparency = 1
    table.insert(activeIndicators, stroke)

    wrapper.MouseEnter:Connect(function()
        tween(frame, 0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, {BackgroundColor3 = Color3.fromRGB(28, 28, 28)})
        tween(stroke, 0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, {Transparency = 0})
    end)
    wrapper.MouseLeave:Connect(function()
        tween(frame, 0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, {BackgroundColor3 = Color3.fromRGB(22, 22, 22)})
        tween(stroke, 0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, {Transparency = 1})
    end)

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -60, 1, 0)
    label.Position = UDim2.new(0, 15, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(200, 200, 200)
    label.Font = Enum.Font.Gotham
    label.TextSize = 13
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.ZIndex = 12
    label.Parent = frame

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 40, 0, 20)
    btn.AnchorPoint = Vector2.new(1, 0.5)
    btn.Position = UDim2.new(1, -15, 0.5, 0)
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    btn.Text = ""
    btn.ZIndex = 12
    btn.Parent = frame
    Instance.new("UICorner", btn).CornerRadius = UDim.new(1, 0)

    local circle = Instance.new("Frame")
    circle.Size = UDim2.new(0, 14, 0, 14)
    circle.Position = UDim2.new(0, 3, 0.5, -7)
    circle.BackgroundColor3 = Color3.fromRGB(150, 150, 150)
    circle.ZIndex = 13
    circle.Parent = btn
    Instance.new("UICorner", circle).CornerRadius = UDim.new(1, 0)

    btn.MouseButton1Click:Connect(function()
        state = not state
        tween(btn, 0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, {BackgroundColor3 = state and AccentColor or Color3.fromRGB(40, 40, 40)})
        tween(circle, 0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, {
            Position = state and UDim2.new(1, -17, 0.5, -7) or UDim2.new(0, 3, 0.5, -7),
            BackgroundColor3 = state and Color3.fromRGB(15, 15, 15) or Color3.fromRGB(150, 150, 150)
        })
        pcall(callback, state)
    end)
end

local function addButton(page, text, callback)
    local wrapper = Instance.new("Frame")
    wrapper.Size = UDim2.new(1, -10, 0, 40)
    wrapper.BackgroundTransparency = 1
    wrapper.ZIndex = 11
    wrapper.Parent = page

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 1, 0)
    btn.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(200, 200, 200)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 13
    btn.ZIndex = 11
    btn.Parent = wrapper
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)

    local stroke = Instance.new("UIStroke", btn)
    stroke.Color = AccentColor
    stroke.Transparency = 1
    table.insert(activeIndicators, stroke)

    btn.MouseEnter:Connect(function()
        tween(btn, 0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, {BackgroundColor3 = Color3.fromRGB(28, 28, 28)})
        tween(stroke, 0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, {Transparency = 0})
    end)
    btn.MouseLeave:Connect(function()
        tween(btn, 0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, {BackgroundColor3 = Color3.fromRGB(22, 22, 22)})
        tween(stroke, 0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, {Transparency = 1})
    end)

    btn.MouseButton1Click:Connect(function()
        pcall(callback)
        -- Pequeño efecto de clic
        tween(btn, 0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, {BackgroundColor3 = Color3.fromRGB(40, 40, 40)})
        task.wait(0.1)
        tween(btn, 0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, {BackgroundColor3 = Color3.fromRGB(28, 28, 28)})
    end)
end

----------------------------------------------------
-- FUNCIONES DE TABS
----------------------------------------------------

-- TROLL TAB
addSection(trollTab, "Mic Up Tools")
local spinConnection
addToggle(trollTab, "Spin Avatar", function(state)
    if state then
        spinConnection = RunService.RenderStepped:Connect(function()
            local char = LocalPlayer.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                char.HumanoidRootPart.CFrame = char.HumanoidRootPart.CFrame * CFrame.Angles(0, math.rad(25), 0)
            end
        end)
    else
        if spinConnection then spinConnection:Disconnect() end
    end
end)

local flingConnection
addToggle(trollTab, "Fling Aura (Spin rápido)", function(state)
    if state then
        flingConnection = RunService.RenderStepped:Connect(function()
            local char = LocalPlayer.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                char.HumanoidRootPart.CFrame = char.HumanoidRootPart.CFrame * CFrame.Angles(0, math.rad(50), 0)
                char.HumanoidRootPart.Velocity = Vector3.new(0, 50, 0)
            end
        end)
    else
        if flingConnection then flingConnection:Disconnect() end
    end
end)

local noclipConnection
addToggle(trollTab, "Noclip (Atravesar Todo)", function(state)
    if state then
        noclipConnection = RunService.Stepped:Connect(function()
            local char = LocalPlayer.Character
            if char then
                for _, part in pairs(char:GetDescendants()) do
                    if part:IsA("BasePart") then part.CanCollide = false end
                end
            end
        end)
    else
        if noclipConnection then noclipConnection:Disconnect() end
    end
end)

local spamming = false
addToggle(trollTab, "Chat Spam (Zengor on top)", function(state)
    spamming = state
    task.spawn(function()
        while spamming do
            pcall(function()
                ReplicatedStorage.DefaultChatSystemChatEvents.SayMessageRequest:FireServer("Zengor Admin on top 🚀", "All")
            end)
            task.wait(2.5)
        end
    end)
end)

-- MOVEMENT TAB
addSection(movementTab, "Local Physics")
addToggle(movementTab, "WalkSpeed (50)", function(state)
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("Humanoid") then char.Humanoid.WalkSpeed = state and 50 or 16 end
end)

addToggle(movementTab, "JumpPower (100)", function(state)
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("Humanoid") then char.Humanoid.JumpPower = state and 100 or 50 end
end)

addToggle(movementTab, "Low Gravity", function(state)
    workspace.Gravity = state and 50 or 196.2
end)

local infJumpConnection
addToggle(movementTab, "Infinite Jump", function(state)
    if state then
        infJumpConnection = UserInputService.JumpRequest:Connect(function()
            local char = LocalPlayer.Character
            if char and char:FindFirstChild("Humanoid") then
                char.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end)
    else
        if infJumpConnection then infJumpConnection:Disconnect() end
    end
end)

-- VISUALS TAB
addSection(visualsTab, "Render & ESP")
local espHighlights = {}
addToggle(visualsTab, "ESP Chams", function(state)
    if state then
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character then
                local hl = Instance.new("Highlight")
                hl.FillColor = AccentColor
                hl.FillTransparency = 0.5
                hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                hl.Parent = player.Character
                espHighlights[player.Name] = hl
            end
        end
    else
        for _, hl in pairs(espHighlights) do if hl then hl:Destroy() end end
        espHighlights = {}
    end
end)

local tracerConnection
local tracers = {}
addToggle(visualsTab, "ESP Tracers", function(state)
    if state then
        tracerConnection = RunService.RenderStepped:Connect(function()
            for _, player in pairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                    local hrp = player.Character.HumanoidRootPart
                    local camera = workspace.CurrentCamera
                    local vector, onScreen = camera:WorldToViewportPoint(hrp.Position)
                    
                    if onScreen then
                        if not tracers[player.Name] then
                            local line = Drawing.new("Line")
                            line.Visible = true
                            line.Color = AccentColor
                            line.Thickness = 1
                            line.Transparency = 1
                            tracers[player.Name] = line
                        end
                        tracers[player.Name].From = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y)
                        tracers[player.Name].To = Vector2.new(vector.X, vector.Y)
                    else
                        if tracers[player.Name] then
                            tracers[player.Name].Visible = false
                        end
                    end
                elseif tracers[player.Name] then
                    tracers[player.Name]:Remove()
                    tracers[player.Name] = nil
                end
            end
        end)
    else
        if tracerConnection then tracerConnection:Disconnect() end
        for _, line in pairs(tracers) do line:Remove() end
        tracers = {}
    end
end)

addToggle(visualsTab, "Fullbright", function(state)
    Lighting.Ambient = state and Color3.new(1, 1, 1) or Color3.fromRGB(138, 138, 138)
end)

-- WORLD TAB
addSection(worldTab, "Environment")
local defaultTime = Lighting.ClockTime
addToggle(worldTab, "Always Day", function(state)
    Lighting.ClockTime = state and 14 or defaultTime
end)

local defaultFog = Lighting.FogEnd
addToggle(worldTab, "No Fog", function(state)
    Lighting.FogEnd = state and 100000 or defaultFog
end)

local defaultShadows = Lighting.GlobalShadows
addToggle(worldTab, "Disable Shadows", function(state)
    Lighting.GlobalShadows = state and false or defaultShadows
end)

-- SETTINGS TAB
addSection(settingsTab, "Theme Colors")

local function changeAccentColor(color)
    AccentColor = color
    -- Actualizar colores en la interfaz dinámicamente
    for _, element in pairs(activeIndicators) do
        if element:IsA("UIStroke") then
            element.Color = color
        elseif element:IsA("Frame") then
            element.BackgroundColor3 = color
        elseif element:IsA("TextLabel") then
            element.TextColor3 = color
        end
    end
    -- Actualizar el botón de la pestaña activa
    for _, b in pairs(tabButtons) do
        if b.ind.Size.X.Offset > 0 then
            b.btn.TextColor3 = color
        end
    end
end

addButton(settingsTab, "Red Theme", function() changeAccentColor(Color3.fromRGB(255, 50, 50)) end)
addButton(settingsTab, "Blue Theme", function() changeAccentColor(Color3.fromRGB(50, 150, 255)) end)
addButton(settingsTab, "Purple Theme", function() changeAccentColor(Color3.fromRGB(180, 50, 255)) end)
addButton(settingsTab, "White Theme (Default)", function() changeAccentColor(Color3.fromRGB(255, 255, 255)) end)

addSection(settingsTab, "System")
addButton(settingsTab, "Destroy GUI", function()
    gui:Destroy()
    if blur then blur:Destroy() end
    if tracerConnection then tracerConnection:Disconnect() end
    for _, line in pairs(tracers) do line:Remove() end
end)

----------------------------------------------------
-- Lógica de Apertura / Cierre
----------------------------------------------------
local opened = false
local function toggleMenu()
    opened = not opened
    if opened then
        clickBlocker.Visible = true
        -- Panel se abre más cerca del botón inferior (0.6 en vez de 0.5)
        tween(panel, 0.55, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out, {Position = UDim2.new(0.5, 0, 0.6, 0)})
        tween(blur, 0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, {Size = 14})
    else
        clickBlocker.Visible = false
        tween(panel, 0.45, Enum.EasingStyle.Exponential, Enum.EasingDirection.In, {Position = UDim2.new(0.5, 0, 1.5, 0)})
        tween(blur, 0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, {Size = 0})
    end
end

bar.MouseEnter:Connect(function() tween(bar, 0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, {BackgroundColor3 = Color3.fromRGB(255, 255, 255)}) end)
bar.MouseLeave:Connect(function() tween(bar, 0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, {BackgroundColor3 = Color3.fromRGB(150, 150, 150)}) end)
bar.MouseButton1Click:Connect(function() toggleMenu() end)
clickBlocker.MouseButton1Click:Connect(function() if opened then toggleMenu() end end)
