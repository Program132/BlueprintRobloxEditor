from src.Nodes.Node import Node

class TableRemove(Node):
    def __init__(self):
        super().__init__()
        self.loadFromJson("nodes/table/tableremove.json")

    def toLuau(self):
        table_name = str(self.getInputValue("table"))
        index_expression = str(self.getInputValue("index"))

        r = f"table.remove({table_name}, {index_expression})"
        return r