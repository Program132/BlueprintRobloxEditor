from src.Node import Node


class GET(Node):
    def __init__(self):
        super().__init__("nodes/variables/get.json")

    def toLuau(self):
        name = self.getInputValue("name")
        self.setOutputValue("value", name)
        return None