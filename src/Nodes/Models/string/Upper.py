from src.Nodes.Node import Node

class Upper(Node):
    def __init__(self):
        super().__init__()
        self.loadFromJson("nodes/string/upper.json")

    def toLuau(self):
        a = self.getInputValue("a")
        r = f"(string.upper({a})"
        self.setOutputValue(name="result", value=r)

    def __str__(self):
        return "UPPER NODE"