# src/Engine.py
class Engine:
    def __init__(self):
        self.nodes = []

    def addNode(self, node):
        self.nodes.append(node)

    def generateFile(self, filename: str):
        if not filename.endswith(".lua"):
            raise ValueError("Le fichier doit avoir l'extension .lua")

        with open(filename, "w", encoding="utf-8") as f:
            f.write(str(self))

    def __str__(self):
        lines = []
        for node in self.nodes:
            luau_code = node.toLuau()
            if luau_code is not None:
                lines.append(luau_code)
        return "\n".join(lines)