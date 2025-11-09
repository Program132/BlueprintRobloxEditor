class Input:
    def __init__(self, name:str="i", value=None):
        self.name = name
        self.value = value

    def __str__(self):
        return f"({self.name}, {self.value})"

class Output:
    def __init__(self, name:str="o", value=None):
        self.name = name
        self.value = value

    def __str__(self):
        return f"({self.name}, {self.value})"