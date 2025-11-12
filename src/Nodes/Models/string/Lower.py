from src.Nodes.Node import Node

class Lower(Node):
    def __init__(self):
        super().__init__()
        self.loadFromJson("nodes/string/lower.json")

    def toLuau(self):
        a = self.getInputValue("a")
        r = f"(string.lower({a})"
        self.setOutputValue(name="result", value=r)

    def __str__(self):
        return "LOWER NODE"