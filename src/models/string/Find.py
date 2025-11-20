from src.Node import Node

class Find(Node):
    def __init__(self):
        super().__init__("nodes/string/find.json")

    def toLuau(self):
        a = self.getInputValue("str")
        b = self.getInputValue("s")

        if self._detectValueType(a) == "string" and not str(a).strip().startswith('"'):
            a = f'"{a}"'
        if self._detectValueType(b) == "string" and not str(b).strip().startswith('"'):
            b = f'"{b}"'
        r = f"(string.find({a}, {b})"
        self.setOutputValue(name="result", value=r)
