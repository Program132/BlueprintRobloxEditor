from typing import Optional
from src.Node import Node


class GetVector3Components(Node):
    def __init__(self) -> None:
        super().__init__("nodes/vector3/getvector3components.json")

    def toLuau(self) -> Optional[str]:
        vector = self.getInputValue("vector")

        self.setOutputValue("x", f'{vector}.X')
        self.setOutputValue("y", f'{vector}.Y')
        self.setOutputValue("z", f'{vector}.Z')
