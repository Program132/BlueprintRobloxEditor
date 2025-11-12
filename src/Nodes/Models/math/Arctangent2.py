from src.Nodes.Node import Node

class Arctangent2(Node):
    def __init__(self):
        super().__init__()
        self.loadFromJson("nodes/math/arctangent2.json")

    def toLuau(self):
        x = self.getInputValue("x")
        y = self.getInputValue("y")
        r = f"(math.atan2({y}, {x}))"
        self.setOutputValue(name="result", value=r)

    def __str__(self):
        return "ATAN2 NODE"