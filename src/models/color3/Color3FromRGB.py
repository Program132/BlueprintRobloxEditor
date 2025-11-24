from typing import Optional
from src.Node import Node

class Color3FromRGB(Node):
    def __init__(self) -> None:
        super().__init__("nodes/color3/color3fromrgb.json")

    def toLuau(self) -> Optional[str]:
        r = self.getInputValue("r") or "255"
        g = self.getInputValue("g") or "255"
        b = self.getInputValue("b") or "255"

        r = f'Color3.fromRGB({r}, {g}, {b})'
        
        self.setOutputValue("color", r)