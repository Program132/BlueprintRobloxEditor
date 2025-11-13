from src.Nodes.Utils import is_luau_expression
from src.Nodes.Node import Node

class Lower(Node):
    def __init__(self):
        super().__init__()
        self.loadFromJson("nodes/boolean/low.json")

    def toLuau(self):
        a = self.getInputValue("a")
        b = self.getInputValue("b")

        engine_vars = self.engine.variables if hasattr(self, "engine") and self.engine else []
        if not is_luau_expression(str(a), engine_vars):
            a = f'"{a}"'
        if not is_luau_expression(str(b), engine_vars):
            b = f'"{b}"'

        r = f"({a} < {b})"
        self.setOutputValue(name="result", value=r)

    def __str__(self):
        return "LOWER NODE"