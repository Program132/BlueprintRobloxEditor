from src.Nodes.Utils import is_luau_expression
from src.Nodes.Node import Node

class Length(Node):
    def __init__(self):
        super().__init__()
        self.loadFromJson("nodes/string/length.json")

    def toLuau(self):
        a = self.getInputValue("a")

        engine_vars = self.engine.variables if hasattr(self, "engine") and self.engine else []
        if not is_luau_expression(str(a), engine_vars):
            a = f'"{a}"'

        r = f"(string.len({a})"
        self.setOutputValue(name="result", value=r)

    def __str__(self):
        return "LEN NODE"