from src.Nodes.Node import Node

class Replace(Node):
    def __init__(self):
        super().__init__()
        self.loadFromJson("nodes/string/replace.json")

    def toLuau(self):
        main = self.getInputValue("main")
        find = self.getInputValue("find")
        replace = self.getInputValue("replace")
        r = f"(string.gsub({main}, {find}, {replace})"
        self.setOutputValue(name="result", value=r)

    def __str__(self):
        return "REPLACE NODE"