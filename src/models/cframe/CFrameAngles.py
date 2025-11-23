from typing import Optional
from src.Node import Node


class CFrameAngles(Node):
    def __init__(self) -> None:
        super().__init__("nodes/cframe/cframeangles.json")

    def toLuau(self) -> Optional[str]:
        rx = self.getInputValue("rx")
        ry = self.getInputValue("ry")
        rz = self.getInputValue("rz")
        
        r = f'CFrame.Angles({rx}, {ry}, {rz})'
        self.setOutputValue("cframe", r)
