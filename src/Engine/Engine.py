from typing import List
from src.Nodes.TransitionType import TransitionType
from src.Nodes.NodeType import NodeType
from src.Nodes.Node import Node
from src.Nodes.Transition import Transition
from src.Nodes.Models.Variables.Variable import Variable
from src.Nodes.Models.Variables.GET import GET
from src.Nodes.Models.Variables.SET import SET

class Engine:
    def __init__(self):
        self.nodes: List[Node] = []
        self.transitions: List[Transition] = []
        self.variables: List[Variable] = []

    def addNode(self, node: Node):
        node.engine = self
        self.nodes.append(node)

    def addTransition(self, transition: Transition):
        self.transitions.append(transition)

    def isInputConnectedToOutput(self, inputName):
        for t in self.transitions:
            inp = t.end.getInputs()
            for o in inp:
                if o.name == inputName:
                    return True
        return False

    def getOutputNodeToInputConnected(self, inputName):
        for t in self.transitions:
            inp = t.end.getInputs()
            for o in inp:
                if o.name == inputName:
                    return t
        return None

    def addVariable(self, variable: 'Variable'):
        if not any(v.name == variable.name for v in self.variables):
            self.variables.append(variable)

    def getVariable(self, name: str) -> 'Variable':
        return next((v for v in self.variables if v.name == name), None)

    def generateLuau(self) -> str:
        start_node = next((n for n in self.nodes if n.type == NodeType.EVENT), None)
        if start_node is None:
            return "Error: Need an EVENT node as the first node in your code"

        luau_declarations = []
        for var in self.variables:
            initial_value_luau = "nil"

            if var.value is not None:
                if isinstance(var.value, str) and var.value.lower() in ["none", "nil"]:
                    initial_value_luau = "nil"
                elif isinstance(var.value, str):
                    initial_value_luau = f'"{var.value}"'
                else:
                    initial_value_luau = str(var.value)

            luau_declarations.append(f"local {var.name} = {initial_value_luau}")

        executable_nodes = [n for n in self.nodes if n.type == NodeType.FUNCTION or n.type == NodeType.METHOD]
        calculated_nodes = set()

        while len(calculated_nodes) < len(executable_nodes):
            nodes_to_calculate_in_this_pass = []
            for node in executable_nodes:
                if node not in calculated_nodes and node != start_node:
                    is_ready = True
                    for input_port in node.getInputs():
                        is_connected = any(t.end == node and t.input == input_port for t in self.transitions if t.type == TransitionType.DATA)
                        if is_connected:
                            source_transition = next((t for t in self.transitions if t.end == node and t.input == input_port and t.type == TransitionType.DATA), None)
                            if source_transition and source_transition.start not in calculated_nodes:
                                is_ready = False
                                break
                    if is_ready:
                        nodes_to_calculate_in_this_pass.append(node)

            if not nodes_to_calculate_in_this_pass and len(calculated_nodes) < len(executable_nodes):
                break

            for node in nodes_to_calculate_in_this_pass:
                for t in self.transitions:
                    if t.type == TransitionType.DATA and t.end == node and t.start in calculated_nodes:
                        if t.start.type == NodeType.FUNCTION or isinstance(t.start, GET):
                            t.start.toLuau()
                        t.setInputValueFromOutput()
                if node.type == NodeType.FUNCTION:
                    node.toLuau()
                calculated_nodes.add(node)

        luau_code = []
        exec_transitions = [t for t in self.transitions if t.type == TransitionType.EXEC]
        current_node = start_node

        while current_node is not None:
            for t in self.transitions:
                if t.type == TransitionType.DATA and t.end == current_node:
                    t.setInputValueFromOutput()
            if current_node.type == NodeType.METHOD:
                code = current_node.toLuau()
                if code is not None:
                    luau_code.append(code)
            next_transition = next((t for t in exec_transitions if t.start == current_node), None)
            if next_transition:
                current_node = next_transition.end
            else:
                current_node = None

        if len(luau_declarations) != 0:
            return "\n".join(luau_declarations) + "\n" + "\n".join(luau_code)
        return "\n".join(luau_code)