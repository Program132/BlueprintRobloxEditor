from src.Nodes.Node import Node

class Byte(Node):
    def __init__(self):
        super().__init__()
        self.loadFromJson("nodes/string/byte.json")

    def toLuau(self):
        a = self.getInputValue("a")
        r = f"(string.byte({a})"
        self.setOutputValue(name="result", value=r)

    def __str__(self):
        return "BYTE NODE"