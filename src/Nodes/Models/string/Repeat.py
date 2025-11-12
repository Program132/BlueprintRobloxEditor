from src.Nodes.Utils import is_luau_expression
from src.Nodes.Node import Node

class Repeat(Node):
    def __init__(self):
        super().__init__()
        self.loadFromJson("nodes/string/repeat.json")

    def toLuau(self):
        s = self.getInputValue("str")
        n = self.getInputValue("n")
        engine_vars = self.engine.variables if hasattr(self, "engine") and self.engine else []
        if not is_luau_expression(str(s), engine_vars):
            s = f'"{s}"'
        r = f"(string.rep({s}, {n})"
        self.setOutputValue(name="result", value=r)

    def __str__(self):
        return "REPEAT NODE"