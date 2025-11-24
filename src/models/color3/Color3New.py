from typing import Optional
from src.Node import Node

class Color3New(Node):
    def __init__(self) -> None:
        super().__init__("nodes/color3/color3new.json")

    def toLuau(self) -> Optional[str]:
        r = self.getInputValue("r") or "1"
        g = self.getInputValue("g") or "1"
        b = self.getInputValue("b") or "1"

        r = f'Color3.new({r}, {g}, {b})'
        
        self.setOutputValue("color", r)
