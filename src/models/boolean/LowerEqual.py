from src.Node import Node


class LowerEqual(Node):
    def __init__(self):
        super().__init__("nodes/boolean/lowerequal.json")

    def toLuau(self):
        a = self.getInputValue("a")
        b = self.getInputValue("b")

        if self._detectValueType(a) == "string" and not str(a).strip().startswith('"'):
            a = f'"{a}"'
        if self._detectValueType(b) == "string" and not str(b).strip().startswith('"'):
            b = f'"{b}"'

        r = f"({a} <= {b})"
        print("BOOLEAN FOUND:" + r)
        self.setOutputValue(name="result", value=r)