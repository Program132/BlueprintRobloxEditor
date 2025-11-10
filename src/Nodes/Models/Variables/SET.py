import json
from src.Nodes.Node import Node

class SET(Node):
    def __init__(self):
        super().__init__()
        self.loadFromJson("nodes/variables/set.json")

    def toLuau(self):
        value = self.getInputValue("value")
        name = self.getInputValue("name")

        if isinstance(value, str):
            luau_value = json.dumps(value)
        elif value is None:
            luau_value = 'nil'
        elif isinstance(value, bool):
            luau_value = str(value).lower()
        else:
            luau_value = str(value)

        return f"{name} = {luau_value}"