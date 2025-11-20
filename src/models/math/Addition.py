from src.Node import Node


class Addition(Node):
    def __init__(self):
        super().__init__("nodes/math/addition.json")

    def toLuau(self):
        a = self.getInputValue("a")
        b = self.getInputValue("b")
        r = f"({a} + {b})"
        self.setOutputValue(name="result", value=r)