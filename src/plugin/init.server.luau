-- Import backend modules
-- Import backend modules
local Shared = script.Parent:WaitForChild("Shared")
local Graph  = require(Shared.Graph)

-- Import plugin classes
local FileManager = require(script.FileManager)

-- Import UI classes
local UI      = script.ui
local TopBar  = require(UI.TopBar)
local Canvas  = require(UI.Canvas)
local Sidebar = require(UI.Sidebar)
local Modal   = require(UI.Modal)
local ScriptModal = require(UI.ScriptModal)
local ChoiceModal = require(UI.ChoiceModal)
local NodeMenu = require(UI.NodeMenu)
local NodeComponent = require(UI.NodeComponent)

local Nodes = {
	["Start Event"] = require(Shared.nodes.events.Start),
	["Print"]       = require(Shared.nodes.Print),
	["Add"]         = require(Shared.nodes.math.Add),
}

-- Toolbar button (toggle widget only)
local toolbar      = plugin:CreateToolbar("Blueprint Editor")
local pluginButton = toolbar:CreateButton("Edit Blueprint", "Open the Blueprint Editor", "rbxassetid://4458901886")
pluginButton.ClickableWhenViewportHidden = true

-- Docking widget
local widgetInfo = DockWidgetPluginGuiInfo.new(Enum.InitialDockState.Float, true, false, 800, 500, 400, 300)
local widget     = plugin:CreateDockWidgetPluginGui("BlueprintEditorWidget", widgetInfo)
widget.Title     = "Blueprint Editor"
widget.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Sync toolbar button active state with widget visibility
widget:GetPropertyChangedSignal("Enabled"):Connect(function()
	pluginButton:SetActive(widget.Enabled)
end)
pluginButton:SetActive(widget.Enabled)

pluginButton.Click:Connect(function()
	widget.Enabled = not widget.Enabled
end)

-- Build UI (order matters for Sibling ZIndex: last created = on top)
local canvas  = Canvas.new(widget)   -- bottom layer
local sidebar = Sidebar.new(widget)  -- above canvas
local topBar  = TopBar.new(widget)   -- top layer

-- Offset canvas to the right of the sidebar
canvas:SetLeftOffset(sidebar:GetWidth())

local newProjectBtn  = topBar:AddButton("NewProjectBtn",  "+ New Project")
local openProjectBtn = topBar:AddButton("OpenProjectBtn", "Open Project")
local saveProjectBtn = topBar:AddButton("SaveProjectBtn", "Save Project")
local exportBtn      = topBar:AddButton("ExportBtn",      "Export Current")
local exportAllBtn   = topBar:AddButton("ExportAllBtn",   "Export All")

-- Initialise services
local fm           = FileManager.new(plugin)

-- Project state
local projectActive      = false
local currentProjectName = nil
local currentProjectData = nil
local currentGraph       = Graph.new()
local visualNodes        = {}
local visualWires        = {} -- stores drawn wire frames with metadata
local hoveredNode        = nil
local currentScriptHandle = nil

local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local function handleKeyDown(keyCode)
	if UserInputService:GetFocusedTextBox() then return end
	
	if (keyCode == Enum.KeyCode.Delete or keyCode == Enum.KeyCode.Backspace) then
		if hoveredNode then
			--print("[Editor] Deleting node: " .. hoveredNode.nodeData.Name)
			
			-- 1. Remove from Graph
			currentGraph:remove_node(hoveredNode.nodeData)
			
			-- 2. Remove connected visual wires
			for i = #visualWires, 1, -1 do
				local wire = visualWires[i]
				if wire.fromNode == hoveredNode.nodeData or wire.toNode == hoveredNode.nodeData then
					-- Show input field again if it was a target pin
					if wire.toNode ~= hoveredNode.nodeData then
						for _, vNode in ipairs(visualNodes) do
							if vNode.nodeData == wire.toNode then
								vNode:UpdatePinState(wire.toPinId, false)
								break
							end
						end
					end
					
					wire.line:Destroy()
					if wire.hbConn then wire.hbConn:Disconnect() end
					table.remove(visualWires, i)
				end
			end
			
			-- 3. Remove from visualNodes list
			for i, vNode in ipairs(visualNodes) do
				if vNode == hoveredNode then
					table.remove(visualNodes, i)
					break
				end
			end
			
			-- 4. Destroy UI
			hoveredNode:Destroy()
			hoveredNode = nil
		else
			--print("[Editor] Delete pressed but no node hovered")
		end
	end
