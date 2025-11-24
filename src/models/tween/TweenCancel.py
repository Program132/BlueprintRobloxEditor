from typing import Optional
from src.Node import Node

class TweenCancel(Node):
    def __init__(self) -> None:
        super().__init__("nodes/tween/tweencancel.json")

    def toLuau(self) -> Optional[str]:
        tween = self.getInputValue("tween")
        
        r = f'{tween}:Cancel()'
        
        return r
