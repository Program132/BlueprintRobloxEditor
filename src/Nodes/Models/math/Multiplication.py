from src.Nodes.Node import Node


class Multiplication(Node):
    def __init__(self):
        super().__init__()
        self.loadFromJson("nodes/math/multiplication.json")

    def toLuau(self):
        a = self.getInputValue("a")
        b = self.getInputValue("b")
        r = f"({a} * {b})"
        self.setOutputValue(name="result", value=r)

    def __str__(self):
        return "MUL NODE"