from src.Node import Node

class Division(Node):
    def __init__(self):
        super().__init__("nodes/math/division.json")

    def toLuau(self):
        a = self.getInputValue("a")
        b = self.getInputValue("b")
        r = f"({a} / {b})" if b != 0 else "1"
        self.setOutputValue(name="result", value=r)