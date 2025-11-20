from src.Node import Node


class TableInsert(Node):
    def __init__(self):
        super().__init__("nodes/table/tableinsert.json")

    def toLuau(self):
        table_name = str(self.getInputValue("table"))
        value_expression = str(self.getInputValue("value"))

        if self._detectValueType(value_expression) == "string" and not str(value_expression).strip().startswith('"'):
            value_expression = f'"{value_expression}"'

        r = f"table.insert({table_name}, {value_expression})"
        return r