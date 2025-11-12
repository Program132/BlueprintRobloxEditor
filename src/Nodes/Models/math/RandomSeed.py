from src.Nodes.Node import Node

class RandomSeed(Node):
    def __init__(self):
        super().__init__()
        self.loadFromJson("nodes/math/randomseed.json")

    def toLuau(self):
        a = self.getInputValue("a")
        r = f"(math.randomseed({a}))"
        self.setOutputValue(name="result", value=r)

    def __str__(self):
        return "RANDOMSEED NODE"