from src.Nodes.Node import Node
from src.Nodes.Utils import is_luau_expression

class ForRange(Node):
    def __init__(self):
        super().__init__()
        self.loadFromJson("nodes/statement/forrange.json")

    def toLuau(self):
        engine_vars = self.engine.variables if hasattr(self, "engine") and self.engine else []

        def format_value(input_name):
            val = self.getInputValue(input_name)
            luau_val = str(val)
            if not is_luau_expression(luau_val, engine_vars):
                try:
                    float(luau_val)
                    return luau_val
                except ValueError:
                    return f'"{luau_val}"'
            return luau_val

        var_name = str(self.getInputValue("variable"))
        start_val = format_value("start")
        end_val = format_value("end")
        step_val = format_value("step")

        loop_transition = self.engine.getExecTransition(self, "Loop Body")
        loop_code = self.engine.generateCodeBranch(loop_transition.end if loop_transition else None, 1)

        result = f"for {var_name} = {start_val}, {end_val}, {step_val} do\n"

        if loop_code.strip():
            result += loop_code + "\n"

        result += "end"

        return result

    def __str__(self):
        return "FOR RANGE NODE"