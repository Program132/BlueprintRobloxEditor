from src.Nodes.Utils import is_luau_expression
from src.Nodes.Node import Node

class TableInsert(Node):
    def __init__(self):
        super().__init__()
        self.loadFromJson("nodes/table/tableinsert.json")

    def toLuau(self):
        table_name = str(self.getInputValue("table"))
        value_expression = str(self.getInputValue("value"))

        engine_vars = self.engine.variables if hasattr(self, "engine") and self.engine else []
        luau_expression = str(value_expression)
        if not is_luau_expression(luau_expression, engine_vars):
            value_expression = f'"{value_expression}"'

        r = f"table.insert({table_name}, {value_expression})"
        return r