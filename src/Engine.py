from typing import List

from src.Graph import Graph

class Engine:
    def __init__(self) -> None:
        self.graphs: List[Graph] = []
        self.blocks = []
        self.variables = []

    def add_graph(self, graph: Graph) -> None:
        self.graphs.append(graph)

    def _build_blocks(self):
        for g in self.graphs:
            self.blocks.extend(g.build_blocks())

    def _generate_code_variables(self):
        c = ""
        for v in self.variables:
            name = v.name
            value = v.value
            c += f"local {name} = nil \n"
        return c

    def run(self) -> str:
        self._build_blocks()

        code = self._generate_code_variables()

        for block in self.blocks:
            code = code + block.run()
            code += "\n"
        return code