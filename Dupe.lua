local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- 1. PERSISTENT INJECTION CONTAINER
local oldGui = playerGui:FindFirstChild("UnifiedDevSuiteGui")
if oldGui then oldGui:Destroy() end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "UnifiedDevSuiteGui"
screenGui.ResetOnSpawn = false
screenGui.DisplayOrder = 999999
screenGui.Parent = playerGui

-- Runtime Global States
local selectedTargetPlayer = player
local activeTab = "Player" 
local currentNavigationPath = {} 

-- 2. MODULAR COMPACT UI BUILDER
local function create(class, parent, props)
	local inst = Instance.new(class)
	for k, v in pairs(props) do inst[k] = v end
	inst.Parent = parent
	return inst
end

-- Base Frames
local mainFrame = create("Frame", screenGui, {Size = UDim2.new(0, 520, 0, 440), Position = UDim2.new(0.5, -260, 0.4, -220), BackgroundColor3 = Color3.fromRGB(24, 24, 28), BorderSizePixel = 0, Active = true})
create("UICorner", mainFrame, {CornerRadius = UDim.new(0, 8)})
create("UIStroke", mainFrame, {Color = Color3.fromRGB(45, 45, 52), Thickness = 1})
create("UIDragDetector", mainFrame, {})

-- Top Bar Panel
local titleBar = create("Frame", mainFrame, {Size = UDim2.new(1, 0, 0, 35), BackgroundColor3 = Color3.fromRGB(16, 16, 20), BorderSizePixel = 0})
create("UICorner", titleBar, {CornerRadius = UDim.new(0, 8)})
create("TextLabel", titleBar, {Size = UDim2.new(1, -60, 1, 0), Position = UDim2.new(0, 12, 0, 0), BackgroundTransparency = 1, Text = "⚙️ Advanced Tool & Character Architecture Suite", TextColor3 = Color3.fromRGB(255, 255, 255), Font = Enum.Font.SourceSansBold, TextSize = 14, TextXAlignment = Enum.TextXAlignment.Left})

local closeButton = create("TextButton", mainFrame, {Size = UDim2.new(0, 24, 0, 24), Position = UDim2.new(1, -30, 0, 5), BackgroundColor3 = Color3.fromRGB(190, 55, 55), Text = "X", TextColor3 = Color3.fromRGB(255, 255, 255), Font = Enum.Font.SourceSansBold, TextSize = 12, ZIndex = 100})
create("UICorner", closeButton, {CornerRadius = UDim.new(0, 4)})

-- Player Selector Dropdown Elements
local playerDropdownBtn = create("TextButton", mainFrame, {Size = UDim2.new(0, 180, 0, 28), Position = UDim2.new(0, 12, 0, 45), BackgroundColor3 = Color3.fromRGB(36, 36, 42), Text = "Target: LocalPlayer ▼", TextColor3 = Color3.fromRGB(240, 240, 245), Font = Enum.Font.SourceSansBold, TextSize = 13})
create("UICorner", playerDropdownBtn, {CornerRadius = UDim.new(0, 4)})

local dropdownScroll = create("ScrollingFrame", screenGui, {Size = UDim2.new(0, 180, 0, 120), BackgroundColor3 = Color3.fromRGB(18, 18, 22), BorderSizePixel = 0, Visible = false, ZIndex = 5000, ScrollBarThickness = 5})
local ddsList = create("UIListLayout", dropdownScroll, {SortOrder = Enum.SortOrder.LayoutOrder})

local function realignDropdown()
	dropdownScroll.Position = UDim2.new(0, playerDropdownBtn.AbsolutePosition.X, 0, playerDropdownBtn.AbsolutePosition.Y + playerDropdownBtn.AbsoluteSize.Y + 36)
end
mainFrame:GetPropertyChangedSignal("Position"):Connect(realignDropdown)

-- Tab Navigation Panel
local tabContainer = create("Frame", mainFrame, {Size = UDim2.new(1, -216, 0, 28), Position = UDim2.new(0, 204, 0, 45), BackgroundTransparency = 1})
local tabLayout = create("UIListLayout", tabContainer, {FillDirection = Enum.FillDirection.Horizontal, Padding = UDim.new(0, 6), SortOrder = Enum.SortOrder.LayoutOrder})

