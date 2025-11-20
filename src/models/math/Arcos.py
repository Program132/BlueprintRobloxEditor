from src.Node import Node

class Arcos(Node):
    def __init__(self):
        super().__init__("nodes/math/arcos.json")

    def toLuau(self):
        a = self.getInputValue("a")
        r = f"(math.acos({a}))"
        self.setOutputValue(name="result", value=r)