from typing import Optional
from src.Node import Node


class EasingDirection(Node):
    def __init__(self) -> None:
        super().__init__("nodes/enums/easingdirection.json")

    def toLuau(self) -> Optional[str]:
        easing_direction = self.getInputValue("easingDirection")
        r = f'Enum.EasingDirection.{easing_direction}'
        self.setOutputValue("easingDirection", r)
