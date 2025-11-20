from src.Node import Node

class Upper(Node):
    def __init__(self):
        super().__init__("nodes/string/upper.json")

    def toLuau(self):
        a = self.getInputValue("a")

        if self._detectValueType(a) == "string" and not str(a).strip().startswith('"'):
            a = f'"{a}"'
        r = f"(string.upper({a})"
        self.setOutputValue(name="result", value=r)

