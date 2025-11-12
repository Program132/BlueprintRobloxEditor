from src.Nodes.Utils import is_luau_expression
from src.Nodes.Node import Node

class Character(Node):
    def __init__(self):
        super().__init__()
        self.loadFromJson("nodes/string/character.json")

    def toLuau(self):
        a = self.getInputValue("a")

        engine_vars = self.engine.variables if hasattr(self, "engine") and self.engine else []
        luau_expression = str(a)
        if is_luau_expression(luau_expression, engine_vars):
            r = f"(string.char({a})"
        else:
            r = f"(string.char(\"{a}\")"

        self.setOutputValue(name="result", value=r)

    def __str__(self):
        return "CHARACTER NODE"