--!strict
local NodeModule = require(script.Parent.Node)
local IO = require(script.Parent.IO)
local NodeTypeModule = require(script.Parent.NodeType)

type Node = NodeModule.Node
type NodeType = NodeTypeModule.NodeType

type Input = IO.Input
type Output = IO.Output

-- DataEdge represents a data connection (output -> input)
local DataEdge = {}
DataEdge.__index = DataEdge
export type DataEdge = typeof(setmetatable({} :: {
	FromNode: Node,
	ToNode: Node,
	FromPort: string,
	ToPort: string,
}, DataEdge))

function DataEdge.new(fromNode: Node, toNode: Node, fromPort: string, toPort: string): DataEdge
	local self = setmetatable({
		FromNode = fromNode,
		ToNode = toNode,
		FromPort = fromPort,
		ToPort = toPort,
	}, DataEdge)
	return self
end

-- ExecEdge represents an execution flow (exec pin)
local ExecEdge = {}
ExecEdge.__index = ExecEdge
export type ExecEdge = typeof(setmetatable({} :: {
	FromNode: Node,
	ToNode: Node,
	FromPort: string,
	ToPort: string,
}, ExecEdge))

function ExecEdge.new(fromNode: Node, toNode: Node, fromPort: string, toPort: string): ExecEdge
	local self = setmetatable({
		FromNode = fromNode,
		ToNode = toNode,
		FromPort = fromPort,
		ToPort = toPort,
	}, ExecEdge)
	return self
end

-- Block groups edges for a given parent node
local Block = {}
Block.__index = Block
export type Block = typeof(setmetatable({} :: {
	exec_edges: {ExecEdge},
	data_edges: {DataEdge},
	parent_node: Node,
	events_counts: IntValue?,
}, Block))

-- Constructor validates that the parent node is an EVENT type
function Block.new(parentNode: Node): Block
	if parentNode.Type ~= NodeTypeModule.EVENT then
		error("Block: parent node must be of type EVENT")
	end
	local self = setmetatable({
		exec_edges = {},
		data_edges = {},
		parent_node = parentNode,
	}, Block)
	return self
end

function Block:connect_exec(fromNode: Node, toNode: Node, fromPort: string, toPort: string)
	local edge = ExecEdge.new(fromNode, toNode, fromPort, toPort)
	table.insert(self.exec_edges, edge)
end

function Block:connect_data(fromNode: Node, toNode: Node, fromPort: string, toPort: string)
	-- Validate ports: output must exist on fromNode, input must exist on toNode
	local outputObj = fromNode:getOutput(fromPort)
	local inputObj = toNode:getInput(toPort)
	if not outputObj then
		warn("connect_data: Output port '" .. fromPort .. "' not found on node " .. tostring(fromNode.Id))
		return
	end
	if not inputObj then
		warn("connect_data: Input port '" .. toPort .. "' not found on node " .. tostring(toNode.Id))
		return
	end
	local edge = DataEdge.new(fromNode, toNode, fromPort, toPort)
	table.insert(self.data_edges, edge)
end

function Block:transfer_data()
	for _, edge in ipairs(self.data_edges) do
		local outputObj = edge.FromNode:getOutput(edge.FromPort)
		local inputObj = edge.ToNode:getInput(edge.ToPort)
		if outputObj and inputObj then
			inputObj.Value = outputObj.Value
		else
			warn("transfer_data: Invalid ports", edge.FromPort, "->", edge.ToPort)
		end
	end
end

-- Internal recursive execution helper
local function _run_node(node: Node, visited: { [Node]: boolean }, block: Block): string
	if visited[node] then
		return ""
	end
	visited[node] = true
	
	-- Execute the node to compute its outputs
	local code = ""
	local nodeCode = node:toLuau()
	if nodeCode and nodeCode ~= "" then
		code = code .. nodeCode .. "\n"
	end
	
	-- Transfer data from this node's outputs to connected nodes' inputs
	for _, edge in ipairs(block.data_edges) do
		if edge.FromNode == node then
			local outputObj = edge.FromNode:getOutput(edge.FromPort)
			local inputObj = edge.ToNode:getInput(edge.ToPort)
			if outputObj and inputObj then
				inputObj.Value = outputObj.Value
			end
		end
	end
	
	-- Follow exec edges originating from this node
	for _, edge in ipairs(block.exec_edges) do
		if edge.FromNode == node then
			code = code .. _run_node(edge.ToNode, visited, block)
		end
	end
	return code
end

function Block:run(): string
	-- Generate code by traversing exec edges starting from the parent node
	-- Data transfer happens after each node execution in _run_node
	local visited = {}
	local generated = _run_node(self.parent_node, visited, self)
	return generated
end

-- Export edge types for external use
Block.DataEdge = DataEdge
Block.ExecEdge = ExecEdge

return Block