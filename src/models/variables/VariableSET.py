from src.Node import Node


class SET(Node):
    def __init__(self):
        super().__init__("nodes/variables/set.json")

    def toLuau(self):
        value = self.getInputValue("value")
        name = self.getInputValue("name")

        value = str(value)
        if self._detectValueType(value) == "string" and not str(value).strip().startswith('"'):
            value = f'"{value}"'

        return f"{name} = {value}"