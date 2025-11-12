from src.Nodes.Node import Node

class LoadExponent(Node):
    def __init__(self):
        super().__init__()
        self.loadFromJson("nodes/math/loadexponent.json")

    def toLuau(self):
        m = self.getInputValue("m")
        e = self.getInputValue("e")
        r = f"(math.ldexp({m}, {e}))"
        self.setOutputValue(name="result", value=r)

    def __str__(self):
        return "LDEXP NODE"