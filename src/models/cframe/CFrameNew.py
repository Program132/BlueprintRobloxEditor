from typing import Optional
from src.Node import Node


class CFrameNew(Node):
    def __init__(self) -> None:
        super().__init__("nodes/cframe/cframenew.json")

    def toLuau(self) -> Optional[str]:
        x = self.getInputValue("x")
        y = self.getInputValue("y")
        z = self.getInputValue("z")
        
        r = f'CFrame.new({x}, {y}, {z})'
        self.setOutputValue("cframe", r)
