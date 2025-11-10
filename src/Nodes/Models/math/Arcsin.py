from src.Nodes.Node import Node

class Arcsin(Node):
    def __init__(self):
        super().__init__()
        self.loadFromJson("nodes/math/arcsin.json")

    def toLuau(self):
        a = self.getInputValue("a")
        r = f"(math.asin({a}))"
        self.setOutputValue(name="result", value=r)

    def __str__(self):
        return "ASIN NODE"