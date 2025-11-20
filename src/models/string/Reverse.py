from src.Node import Node

class Reverse(Node):
    def __init__(self):
        super().__init__("nodes/string/reverse.json")

    def toLuau(self):
        a = self.getInputValue("a")

        if self._detectValueType(a) == "string" and not str(a).strip().startswith('"'):
            a = f'"{a}"'
        r = f"(string.reverse({a})"
        self.setOutputValue(name="result", value=r)
