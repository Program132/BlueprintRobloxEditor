from src.Nodes.Node import Node

class Reverse(Node):
    def __init__(self):
        super().__init__()
        self.loadFromJson("nodes/string/reverse.json")

    def toLuau(self):
        a = self.getInputValue("a")
        r = f"(string.reverse({a})"
        self.setOutputValue(name="result", value=r)

    def __str__(self):
        return "REVERSE NODE"