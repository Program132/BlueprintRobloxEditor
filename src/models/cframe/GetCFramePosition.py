from typing import Optional
from src.Node import Node


class GetCFramePosition(Node):
    def __init__(self) -> None:
        super().__init__("nodes/cframe/getcframeposition.json")

    def toLuau(self) -> Optional[str]:
        cframe = self.getInputValue("cframe")
        
        r = f'{cframe}.Position'
        self.setOutputValue("position", r)
