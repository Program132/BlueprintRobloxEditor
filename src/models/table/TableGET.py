from src.Node import Node

class TableGET(Node):
    def __init__(self):
        super().__init__("nodes/table/tableget.json")

    def toLuau(self):
        table_name = str(self.getInputValue("table"))
        key_expression = str(self.getInputValue("key"))

        if self._detectValueType(key_expression) == "string" and not str(key_expression).strip().startswith('"'):
            r = f'"{key_expression}"'

        r = f"{table_name}[{key_expression}]"
        self.setOutputValue("value", r)