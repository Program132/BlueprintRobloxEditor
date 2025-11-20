from src.Node import Node

class ModuloFractional(Node):
    def __init__(self):
        super().__init__("nodes/math/modulofractional.json")

    def toLuau(self):
        a = self.getInputValue("a")
        r = f"(math.modf({a}))"
        self.setOutputValue(name="result", value=r)
