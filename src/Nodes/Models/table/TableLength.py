from src.Nodes.Node import Node


class TableLength(Node):
    def __init__(self):
        super().__init__()
        self.loadFromJson("nodes/table/tablelength.json")

    def toLuau(self):
        table_name = str(self.getInputValue("table"))
        r = f"#{table_name}"
        self.setOutputValue("result", r)