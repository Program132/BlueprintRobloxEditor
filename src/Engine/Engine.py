from typing import List
from src.Nodes.TransitionType import TransitionType
from src.Nodes.NodeType import NodeType
from src.Nodes.Node import Node
from src.Nodes.Transition import Transition

class Engine:
    def __init__(self):
        self.nodes: List[Node] = []
        self.transitions: List[Transition] = []

    def addNode(self, node: Node):
        self.nodes.append(node)

    def addTransition(self, transition: Transition):
        self.transitions.append(transition)

    def isInputConnectedToOutput(self, inputName):
        for t in self.transitions:
            inp = t.end.getInputs()
            for o in inp:
                if o == inputName:
                    return True
        return False

    def getOutputNodeToInputConnected(self, inputName):
        for t in self.transitions:
            inp = t.end.getInputs()
            for o in inp:
                if o == inputName:
                    return t
        return None

    def generateLuau(self) -> str:
        start_node = next((n for n in self.nodes if n.type == NodeType.EVENT), None)
        if start_node is None:
            return "Error: Need an EVENT node as the first node in your code"

        executable_nodes = [n for n in self.nodes if n.type in (NodeType.FUNCTION, NodeType.METHOD)]

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
                # Appliquer d'abord les valeurs d'entrée à partir des sorties déjà calculées
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
            # Maintenant, on s'assure que le nœud a toutes ses valeurs d'entrée
            # et on génère le code s'il ne s'agit pas d'un simple EVENT.
            if current_node.type == NodeType.METHOD:
                # Si c'est un METHOD comme Print, on n'a pas besoin de le calculer avant,
                # on le génère simplement, car ses inputs ont été mis à jour dans la première étape.
                code = current_node.toLuau()
                if code is not None:
                    luau_code.append(code)

            next_transition = next((t for t in exec_transitions if t.start == current_node), None)

            if next_transition:
                current_node = next_transition.end
            else:
                current_node = None

        return "\n".join(luau_code)