-- View Panels
local contentCanvas = create("ScrollingFrame", mainFrame, {Size = UDim2.new(1, -24, 1, -125), Position = UDim2.new(0, 12, 0, 85), BackgroundColor3 = Color3.fromRGB(14, 14, 18), BorderSizePixel = 0, CanvasSize = UDim2.new(0, 0, 0, 0), ScrollBarThickness = 6})
create("UICorner", contentCanvas, {CornerRadius = UDim.new(0, 6)})
local canvasLayout = create("UIListLayout", contentCanvas, {SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 5)})
create("UIPadding", contentCanvas, {PaddingLeft = UDim.new(0, 8), PaddingTop = UDim.new(0, 8), PaddingRight = UDim.new(0, 8)})

-- Status Readout Panel
local statusPanel = create("TextLabel", mainFrame, {Size = UDim2.new(1, -24, 0, 30), Position = UDim2.new(0, 12, 1, -38), BackgroundColor3 = Color3.fromRGB(18, 18, 22), Text = "Suite Ready.", TextColor3 = Color3.fromRGB(140, 140, 150), Font = Enum.Font.SourceSansItalic, TextSize = 13, TextXAlignment = Enum.TextXAlignment.Center})
create("UICorner", statusPanel, {CornerRadius = UDim.new(0, 4)})

-- =============================================================================
-- 3. ATTRIBUTE & SCRIPT EDITOR MODAL WINDOW
-- =============================================================================
local editModal = create("Frame", screenGui, {Size = UDim2.new(0, 380, 0, 240), Position = UDim2.new(0.5, -190, 0.5, -120), BackgroundColor3 = Color3.fromRGB(28, 28, 34), BorderSizePixel = 0, Visible = false, ZIndex = 10000})
create("UICorner", editModal, {CornerRadius = UDim.new(0, 8)})
create("UIStroke", editModal, {Color = Color3.fromRGB(60, 60, 70), Thickness = 1})
create("UIDragDetector", editModal, {})

local modalTitle = create("TextLabel", editModal, {Size = UDim2.new(1, -40, 0, 30), Position = UDim2.new(0, 12, 0, 4), BackgroundTransparency = 1, Text = "Data Context Editor", TextColor3 = Color3.fromRGB(255, 255, 255), Font = Enum.Font.SourceSansBold, TextSize = 14, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 10001})
local modalClose = create("TextButton", editModal, {Size = UDim2.new(0, 20, 0, 20), Position = UDim2.new(1, -26, 0, 5), BackgroundColor3 = Color3.fromRGB(150, 40, 40), Text = "X", TextColor3 = Color3.fromRGB(255, 255, 255), Font = Enum.Font.SourceSansBold, TextSize = 11, ZIndex = 10005})
create("UICorner", modalClose, {CornerRadius = UDim.new(0, 4)})

local modalTextBox = create("TextBox", editModal, {Size = UDim2.new(1, -24, 1, -85), Position = UDim2.new(0, 12, 0, 40), BackgroundColor3 = Color3.fromRGB(16, 16, 20), Text = "", TextColor3 = Color3.fromRGB(230, 230, 235), Font = Enum.Font.Code, TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left, TextYAlignment = Enum.TextYAlignment.Top, TextWrapped = true, MultiLine = true, ClearTextOnFocus = false, ZIndex = 10001})
create("UICorner", modalTextBox, {CornerRadius = UDim.new(0, 4)})

local saveModalBtn = create("TextButton", editModal, {Size = UDim2.new(1, -24, 0, 32), Position = UDim2.new(0, 12, 1, -40), BackgroundColor3 = Color3.fromRGB(35, 130, 80), Text = "SAVE AND COMPILE MODIFICATIONS", TextColor3 = Color3.fromRGB(255, 255, 255), Font = Enum.Font.SourceSansBold, TextSize = 13, ZIndex = 10001})
create("UICorner", saveModalBtn, {CornerRadius = UDim.new(0, 4)})

local currentEditingInstance, currentEditingType, currentEditingKey = nil, nil, nil

local function openEditor(title, initialText, inst, eType, key)
	currentEditingInstance, currentEditingType, currentEditingKey = inst, eType, key
	modalTitle.Text = title
	modalTextBox.Text = initialText
	editModal.Visible = true
end

modalClose.MouseButton1Click:Connect(function() editModal.Visible = false end)

saveModalBtn.MouseButton1Click:Connect(function()
	local entryValue = modalTextBox.Text
	if currentEditingType == "Attribute" then
		local numericCheck = tonumber(entryValue)
		if numericCheck then
			currentEditingInstance:SetAttribute(currentEditingKey, numericCheck)
		elseif entryValue == "true" or entryValue == "false" then
			currentEditingInstance:SetAttribute(currentEditingKey, entryValue == "true")
		else
			currentEditingInstance:SetAttribute(currentEditingKey, entryValue)
		end
		statusPanel.Text = "✅ Attribute context updated successfully."
	elseif currentEditingType == "LocalScript" then
		statusPanel.Text = "❌ Engine security policy blocks live script compilation on clients."
	end
	editModal.Visible = false
end)

