import json
from src.Nodes.Node import Node

class SET(Node):
    def __init__(self):
        super().__init__()
        self.loadFromJson("nodes/variables/set.json")

    def toLuau(self):
        value = self.getInputValue("value")
        name = self.getInputValue("name")

        v = self.getInputValue("value")
        if v is None:
            return "print(nil)"

        luau_expression = str(v)
        is_string_literal = False
        if hasattr(self, "engine") and any(var.name == v for var in self.engine.variables):
            return f"print({v})"

        try:
            v_test = eval(luau_expression)
            if isinstance(v_test, str):
                pass
        except NameError:
            is_string_literal = True
        except Exception:
            is_string_literal = True

        if is_string_literal:
            luau_expression = f'"{luau_expression}"'

        return f"{name} = {luau_expression}"