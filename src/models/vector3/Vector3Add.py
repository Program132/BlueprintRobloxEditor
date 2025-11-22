from typing import Optional
from src.Node import Node

class Vector3Add(Node):
    def __init__(self) -> None:
        super().__init__("nodes/vector3/vector3add.json")

    def toLuau(self) -> Optional[str]:
        vec1 = self.getInputValue("vec1")
        vec2 = self.getInputValue("vec2")
        r = f"{vec1} + {vec2}"
        
        self.setOutputValue("Vector3", r)