end

-- ── Wires Global State ────────────────────────────────────────────────────────
local wiresFrame = Instance.new("Frame")
wiresFrame.Name = "Wires"
wiresFrame.Size = UDim2.new(1, 0, 1, 0)
wiresFrame.BackgroundTransparency = 1
wiresFrame.ZIndex = 5
wiresFrame.Parent = canvas:GetNodeContainer()

local hoveredPin = nil
local wireDragging = false
local wireStartInfo = nil
local tempWireFrame = nil
local dragMousePos = Vector2.new()

local function drawWireLine(parent, p1, p2, color)
	local line = Instance.new("Frame")
	local distance = (p2 - p1).Magnitude
	local center = (p1 + p2) / 2
	local angle = math.atan2(p2.Y - p1.Y, p2.X - p1.X)
	
	line.AnchorPoint = Vector2.new(0.5, 0.5)
	line.Position = UDim2.fromOffset(center.X, center.Y)
	line.Size = UDim2.fromOffset(distance, 3)
	line.Rotation = math.deg(angle)
	line.BackgroundColor3 = color
	line.BorderSizePixel = 0
	line.ZIndex = 5
	line.Parent = parent
	return line
end

local function clearCanvas()
	for _, vNode in ipairs(visualNodes) do
		vNode:Destroy()
	end
	visualNodes = {}
	
	for _, wire in ipairs(visualWires) do
		wire.line:Destroy()
		if wire.hbConn then wire.hbConn:Disconnect() end
	end
	visualWires = {}
	
	hoveredNode = nil
end

local function hookUpNodeEvents(visualNode, nodeInstance)
	visualNode.OnSelect.Event:Connect(function()
		for _, v in ipairs(visualNodes) do
			if v ~= visualNode then
				v:Deselect()
			end
		end
	end)
	
	visualNode.OnHover.Event:Connect(function()
		--print("[Editor] Hovering node: " .. nodeInstance.Name)
		hoveredNode = visualNode
	end)
	
	visualNode.OnHoverEnd.Event:Connect(function()
		if hoveredNode == visualNode then
			--print("[Editor] Stopped hovering node: " .. nodeInstance.Name)
			hoveredNode = nil
		end
	end)
	
	visualNode.OnKeyDown.Event:Connect(function(keyCode)
		handleKeyDown(keyCode)
	end)

	visualNode.OnPinDragStart.Event:Connect(function(nodeData, pinData, isOutput, pinGui, inputPos)
		if tempWireFrame then
			tempWireFrame:Destroy()
		end
		
		wireDragging = true
		dragMousePos = Vector2.new(inputPos.X, inputPos.Y)
		wireStartInfo = { nodeData = nodeData, pinData = pinData, isOutput = isOutput, pinGui = pinGui }
		
		tempWireFrame = Instance.new("Frame")
		tempWireFrame.AnchorPoint = Vector2.new(0.5, 0.5)
		tempWireFrame.BackgroundColor3 = (pinData.Name == "Exec") and Color3.fromRGB(240, 240, 240) or Color3.fromRGB(110, 180, 240)
		tempWireFrame.BorderSizePixel = 0
		tempWireFrame.ZIndex = 10
		tempWireFrame.Parent = wiresFrame
	end)
	
	visualNode.OnPinDragEnd.Event:Connect(function()
		if wireDragging then
			wireDragging = false
			if tempWireFrame then
				tempWireFrame:Destroy()
				tempWireFrame = nil
			end
			
			if hoveredPin and wireStartInfo then
				--print("[Wire] Dropped on pin: " .. hoveredPin.pinData.Name .. " of node: " .. hoveredPin.nodeData.Name)
				-- Check if valid: one output, one input
				if wireStartInfo.isOutput ~= hoveredPin.isOutput then
					local isExec1 = (wireStartInfo.pinData.Name == "Exec")
					local isExec2 = (hoveredPin.pinData.Name == "Exec")
					if isExec1 == isExec2 then
						--print(string.format("[Wire] VALID CONNECTION! %s -> %s", wireStartInfo.nodeData.Name, hoveredPin.nodeData.Name))
						-- valid connection
						local outInfo = wireStartInfo.isOutput and wireStartInfo or hoveredPin
						local inInfo = not wireStartInfo.isOutput and wireStartInfo or hoveredPin
						
						if isExec1 then
							currentGraph:connect_exec(outInfo.nodeData, inInfo.nodeData, outInfo.pinData.Name)
						else
							currentGraph:connect_data(outInfo.nodeData, inInfo.nodeData, outInfo.pinData.Name, inInfo.pinData.Name)
						end
						
						-- Draw permanent wire
						local color = isExec1 and Color3.fromRGB(240, 240, 240) or Color3.fromRGB(110, 180, 240)
						local function updatePermanentWire()
							local cPos = canvas:GetNodeContainer().AbsolutePosition
							local p1 = outInfo.pinGui.AbsolutePosition + (outInfo.pinGui.AbsoluteSize / 2) - cPos
							local p2 = inInfo.pinGui.AbsolutePosition + (inInfo.pinGui.AbsoluteSize / 2) - cPos
							return p1, p2
						end
						
						local p1, p2 = updatePermanentWire()
						local line = drawWireLine(wiresFrame, p1, p2, color)
						
						local wireObj = {
							line = line,
							fromNode = outInfo.nodeData,
							toNode = inInfo.nodeData,
							toPinId = inInfo.pinData.Id,
							hbConn = nil
						}
						
						-- Continuously update this line
						wireObj.hbConn = RunService.Heartbeat:Connect(function()
							local np1, np2 = updatePermanentWire()
							local distance = (np2 - np1).Magnitude
							local center = (np1 + np2) / 2
							local angle = math.atan2(np2.Y - np1.Y, np2.X - np1.X)
							line.Position = UDim2.fromOffset(center.X, center.Y)
							line.Size = UDim2.fromOffset(distance, 3)
							line.Rotation = math.deg(angle)
						end)
						
						table.insert(visualWires, wireObj)
						
						-- Hide manual input field on target pin
						for _, vNode in ipairs(visualNodes) do
							if vNode.nodeData == inInfo.nodeData then
								vNode:UpdatePinState(inInfo.pinData.Id, true)
								break
							end
						end
					end
				end
			end
		end
	end)
