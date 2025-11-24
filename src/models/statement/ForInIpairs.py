from src.Node import Node, NodeType

class ForInIpairs(Node):
    def __init__(self):
        super().__init__("nodes/statement/forinipairs.json")

    def toLuau(self) -> str:
        index_var = self.getInputValue("indexVariable") or "i"
        value_var = self.getInputValue("valueVariable") or "value"
        array = self.getInputValue("array") or "myArray"

        if ':' in str(array) or '(' in str(array):
            array_formatted = array
        else:
            array_formatted = self._formatValueForLuau(array)

        luau_code = f"for {index_var}, {value_var} in ipairs({array_formatted}) do"
        return luau_code
