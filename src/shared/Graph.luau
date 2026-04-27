local _Node = require(script.Parent.Node)
local NodeType = require(script.Parent.NodeType)
local IO = require(script.Parent.IO)
local Block = require(script.Parent.Block)

local Graph = {}
Graph.__index = Graph

function Graph.new()
    local self = setmetatable({}, Graph)
    self.nodes = {} -- Map of ID -> NodeInstance
    self.exec_edges = {} -- List of ExecEdge
    self.data_edges = {} -- List of DataEdge
    return self
end

function Graph:add_node(node)
    self.nodes[node.Id] = node
end

function Graph:remove_node(node)
    self.nodes[node.Id] = nil
    
    -- Remove exec connections
    for i = #self.exec_edges, 1, -1 do
        local edge = self.exec_edges[i]
        if rawequal(edge.FromNode, node) or rawequal(edge.ToNode, node) then
            table.remove(self.exec_edges, i)
        end
    end
    
    -- Remove data connections
    for i = #self.data_edges, 1, -1 do
        local edge = self.data_edges[i]
        if rawequal(edge.FromNode, node) or rawequal(edge.ToNode, node) then
            table.remove(self.data_edges, i)
        end
    end
end

--- Connect two nodes with an execution edge.
function Graph:connect_exec(from_node, to_node, from_pin, to_pin)
    local fPin = from_pin or "Exec"
    local tPin = to_pin or "Exec"
    -- Enforce single outgoing connection for exec pins
    for i = #self.exec_edges, 1, -1 do
        local edge = self.exec_edges[i]
        if rawequal(edge.FromNode, from_node) and edge.FromPort == fPin then
            table.remove(self.exec_edges, i)
        end
    end
    local edge = Block.ExecEdge.new(from_node, to_node, fPin, tPin)
    table.insert(self.exec_edges, edge)
end

--- Connect two nodes with a data edge (output → input).
function Graph:connect_data(from_node, to_node, output_name, input_name)
    if type(from_node) ~= "table" or type(to_node) ~= "table" then
        warn("Graph: connect_data received non-table nodes", typeof(from_node), typeof(to_node))
        return
    end

    if not from_node.getOutput or not to_node.getInput then
        warn(string.format("Graph: Node missing methods! From: %s (HasOutput: %s), To: %s (HasInput: %s)", 
            tostring(from_node.Name or from_node.Title or "Unknown"), tostring(from_node.getOutput ~= nil),
            tostring(to_node.Name or to_node.Title or "Unknown"), tostring(to_node.getInput ~= nil)))
        
        -- Fallback: If it's a raw data table, it shouldn't be here, but let's try to find why.
        return
    end

    -- Enforce single incoming connection for data input pins
    for i = #self.data_edges, 1, -1 do
        local edge = self.data_edges[i]
        if rawequal(edge.ToNode, to_node) and edge.ToPort == input_name then
            table.remove(self.data_edges, i)
        end
    end
    
    local outPin = from_node:getOutput(output_name)
    local inPin = to_node:getInput(input_name)
    
    if not inPin and to_node.Name == "Function Return" then
        -- Auto-reconstruct missing pins on Return nodes for robustness
        if to_node.addInput then
            to_node:addInput(IO.Input.new(input_name, ""))
            inPin = to_node:getInput(input_name)
        end
    end

    if outPin and inPin then
        local edge = Block.DataEdge.new(from_node, to_node, output_name, input_name)
        table.insert(self.data_edges, edge)
    else
        -- warn("Graph: Failed to connect data pins: " .. output_name .. " -> " .. input_name .. " (Pins not found on " .. to_node.Name .. ")")
    end
end

--- Disconnect a specific edge.
function Graph:disconnect(from_node, to_node, from_port, to_port, is_exec)
    if is_exec then
        for i = #self.exec_edges, 1, -1 do
            local edge = self.exec_edges[i]
            if rawequal(edge.FromNode, from_node) and rawequal(edge.ToNode, to_node) 
               and edge.FromPort == from_port and edge.ToPort == to_port then
                table.remove(self.exec_edges, i)
                return true
            end
        end
    else
        for i = #self.data_edges, 1, -1 do
            local edge = self.data_edges[i]
            if rawequal(edge.FromNode, from_node) and rawequal(edge.ToNode, to_node) and edge.FromPort == from_port and edge.ToPort == to_port then
                table.remove(self.data_edges, i)
                return true
            end
        end
    end
    return false
end

--- Internal helper: compute reachable nodes and relevant edges for a start node.
function Graph:_get_reachable_nodes(start_node)
    local reachable = { [start_node] = true }
    local queue = { start_node }
    
    -- 1. Find nodes reachable via execution flow
    while #queue > 0 do
        local curr = table.remove(queue, 1)
        for _, edge in ipairs(self.exec_edges) do
            if rawequal(edge.FromNode, curr) and not reachable[edge.ToNode] then
                reachable[edge.ToNode] = true
                table.insert(queue, edge.ToNode)
            end
        end
    end
    
    -- 2. Find nodes reachable via data dependencies (backward from exec-reachable nodes)
    local data_queue = {}
    for node, _ in pairs(reachable) do
        table.insert(data_queue, node)
    end
    
    while #data_queue > 0 do
        local curr = table.remove(data_queue, 1)
        for _, edge in ipairs(self.data_edges) do
            if rawequal(edge.ToNode, curr) and not reachable[edge.FromNode] then
                reachable[edge.FromNode] = true
                table.insert(data_queue, edge.FromNode)
            end
        end
    end
    
    local edges = {}
    for _, edge in ipairs(self.exec_edges) do
        if reachable[edge.FromNode] and reachable[edge.ToNode] then
            table.insert(edges, edge)
        end
    end
    
    local d_edges = {}
    for _, edge in ipairs(self.data_edges) do
        if reachable[edge.ToNode] then
            table.insert(d_edges, edge)
        end
    end
    
    return reachable, edges, d_edges