end

local function renderGraph(graph)
	for node, _ in pairs(graph.nodes) do
		local visualNode = NodeComponent.new(canvas:GetNodeContainer(), node)
		table.insert(visualNodes, visualNode)
		hookUpNodeEvents(visualNode, node)
	end
	
	-- Render Exec edges
	for _, edge in ipairs(graph.exec_edges) do
		local outNode = edge.FromNode
		local inNode = edge.ToNode
		
		-- Find visual pins
		local vOut, vIn
		for _, vNode in ipairs(visualNodes) do
			if vNode.nodeData == outNode then
				for _, pInfo in ipairs(vNode:GetPins()) do
					if pInfo.isOutput and pInfo.pinData.Name == edge.FromPort then vOut = pInfo.pinGui break end
				end
			elseif vNode.nodeData == inNode then
				for _, pInfo in ipairs(vNode:GetPins()) do
					if not pInfo.isOutput and pInfo.pinData.Name == edge.ToPort then vIn = pInfo.pinGui break end
				end
			end
		end
		
		if vOut and vIn then
			local function updatePermanentWire()
				local cPos = canvas:GetNodeContainer().AbsolutePosition
				local p1 = vOut.AbsolutePosition + (vOut.AbsoluteSize / 2) - cPos
				local p2 = vIn.AbsolutePosition + (vIn.AbsoluteSize / 2) - cPos
				return p1, p2
			end
			local p1, p2 = updatePermanentWire()
			local line = drawWireLine(wiresFrame, p1, p2, Color3.fromRGB(240, 240, 240))
			
			local wireObj = { 
				line = line, 
				fromNode = outNode, 
				toNode = inNode, 
				toPinId = nil,
				hbConn = nil 
			}
			for _, inp in ipairs(inNode:getInputs()) do
				if inp.Name == edge.ToPort then wireObj.toPinId = inp.Id break end
			end

			wireObj.hbConn = RunService.Heartbeat:Connect(function()
				local np1, np2 = updatePermanentWire()
				local distance = (np2 - np1).Magnitude
				local center = (np1 + np2) / 2
				local angle = math.atan2(np2.Y - np1.Y, np2.X - np1.X)
				line.Position = UDim2.fromOffset(center.X, center.Y)
				line.Size = UDim2.fromOffset(distance, 3)
				line.Rotation = math.deg(angle)
			end)
			table.insert(visualWires, wireObj)
			if wireObj.toPinId then
				for _, vNode in ipairs(visualNodes) do
					if vNode.nodeData == inNode then vNode:UpdatePinState(wireObj.toPinId, true) break end
				end
			end
		end
	end
	
	-- Render Data edges
	for _, edge in ipairs(graph.data_edges) do
		local outNode = edge.FromNode
		local inNode = edge.ToNode
		
		local vOut, vIn
		for _, vNode in ipairs(visualNodes) do
			if vNode.nodeData == outNode then
				for _, pInfo in ipairs(vNode:GetPins()) do
					if pInfo.isOutput and pInfo.pinData.Name == edge.FromPort then vOut = pInfo.pinGui break end
				end
			elseif vNode.nodeData == inNode then
				for _, pInfo in ipairs(vNode:GetPins()) do
					if not pInfo.isOutput and pInfo.pinData.Name == edge.ToPort then vIn = pInfo.pinGui break end
				end
			end
		end
		
		if vOut and vIn then
			local function updatePermanentWire()
				local cPos = canvas:GetNodeContainer().AbsolutePosition
				local p1 = vOut.AbsolutePosition + (vOut.AbsoluteSize / 2) - cPos
				local p2 = vIn.AbsolutePosition + (vIn.AbsoluteSize / 2) - cPos
				return p1, p2
			end
			local p1, p2 = updatePermanentWire()
			local line = drawWireLine(wiresFrame, p1, p2, Color3.fromRGB(110, 180, 240))
			
			local wireObj = { 
				line = line, 
				fromNode = outNode, 
				toNode = inNode, 
				toPinId = nil,
				hbConn = nil 
			}
			for _, inp in ipairs(inNode:getInputs()) do
				if inp.Name == edge.ToPort then wireObj.toPinId = inp.Id break end
			end

			wireObj.hbConn = RunService.Heartbeat:Connect(function()
				local np1, np2 = updatePermanentWire()
				local distance = (np2 - np1).Magnitude
				local center = (np1 + np2) / 2
				local angle = math.atan2(np2.Y - np1.Y, np2.X - np1.X)
				line.Position = UDim2.fromOffset(center.X, center.Y)
				line.Size = UDim2.fromOffset(distance, 3)
				line.Rotation = math.deg(angle)
			end)
			table.insert(visualWires, wireObj)
			if wireObj.toPinId then
				for _, vNode in ipairs(visualNodes) do
					if vNode.nodeData == inNode then vNode:UpdatePinState(wireObj.toPinId, true) break end
				end
			end
		end
	end
