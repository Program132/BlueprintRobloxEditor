from src.Node import Node

class ToString(Node):
    def __init__(self):
        super().__init__("nodes/convert/tostring.json")

    def toLuau(self):
        input_value = self.getInputValue("value")

        r = f"(tostring({input_value}))"
        if self._detectValueType(input_value) == "string" and not str(input_value).strip().startswith('"'):
            r = f'(tostring("{input_value}"))'

        self.setOutputValue("result", r)