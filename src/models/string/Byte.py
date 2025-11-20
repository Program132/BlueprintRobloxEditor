from src.Node import Node

class Byte(Node):
    def __init__(self):
        super().__init__("nodes/string/byte.json")

    def toLuau(self):
        a = self.getInputValue("a")
        r = f"string.byte({a})"
        if self._detectValueType(a) == "string" and not str(a).strip().startswith('"'):
            r = f'(string.byte("{a}"))'
        self.setOutputValue(name="result", value=r)