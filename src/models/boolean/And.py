from src.Node import Node

class And(Node):
    def __init__(self):
        super().__init__("nodes/boolean/add.json")

    def toLuau(self):
        a = self.getInputValue("a")
        b = self.getInputValue("b")

        if self._detectValueType(a) == "string" and not str(a).strip().startswith('"'):
            a = f'"{a}"'
        if self._detectValueType(b) == "string" and not str(b).strip().startswith('"'):
            b = f'"{b}"'

        r = f"({a} and {b})"
        self.setOutputValue(name="result", value=r)