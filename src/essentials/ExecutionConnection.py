# src/essentials/ExecutionConnection.py
class ExecutionConnection:
    def __init__(self, from_node, to_node):
        self.from_node = from_node
        self.to_node = to_node

        if not hasattr(from_node, "exec_outputs"):
            from_node.exec_outputs = []
        from_node.exec_outputs.append(to_node)