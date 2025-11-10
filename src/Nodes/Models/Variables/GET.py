from src.Nodes.Node import Node

class GET(Node):
    def __init__(self):
        super().__init__()
        self.loadFromJson("nodes/variables/get.json")

    def toLuau(self):
        name = self.getInputValue("name")
        self.setOutputValue("value", name)
        return None
