from typing import Optional
from src.Node import Node

class Vector3Builder(Node):
    def __init__(self) -> None:
        super().__init__("nodes/vector3/vector3builder.json")

    def toLuau(self) -> Optional[str]:
        x = self.getInputValue("x")
        y = self.getInputValue("y")
        z = self.getInputValue("z")
        r = f"Vector3.new({x}, {y}, {z})"
        
        self.setOutputValue("Vector3", r)