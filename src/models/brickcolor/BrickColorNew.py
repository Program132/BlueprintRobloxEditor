from typing import Optional
from src.Node import Node

class BrickColorNew(Node):
    def __init__(self) -> None:
        super().__init__("nodes/brickcolor/brickcolornew.json")

    def toLuau(self) -> Optional[str]:
        color_name = self.getInputValue("colorName") or "Bright red"
        
        color_name_formatted = f'"{color_name}"'
        
        r = f'BrickColor.new({color_name_formatted})'
        
        self.setOutputValue("brickColor", r)
