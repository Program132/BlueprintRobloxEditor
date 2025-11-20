from typing import List, Set, Any
from src.Node import Node, NodeType
from src.Block import Block, ExecEdge, DataEdge


class Graph:
    def __init__(self) -> None:
        self.nodes: Set[Node] = set()
        self.exec_edges: List[ExecEdge] = []
        self.data_edges: List[DataEdge] = []

    def add_node(self, node: Node) -> None:
        self.nodes.add(node)

    def connect_exec(self, from_node: Node, to_node: Node, exec_pin: str = "default") -> None:
        self.exec_edges.append(ExecEdge(from_node, to_node, exec_pin))

    def connect_data(self, from_node: Node, to_node: Node, output_name: str, input_name: str) -> None:
        self.data_edges.append(DataEdge(from_node, to_node, output_name, input_name))

    def _get_reachable_nodes(self, start_node: Node) -> tuple[set[Node], list[Any], list[Any]]:
        reachable_nodes = {start_node}
        queue = [start_node]
        relevant_exec_edges = []
        relevant_data_edges = []

        while queue:
            current_node = queue.pop(0)

            for edge in self.exec_edges:
                if edge.from_node == current_node:
                    if edge.to_node not in reachable_nodes:
                        reachable_nodes.add(edge.to_node)
                        queue.append(edge.to_node)
                    relevant_exec_edges.append(edge)

            for edge in self.data_edges:
                if edge.to_node == current_node:
                    if edge.from_node not in reachable_nodes:
                        reachable_nodes.add(edge.from_node)
                        queue.append(edge.from_node)
                    relevant_data_edges.append(edge)

        return reachable_nodes, relevant_exec_edges, relevant_data_edges

    @staticmethod
    def get_start_index_event(blocks):
        i = 0
        while i < len(blocks):
            block = blocks[i]
            if block.parent_node.title == "Event Start":
                return i
            i = i + 1
        return -1

    def build_blocks(self) -> List[Block]:
        event_nodes = {n for n in self.nodes if n.type == NodeType.EVENT}
        root_events = set()
        all_to_nodes = {e.to_node for e in self.exec_edges}

        for event in event_nodes:
            if event not in all_to_nodes:
                root_events.add(event)

        if not root_events:
            start_node = next((n for n in self.nodes if n.title == "Event Start"), None)
            if start_node:
                root_events.add(start_node)
            else:
                raise ValueError("Graph must contain at least one root EVENT node.")

        blocks = []

        for root in root_events:
            reachable_nodes, relevant_exec_edges, relevant_data_edges = self._get_reachable_nodes(root)
            new_block = Block(root)
            new_block.exec_edges = relevant_exec_edges
            new_block.data_edges = [
                edge for edge in self.data_edges
                if edge in relevant_data_edges and edge.from_node in reachable_nodes
            ]
            blocks.append(new_block)

        start_event_i = self.get_start_index_event(blocks)

        if start_event_i != -1 and start_event_i != 0:
            other_block = blocks[0]
            start_block = blocks[start_event_i]
            blocks[0] = start_block
            blocks[start_event_i] = other_block

        return blocks

    def __str__(self):
        blocks = self.build_blocks()
        for b in blocks:
            print(b)
        return ""