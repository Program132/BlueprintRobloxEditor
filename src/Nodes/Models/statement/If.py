from src.Nodes.Node import Node
from src.Nodes.Utils import is_luau_expression


class If(Node):
    def __init__(self):
        super().__init__()
        self.loadFromJson("nodes/statement/if.json")

    def toLuau(self):
        condition = self.getInputValue("condition")
        engine_vars = self.engine.variables if hasattr(self, "engine") and self.engine else []

        luau_condition = str(condition)
        if not is_luau_expression(luau_condition, engine_vars):
            luau_condition = f'"{luau_condition}"'

        true_transition = self.engine.getExecTransition(self, "True")
        true_code = self.engine.generateCodeBranch(true_transition.end if true_transition else None, 1)

        false_transition = self.engine.getExecTransition(self, "False")
        false_code = self.engine.generateCodeBranch(false_transition.end if false_transition else None, 1)

        result = f"if {luau_condition} then\n"

        if true_code.strip():
            result += true_code + "\n"

        if false_code.strip():
            result += f"else\n"
            result += false_code + "\n"

        result += "end"

        return result

    def __str__(self):
        return "IF NODE"
