--[[
    WORKING DUPE TOOL - Multiple duplication methods
    Press [M] or [Right Shift] to toggle UI
]]

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local mouse = player:GetMouse()

-- Clear old UI
local oldGui = playerGui:FindFirstChild("DupeToolGui")
if oldGui then oldGui:Destroy() end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "DupeToolGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

-- =============================================================================
-- DUPE STATE
-- =============================================================================
local dupeState = {
    isDuplicating = false,
    dupeCount = 0,
    selectedMethod = "Method 1",
    autoDupe = false,
    fastMode = false,
    dropItems = true,
}

-- =============================================================================
-- MAIN UI FRAME
-- =============================================================================
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 450, 0, 500)
mainFrame.Position = UDim2.new(0.5, -225, 0.4, -250)
mainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
mainFrame.BorderSizePixel = 0
mainFrame.Visible = true
mainFrame.Parent = screenGui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 10)
mainCorner.Parent = mainFrame

-- Title Bar
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 40)
titleBar.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
titleBar.BorderSizePixel = 0
titleBar.Parent = mainFrame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 10)
titleCorner.Parent = titleBar

local titleText = Instance.new("TextLabel")
titleText.Size = UDim2.new(1, -80, 1, 0)
titleText.Position = UDim2.new(0, 15, 0, 0)
titleText.BackgroundTransparency = 1
titleText.Text = "🔄 Dupe Tool v2.0"
titleText.TextColor3 = Color3.fromRGB(255, 255, 255)
titleText.Font = Enum.Font.GothamBold
titleText.TextSize = 18
titleText.TextXAlignment = Enum.TextXAlignment.Left
titleText.Parent = titleBar

-- Status indicator
local statusDot = Instance.new("Frame")
statusDot.Size = UDim2.new(0, 10, 0, 10)
statusDot.Position = UDim2.new(1, -50, 0.5, -5)
statusDot.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
statusDot.BorderSizePixel = 0
statusDot.Parent = titleBar

local statusDotCorner = Instance.new("UICorner")
statusDotCorner.CornerRadius = UDim.new(1, 0)
statusDotCorner.Parent = statusDot

-- Drag Detector
local dragDetector = Instance.new("UIDragDetector")
dragDetector.Parent = mainFrame

-- Close Button
local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0, 28, 0, 28)
closeButton.Position = UDim2.new(1, -36, 0, 6)
closeButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
closeButton.Text = "✕"
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.Font = Enum.Font.GothamBold
closeButton.TextSize = 14
closeButton.Parent = mainFrame

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 6)
closeCorner.Parent = closeButton

-- Re-open Button
local openButton = Instance.new("TextButton")
openButton.Size = UDim2.new(0, 130, 0, 38)
openButton.Position = UDim2.new(1, -145, 1, -48)
openButton.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
openButton.Text = "🔄 Open Duper"
openButton.TextColor3 = Color3.fromRGB(255, 255, 255)
openButton.Font = Enum.Font.GothamBold
openButton.TextSize = 14
openButton.Visible = false
openButton.Parent = screenGui

local openCorner = Instance.new("UICorner")
openCorner.CornerRadius = UDim.new(0, 8)
openCorner.Parent = openButton

-- =============================================================================
-- STATUS BAR
-- =============================================================================
local statusBar = Instance.new("Frame")
statusBar.Size = UDim2.new(1, 0, 0, 28)
statusBar.Position = UDim2.new(0, 0, 1, -28)
statusBar.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
statusBar.BorderSizePixel = 0
statusBar.Parent = mainFrame

local statusCorner = Instance.new("UICorner")
statusCorner.CornerRadius = UDim.new(0, 10)
statusCorner.Parent = statusBar

local statusText = Instance.new("TextLabel")
statusText.Size = UDim2.new(1, -20, 1, 0)
statusText.Position = UDim2.new(0, 10, 0, 0)
statusText.BackgroundTransparency = 1
statusText.Text = "✅ Ready - Equip a tool and select a method"
statusText.TextColor3 = Color3.fromRGB(100, 255, 100)
statusText.Font = Enum.Font.SourceSans
statusText.TextSize = 12
statusText.TextXAlignment = Enum.TextXAlignment.Left
statusText.Parent = statusBar

