-- Canvas : the main viewport for the blueprint graph, rendered as a unified texture
-- Uses CanvasGroup so all child nodes share group transparency and color tinting
local Canvas = {}
Canvas.__index = Canvas

function Canvas.new(parent)
	local self = setmetatable({}, Canvas)

	-- CanvasGroup renders all descendants as a single flattened texture.
	-- ClipsDescendants is always true on CanvasGroup.
	local group = Instance.new("CanvasGroup")
	group.Name = "Canvas"
	group.Size = UDim2.new(1, 0, 1, -40)
	group.Position = UDim2.new(0, 0, 0, 40)
	group.BackgroundColor3 = Color3.fromRGB(24, 24, 24)
	group.BorderSizePixel = 0
	group.GroupTransparency = 0
	group.Parent = parent

	local placeholder = Instance.new("TextLabel")
	placeholder.Name = "Placeholder"
	placeholder.Size = UDim2.new(1, 0, 1, 0)
	placeholder.BackgroundTransparency = 1
	placeholder.Text = "No project open.\nUse '+ New Project' or 'Open Project' above."
	placeholder.TextColor3 = Color3.fromRGB(100, 100, 100)
	placeholder.TextSize = 14
	placeholder.Font = Enum.Font.Gotham
	placeholder.TextWrapped = true
	placeholder.Parent = group

	self._group = group
	self._placeholder = placeholder

	return self
end

-- Update the placeholder message
function Canvas:SetPlaceholder(text)
	self._placeholder.Text = text
end

-- Hide the placeholder (when a real graph is drawn)
function Canvas:HidePlaceholder()
	self._placeholder.Visible = false
end

-- Fade the whole canvas in/out via GroupTransparency
function Canvas:SetTransparency(t)
	self._group.GroupTransparency = t
end

function Canvas:GetInstance()
	return self._group
end

return Canvas