from src.Node import Node

class Arcsin(Node):
    def __init__(self):
        super().__init__("nodes/math/arcsin.json")

    def toLuau(self):
        a = self.getInputValue("a")
        r = f"(math.asin({a}))"
        self.setOutputValue(name="result", value=r)