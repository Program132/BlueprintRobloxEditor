from src.Node import Node

class Lower(Node):
    def __init__(self):
        super().__init__("nodes/string/lower.json")

    def toLuau(self):
        a = self.getInputValue("a")
        v = self._detectValueType(a)
        r = f"string.lower({a})"
        if v == "string" and not str(a).strip().startswith('"'):
            r = f'(string.lower("{a}"))'
        self.setOutputValue(name="result", value=r)
