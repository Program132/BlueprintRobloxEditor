from src.Nodes.Utils import is_luau_expression
from src.Nodes.Node import Node

class Find(Node):
    def __init__(self):
        super().__init__()
        self.loadFromJson("nodes/string/find.json")

    def toLuau(self):
        string = self.getInputValue("str")
        s = self.getInputValue("s")

        engine_vars = self.engine.variables if hasattr(self, "engine") and self.engine else []
        if not is_luau_expression(str(string), engine_vars):
            string = f'"{string}"'
        if not is_luau_expression(str(s), engine_vars):
            s = f'"{s}"'

        r = f"(string.find({string}, {s})"
        self.setOutputValue(name="result", value=r)

    def __str__(self):
        return "FIND NODE"