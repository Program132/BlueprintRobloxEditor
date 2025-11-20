from typing import Dict, List, Any
from src.Graph import Graph
from src.Node import Node, NodeType
from src.Block import Block

class FunctionGenerator:
    
    def __init__(self, engine):
        self.engine = engine
    
    def generate_function_definition(self, func_data: Dict[str, Any]) -> str:
        func_name = func_data.get('name', 'UnnamedFunction')
        inputs = func_data.get('inputs', [])
        outputs = func_data.get('outputs', [])
        nodes = func_data.get('nodes', [])
        connections = func_data.get('connections', [])
        has_return = func_data.get('hasReturnNode', False)
        
        signature = self._generate_signature(func_name, inputs)
        
        if nodes:
            body = self._generate_body(nodes, connections, inputs, outputs)
        else:
            body = ""
            if outputs:
                return_values = ", ".join(["nil"] * len(outputs))
                body += f"    return {return_values}\n"
        
        code = f"{signature}\n{body}end\n"
        return code
    
    def _generate_signature(self, func_name: str, inputs: List[str]) -> str:
        params = ", ".join(inputs) if inputs else ""
        return f"local function {func_name}({params})"
    
    def _generate_body(self, nodes: List[dict], connections: List[dict], 
                      inputs: List[str], outputs: List[str]) -> str:
        from src.models.statement.FunctionStartNode import FunctionStartNode
        from src.models.statement.ReturnNode import ReturnNode
        
        graph = Graph()
        node_instances = {}
        
        from app import NODE_CLASS_MAP
        
        for n_data in nodes:
            node_id = n_data.get('id')
            node_name = n_data.get('name', '').lower()
            
            if node_name == 'function_start':
                node_instance = FunctionStartNode(inputs)
                node_instance.id = node_id
                node_instance.engine = self.engine
                graph.add_node(node_instance)
                node_instances[node_id] = node_instance
                
            elif node_name == 'return':
                node_instance = ReturnNode(outputs)
                node_instance.id = node_id
                node_instance.engine = self.engine
                
                node_inputs = n_data.get('inputs', {})
                for input_name, input_value in node_inputs.items():
                    node_instance.setInputValue(input_name, input_value)
                
                graph.add_node(node_instance)
                node_instances[node_id] = node_instance
                
            elif node_name in NODE_CLASS_MAP:
                node_instance = NODE_CLASS_MAP[node_name]()
                node_instance.id = node_id
                node_instance.engine = self.engine
                
                node_inputs = n_data.get('inputs', {})
                for input_name, input_value in node_inputs.items():
                    node_instance.setInputValue(input_name, input_value)
                
                graph.add_node(node_instance)
                node_instances[node_id] = node_instance
        
        for c_data in connections:
            from_id = c_data.get('fromNode')
            to_id = c_data.get('toNode')
            
            from_node = node_instances.get(from_id)
            to_node = node_instances.get(to_id)
            
            if from_node and to_node:
                from_port = c_data.get('fromPort')
                to_port = c_data.get('toPort')
                conn_type = c_data.get('type', 'exec').lower()
                
                if conn_type == 'exec':
                    graph.connect_exec(from_node, to_node, from_port)
                else:
                    graph.connect_data(from_node, to_node, from_port, to_port)
        
        try:
            blocks = graph.build_blocks()
            
            body_code = ""
            for block in blocks:
                block_code = block.run()
                lines = block_code.split("\n")
                indented_lines = []
                for line in lines:
                    if line.strip():
                        indented_lines.append("    " + line)
                    else:
                        indented_lines.append("")
                body_code += "\n".join(indented_lines) + "\n"
            
            return body_code
            
        except ValueError:
            body = ""
            if outputs:
                return_values = ", ".join(["nil"] * len(outputs))
                body += f"    return {return_values}\n"
            return body
    
    def generate_all_functions(self, functions_data: List[Dict[str, Any]]) -> str:
        if not functions_data:
            return ""
        
        code_parts = []
        for func_data in functions_data:
            func_code = self.generate_function_definition(func_data)
            code_parts.append(func_code)
        
        return "\n".join(code_parts)