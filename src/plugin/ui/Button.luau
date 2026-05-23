-- Button : wraps a TextButton with a consistent modern style and smooth hover/press animations
local TweenService = game:GetService("TweenService")

local Button = {}
Button.__index = Button

local STYLES = {
	primary = {
		bgStart = Color3.fromRGB(43, 82, 205),
		bgEnd = Color3.fromRGB(33, 67, 178),
		border = Color3.fromRGB(62, 106, 225),
		text = Color3.fromRGB(255, 255, 255),
		hoverBgStart = Color3.fromRGB(53, 92, 225),
		hoverBgEnd = Color3.fromRGB(43, 77, 198),
		hoverBorder = Color3.fromRGB(82, 126, 245),
		hoverText = Color3.fromRGB(255, 255, 255),
	},
	secondary = {
		bgStart = Color3.fromRGB(18, 22, 34),
		bgEnd = Color3.fromRGB(14, 18, 28),
		border = Color3.fromRGB(40, 50, 72),
		text = Color3.fromRGB(255, 255, 255),
		hoverBgStart = Color3.fromRGB(24, 28, 42),
		hoverBgEnd = Color3.fromRGB(18, 22, 34),
		hoverBorder = Color3.fromRGB(60, 70, 92),
		hoverText = Color3.fromRGB(255, 255, 255),
	},
	accent = {
		bgStart = Color3.fromRGB(88, 50, 195),
		bgEnd = Color3.fromRGB(69, 36, 168),
		border = Color3.fromRGB(108, 66, 219),
		text = Color3.fromRGB(255, 255, 255),
		hoverBgStart = Color3.fromRGB(108, 70, 215),
		hoverBgEnd = Color3.fromRGB(89, 56, 188),
		hoverBorder = Color3.fromRGB(128, 86, 239),
		hoverText = Color3.fromRGB(255, 255, 255),
	}
}

function Button.new(parent, name, label, styleName)
	styleName = styleName or "secondary"
	local styleConfig = STYLES[styleName] or STYLES.secondary

	local self = setmetatable({}, Button)

	-- Wrapper frame holds the background and gradient
	local wrapper = Instance.new("Frame")
	wrapper.Name = name
	wrapper.Size = UDim2.new(0, 140, 0, 32)
	wrapper.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	wrapper.BorderSizePixel = 0
	wrapper.ZIndex = 3
	wrapper.Parent = parent

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 4)
	corner.Parent = wrapper

	local grad = Instance.new("UIGradient")
	grad.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, styleConfig.bgStart),
		ColorSequenceKeypoint.new(1, styleConfig.bgEnd)
	})
	grad.Rotation = 90
	grad.Parent = wrapper

	local stroke = Instance.new("UIStroke")
	stroke.Color = styleConfig.border
	stroke.Thickness = 1
	stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	stroke.Parent = wrapper

	-- TextButton for the text and interaction
	local btn = Instance.new("TextButton")
	btn.Name = "ButtonText"
	btn.Size = UDim2.new(1, 0, 1, 0)
	btn.BackgroundTransparency = 1
	btn.Text = label
	btn.TextColor3 = Color3.fromRGB(255, 255, 255)
	btn.TextSize = 14
	btn.Font = Enum.Font.GothamBold
	btn.ZIndex = 4
	btn.Parent = wrapper

	-- Hover effects using TweenService
	local tweenInfo = TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
	
	btn.MouseEnter:Connect(function()
		TweenService:Create(stroke, tweenInfo, {Color = styleConfig.hoverBorder}):Play()
		TweenService:Create(btn, tweenInfo, {TextColor3 = styleConfig.hoverText}):Play()
		grad.Color = ColorSequence.new({
			ColorSequenceKeypoint.new(0, styleConfig.hoverBgStart),
			ColorSequenceKeypoint.new(1, styleConfig.hoverBgEnd)
		})
	end)

	btn.MouseLeave:Connect(function()
		TweenService:Create(stroke, tweenInfo, {Color = styleConfig.border}):Play()
		TweenService:Create(btn, tweenInfo, {TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
		grad.Color = ColorSequence.new({
			ColorSequenceKeypoint.new(0, styleConfig.bgStart),
			ColorSequenceKeypoint.new(1, styleConfig.bgEnd)
		})
	end)

	btn.MouseButton1Down:Connect(function()
		grad.Color = ColorSequence.new({
			ColorSequenceKeypoint.new(0, styleConfig.bgEnd),
			ColorSequenceKeypoint.new(1, styleConfig.bgEnd)
		})
	end)

	btn.MouseButton1Up:Connect(function()
		grad.Color = ColorSequence.new({
			ColorSequenceKeypoint.new(0, styleConfig.hoverBgStart),
			ColorSequenceKeypoint.new(1, styleConfig.hoverBgEnd)
		})
	end)

	self._btn = btn
	self._wrapper = wrapper

	return self
end

-- Register a click callback
function Button:OnClick(callback)
	self._btn.MouseButton1Click:Connect(callback)
end

-- Get the underlying Instance
function Button:GetInstance()
	return self._wrapper
end

return Button