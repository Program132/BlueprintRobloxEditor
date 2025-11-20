from src.Node import Node, NodeType

class ForRange(Node):
    def __init__(self):
        super().__init__("nodes/statement/forrange.json")

    def toLuau(self) -> str:
        var = self.getInputValue("variable") or "i"
        start = self.getInputValue("start") or 1
        end = self.getInputValue("end") or 10
        step = self.getInputValue("step") or 1

        luau_code = f"for {var} = {start}, {end}, {step} do"
        return luau_code
