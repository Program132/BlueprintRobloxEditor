from typing import Optional
from src.Node import Node

class TweenPlay(Node):
    def __init__(self) -> None:
        super().__init__("nodes/tween/tweenplay.json")

    def toLuau(self) -> Optional[str]:
        tween = self.getInputValue("tween")
        
        r = f'{tween}:Play()'
        
        return r