end

function Graph:build_blocks()
    local roots = {}
    
    -- Roots are nodes with NO incoming exec edges AND must be of type EVENT
    for _, node in pairs(self.nodes) do
        local isRoot = true
        for _, edge in ipairs(self.exec_edges) do
            if rawequal(edge.ToNode, node) then
                isRoot = false
                break
            end
        end
        -- Only EVENT nodes can start a block (Start Event, Function Entry)
        if isRoot and node.Type == NodeType.EVENT then
            table.insert(roots, node)
        end
    end
    
    local blocks = {}
    for _, root in ipairs(roots) do
        local _, exec_edges, data_edges = self:_get_reachable_nodes(root)
        local b = Block.new(root)
        b.exec_edges = exec_edges
        b.data_edges = data_edges
        table.insert(blocks, b)
    end
    
    return blocks
end

function Graph:compile()
    local blocks = self:build_blocks()
    local code = ""
    for _, b in ipairs(blocks) do
        code ..= b:run() .. "\n"
    end
    return code
end

function Graph:toLuau(variables)
    -- Identify used variables to declare them locally
    local usedVars = {}
    for _, node in pairs(self.nodes) do
        if node.Name == "Get Variable" or node.Name == "Set Variable" then
            local nameInput = node:getInput("name")
            if nameInput and nameInput.Value ~= "" then
                usedVars[nameInput.Value] = true
            end
        end
    end

    local prefix = ""
    local sortedVars = {}
    for varName, _ in pairs(usedVars) do
        table.insert(sortedVars, varName)
    end
    table.sort(sortedVars)

    for _, varName in ipairs(sortedVars) do
        prefix ..= "local var_" .. varName .. " = nil\n"
    end
    
    local compiled = self:compile()
    if prefix ~= "" and compiled ~= "" then
        prefix ..= "\n"
    end
    
    return prefix .. compiled
end

function Graph:serialize()
    local data = {
        nodes = {},
        exec_edges = {},
        data_edges = {}
    }
    
    for _, node in pairs(self.nodes) do
        local nData = {
            Id = node.Id,
            Name = node.Name,
            Class = node.Class or node.Name,
            Title = node.Title,
            Position = { X = node.Position.X, Y = node.Position.Y },
            InputsValues = {},
            OutputsValues = {}
        }
        for _, input in ipairs(node:getInputs()) do
            nData.InputsValues[input.Name] = input.Value
        end
        for _, output in ipairs(node:getOutputs()) do
            nData.OutputsValues[output.Name] = output.Value
        end
        table.insert(data.nodes, nData)
    end
    
    for _, edge in ipairs(self.exec_edges) do
        table.insert(data.exec_edges, {
            fromId = edge.FromNode.Id,
            toId = edge.ToNode.Id,
            fromPin = edge.FromPort,
            toPin = edge.ToPort
        })
    end
    
    for _, edge in ipairs(self.data_edges) do
        table.insert(data.data_edges, {
            fromId = edge.FromNode.Id,
            toId = edge.ToNode.Id,
            outName = edge.FromPort,
            inName = edge.ToPort
        })
    end
    
    return data
end

function Graph.from_data(data, Nodes, context)
    local graph = Graph.new()
    if not data or not data.nodes then return graph end

    for _, nData in ipairs(data.nodes) do
        local nodeClass = Nodes[nData.Class]
        
        -- Special handling for dynamic classes (like "Call MyFunction")
        if not nodeClass then
            if nData.Class:sub(1, 5) == "Call " then
                nodeClass = Nodes["Function Call"]
            elseif nData.Class:sub(1, 12) == "MethodEntry:" then
                nodeClass = Nodes["Function Entry"]
            elseif nData.Class:sub(1, 13) == "MethodReturn:" then
                nodeClass = Nodes["Function Return"]
            end
        end

        if nodeClass then
            local nodeInstance = nodeClass.new(nData, context)
            if nData.Id then
                nodeInstance.Id = nData.Id
            end
            if nData.Class then
                nodeInstance.Class = nData.Class
            end
            nodeInstance:editPosition(Vector2.new(nData.Position.X, nData.Position.Y))
            
            if nData.InputsValues then
                for name, val in pairs(nData.InputsValues) do
                    local inp = nodeInstance:getInput(name)
                    if inp then
                        inp.Value = val
                    end
                end
            end
            
            graph:add_node(nodeInstance)
        else
            warn("Graph: Unknown node class: " .. (nData.Class or "nil"))
        end
    end
    
    for _, eData in ipairs(data.exec_edges or {}) do
        local fromNode = graph.nodes[eData.fromId]
        local toNode = graph.nodes[eData.toId]
        if fromNode and toNode then
            graph:connect_exec(fromNode, toNode, eData.fromPin, eData.toPin)
        end
    end
    
    for _, eData in ipairs(data.data_edges or {}) do
        local fromNode = graph.nodes[eData.fromId]
        local toNode = graph.nodes[eData.toId]
        if fromNode and toNode then
            graph:connect_data(fromNode, toNode, eData.outName, eData.inName)
        end
    end
    
    return graph
end

return Graph
