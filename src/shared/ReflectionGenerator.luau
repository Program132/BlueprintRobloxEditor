local ReflectionService = game:GetService("ReflectionService")
local Shared = script.Parent
local Node = require(Shared.Node)
local NodeType = require(Shared.NodeType)
local IO = require(Shared.IO)

local ReflectionGenerator = {}


local CATEGORY_COLORS = {
	["Players"] = Color3.fromRGB(0, 162, 255),
	["Chat"] = Color3.fromRGB(0, 162, 255),
	["Part"] = Color3.fromRGB(75, 180, 100),
	["MeshPart"] = Color3.fromRGB(75, 180, 100),
	["BasePart"] = Color3.fromRGB(75, 180, 100),
	["Sound"] = Color3.fromRGB(220, 200, 50),
	["GuiObject"] = Color3.fromRGB(255, 80, 150),
	["ScreenGui"] = Color3.fromRGB(255, 80, 150),
	["BillboardGui"] = Color3.fromRGB(255, 80, 150),
	["SurfaceGui"] = Color3.fromRGB(255, 80, 150),
	["TweenService"] = Color3.fromRGB(255, 170, 0),
	["RunService"] = Color3.fromRGB(255, 170, 0),
	["HttpService"] = Color3.fromRGB(0, 200, 200),
	["DataStoreService"] = Color3.fromRGB(0, 200, 200),
	["Humanoid"] = Color3.fromRGB(255, 100, 100),
	["Animator"] = Color3.fromRGB(255, 100, 100),
}

local function getTypeString(typeInfo)
	if not typeInfo then return nil end
	if type(typeInfo) == "string" then return typeInfo end
	
	if typeInfo.EnumType then
		return "Enum." .. typeInfo.EnumType
	elseif typeInfo.InstanceType then
		return typeInfo.InstanceType
	elseif typeInfo.ScriptType then
		return typeInfo.ScriptType
	elseif typeInfo.Name then
		return typeInfo.Name
	end
	
	return nil
end

local function getCategoryColor(categoryName, isService)
	if isService then
		return Color3.fromRGB(255, 170, 0)
	end
	
	if CATEGORY_COLORS[categoryName] then
		return CATEGORY_COLORS[categoryName]
	end
	
	-- Generate a stable color from the name
	local hash = 0
	for i = 1, #categoryName do
		hash = (hash * 31 + string.byte(categoryName, i)) % 360
	end
	return Color3.fromHSV(hash / 360, 0.6, 0.8)
end

function ReflectionGenerator.populate(NodesTable)
	local filter = {
		ExcludeDisplay = true
	}

	local success, classes = pcall(function()
		return ReflectionService:GetClasses(filter)
	end)

	if not success or not classes then
		warn("ReflectionGenerator: GetClasses failed or returned nil!", classes)
		return
	end

	local function getOwnerName(info, fallback)
		if info.Owner then
			if type(info.Owner) == "string" then
				return info.Owner
			elseif type(info.Owner) == "table" or typeof(info.Owner) == "Instance" then
				return info.Owner.Name or fallback
			end
		end
		return fallback
	end

	local count = 0
	for _, classInfo in ipairs(classes) do
		local className = classInfo.Name
		local isService = classInfo.Permits and classInfo.Permits.GetService ~= nil
		local serviceColor = getCategoryColor(className, isService)
		
		local options = {}

		-- Methods
		local methodSuccess, methods = pcall(function()
			return ReflectionService:GetMethodsOfClass(className, options)
		end)
		
		if methodSuccess and methods then
			for _, methodInfo in ipairs(methods) do
				-- Skip deprecated methods
				if methodInfo.Display and methodInfo.Display.DeprecationMessage then
					continue
				end

				local ownerName = getOwnerName(methodInfo, className)
				local nodeName = ownerName .. " " .. methodInfo.Name
				-- Only add if not already defined (manually or by a previous pass)
				if not NodesTable[nodeName] then
					local ownerColor = getCategoryColor(ownerName, isService and ownerName == className)
					NodesTable[nodeName] = ReflectionGenerator.createMethodNode(ownerName, methodInfo, nil, ownerColor)
				end
			end
		end

		-- Events
		local eventSuccess, events = pcall(function()
			return ReflectionService:GetEventsOfClass(className, options)
		end)

		if eventSuccess and events then
			for _, eventInfo in ipairs(events) do
				-- Skip deprecated events
				if eventInfo.Display and eventInfo.Display.DeprecationMessage then
					continue
				end

				local ownerName = getOwnerName(eventInfo, className)
				local nodeName = "Event " .. ownerName .. " " .. eventInfo.Name
				if not NodesTable[nodeName] then
					local ownerColor = getCategoryColor(ownerName, isService and ownerName == className)
					NodesTable[nodeName] = ReflectionGenerator.createEventNode(ownerName, eventInfo, nil, ownerColor)
				end
			end
		end

		-- Properties
		local propSuccess, properties = pcall(function()
			return ReflectionService:GetPropertiesOfClass(className, options)
		end)

		local readableProperties = {}
		if propSuccess and properties then
			for _, propInfo in ipairs(properties) do
				-- Skip deprecated properties
				if propInfo.Display and propInfo.Display.DeprecationMessage then
					continue
				end

				local ownerName = getOwnerName(propInfo, className)
				
				-- Individual Set nodes for writable properties
				if propInfo.Permits and propInfo.Permits.Write then
					local setName = ownerName .. " Set " .. propInfo.Name
					if not NodesTable[setName] then
						local ownerColor = getCategoryColor(ownerName, isService and ownerName == className)
						NodesTable[setName] = ReflectionGenerator.createSetPropertyNode(ownerName, propInfo, ownerColor)
					end
				end
				
				-- Collect all readable properties for the Cast/Break node
				if propInfo.Permits and propInfo.Permits.Read then
					table.insert(readableProperties, propInfo)
				end
			end
		end

		-- Casting/Break node (Instance To <Class>) - Contains all readable properties for THIS class level
		local castName = "Instance To " .. className
		if not NodesTable[castName] then
			NodesTable[castName] = ReflectionGenerator.createCastNode(className, readableProperties, isService and serviceColor)
		end

		count += 1
		if count % 10 == 0 then
			task.wait()
		end
	end
