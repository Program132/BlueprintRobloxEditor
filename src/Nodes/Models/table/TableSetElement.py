from src.Nodes.Utils import is_luau_expression
from src.Nodes.Node import Node

class TableSetElement(Node):
    def __init__(self):
        super().__init__()
        self.loadFromJson("nodes/table/tableset.json")

    def toLuau(self):
        table_name = str(self.getInputValue("table"))
        key_expression = str(self.getInputValue("key"))
        value_expression = str(self.getInputValue("value"))

        engine_vars = self.engine.variables if hasattr(self, "engine") and self.engine else []
        luau_expression = str(value_expression)
        if not is_luau_expression(luau_expression, engine_vars):
            value_expression = f'"{value_expression}"'
        luau_expression = str(key_expression)
        if not is_luau_expression(luau_expression, engine_vars):
            key_expression = f'"{key_expression}"'

        r = f"{table_name}[{key_expression}] = {value_expression}"
        return r