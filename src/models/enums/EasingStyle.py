from typing import Optional
from src.Node import Node


class EasingStyle(Node):
    def __init__(self) -> None:
        super().__init__("nodes/enums/easingstyle.json")

    def toLuau(self) -> Optional[str]:
        easing_style = self.getInputValue("easingStyle")
        r = f'Enum.EasingStyle.{easing_style}'
        self.setOutputValue("easingStyle", r)
