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

    def _find_next_nodes(self, node, output_name=None):
        if output_name is None:
            return [conn.to_node for conn in self.execution_connections if conn.from_node == node]
        return [conn.to_node for conn in self.execution_connections
                if conn.from_node == node and getattr(conn, "output_name", None) == output_name]

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
        if node.__class__.__name__ == "IfStatementNode":
            if luau_code:
                lines.append(luau_code)
            success_nodes = self._find_next_nodes(node, "success")
            for next_node in success_nodes:
                lines.extend(self._traverse_exec(next_node, visited))
            fail_nodes = self._find_next_nodes(node, "fail")
            if fail_nodes:
                lines.append("else")
                for next_node in fail_nodes:
                    lines.extend(self._traverse_exec(next_node, visited))
            lines.append("end")
            return lines
        if node.__class__.__name__ == "EndStatementNode":
            if luau_code:
                lines.append(luau_code)
            return lines
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

    exec = addExecutionConnection
    data = addDataConnection
