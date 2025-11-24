from typing import Optional
from src.Node import Node

class TweenInfoNew(Node):
    def __init__(self) -> None:
        super().__init__("nodes/tween/tweeninfonew.json")

    def toLuau(self) -> Optional[str]:
        time = self.getInputValue("time") or "1"
        easing_style = self.getInputValue("easingStyle") or "Enum.EasingStyle.Linear"
        easing_direction = self.getInputValue("easingDirection") or "Enum.EasingDirection.Out"
        repeat_count = self.getInputValue("repeatCount") or "0"
        reverses = self.getInputValue("reverses") or "false"
        delay_time = self.getInputValue("delayTime") or "0"

        r = f'TweenInfo.new({time}, {easing_style}, {easing_direction}, {repeat_count}, {reverses}, {delay_time})'
        
        self.setOutputValue("tweenInfo", r)
