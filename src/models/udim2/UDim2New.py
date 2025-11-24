from typing import Optional
from src.Node import Node

class UDim2New(Node):
    def __init__(self) -> None:
        super().__init__("nodes/udim2/udim2new.json")

    def toLuau(self) -> Optional[str]:
        scale_x = self.getInputValue("scaleX") or "0"
        offset_x = self.getInputValue("offsetX") or "0"
        scale_y = self.getInputValue("scaleY") or "0"
        offset_y = self.getInputValue("offsetY") or "0"

        r = f'UDim2.new({scale_x}, {offset_x}, {scale_y}, {offset_y})'
        
        self.setOutputValue("udim2", r)