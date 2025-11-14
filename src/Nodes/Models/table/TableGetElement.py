from src.Nodes.Node import Node
from src.Nodes.Utils import is_luau_expression

class TableGetElement(Node):
    def __init__(self):
        super().__init__()
        self.loadFromJson("nodes/table/tableget.json")

    def toLuau(self):
        table_name = str(self.getInputValue("table"))
        key_expression = str(self.getInputValue("key"))

        engine_vars = self.engine.variables if hasattr(self, "engine") and self.engine else []
        luau_expression = str(key_expression)
        if not is_luau_expression(luau_expression, engine_vars):
            key_expression = f'"{key_expression}"'

        r = f"{table_name}[{key_expression}]"
        self.setOutputValue("value", r)