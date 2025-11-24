from typing import Optional
from src.Node import Node

class Color3FromHSV(Node):
    def __init__(self) -> None:
        super().__init__("nodes/color3/color3fromhsv.json")

    def toLuau(self) -> Optional[str]:
        h = self.getInputValue("h") or "0"
        s = self.getInputValue("s") or "1"
        v = self.getInputValue("v") or "1"

        r = f'Color3.fromHSV({h}, {s}, {v})'
        
        self.setOutputValue("color", r)