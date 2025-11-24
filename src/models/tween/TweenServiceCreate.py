from typing import Optional
from src.Node import Node

class TweenServiceCreate(Node):
    def __init__(self) -> None:
        super().__init__("nodes/tween/tweenservicecreate.json")

    def toLuau(self) -> Optional[str]:
        tween_service = self.getInputValue("tweenService")
        instance = self.getInputValue("instance")
        tween_info = self.getInputValue("tweenInfo")
        properties = self.getInputValue("properties") or "{}"

        r = f'{tween_service}:Create({instance}, {tween_info}, {properties})'
        
        self.setOutputValue("tween", r)