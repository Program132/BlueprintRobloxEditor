local HttpService = game:GetService("HttpService")

local Node = {}
Node.__index = Node

local NodeTypeModule = require(script.Parent.NodeType)
type NodeType = NodeTypeModule.NodeType

local IO = require(script.Parent.IO)
type Input = IO.Input
type Output = IO.Output

export type Node = typeof(setmetatable({} :: {
	Id: string,
	Type: NodeType,
	Name: string,
	Title: string,
	Description: string,
	Position: Vector2,
	Color: Color3,
	Inputs: {Input},
	Outputs: {Output},
	EventsCounts: IntValue,
}, Node))

function Node.new(name: string?, type: NodeType?): Node
	local self = setmetatable({
		Id = HttpService:GenerateGUID(false),
		Type = type or "FUNCTION",
		Name = name or "Node",
		Title = name or "Node",
		Description = "",
		Position = Vector2.zero,
		Color = Color3.new(1, 1, 1),
		Inputs = {},
		Outputs = {},
		EventsCounts = 0,
	}, Node)

	return self
end

function Node:editName(name: string)
	self.Name = name
end

function Node:editTitle(title: string)
	self.Title = title
end

function Node:editDescription(description: string)
	self.Description = description
end

function Node:editPosition(position: Vector2)
	self.Position = position
end

function Node:editColor(color: Color3)
	self.Color = color
end

function Node:editInputs(inputs: {Input})
	self.Inputs = inputs
end

function Node:editOutputs(outputs: {Output})
	self.Outputs = outputs
end

function Node:setX(x: number) 
	self.Position = Vector2.new(x, self.Position.Y)
end

function Node:setY(y: number) 
	self.Position = Vector2.new(self.Position.X, y)
end

function Node:setXY(x: number, y: number) 
	self.Position = Vector2.new(x, y)
end

function Node:getOutputs(): {Output}
	return self.Outputs
end

function Node:getInputs(): {Input}
	return self.Inputs
end

function Node:getOutput(outputName: string): Output?
	for _, output in self.Outputs do
		if output.Name == outputName then
			return output
		end
	end
	return nil
end

function Node:getInput(inputName: string): Input?
	for _, input in self.Inputs do
		if input.Name == inputName then
			return input
		end
	end
	return nil
end

function Node:addOutput(output: Output)
	table.insert(self.Outputs, output)
end

function Node:addInput(input: Input)
	table.insert(self.Inputs, input)
end

function Node:removeOutput(outputName: string)
	for i, output in self.Outputs do
		if output.Name == outputName then
			table.remove(self.Outputs, i)
		end
	end
end

function Node:removeInput(inputName: string)
	for i, input in self.Inputs do
		if input.Name == inputName then
			table.remove(self.Inputs, i)
		end
	end
end

function Node:toLuau(): string
	return ""
end

return Node