from src.Node import Node

class While(Node):
    def __init__(self):
        super().__init__("nodes/statement/while.json")

    def toLuau(self) -> str:
        c = self.getInputValue("condition")
        print("CONDITION FOUND:", c)

        luau_code = f"while {c} do"
        return luau_code
