from src.Node import Node, NodeType

class ForInPairs(Node):
    def __init__(self):
        super().__init__("nodes/statement/forinpairs.json")

    def toLuau(self) -> str:
        key_var = self.getInputValue("keyVariable") or "key"
        value_var = self.getInputValue("valueVariable") or "value"
        table = self.getInputValue("table") or "myTable"

        if ':' in str(table) or '(' in str(table):
            table_formatted = table
        else:
            table_formatted = self._formatValueForLuau(table)

        luau_code = f"for {key_var}, {value_var} in pairs({table_formatted}) do"
        return luau_code
