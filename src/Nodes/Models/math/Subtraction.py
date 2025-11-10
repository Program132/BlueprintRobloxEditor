from src.Nodes.Node import Node


class Subtraction(Node):
    def __init__(self):
        super().__init__()
        self.loadFromJson("nodes/math/subtraction.json")

    def toLuau(self):
        a = self.getInputValue("a")
        b = self.getInputValue("b")
        r = f"({a} - {b})"
        self.setOutputValue(name="result", value=r)

    def __str__(self):
        return "SUB NODE"