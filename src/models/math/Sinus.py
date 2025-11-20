from src.Node import Node


class Sinus(Node):
    def __init__(self):
        super().__init__("nodes/math/sinus.json")

    def toLuau(self):
        a = self.getInputValue("a")
        r = f"(math.sin({a}))"
        self.setOutputValue(name="result", value=r)