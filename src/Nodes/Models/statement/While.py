from src.Nodes.Node import Node
from src.Nodes.Utils import is_luau_expression

class While(Node):
    def __init__(self):
        super().__init__()
        self.loadFromJson("nodes/statement/while.json")

    def toLuau(self):
        condition = self.getInputValue("condition")
        engine_vars = self.engine.variables if hasattr(self, "engine") and self.engine else []

        luau_condition = str(condition)
        if not is_luau_expression(luau_condition, engine_vars):
            luau_condition = f'"{luau_condition}"'

        loop_transition = self.engine.getExecTransition(self, "True")
        loop_code = self.engine.generateCodeBranch(loop_transition.end if loop_transition else None, 1)

        result = f"while {luau_condition} do\n"

        if loop_code.strip():
            result += loop_code + "\n"

        result += "end"

        return result

    def __str__(self):
        return "WHILE NODE"