from src.Nodes.Utils import is_luau_expression
from src.Nodes.Node import Node

class ToNumber(Node):
    def __init__(self):
        super().__init__()
        self.loadFromJson("nodes/convert/tonumber.json")

    def toLuau(self):
        input_value = self.getInputValue("string")

        luau_expression = str(input_value)
        engine_vars = self.engine.variables if hasattr(self, "engine") and self.engine else []
        r = f"tonumber({input_value})"
        if not is_luau_expression(luau_expression, engine_vars):
            r = f"tonumber(\"{input_value}\")"

        self.setOutputValue("result", r)