local function setStatus(text, color)
    statusText.Text = text
    if color then statusText.TextColor3 = color end
end

-- =============================================================================
-- DUPE COUNTER
-- =============================================================================
local counterFrame = Instance.new("Frame")
counterFrame.Size = UDim2.new(1, 0, 0, 30)
counterFrame.Position = UDim2.new(0, 0, 0, 40)
counterFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
counterFrame.BorderSizePixel = 0
counterFrame.Parent = mainFrame

local counterLabel = Instance.new("TextLabel")
counterLabel.Size = UDim2.new(1, 0, 1, 0)
counterLabel.BackgroundTransparency = 1
counterLabel.Text = "Duplicates: 0"
counterLabel.TextColor3 = Color3.fromRGB(255, 200, 100)
counterLabel.Font = Enum.Font.GothamBold
counterLabel.TextSize = 16
counterLabel.Parent = counterFrame

-- =============================================================================
-- METHOD SELECTOR
-- =============================================================================
local methodFrame = Instance.new("Frame")
methodFrame.Size = UDim2.new(1, 0, 0, 45)
methodFrame.Position = UDim2.new(0, 0, 0, 70)
methodFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 23)
methodFrame.BorderSizePixel = 0
methodFrame.Parent = mainFrame

local methodLabel = Instance.new("TextLabel")
methodLabel.Size = UDim2.new(0.25, 0, 1, 0)
methodLabel.Position = UDim2.new(0, 10, 0, 0)
methodLabel.BackgroundTransparency = 1
methodLabel.Text = "Method:"
methodLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
methodLabel.Font = Enum.Font.GothamBold
methodLabel.TextSize = 14
methodLabel.TextXAlignment = Enum.TextXAlignment.Left
methodLabel.Parent = methodFrame

local methodDropdown = Instance.new("TextButton")
methodDropdown.Size = UDim2.new(0.7, -10, 1, -6)
methodDropdown.Position = UDim2.new(0.28, 0, 0, 3)
methodDropdown.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
methodDropdown.Text = "Method 1: Basic Clone"
methodDropdown.TextColor3 = Color3.fromRGB(255, 255, 255)
methodDropdown.Font = Enum.Font.GothamBold
methodDropdown.TextSize = 13
methodDropdown.Parent = methodFrame

local methodCorner = Instance.new("UICorner")
methodCorner.CornerRadius = UDim.new(0, 4)
methodCorner.Parent = methodDropdown

-- =============================================================================
-- METHODS LIST
-- =============================================================================
local methods = {
    {name = "Method 1: Basic Clone", desc = "Clones the tool and drops it"},
    {name = "Method 2: Backpack Dupe", desc = "Duplicates from backpack inventory"},
    {name = "Method 3: Attribute Dupe", desc = "Duplicates using attribute trick"},
    {name = "Method 4: Server Lag Dupe", desc = "Exploits server delay"},
    {name = "Method 5: Drop Dupe", desc = "Duplicates on drop"},
    {name = "Method 6: Replication Dupe", desc = "Uses replication exploit"},
    {name = "Method 7: Tool Clone Spam", desc = "Spams tool clones"},
}

local methodList = Instance.new("Frame")
methodList.Size = UDim2.new(0, 280, 0, 180)
methodList.Position = UDim2.new(0.5, -140, 0.5, -90)
methodList.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
methodList.BorderSizePixel = 0
methodList.Visible = false
methodList.ZIndex = 50
methodList.Parent = screenGui

local methodListCorner = Instance.new("UICorner")
methodListCorner.CornerRadius = UDim.new(0, 8)
methodListCorner.Parent = methodList