-- =============================================================================
-- 4. INTERACTION MANAGEMENT LAYERS
-- =============================================================================
local function clearCanvas()
	for _, c in ipairs(contentCanvas:GetChildren()) do if c:IsA("Frame") or c:IsA("TextButton") then c:Destroy() end end
	contentCanvas.CanvasSize = UDim2.new(0, 0, 0, 0)
end

local function addContentRow(title, buttonText, buttonColor, clickCallback)
	local rowFrame = create("Frame", contentCanvas, {Size = UDim2.new(1, 0, 0, 32), BackgroundColor3 = Color3.fromRGB(20, 20, 24), BorderSizePixel = 0})
	create("UICorner", rowFrame, {CornerRadius = UDim.new(0, 4)})
	
	create("TextLabel", rowFrame, {Size = UDim2.new(1, -120, 1, 0), Position = UDim2.new(0, 10, 0, 0), BackgroundTransparency = 1, Text = title, TextColor3 = Color3.fromRGB(220, 220, 225), Font = Enum.Font.SourceSans, TextSize = 14, TextXAlignment = Enum.TextXAlignment.Left})
	
	if buttonText and clickCallback then
		local actBtn = create("TextButton", rowFrame, {Size = UDim2.new(0, 100, 0, 24), Position = UDim2.new(1, -105, 0.5, -12), BackgroundColor3 = buttonColor, Text = buttonText, TextColor3 = Color3.fromRGB(255, 255, 255), Font = Enum.Font.SourceSansBold, TextSize = 12})
		create("UICorner", actBtn, {CornerRadius = UDim.new(0, 4)})
		actBtn.MouseButton1Click:Connect(clickCallback)
	end
	contentCanvas.CanvasSize = UDim2.new(0, 0, 0, canvasLayout.AbsoluteContentSize.Y + 15)
end

local function getCurrentDirectory()
	local root = selectedTargetPlayer.Character or selectedTargetPlayer.CharacterAdded:Wait()
	for _, folderName in ipairs(currentNavigationPath) do
		local nxt = root:FindFirstChild(folderName)
		if nxt then root = nxt else break end
	end
	return root
end

local renderSuiteViews = {}

renderSuiteViews.Player = function()
	clearCanvas()
	local dir = getCurrentDirectory()
	
	if #currentNavigationPath > 0 then
		addContentRow("📁 .. [Return to Parent]", "BACK ↩️", Color3.fromRGB(70, 70, 80), function()
			table.remove(currentNavigationPath)
			renderSuiteViews.Player()
		end)
	end
	
	addContentRow("--- 📂 EXPLORER TREE ("..dir.Name..") ---", nil, nil, nil)