end

local function switchScript(handle)
	if not projectActive then return end
	
	-- 1. Save current graph to the old handle
	if currentScriptHandle then
		currentScriptHandle.data.graph = currentGraph:serialize()
		currentScriptHandle:Deselect()
	end
	
	-- 2. Clear canvas
	clearCanvas()
	
	-- 3. Load new graph
	currentScriptHandle = handle
	currentScriptHandle:Select()
	
	if handle.data.graph then
		currentGraph = Graph.from_data(handle.data.graph, Nodes)
	else
		currentGraph = Graph.new()
	end
	
	-- 4. Render
	renderGraph(currentGraph)
	--print("[Editor] Switched to script: " .. handle.data.name)
end


-- Ready


-- ── Sidebar: Scripts ──────────────────────────────────────────────────────────
local function onEditScript(handle)
	ScriptModal.prompt(widget, handle.data, function(updatedData)
		-- Update the data
		handle.data = updatedData
		-- Update UI
		handle.nameLabel.Text = updatedData.name
		handle.typeBtn.Text = updatedData.type == "Function" and "FUN" or (updatedData.type == "Module" and "MOD" or "DEF")
	end)
end

-- ── Start a project (shared setup for new / open) ─────────────────────────────
local function activateProject(data, name)
	projectActive      = true
	currentProjectName = name or data.name or "Untitled"
	currentProjectData = data

	clearCanvas()
	sidebar:Clear()
	currentScriptHandle = nil
	
	-- Populate sidebar with scripts
	local firstHandle = nil
	for _, sData in ipairs(data.scripts or {}) do
		local handle = sidebar:AddScript(sData, onEditScript)
		if not firstHandle then firstHandle = handle end
	end
	
	-- Populate sidebar with variables
	for _, vName in ipairs(data.variables or {}) do
		sidebar:AddVariable(vName)
	end

	canvas:ShowGrid()
	canvas:HidePlaceholder()

	widget.Title = "Blueprint Editor  -  " .. currentProjectName
	
	-- Switch to first script
	if firstHandle then
		switchScript(firstHandle)
	else
		currentGraph = Graph.new()
	end
