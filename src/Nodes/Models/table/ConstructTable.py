from src.Nodes.Node import Node


class ConstructTable(Node):
    def __init__(self):
        super().__init__()
        self.loadFromJson("nodes/table/constructtable.json")

    def toLuau(self):
        r = "{}"
        self.setOutputValue("table", r)