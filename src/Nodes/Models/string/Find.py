from src.Nodes.Node import Node

class Find(Node):
    def __init__(self):
        super().__init__()
        self.loadFromJson("nodes/string/find.json")

    def toLuau(self):
        string = self.getInputValue("str")
        s = self.getInputValue("s")
        r = f"(string.find({string}, {s})"
        self.setOutputValue(name="result", value=r)

    def __str__(self):
        return "FIND NODE"