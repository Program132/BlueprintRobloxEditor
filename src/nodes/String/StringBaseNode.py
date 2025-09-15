import re
from src.essentials.Node import Node
from src.essentials.NodeType import NodeType

class _StringNodeBase(Node):
    def _quote_if_needed(self, val):
        from src.essentials.Node import Node as BaseNode
        if isinstance(val, BaseNode):
            val = val.getValue()
        if isinstance(val, str):
            if re.match(r'^[A-Za-z_][A-Za-z0-9_]*$', val):
                return val
            return f'"{val}"'
        return val if val is not None else '""'