end

function ReflectionGenerator.createMethodNode(className, methodInfo, overrideName, overrideColor)
	local CustomNode = {}
	CustomNode.__index = CustomNode
	setmetatable(CustomNode, Node)

	local returnType = methodInfo.ReturnType
	local isFunction = false
	if returnType ~= nil then
		if type(returnType) == "string" then
			isFunction = (returnType ~= "void")
		elseif type(returnType) == "table" or typeof(returnType) == "Instance" then
			isFunction = (returnType.Name ~= "void")
		end
	end
	
	local defaultColor = overrideColor or (isFunction and Color3.fromRGB(120, 160, 200) or Color3.fromRGB(100, 180, 255))
	CustomNode.DefaultColor = defaultColor

	function CustomNode.new()
		local self = Node.new(overrideName or (className .. " " .. methodInfo.Name), isFunction and NodeType.FUNCTION or NodeType.METHOD)
		setmetatable(self, CustomNode)
		self:editColor(defaultColor)

		if not isFunction then
			self:addInput(IO.Input.new("Exec", ""))
		end
		self:addInput(IO.Input.new("Instance", "nil", false, nil, className))

		if methodInfo.Parameters then
			for i, param in ipairs(methodInfo.Parameters) do
				local rawName = param.Name
				if not rawName or rawName == "" then rawName = "Param" .. i end
				local paramName = string.upper(string.sub(rawName, 1, 1)) .. string.sub(rawName, 2)
				
				local defaultValue = "nil"
				if param.DefaultValue ~= nil then
					defaultValue = tostring(param.DefaultValue)
				end
				
				self:addInput(IO.Input.new(paramName, defaultValue, false, nil, getTypeString(param.Type)))
			end
		end

		if not isFunction then
			self:addOutput(IO.Output.new("Exec", ""))
		end
		
		if isFunction then
			self:addOutput(IO.Output.new("Result", "nil", false, nil, getTypeString(methodInfo.ReturnType)))
		end

		return self
	end

	function CustomNode:toLuau()
		local inst = self:getInput("Instance").Value or "nil"
		local args = {}

		if methodInfo.Parameters then
			for i, param in ipairs(methodInfo.Parameters) do
				local rawName = param.Name
				if not rawName or rawName == "" then rawName = "Param" .. i end
				local paramName = string.upper(string.sub(rawName, 1, 1)) .. string.sub(rawName, 2)
				local val = self:getInput(paramName).Value or "nil"
				table.insert(args, val)
			end
		end

		local argStr = table.concat(args, ", ")
		local call = inst .. ":" .. methodInfo.Name .. "(" .. argStr .. ")"

		if isFunction then
			local resultVar = string.lower(methodInfo.Name:sub(1,1)) .. methodInfo.Name:sub(2) .. "_" .. self.Id:gsub("-", ""):sub(1, 4)
			self:getOutput("Result").Value = resultVar
			return (isFunction and "" or "local ") .. resultVar .. " = " .. call
		else
			return call
		end
	end

	return CustomNode
end

