from src.Nodes.Node import Node

class Length(Node):
    def __init__(self):
        super().__init__()
        self.loadFromJson("nodes/string/length.json")

    def toLuau(self):
        a = self.getInputValue("a")
        r = f"(string.len({a})"
        self.setOutputValue(name="result", value=r)

    def __str__(self):
        return "LEN NODE"