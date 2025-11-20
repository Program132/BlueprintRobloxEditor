from src.Node import Node

class Not(Node):
    def __init__(self):
        super().__init__("nodes/boolean/not.json")

    def toLuau(self):
        a = self.getInputValue("a")

        if self._detectValueType(a) == "string" and not str(a).strip().startswith('"'):
            a = f'"{a}"'

        r = f"(not {a})"
        self.setOutputValue(name="result", value=r)