end

-- ── Collect current project data ──────────────────────────────────────────────
local function gatherProjectData()
	-- Save active graph
	if currentScriptHandle then
		currentScriptHandle.data.graph = currentGraph:serialize()
	end
	
	return {
		name        = currentProjectName,
		variables   = sidebar:GetVariables(),
		scripts     = sidebar:GetScripts(),
	}
end

-- ── New Project ────────────────────────────────────────────────────────────────
newProjectBtn:OnClick(function()
	local defaultData = { 
		name = "Untitled", 
		variables = {}, 
		scripts = { { name = "Main", type = "Default", graph = nil } } 
	}
	activateProject(defaultData, nil)
end)

-- ── Open Project ───────────────────────────────────────────────────────────────
openProjectBtn:OnClick(function()
	local project = fm:OpenJSON({"json"})
	if project == nil then return end

	activateProject(project.data, project.name)
end)

-- ── Save Project ───────────────────────────────────────────────────────────────
saveProjectBtn:OnClick(function()
	if not projectActive then return end

	local data = gatherProjectData()

	-- Export to StringValue for manual copy
	fm:ExportToStringValue(data)

	canvas:SetPlaceholder(
		"Project saved!\n\n"
		.. "JSON exported to workspace.__BlueprintExport.\n"
		.. "Select it in Explorer and copy the Value."
	)
	task.delay(3, function()
		if projectActive then canvas:HidePlaceholder() end
	end)
end)

-- ── Export Logic ──────────────────────────────────────────────────────────────

local function compileScriptData(sData)
	if not sData.graph then return "-- No graph data\n" end
	
	-- We need to temporarily restore the graph to build blocks
	local graph = Graph.from_data(sData.graph, Nodes)
	local blocks = {}
	local ok, err = pcall(function()
		blocks = graph:build_blocks()
	end)
	
	if not ok then
		warn("[Compiler] Failed to build blocks: " .. tostring(err))
		return "-- Compilation Error: " .. tostring(err) .. "\n"
	end
	
	local code = ""
	for _, b in ipairs(blocks) do
		code ..= b:run() .. "\n"
	end
	return code
end

local function performExport(sData, callback)
	if sData.type == "Default" then
		ChoiceModal.prompt(widget, "Export '" .. sData.name .. "' as:", {"Script", "LocalScript"}, function(choice)
			local code = compileScriptData(sData)
			local instance = fm:ExportToScript(sData.name, choice, code)
			if callback then callback(instance) end
		end)
	else
		local code = compileScriptData(sData)
		local instance = fm:ExportToScript(sData.name, sData.type, code)
		if callback then callback(instance) end
	end
end

exportBtn:OnClick(function()
	if not projectActive or not currentScriptHandle then return end
	
	-- Save current state first
	currentScriptHandle.data.graph = currentGraph:serialize()
	
	performExport(currentScriptHandle.data, function(inst)
		canvas:SetPlaceholder("Exported '" .. inst.Name .. "' to workspace.__BlueprintExport")
		task.delay(2, function() if projectActive then canvas:HidePlaceholder() end end)
	end)
end)

exportAllBtn:OnClick(function()
	if not projectActive then return end
	
	-- Save current state first
	if currentScriptHandle then
		currentScriptHandle.data.graph = currentGraph:serialize()
	end
	
	local allScripts = sidebar:GetScripts()
	local exportedCount = 0
	
	local function exportNext(index)
		if index > #allScripts then
			canvas:SetPlaceholder("Exported " .. exportedCount .. " scripts to workspace.__BlueprintExport")
			task.delay(3, function() if projectActive then canvas:HidePlaceholder() end end)
			return
		end
		
		local sData = allScripts[index]
		performExport(sData, function()
			exportedCount += 1
			exportNext(index + 1)
		end)
	end
	
	exportNext(1)
end)



