--!strict
--[[
  Graph.luau
  ------------
  Luau implementation of the original Python `graph.py`.
  Manages Nodes, ExecEdges and DataEdges, builds Blocks for EVENT roots.
]]

local NodeModule = require(script.Parent.Node)
local NodeTypeModule = require(script.Parent.NodeType)
local BlockModule = require(script.Parent.Block)

type Node = NodeModule.Node
type NodeType = NodeTypeModule.NodeType
type Block = BlockModule.Block
type ExecEdge = BlockModule.ExecEdge
type DataEdge = BlockModule.DataEdge

local NodeType = NodeTypeModule
local Block = BlockModule
local ExecEdge = BlockModule.ExecEdge
local DataEdge = BlockModule.DataEdge

type Graph = {
    nodes: { [Node]: boolean },
    exec_edges: { ExecEdge },
    data_edges: { DataEdge },
}

local Graph = {}
Graph.__index = Graph

--- Create a new empty graph.
function Graph.new()
    local self = setmetatable({
        nodes = {},
        exec_edges = {},
        data_edges = {},
    }, Graph)
    return self
end

--- Add a node to the graph.
function Graph:add_node(node: Node)
    self.nodes[node] = true
end

--- Connect two nodes with an execution edge.
function Graph:connect_exec(from_node: Node, to_node: Node, exec_pin: string?)
    local pin = exec_pin or "default"
    local edge = ExecEdge.new(from_node, to_node, pin, pin)
    table.insert(self.exec_edges, edge)
end

--- Connect two nodes with a data edge (output → input).
function Graph:connect_data(from_node: Node, to_node: Node, output_name: string, input_name: string)
    local edge = DataEdge.new(from_node, to_node, output_name, input_name)
    table.insert(self.data_edges, edge)
end

--- Internal helper: compute reachable nodes and relevant edges for a start node.
function Graph:_get_reachable_nodes(start_node: Node)
    local reachable: { [Node]: boolean } = { [start_node] = true }
    local queue = { start_node }
    local relevant_exec = {}
    local relevant_data = {}
    while #queue > 0 do
        local current = table.remove(queue, 1)
        for _, edge in ipairs(self.exec_edges) do
            if edge.FromNode == current then
                table.insert(relevant_exec, edge)
                if not reachable[edge.ToNode] then
                    reachable[edge.ToNode] = true
                    table.insert(queue, edge.ToNode)
                end
            end
        end
        for _, edge in ipairs(self.data_edges) do
            if edge.ToNode == current then
                table.insert(relevant_data, edge)
                if not reachable[edge.FromNode] then
                    reachable[edge.FromNode] = true
                    table.insert(queue, edge.FromNode)
                end
            end
        end
    end
    return reachable, relevant_exec, relevant_data
end

--- Find the index of the block whose parent node title is "Event Start".
function Graph.get_start_index_event(blocks: { Block }): number
    for i, block in ipairs(blocks) do
        if block.parent_node.Title == "Event Start" then
            return i
        end
    end
    return -1
end

--- Build Block objects for each root EVENT node.
function Graph:build_blocks(): { Block }
    -- Collect EVENT nodes
    local event_nodes = {}
    for node, _ in pairs(self.nodes) do
        if node.Type == NodeType.EVENT then
            table.insert(event_nodes, node)
        end
    end
    -- Determine root EVENT nodes (not a target of any exec edge)
    local to_nodes = {}
    for _, edge in ipairs(self.exec_edges) do
        to_nodes[edge.ToNode] = true
    end
    local root_events = {}
    for _, ev in ipairs(event_nodes) do
        if not to_nodes[ev] then
            table.insert(root_events, ev)
        end
    end
    -- Fallback to "Event Start" if no roots
    if #root_events == 0 then
        for node, _ in pairs(self.nodes) do
            if node.Title == "Event Start" then
                table.insert(root_events, node)
                break
            end
        end
        if #root_events == 0 then
            error("Graph must contain at least one root EVENT node.")
        end
    end
    local blocks = {}
    for _, root in ipairs(root_events) do
        local reachable, exec_edges, _data_edges = self:_get_reachable_nodes(root)
        local block = Block.new(root)
        block.exec_edges = exec_edges
        -- Filter data edges to those fully reachable
        local filtered = {}
        for _, de in ipairs(self.data_edges) do
            if reachable[de.FromNode] and reachable[de.ToNode] then
                table.insert(filtered, de)
            end
        end
        block.data_edges = filtered
        table.insert(blocks, block)
    end
    -- Ensure "Event Start" block is first
    local start_i = Graph.get_start_index_event(blocks)
    if start_i ~= -1 and start_i ~= 1 then
        blocks[1], blocks[start_i] = blocks[start_i], blocks[1]
    end
    return blocks
end

--- String representation for debugging.
function Graph:__tostring(): string
    local blocks = self:build_blocks()
    local lines = {}
    for _, b in ipairs(blocks) do
        table.insert(lines, "Block for node: " .. tostring(b.parent_node.Title))
    end
    return table.concat(lines, "\n")
end

return Graph
