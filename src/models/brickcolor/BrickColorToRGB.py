from typing import Optional
from src.Node import Node

class BrickColorToRGB(Node):
    def __init__(self) -> None:
        super().__init__("nodes/brickcolor/brickcolortorgb.json")

    def toLuau(self) -> Optional[str]:
        brick_color = self.getInputValue("brickColor")
        
        self.setOutputValue("r", f'{brick_color}.r')
        self.setOutputValue("g", f'{brick_color}.g')
        self.setOutputValue("b", f'{brick_color}.b')