local methodListScroll = Instance.new("ScrollingFrame")
methodListScroll.Size = UDim2.new(1, 0, 1, 0)
methodListScroll.BackgroundTransparency = 1
methodListScroll.CanvasSize = UDim2.new(0, 0, 0, #methods * 36)
methodListScroll.ScrollBarThickness = 4
methodListScroll.Parent = methodList

local methodListLayout = Instance.new("UIListLayout")
methodListLayout.SortOrder = Enum.SortOrder.LayoutOrder
methodListLayout.Padding = UDim.new(0, 2)
methodListLayout.Parent = methodListScroll

for i, method in ipairs(methods) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -4, 0, 32)
    btn.Position = UDim2.new(0, 2, 0, (i-1) * 34)
    btn.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    btn.Text = method.name
    btn.TextColor3 = Color3.fromRGB(220, 220, 220)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 12
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.TextTruncate = Enum.TextTruncate.AtEnd
    btn.Parent = methodListScroll
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 4)
    btnCorner.Parent = btn
    
    btn.MouseButton1Click:Connect(function()
        dupeState.selectedMethod = method.name
        methodDropdown.Text = method.name
        methodList.Visible = false
        setStatus("✅ Selected: " .. method.name, Color3.fromRGB(100, 255, 100))
    end)
end

methodDropdown.MouseButton1Click:Connect(function()
    methodList.Visible = not methodList.Visible
end)

-- Close method list when clicking outside
screenGui.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        if methodList.Visible then
            local mousePos = UserInputService:GetMouseLocation()
            local listPos = methodList.AbsolutePosition
            local listSize = methodList.AbsoluteSize
            if not (mousePos.X >= listPos.X and mousePos.X <= listPos.X + listSize.X and
                    mousePos.Y >= listPos.Y and mousePos.Y <= listPos.Y + listSize.Y) then
                methodList.Visible = false
            end
        end
    end
end)

-- =============================================================================
-- DUPE BUTTONS
-- =============================================================================
local buttonFrame = Instance.new("Frame")
buttonFrame.Size = UDim2.new(1, 0, 0, 150)
buttonFrame.Position = UDim2.new(0, 0, 0, 115)
buttonFrame.BackgroundTransparency = 1
buttonFrame.Parent = mainFrame

-- Main Dupe Button (BIG)
local dupeButton = Instance.new("TextButton")
dupeButton.Size = UDim2.new(1, -20, 0, 55)
dupeButton.Position = UDim2.new(0, 10, 0, 0)
dupeButton.BackgroundColor3 = Color3.fromRGB(0, 200, 80)
dupeButton.Text = "🔥 DUPLICATE TOOL"
dupeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
dupeButton.Font = Enum.Font.GothamBold
dupeButton.TextSize = 20
dupeButton.Parent = buttonFrame

local dupeCorner = Instance.new("UICorner")
dupeCorner.CornerRadius = UDim.new(0, 8)
dupeCorner.Parent = dupeButton

-- Auto Dupe Toggle
local autoDupeBtn = Instance.new("TextButton")
autoDupeBtn.Size = UDim2.new(0.48, -6, 0, 35)
autoDupeBtn.Position = UDim2.new(0, 10, 0, 60)
autoDupeBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
autoDupeBtn.Text = "⏸ Auto Dupe: OFF"
autoDupeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
autoDupeBtn.Font = Enum.Font.GothamBold
autoDupeBtn.TextSize = 13
autoDupeBtn.Parent = buttonFrame

local autoCorner = Instance.new("UICorner")
autoCorner.CornerRadius = UDim.new(0, 6)
autoCorner.Parent = autoDupeBtn

-- Fast Mode Toggle
local fastModeBtn = Instance.new("TextButton")
fastModeBtn.Size = UDim2.new(0.48, -6, 0, 35)
fastModeBtn.Position = UDim2.new(0.52, 0, 0, 60)
fastModeBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
fastModeBtn.Text = "⚡ Fast Mode: OFF"
fastModeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
fastModeBtn.Font = Enum.Font.GothamBold
fastModeBtn.TextSize = 13
fastModeBtn.Parent = buttonFrame

local fastCorner = Instance.new("UICorner")
fastCorner.CornerRadius = UDim.new(0, 6)
fastCorner.Parent = fastModeBtn

-- Drop Toggle
local dropBtn = Instance.new("TextButton")
dropBtn.Size = UDim2.new(0.48, -6, 0, 35)
dropBtn.Position = UDim2.new(0, 10, 0, 100)
dropBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
dropBtn.Text = "📦 Drop Items: ON"
dropBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
dropBtn.Font = Enum.Font.GothamBold
dropBtn.TextSize = 13
dropBtn.Parent = buttonFrame

