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
            if isinstance(var.value, str):
                default_val_luau = f'"{var.value}"'
            elif var.value is None:
                default_val_luau = 'nil'
            elif isinstance(var.value, bool):
                default_val_luau = str(var.value).lower()
            else:
                default_val_luau = str(var.value)
            luau_declarations.append(f'local {var.name} = {default_val_luau}')

        executable_nodes = [n for n in self.nodes if n.type == NodeType.FUNCTION]
        calculated_nodes = set()

        while len(calculated_nodes) < len(executable_nodes):
            nodes_to_calculate_in_this_pass = []
            for node in executable_nodes:
                if node not in calculated_nodes:
                    is_ready = True
                    for t in self.transitions:
                        if t.type == TransitionType.DATA and t.end == node:
                            if t.start not in calculated_nodes:
                                is_ready = False
                                break
                    if is_ready:
                        nodes_to_calculate_in_this_pass.append(node)

            if not nodes_to_calculate_in_this_pass and len(calculated_nodes) < len(executable_nodes):
                break

            for node in nodes_to_calculate_in_this_pass:
                for t in self.transitions:
                    if t.type == TransitionType.DATA and t.end == node and t.start in calculated_nodes:
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
                    if isinstance(t.start, GET):
                        t.start.toLuau()
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
        return "\n".join(luau_declarations) + "\n" + "\n".join(luau_code)