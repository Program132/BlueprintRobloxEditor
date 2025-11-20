from src.Node import Node, NodeType

class If(Node):
    def __init__(self):
        super().__init__("nodes/statement/if.json")

    def toLuau(self) -> str:
        condition = self.getInputValue("condition")

        luau_code = f"if {condition} then"
        return luau_code