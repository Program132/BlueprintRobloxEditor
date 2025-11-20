from src.Node import Node

class Sinush(Node):
    def __init__(self):
        super().__init__("nodes/math/sinush.json")

    def toLuau(self):
        a = self.getInputValue("a")
        r = f"(math.sinh({a}))"
        self.setOutputValue(name="result", value=r)