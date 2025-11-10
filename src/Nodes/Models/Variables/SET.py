import json
from src.Nodes.Node import Node
from src.Nodes.Utils import is_luau_expression

class SET(Node):
    def __init__(self):
        super().__init__()
        self.loadFromJson("nodes/variables/set.json")

    def toLuau(self):
        value = self.getInputValue("value")
        name = self.getInputValue("name")

        if name is None:
            return None

        if value is None:
            luau_expression = "nil"
        else:
            luau_expression = str(value)

        engine_vars = self.engine.variables if hasattr(self, "engine") and self.engine else []

        if is_luau_expression(luau_expression, engine_vars):
            return f"{name} = {luau_expression}"
        else:
            return f'{name} = "{luau_expression}"'