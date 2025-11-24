from typing import Optional
from src.Node import Node

class UDim2FromScale(Node):
    def __init__(self) -> None:
        super().__init__("nodes/udim2/udim2fromscale.json")

    def toLuau(self) -> Optional[str]:
        x = self.getInputValue("x") or "0.5"
        y = self.getInputValue("y") or "0.5"

        r = f'UDim2.fromScale({x}, {y})'
        
        self.setOutputValue("udim2", r)