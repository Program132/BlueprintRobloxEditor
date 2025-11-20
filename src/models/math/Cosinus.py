class Cosinus(Node):
    def __init__(self):
        super().__init__("nodes/math/cosinus.json")

    def toLuau(self):
        a = self.getInputValue("a")
        r = f"(math.cos({a}))"
        self.setOutputValue(name="result", value=r)