function ReflectionGenerator.createEventNode(className, eventInfo, overrideName, overrideColor)
	local CustomNode = {}
	CustomNode.__index = CustomNode
	setmetatable(CustomNode, Node)

	local defaultColor = Color3.fromRGB(200, 30, 30)
	CustomNode.DefaultColor = defaultColor

	function CustomNode.new()
		local self = Node.new(overrideName or ("Event " .. className .. " " .. eventInfo.Name), NodeType.EVENT)
		self:editTitle(className .. " " .. eventInfo.Name)
		setmetatable(self, CustomNode)
		self:editColor(defaultColor)

		self:addInput(IO.Input.new("Instance", "nil", false, nil, className))
		self:addOutput(IO.Output.new("Exec", ""))

		if eventInfo.Parameters then
			for i, param in ipairs(eventInfo.Parameters) do
				local rawName
				local paramType = nil
				if type(param) == "string" then
					rawName = param
				elseif type(param) == "table" or typeof(param) == "Instance" then
					rawName = param.Name
					paramType = getTypeString(param.Type)
				end
				
				if type(rawName) ~= "string" or rawName == "" then
					rawName = "Param" .. tostring(i)
				end
				local paramName = string.upper(string.sub(rawName, 1, 1)) .. string.sub(rawName, 2)
				self:addOutput(IO.Output.new(paramName, "nil", false, nil, paramType))
			end
		end
		return self
	end

	function CustomNode:toLuau(block, visited, indentCode)
		local inst = self:getInput("Instance").Value or "nil"
		local argList = {}

		if eventInfo.Parameters then
			for i, param in ipairs(eventInfo.Parameters) do
				local rawName
				if type(param) == "string" then
					rawName = param
				elseif type(param) == "table" or typeof(param) == "Instance" then
					rawName = param.Name
				end
				
				if type(rawName) ~= "string" or rawName == "" then
					rawName = "Param" .. tostring(i)
				end
				local paramName = string.upper(string.sub(rawName, 1, 1)) .. string.sub(rawName, 2)
				table.insert(argList, paramName)
				self:getOutput(paramName).Value = paramName
			end
		end

		local args = table.concat(argList, ", ")
		
		local innerCode = ""
		if block and block.run_from_port then
			innerCode = block:run_from_port(self, "Exec", visited)
			if indentCode then
				innerCode = indentCode(innerCode)
			end
		end
		
		return inst .. "." .. eventInfo.Name .. ":Connect(function(" .. args .. ")\n" .. innerCode .. "end)"
	end

	return CustomNode
end

function ReflectionGenerator.createGetPropertyNode(className, propInfo, overrideColor)
	local CustomNode = {}
	CustomNode.__index = CustomNode
	setmetatable(CustomNode, Node)

	local defaultColor = overrideColor or Color3.fromRGB(120, 160, 200)
	CustomNode.DefaultColor = defaultColor

	function CustomNode.new()
		local self = Node.new(className .. " Get " .. propInfo.Name, NodeType.FUNCTION)
		self:editTitle(className .. " " .. propInfo.Name)
		setmetatable(self, CustomNode)
		self:editColor(defaultColor)

		self:addInput(IO.Input.new("Instance", "nil"))
		self:addOutput(IO.Output.new("Value", "nil"))

		return self
	end

	function CustomNode:toLuau()
		local inst = self:getInput("Instance").Value or "nil"
		self:getOutput("Value").Value = inst .. "." .. propInfo.Name
		return ""
	end

	return CustomNode
end

function ReflectionGenerator.createSetPropertyNode(className, propInfo, overrideColor)
	local CustomNode = {}
	CustomNode.__index = CustomNode
	setmetatable(CustomNode, Node)

	local defaultColor = overrideColor or Color3.fromRGB(120, 160, 200)
	CustomNode.DefaultColor = defaultColor

	function CustomNode.new()
		local self = Node.new(className .. " Set " .. propInfo.Name, NodeType.METHOD)
		self:editTitle(className .. " " .. propInfo.Name)
		setmetatable(self, CustomNode)
		self:editColor(defaultColor)

		self:addInput(IO.Input.new("Exec", ""))
		self:addInput(IO.Input.new("Instance", "nil", false, nil, className))
		self:addInput(IO.Input.new("Value", "nil", false, nil, getTypeString(propInfo.Type)))
		self:addOutput(IO.Output.new("Exec", ""))

		return self
	end

	function CustomNode:toLuau()
		local inst = self:getInput("Instance").Value or "nil"
		local val = self:getInput("Value").Value or "nil"
		return inst .. "." .. propInfo.Name .. " = " .. val .. "\n"
	end

	return CustomNode
end

function ReflectionGenerator.createCastNode(className, readableProperties, overrideColor)
	local CustomNode = {}
	CustomNode.__index = CustomNode
	setmetatable(CustomNode, Node)

	local defaultColor = overrideColor or Color3.fromRGB(120, 100, 180) -- Conversion color
	CustomNode.DefaultColor = defaultColor

	function CustomNode.new()
		local self = Node.new("Instance To " .. className, NodeType.FUNCTION)
		setmetatable(self, CustomNode)
		self:editColor(defaultColor)

		self:addInput(IO.Input.new("Instance", "nil", false, nil, className))
		
		-- Add output pins for every readable property
		if readableProperties then
			for _, prop in ipairs(readableProperties) do
				self:addOutput(IO.Output.new(prop.Name, "nil", false, nil, getTypeString(prop.Type)))
			end
		end

		return self
	end

	function CustomNode:toLuau()
		local inst = self:getInput("Instance").Value or "nil"
		
		-- Populate output values for downstream nodes
		if readableProperties then
			for _, prop in ipairs(readableProperties) do
				self:getOutput(prop.Name).Value = inst .. "." .. prop.Name
			end
		end
		
		return "" -- No code generated, just propagates values
	end

	return CustomNode
end

return ReflectionGenerator
