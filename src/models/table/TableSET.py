from src.Node import Node

class TableSetElement(Node):
    def __init__(self):
        super().__init__("nodes/table/tableset.json")

    def toLuau(self):
        table_name = str(self.getInputValue("table"))
        key_expression = str(self.getInputValue("key"))
        value_expression = str(self.getInputValue("value"))

        if self._detectValueType(value_expression) == "string" and not str(value_expression).strip().startswith('"'):
            r = f'"{value_expression}"'
        if self._detectValueType(key_expression) == "string" and not str(key_expression).strip().startswith('"'):
            r = f'"{key_expression}"'

        r = f"{table_name}[{key_expression}] = {value_expression}"
        return r