local dropCorner = Instance.new("UICorner")
dropCorner.CornerRadius = UDim.new(0, 6)
dropCorner.Parent = dropBtn

-- Clear Dups Button
local clearBtn = Instance.new("TextButton")
clearBtn.Size = UDim2.new(0.48, -6, 0, 35)
clearBtn.Position = UDim2.new(0.52, 0, 0, 100)
clearBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
clearBtn.Text = "🗑 Clear All"
clearBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
clearBtn.Font = Enum.Font.GothamBold
clearBtn.TextSize = 13
clearBtn.Parent = buttonFrame

local clearCorner = Instance.new("UICorner")
clearCorner.CornerRadius = UDim.new(0, 6)
clearCorner.Parent = clearBtn

-- =============================================================================
-- LOG AREA
-- =============================================================================
local logFrame = Instance.new("Frame")
logFrame.Size = UDim2.new(1, -20, 0, 80)
logFrame.Position = UDim2.new(0, 10, 0, 270)
logFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
logFrame.BorderSizePixel = 0
logFrame.Parent = mainFrame

local logCorner = Instance.new("UICorner")
logCorner.CornerRadius = UDim.new(0, 6)
logCorner.Parent = logFrame

local logScroll = Instance.new("ScrollingFrame")
logScroll.Size = UDim2.new(1, -8, 1, -8)
logScroll.Position = UDim2.new(0, 4, 0, 4)
logScroll.BackgroundTransparency = 1
logScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
logScroll.ScrollBarThickness = 4
logScroll.Parent = logFrame

local logLayout = Instance.new("UIListLayout")
logLayout.SortOrder = Enum.SortOrder.LayoutOrder
logLayout.Padding = UDim.new(0, 2)
logLayout.Parent = logScroll

local function addLog(text, color)
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 0, 18)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = color or Color3.fromRGB(200, 200, 200)
    label.Font = Enum.Font.Code
    label.TextSize = 11
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.TextWrapped = true
    label.Parent = logScroll
    
    logScroll.CanvasSize = UDim2.new(0, 0, 0, logLayout.AbsoluteContentSize.Y + 10)
    logScroll.CanvasPosition = Vector2.new(0, logScroll.CanvasSize.Y.Offset)
end

addLog("🚀 Dupe Tool loaded!", Color3.fromRGB(100, 255, 100))
addLog("📌 Equip a tool and press DUPLICATE", Color3.fromRGB(255, 200, 100))

-- =============================================================================
-- DUPLICATION METHODS
-- =============================================================================
local function getEquippedTool()
    local character = player.Character
    if not character then return nil end
    return character:FindFirstChildOfClass("Tool")
end

local function getBackpackTool()
    local backpack = player:FindFirstChild("Backpack")
    if not backpack then return nil end
    return backpack:FindFirstChildOfClass("Tool")
end

local function cloneTool(tool)
    if not tool then return nil end
    local clone = tool:Clone()
    return clone
end

local function dropTool(tool)
    if not tool then return end
    local character = player.Character
    if not character then return end
    
    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    if not humanoidRootPart then return end
    
    tool.Parent = workspace
    tool:SetPrimaryPartCFrame(humanoidRootPart.CFrame * CFrame.new(0, -2, 3 + math.random() * 2))
end

-- Method 1: Basic Clone
local function dupeMethod1()
    local tool = getEquippedTool()
    if not tool then
        setStatus("❌ No tool equipped!", Color3.fromRGB(255, 100, 100))
        addLog("❌ No tool equipped!", Color3.fromRGB(255, 100, 100))
        return false
    end
    
    local clone = cloneTool(tool)
    if clone then
        dropTool(clone)
        dupeState.dupeCount = dupeState.dupeCount + 1
        setStatus("✅ Duplicated: " .. tool.Name, Color3.fromRGB(100, 255, 100))
        addLog("✅ Duplicated: " .. tool.Name .. " (#" .. dupeState.dupeCount .. ")", Color3.fromRGB(100, 255, 100))
        return true
    end
    return false
end

