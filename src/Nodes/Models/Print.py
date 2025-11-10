from src.Nodes.Node import Node
from src.Nodes.Utils import is_luau_expression

class Print(Node):
    def __init__(self):
        super().__init__()
        self.loadFromJson("nodes/print.json")

    def toLuau(self):
        v = self.getInputValue("value")
        engine_vars = self.engine.variables if hasattr(self, "engine") and self.engine else []

        if v is None:
            return "print(nil)"

        luau_expression = str(v)

        if is_luau_expression(luau_expression, engine_vars):
            return f"print({luau_expression})"
        else:
            return f'print("{luau_expression}")'

    def __str__(self):
        return "PRINT NODE"