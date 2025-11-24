from typing import Optional
from src.Node import Node

class UDim2FromOffset(Node):
    def __init__(self) -> None:
        super().__init__("nodes/udim2/udim2fromoffset.json")

    def toLuau(self) -> Optional[str]:
        x = self.getInputValue("x") or "100"
        y = self.getInputValue("y") or "100"

        r = f'UDim2.fromOffset({x}, {y})'
        
        self.setOutputValue("udim2", r)