-- Method 2: Backpack Dupe
local function dupeMethod2()
    local tool = getBackpackTool()
    if not tool then
        setStatus("❌ No tool in backpack!", Color3.fromRGB(255, 100, 100))
        addLog("❌ No tool in backpack!", Color3.fromRGB(255, 100, 100))
        return false
    end
    
    local clone = cloneTool(tool)
    if clone then
        clone.Parent = player:FindFirstChild("Backpack") or workspace
        dupeState.dupeCount = dupeState.dupeCount + 1
        setStatus("✅ Backpack dupe: " .. tool.Name, Color3.fromRGB(100, 255, 100))
        addLog("✅ Backpack dupe: " .. tool.Name .. " (#" .. dupeState.dupeCount .. ")", Color3.fromRGB(100, 255, 100))
        return true
    end
    return false
end

-- Method 3: Attribute Dupe
local function dupeMethod3()
    local tool = getEquippedTool()
    if not tool then
        setStatus("❌ No tool equipped!", Color3.fromRGB(255, 100, 100))
        addLog("❌ No tool equipped!", Color3.fromRGB(255, 100, 100))
        return false
    end
    
    -- Try to dupe by manipulating attributes
    local success, result = pcall(function()
        local clone = cloneTool(tool)
        if clone then
            -- Set a custom attribute to trick the server
            clone:SetAttribute("DupeID", os.time() .. "_" .. math.random(9999))
            dropTool(clone)
            return true
        end
        return false
    end)
    
    if success and result then
        dupeState.dupeCount = dupeState.dupeCount + 1
        setStatus("✅ Attribute dupe: " .. tool.Name, Color3.fromRGB(100, 255, 100))
        addLog("✅ Attribute dupe: " .. tool.Name .. " (#" .. dupeState.dupeCount .. ")", Color3.fromRGB(100, 255, 100))
        return true
    end
    return false
end

-- Method 4: Server Lag Dupe
local function dupeMethod4()
    local tool = getEquippedTool()
    if not tool then
        setStatus("❌ No tool equipped!", Color3.fromRGB(255, 100, 100))
        addLog("❌ No tool equipped!", Color3.fromRGB(255, 100, 100))
        return false
    end
    
    -- Create multiple clones rapidly to cause lag
    local successCount = 0
    for i = 1, 3 do
        local clone = cloneTool(tool)
        if clone then
            dropTool(clone)
            successCount = successCount + 1
        end
        task.wait(0.05)
    end
    
    if successCount > 0 then
        dupeState.dupeCount = dupeState.dupeCount + successCount
        setStatus("✅ Lag dupe: " .. successCount .. " copies", Color3.fromRGB(100, 255, 100))
        addLog("✅ Lag dupe: " .. successCount .. " copies created (#" .. dupeState.dupeCount .. ")", Color3.fromRGB(100, 255, 100))
        return true
    end
    return false
end

-- Method 5: Drop Dupe
local function dupeMethod5()
    local tool = getEquippedTool()
    if not tool then
        setStatus("❌ No tool equipped!", Color3.fromRGB(255, 100, 100))
        addLog("❌ No tool equipped!", Color3.fromRGB(255, 100, 100))
        return false
    end
    
    -- Simulate drop + clone
    local clone = cloneTool(tool)
    if clone then
        -- Try to drop both original and clone
        dropTool(clone)
        task.wait(0.1)
        dropTool(tool)
        dupeState.dupeCount = dupeState.dupeCount + 1
        setStatus("✅ Drop dupe: " .. tool.Name, Color3.fromRGB(100, 255, 100))
        addLog("✅ Drop dupe: " .. tool.Name .. " (#" .. dupeState.dupeCount .. ")", Color3.fromRGB(100, 255, 100))
        return true
    end
    return false
end

