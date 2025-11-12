from src.Nodes.Node import Node

class Repeat(Node):
    def __init__(self):
        super().__init__()
        self.loadFromJson("nodes/string/repeat.json")

    def toLuau(self):
        s = self.getInputValue("str")
        n = self.getInputValue("n")
        r = f"(string.rep({s}, {n})"
        self.setOutputValue(name="result", value=r)

    def __str__(self):
        return "REPEAT NODE"