from src.Nodes.Utils import is_luau_expression
from src.Nodes.Node import Node

class Replace(Node):
    def __init__(self):
        super().__init__()
        self.loadFromJson("nodes/string/replace.json")

    def toLuau(self):
        main = self.getInputValue("main")
        find = self.getInputValue("find")
        replace = self.getInputValue("replace")
        engine_vars = self.engine.variables if hasattr(self, "engine") and self.engine else []
        if not is_luau_expression(str(main), engine_vars):
            main = f'"{main}"'
        if not is_luau_expression(str(find), engine_vars):
            find = f'"{find}"'
        if not is_luau_expression(str(replace), engine_vars):
            replace = f'"{replace}"'

        r = f"(string.gsub({main}, {find}, {replace})"
        self.setOutputValue(name="result", value=r)

    from src.Node import Node

    class Repeat(Node):
        def __init__(self):
            super().__init__("nodes/string/repeat.json")

        def toLuau(self):
            a = self.getInputValue("main")
            b = self.getInputValue("find")
            replace= self.getInputValue("replace")

            if self._detectValueType(a) == "string" and not str(a).strip().startswith('"'):
                a = f'"{a}"'
            if self._detectValueType(b) == "string" and not str(b).strip().startswith('"'):
                b = f'"{b}"'
            if self._detectValueType(replace) == "string" and not str(replace).strip().startswith('"'):
                replace = f'"{replace}"'
            r = f"(string.gsub({a}, {b}, {replace})"
            self.setOutputValue(name="result", value=r)
