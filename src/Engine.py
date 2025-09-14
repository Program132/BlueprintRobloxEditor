# src/Engine.py
from src.essentials.NodeType import NodeType


class Engine:
    def __init__(self):
        self.execution_connections = []
        self.data_connections = []

    def addExecutionConnection(self, exec_conn):
        self.execution_connections.append(exec_conn)

    def addDataConnection(self, data_conn):
        self.data_connections.append(data_conn)

    def _find_next_nodes(self, node):
        return [conn.to_node for conn in self.execution_connections if conn.from_node == node]

    def _traverse_exec(self, node, visited):
        if node in visited:
            return []
        visited.add(node)

        try:
            node.getValue()
        except Exception:
            pass

        lines = []
        luau_code = node.toLuau()
        if luau_code and node.nodeType != NodeType.METHOD:
            lines.append(luau_code)

        for next_node in self._find_next_nodes(node):
            lines.extend(self._traverse_exec(next_node, visited))

        return lines

    def __str__(self):
        for data_conn in self.data_connections:
            data_conn.propagate()

        start_nodes = [conn.from_node for conn in self.execution_connections
                       if conn.from_node.__class__.__name__ == "EventStartNode"]

        visited = set()
        lines = []
        for start in start_nodes:
            lines.extend(self._traverse_exec(start, visited))

        return "\n".join(lines)
