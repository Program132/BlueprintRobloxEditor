from src.Nodes.Node import Node

class FloatingPointRemainder(Node):
    def __init__(self):
        super().__init__()
        self.loadFromJson("nodes/math/floatingpointremainder.json")

    def toLuau(self):
        x = self.getInputValue("x")
        y = self.getInputValue("y")
        r = f"(math.fmod({x}, {y}))"
        self.setOutputValue(name="result", value=r)

    def __str__(self):
        return "FMOD NODE"