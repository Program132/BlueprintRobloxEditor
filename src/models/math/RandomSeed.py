from src.Node import Node

class RandomSeed(Node):
    def __init__(self):
        super().__init__("nodes/math/randomseed.json")

    def toLuau(self):
        a = self.getInputValue("a")
        r = f"(math.randomseed({a}))"
        self.setOutputValue(name="result", value=r)