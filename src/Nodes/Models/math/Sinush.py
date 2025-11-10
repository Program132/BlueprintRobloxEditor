from src.Nodes.Node import Node

class Sinush(Node):
    def __init__(self):
        super().__init__()
        self.loadFromJson("nodes/math/sinush.json")

    def toLuau(self):
        a = self.getInputValue("a")
        r = f"(math.sinh({a}))"
        self.setOutputValue(name="result", value=r)

    def __str__(self):
        return "SINH NODE"