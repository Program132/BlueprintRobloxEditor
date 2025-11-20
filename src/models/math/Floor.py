from src.Node import Node


class Floor(Node):
    def __init__(self):
        super().__init__("nodes/math/floor.json")

    def toLuau(self):
        a = self.getInputValue("a")
        r = f"(math.floor({a}))"
        self.setOutputValue(name="result", value=r)
