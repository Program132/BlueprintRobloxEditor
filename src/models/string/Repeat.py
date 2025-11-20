from src.Node import Node

class Repeat(Node):
    def __init__(self):
        super().__init__("nodes/string/repeat.json")

    def toLuau(self):
        a = self.getInputValue("str")
        b = self.getInputValue("n")

        if self._detectValueType(a) == "string" and not str(a).strip().startswith('"'):
            a = f'"{a}"'
        r = f"(string.rep({a}, {b})"
        self.setOutputValue(name="result", value=r)
