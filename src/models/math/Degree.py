from src.Node import Node

class Degree(Node):
    def __init__(self):
        super().__init__("nodes/math/degree.json")

    def toLuau(self):
        a = self.getInputValue("a")
        r = f"(math.deg({a}))"
        self.setOutputValue(name="result", value=r)