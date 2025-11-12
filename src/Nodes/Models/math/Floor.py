from src.Nodes.Node import Node

class Floor(Node):
    def __init__(self):
        super().__init__()
        self.loadFromJson("nodes/math/floor.json")

    def toLuau(self):
        a = self.getInputValue("a")
        r = f"(math.floor({a}))"
        self.setOutputValue(name="result", value=r)

    def __str__(self):
        return "FLOOR NODE"