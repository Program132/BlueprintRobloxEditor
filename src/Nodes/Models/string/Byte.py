from src.Nodes.Utils import is_luau_expression
from src.Nodes.Node import Node

class Byte(Node):
    def __init__(self):
        super().__init__()
        self.loadFromJson("nodes/string/byte.json")

    def toLuau(self):
        a = self.getInputValue("a")

        engine_vars = self.engine.variables if hasattr(self, "engine") and self.engine else []
        luau_expression = str(a)
        if is_luau_expression(luau_expression, engine_vars):
            r = f"(string.byte({a})"
        else:
            r = f"(string.byte(\"{a}\")"


        self.setOutputValue(name="result", value=r)

    def __str__(self):
        return "BYTE NODE"