Use code with caution.for _, child in ipairs(dir:GetChildren()) doif child:IsA("Folder") or child:IsA("Model") or child:IsA("Configuration") thenaddContentRow("📁 Folder: " .. child.Name, "EXPLORE", Color3.fromRGB(50, 110, 180), function()table.insert(currentNavigationPath, child.Name)renderSuiteViews.Player()end)elseif child:IsA("LocalScript") or child:IsA("ModuleScript") thenaddContentRow("📜 Script: " .. child.Name, "VIEW REPO", Color3.fromRGB(120, 60, 160), function()openEditor("Script Interface: " .. child.Name, "-- Client sandboxing limits modification of active threads.\n-- Setup configuration references inside game scripts here.", child, "LocalScript", nil)end)elseaddContentRow("🔹 Object: " .. child.Name .. " ["..child.ClassName.."]", nil, nil, nil)endendaddContentRow("\n--- ✨ METADATA ATTRIBUTES ---", nil, nil, nil)local attrs = dir:GetAttributes()for k, v in pairs(attrs) doaddContentRow(string.format("   %s = %s (%s)", k, tostring(v), typeof(v)), "MUTATE ⚙️", Color3.fromRGB(180, 110, 40), function()openEditor("Modify Attribute: " .. k, tostring(v), dir, "Attribute", k)end)endendrenderSuiteViews.Tool = function()clearCanvas()local char = selectedTargetPlayer.Characterlocal heldTool = char and char:FindFirstChildOfClass("Tool")if not heldTool thenaddContentRow("❌ No active tool equipped on target player character context.", nil, nil, nil)returnendaddContentRow("--- 🛠️ EQUIPPED TARGET TOOL: " .. heldTool.Name .. " ---", nil, nil, nil)addContentRow("Property - Enabled: " .. tostring(heldTool.Enabled), nil, nil, nil)addContentRow("Property - RequiresHandle: " .. tostring(heldTool.RequiresHandle), nil, nil, nil)addContentRow("\n--- ✨ TARGET TOOL METADATA ATTRIBUTES ---", nil, nil, nil)local attrs = heldTool:GetAttributes()for k, v in pairs(attrs) doaddContentRow(string.format("   %s = %s", k, tostring(v)), "MUTATE ⚙️", Color3.fromRGB(180, 110, 40), function()openEditor("Modify Tool Attribute: " .. k, tostring(v), heldTool, "Attribute", k)end)endendrenderSuiteViews.Duper = function()clearCanvas()addContentRow("--- ⚡ INVENTORY ATOMIC DUPPLICATION CORE ---", nil, nil, nil)addContentRow("Targets the active weapon matrix configuration held inside player hands.", nil, nil, nil)addContentRow("Duplicate Tool to Target Inventory Pack", "RUN CLONE", Color3.fromRGB(35, 140, 85), function()local char = selectedTargetPlayer.Characterlocal heldTool = char and char:FindFirstChildOfClass("Tool")local targetBackpack = selectedTargetPlayer:FindFirstChild("Backpack")if heldTool and targetBackpack thenlocal clonedTool = heldTool:Clone()clonedTool.Parent = targetBackpackstatusPanel.Text = "🚀 Double configuration replicated successfully into Backpack!"elsestatusPanel.Text = "❌ Execution Failed: Player must equip the tool target first."endend)end-- =============================================================================-- 5. INITIALIZATION & DROPDOWN CORE PIPELINES-- =============================================================================local function refreshDropdown()for _, child in ipairs(dropdownScroll:GetChildren()) do if child:IsA("TextButton") then child:Destroy() end endfor _, p in ipairs(Players:GetPlayers()) dolocal btn = create("TextButton", dropdownScroll, {Size = UDim2.new(1, 0, 0, 26), BackgroundColor3 = Color3.fromRGB(26, 26, 32), BorderSizePixel = 0, Text = p.Name, TextColor3 = Color3.fromRGB(230, 230, 235), Font = Enum.Font.SourceSans, TextSize = 13, ZIndex = 5005})btn.MouseButton1Click:Connect(function()selectedTargetPlayer = pplayerDropdownBtn.Text = "Target: " .. p.Name .. " ▼"dropdownScroll.Visible = falsecurrentNavigationPath = {}renderSuiteViewsactiveTabend)enddropdownScroll.CanvasSize = UDim2.new(0, 0, 0, ddsList.AbsoluteContentSize.Y)endplayerDropdownBtn.MouseButton1Click:Connect(function()realignDropdown()refreshDropdown()dropdownScroll.Visible = not dropdownScroll.Visibleend)local tabNames = {"Player", "Tool", "Duper"}for idx, name in ipairs(tabNames) dolocal tBtn = create("TextButton", tabContainer, {Size = UDim2.new(0, 90, 1, 0), BackgroundColor3 = (name == activeTab and Color3.fromRGB(50, 110, 180) or Color3.fromRGB(40, 40, 46)), Text = name, TextColor3 = Color3.fromRGB(255, 255, 255), Font = Enum.Font.SourceSansBold, TextSize = 13, LayoutOrder = idx})create("UICorner", tBtn, {CornerRadius = UDim.new(0, 4)})tBtn.MouseButton1Click:Connect(function()activeTab = namefor _, child in ipairs(tabContainer:GetChildren()) doif child:IsA("TextButton") thenchild.BackgroundColor3 = (child.Text == activeTab and Color3.fromRGB(50, 110, 180) or Color3.fromRGB(40, 40, 46))endenddropdownScroll.Visible = falserenderSuiteViewsactiveTabend)endcloseButton.MouseButton1Click:Connect(function()screenGui:Destroy()end)UserInputService.InputBegan:Connect(function(input, processed)if not processed and (input.KeyCode == Enum.KeyCode.M or input.KeyCode == Enum.KeyCode.RightShift) thenmainFrame.Visible = not mainFrame.VisibledropdownScroll.Visible = falseeditModal.Visible = falseendend)renderSuiteViews.Player()print("⚡ Architecture Development Panel successfully mounted.")