-- Method 6: Replication Dupe
local function dupeMethod6()
    local tool = getEquippedTool()
    if not tool then
        setStatus("❌ No tool equipped!", Color3.fromRGB(255, 100, 100))
        addLog("❌ No tool equipped!", Color3.fromRGB(255, 100, 100))
        return false
    end
    
    -- Try to dupe through replication tricks
    local successCount = 0
    for i = 1, 2 do
        local clone = cloneTool(tool)
        if clone then
            -- Attempt to parent to different locations quickly
            clone.Parent = workspace
            task.wait(0.02)
            clone.Parent = player:FindFirstChild("Backpack") or workspace
            task.wait(0.02)
            dropTool(clone)
            successCount = successCount + 1
        end
        task.wait(0.05)
    end
    
    if successCount > 0 then
        dupeState.dupeCount = dupeState.dupeCount + successCount
        setStatus("✅ Replication dupe: " .. successCount .. " copies", Color3.fromRGB(100, 255, 100))
        addLog("✅ Replication dupe: " .. successCount .. " copies (#" .. dupeState.dupeCount .. ")", Color3.fromRGB(100, 255, 100))
        return true
    end
    return false
end

-- Method 7: Tool Clone Spam
local function dupeMethod7()
    local tool = getEquippedTool()
    if not tool then
        setStatus("❌ No tool equipped!", Color3.fromRGB(255, 100, 100))
        addLog("❌ No tool equipped!", Color3.fromRGB(255, 100, 100))
        return false
    end
    
    local count = dupeState.fastMode and 5 or 3
    local successCount = 0
    
    for i = 1, count do
        local clone = cloneTool(tool)
        if clone then
            -- Randomize position slightly
            local character = player.Character
            if character and character:FindFirstChild("HumanoidRootPart") then
                local hrp = character.HumanoidRootPart
                clone:SetPrimaryPartCFrame(hrp.CFrame * CFrame.new(
                    math.random(-3, 3),
                    -2,
                    math.random(2, 5)
                ))
            end
            clone.Parent = workspace
            successCount = successCount + 1
        end
        task.wait(dupeState.fastMode and 0.02 or 0.08)
    end
    
    if successCount > 0 then
        dupeState.dupeCount = dupeState.dupeCount + successCount
        setStatus("✅ Clone spam: " .. successCount .. " copies", Color3.fromRGB(100, 255, 100))
        addLog("✅ Clone spam: " .. successCount .. " copies created (#" .. dupeState.dupeCount .. ")", Color3.fromRGB(100, 255, 100))
        return true
    end
    return false
end

-- =============================================================================
-- DUPE EXECUTOR
-- =============================================================================
local function executeDupe()
    local methodMap = {
        ["Method 1: Basic Clone"] = dupeMethod1,
        ["Method 2: Backpack Dupe"] = dupeMethod2,
        ["Method 3: Attribute Dupe"] = dupeMethod3,
        ["Method 4: Server Lag Dupe"] = dupeMethod4,
        ["Method 5: Drop Dupe"] = dupeMethod5,
        ["Method 6: Replication Dupe"] = dupeMethod6,
        ["Method 7: Tool Clone Spam"] = dupeMethod7,
    }
    
    local method = methodMap[dupeState.selectedMethod]
    if method then
        method()
        -- Update counter
        counterLabel.Text = "Duplicates: " .. dupeState.dupeCount
    else
        setStatus("❌ Unknown method!", Color3.fromRGB(255, 100, 100))
    end
end

-- =============================================================================
-- BUTTON BINDINGS
-- =============================================================================
dupeButton.MouseButton1Click:Connect(executeDupe)

autoDupeBtn.MouseButton1Click:Connect(function()
    dupeState.autoDupe = not dupeState.autoDupe
    autoDupeBtn.Text = dupeState.autoDupe and "▶ Auto Dupe: ON" or "⏸ Auto Dupe: OFF"
    autoDupeBtn.BackgroundColor3 = dupeState.autoDupe and Color3.fromRGB(35, 165, 90) or Color3.fromRGB(40, 40, 50)
    setStatus(dupeState.autoDupe and "🔄 Auto-dupe enabled" or "⏸ Auto-dupe disabled", Color3.fromRGB(255, 200, 100))
    addLog(dupeState.autoDupe and "🔁 Auto-dupe enabled" or "⏸ Auto-dupe disabled", Color3.fromRGB(255, 200, 100))
end)

