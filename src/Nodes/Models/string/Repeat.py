from src.Nodes.Node import Node

class Repeat(Node):
    def __init__(self):
        super().__init__()
        self.loadFromJson("nodes/string/find.json")

    def toLuau(self):
        string = self.getInputValue("str")
        n = self.getInputValue("n")
        r = f"(string.rep({string}, {n})"
        self.setOutputValue(name="result", value=r)

    def __str__(self):
        return "REPEAT NODE"