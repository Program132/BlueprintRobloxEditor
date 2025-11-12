from src.Nodes.Node import Node

class Character(Node):
    def __init__(self):
        super().__init__()
        self.loadFromJson("nodes/string/character.json")

    def toLuau(self):
        a = self.getInputValue("a")
        r = f"(string.char({a})"
        self.setOutputValue(name="result", value=r)

    def __str__(self):
        return "CHARACTER NODE"