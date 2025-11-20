from src.Node import Node

class Character(Node):
    def __init__(self):
        super().__init__("nodes/string/character.json")

    def toLuau(self):
        a = self.getInputValue("a")
        v = self._detectValueType(a)
        r = f"string.char({a})"
        if v == "string" and not str(a).strip().startswith('"'):
            r = f'(string.char("{a}"))'
        self.setOutputValue(name="result", value=r)
