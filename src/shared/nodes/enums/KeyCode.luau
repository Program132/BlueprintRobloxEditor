local Node = require(script.Parent.Parent.Parent.Node)
local NodeType = require(script.Parent.Parent.Parent.NodeType)
local IO = require(script.Parent.Parent.Parent.IO)

local KeyCodes = {
	"Unknown", "Backspace", "Tab", "Clear", "Return", "Pause", "Escape", "Space",
	"QuotedDouble", "Hash", "Dollar", "Percent", "Ampersand", "Quote", "LeftParenthesis",
	"RightParenthesis", "Asterisk", "Plus", "Comma", "Minus", "Period", "Slash",
	"Zero", "One", "Two", "Three", "Four", "Five", "Six", "Seven", "Eight", "Nine",
	"Colon", "Semicolon", "LessThan", "Equals", "GreaterThan", "Question", "At",
	"LeftBracket", "BackSlash", "RightBracket", "Caret", "Underscore", "Backquote",
	"A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P",
	"Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z", "LeftCurly", "Pipe", "RightCurly",
	"Tilde", "Delete", "KeypadZero", "KeypadOne", "KeypadTwo", "KeypadThree", "KeypadFour",
	"KeypadFive", "KeypadSix", "KeypadSeven", "KeypadEight", "KeypadNine", "KeypadPeriod",
	"KeypadDivide", "KeypadMultiply", "KeypadMinus", "KeypadPlus", "KeypadEnter",
	"KeypadEquals", "Up", "Down", "Right", "Left", "Insert", "Home", "End", "PageUp",
	"PageDown", "F1", "F2", "F3", "F4", "F5", "F6", "F7", "F8", "F9", "F10", "F11",
	"F12", "F13", "F14", "F15", "NumLock", "CapsLock", "ScrollLock", "RightShift",
	"LeftShift", "RightControl", "LeftControl", "RightAlt", "LeftAlt", "RightMeta",
	"LeftMeta", "LeftSuper", "RightSuper", "Mode", "Compose", "Help", "Print",
	"SysReq", "Break", "Menu", "Power", "Euro", "Undo", "ButtonX", "ButtonY",
	"ButtonA", "ButtonB", "ButtonR1", "ButtonL1", "ButtonR2", "ButtonL2", "ButtonR3",
	"ButtonL3", "ButtonStart", "ButtonSelect", "DPadLeft", "DPadRight", "DPadUp",
	"DPadDown", "Thumbstick1", "Thumbstick2", "Thumbstick1Up", "Thumbstick1Down",
	"Thumbstick1Left", "Thumbstick1Right", "Thumbstick2Up", "Thumbstick2Down",
	"Thumbstick2Left", "Thumbstick2Right", "MouseLeftButton", "MouseRightButton",
	"MouseMiddleButton", "MousePosition", "TouchPosition", "MouseWheel", "TrackpadPan",
	"TrackpadPinch", "MouseDelta"
}

local KeyCodeNode = {}
KeyCodeNode.__index = KeyCodeNode
setmetatable(KeyCodeNode, Node)

function KeyCodeNode.new()
	local self = Node.new("Enum KeyCode", NodeType.ENUM)
	setmetatable(self, KeyCodeNode)
	self:editColor(Color3.fromRGB(150, 150, 40)) -- Yellow-ish for Enums
	
	self:addInput(IO.Input.new("KeyCode", "A", false, KeyCodes))
	self:addOutput(IO.Output.new("Enum", "Enum.KeyCode.A"))
	
	return self
end

function KeyCodeNode:toLuau()
	local selected = self:getInput("KeyCode").Value
	self:getOutput("Enum").Value = `Enum.KeyCode.{selected}`
	return ""
end

return KeyCodeNode