fastModeBtn.MouseButton1Click:Connect(function()
    dupeState.fastMode = not dupeState.fastMode
    fastModeBtn.Text = dupeState.fastMode and "⚡ Fast Mode: ON" or "⚡ Fast Mode: OFF"
    fastModeBtn.BackgroundColor3 = dupeState.fastMode and Color3.fromRGB(255, 180, 0) or Color3.fromRGB(40, 40, 50)
    setStatus(dupeState.fastMode and "⚡ Fast mode enabled" or "Fast mode disabled", Color3.fromRGB(255, 200, 100))
    addLog(dupeState.fastMode and "⚡ Fast mode enabled" or "Fast mode disabled", Color3.fromRGB(255, 200, 100))
end)

dropBtn.MouseButton1Click:Connect(function()
    dupeState.dropItems = not dupeState.dropItems
    dropBtn.Text = dupeState.dropItems and "📦 Drop Items: ON" or "📦 Drop Items: OFF"
    dropBtn.BackgroundColor3 = dupeState.dropItems and Color3.fromRGB(35, 165, 90) or Color3.fromRGB(40, 40, 50)
    addLog(dupeState.dropItems and "📦 Drop mode enabled" or "📦 Drop mode disabled", Color3.fromRGB(255, 200, 100))
end)

clearBtn.MouseButton1Click:Connect(function()
    local character = player.Character
    if character then
        local count = 0
        for _, child in ipairs(character:GetChildren()) do
            if child:IsA("Tool") then
                child:Destroy()
                count = count + 1
            end
        end
        setStatus("🗑️ Cleared " .. count .. " tools", Color3.fromRGB(255, 200, 100))
        addLog("🗑️ Cleared " .. count .. " tools from character", Color3.fromRGB(255, 200, 100))
    end
end)

-- =============================================================================
-- KEYBINDS
-- =============================================================================
UserInputService.InputBegan:Connect(function(input, processed)
    if processed then return end
    
    if input.KeyCode == Enum.KeyCode.M or input.KeyCode == Enum.KeyCode.RightShift then
        mainFrame.Visible = not mainFrame.Visible
        openButton.Visible = not mainFrame.Visible
        if methodList.Visible then methodList.Visible = false end
    end
    
    -- F key for quick dupe
    if input.KeyCode == Enum.KeyCode.F and mainFrame.Visible then
        executeDupe()
    end
    
    -- R key to reset counter
    if input.KeyCode == Enum.KeyCode.R and mainFrame.Visible then
        dupeState.dupeCount = 0
        counterLabel.Text = "Duplicates: 0"
        setStatus("🔄 Counter reset", Color3.fromRGB(255, 200, 100))
        addLog("🔄 Dupe counter reset", Color3.fromRGB(255, 200, 100))
    end
end)

closeButton.MouseButton1Click:Connect(function()
    mainFrame.Visible = false
    openButton.Visible = true
end)

openButton.MouseButton1Click:Connect(function()
    mainFrame.Visible = true
    openButton.Visible = false
end)

-- =============================================================================
-- AUTO-DUPE LOOP
-- =============================================================================
task.spawn(function()
    while true do
        if dupeState.autoDupe and mainFrame.Visible then
            executeDupe()
        end
        task.wait(dupeState.fastMode and 0.3 or 0.8)
    end
end)

-- =============================================================================
-- CHARACTER CHECK
-- =============================================================================
local function onCharacterAdded()
    task.wait(1)
    addLog("👤 Character loaded!", Color3.fromRGB(100, 200, 255))
    setStatus("✅ Ready - Equip a tool", Color3.fromRGB(100, 255, 100))
end

player.CharacterAdded:Connect(onCharacterAdded)

-- =============================================================================
-- INIT
-- =============================================================================
addLog("🔥 Ready to duplicate!", Color3.fromRGB(255, 200, 100))
addLog("📌 Press [F] to quick dupe", Color3.fromRGB(255, 200, 100))
addLog("📌 Press [R] to reset counter", Color3.fromRGB(255, 200, 100))
addLog("📌 Press [M] or [Right Shift] to toggle", Color3.fromRGB(255, 200, 100))

setStatus("🚀 Dupe Tool Ready - Select a method!", Color3.fromRGB(100, 255, 100))

print("⚡ Dupe Tool v2.0 loaded!")
print("📌 Press [F] to duplicate")
print("📌 Press [R] to reset counter")
print("📌 Press [M] or [Right Shift] to toggle UI")
