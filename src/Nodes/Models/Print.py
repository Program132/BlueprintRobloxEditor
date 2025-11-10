from src.Nodes.Node import Node
from src.Nodes.NodeColor import NodeColor
from src.Nodes.NodeType import NodeType

class Print(Node):
    def __init__(self):
        #super().__init__(NodeType.METHOD, NodeColor(0,0,255))
        super().__init__()
        self.loadFromJson("nodes/print.json")

    def toLuau(self):
        v = self.getInputValue("value")
        if v is None:
            return "print(nil)"

        luau_expression = str(v)
        is_string_literal = False
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

        return f"print({luau_expression})"

    def __str__(self):
        return "PRINT NODE"