from src.Node import Node

class Length(Node):
    def __init__(self):
        super().__init__("nodes/string/length.json")

    def toLuau(self):
        a = self.getInputValue("a")
        v = self._detectValueType(a)
        r = f"string.len({a})"
        if v == "string" and not str(a).strip().startswith('"'):
            r = f'(string.len("{a}"))'
        self.setOutputValue(name="result", value=r)