sidebar:OnAddScript(function()
	ScriptModal.prompt(widget, nil, function(newScriptData)
		local handle = sidebar:AddScript(newScriptData, onEditScript)
		-- Automatically switch to the new script so we can start drawing!
		switchScript(handle)
	end)
end)

-- ── Sidebar: Variables ────────────────────────────────────────────────────────
sidebar:OnAddVariable(function()
	Modal.prompt(widget, "New Variable", "Variable name...", function(varName)
		sidebar:AddVariable(varName)
	end)
end)

sidebar:OnScriptSelected(function(handle)
	switchScript(handle)
end)


-- ── Canvas: Mouse Tracking ──────────────────────────────────────────────────────
canvas:OnLeftClick(function()
	if not projectActive then return end
	
	-- Deselect all nodes
	for _, v in ipairs(visualNodes) do
		v:Deselect()
	end
end)



canvas:OnMouseMove(function(position)
	dragMousePos = Vector2.new(position.X, position.Y)
end)

canvas:OnKeyDown(handleKeyDown)

-- ── Keyboard Shortcuts ────────────────────────────────────────────────────────
UserInputService.InputBegan:Connect(function(input, gpe)
	-- Fallback global listener
	handleKeyDown(input.KeyCode)
end)

-- We now use OnPinDragEnd instead of UserInputService.InputEnded for robustness

RunService.Heartbeat:Connect(function()
	if wireDragging and tempWireFrame and wireStartInfo then
		local containerPos = canvas:GetNodeContainer().AbsolutePosition
		local mousePos = dragMousePos
		
		local p1 = wireStartInfo.pinGui.AbsolutePosition + (wireStartInfo.pinGui.AbsoluteSize / 2) - containerPos
		
		-- Distance-based snapping
		hoveredPin = nil
		local closestDist = 45 -- Snap distance
		
		for _, vNode in ipairs(visualNodes) do
			for _, pinInfo in ipairs(vNode:GetPins()) do
				if pinInfo.pinData.Id ~= wireStartInfo.pinData.Id then
					local pinAbsolute = pinInfo.pinGui.AbsolutePosition + (pinInfo.pinGui.AbsoluteSize / 2)
					local dist = (pinAbsolute - mousePos).Magnitude
					
					if dist < closestDist then
						closestDist = dist
						hoveredPin = {
							nodeData = vNode.nodeData,
							pinData = pinInfo.pinData,
							isOutput = pinInfo.isOutput,
							pinGui = pinInfo.pinGui
						}
					end
				end
			end
		end

		local p2 = mousePos - containerPos
		if hoveredPin then
			-- Snap exactly to the hovered pin center
			p2 = hoveredPin.pinGui.AbsolutePosition + (hoveredPin.pinGui.AbsoluteSize / 2) - containerPos
		end
		
		local distance = (p2 - p1).Magnitude
		local center = (p1 + p2) / 2
		local angle = math.atan2(p2.Y - p1.Y, p2.X - p1.X)
		
		tempWireFrame.Position = UDim2.fromOffset(center.X, center.Y)
		tempWireFrame.Size = UDim2.fromOffset(distance, 3)
		tempWireFrame.Rotation = math.deg(angle)
	end
end)

-- ── Canvas: Right Click Menu & Panning ────────────────────────────────────────
canvas:OnRightClick(function(position)
	if not projectActive then return end
	
	NodeMenu.prompt(widget, position, function(nodeId)
		local nodeClass = Nodes[nodeId]
		if not nodeClass then return end
		
		local nodeInstance = nodeClass.new()
		
		-- Place it under the mouse cursor in the canvas
		-- We need to offset the screen position by the canvas absolute position and pan offset
		local canvasPos = canvas:GetInstance().AbsolutePosition
		local panOffset = canvas:GetPanOffset()
		local relativeX = position.X - canvasPos.X - panOffset.X
		local relativeY = position.Y - canvasPos.Y - panOffset.Y
		
		nodeInstance:editPosition(Vector2.new(relativeX, relativeY))
		currentGraph:add_node(nodeInstance)
		
		-- Render it
		local visualNode = NodeComponent.new(canvas:GetNodeContainer(), nodeInstance)
		table.insert(visualNodes, visualNode)
		
		hookUpNodeEvents(visualNode, nodeInstance)
	end)
end)

-- Ready