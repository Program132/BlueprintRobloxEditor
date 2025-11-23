from typing import Optional
from src.Node import Node


class HumanoidStateType(Node):
    def __init__(self) -> None:
        super().__init__("nodes/enums/humanoidstatetype.json")

    def toLuau(self) -> Optional[str]:
        state = self.getInputValue("state")
        r = f'Enum.HumanoidStateType.{state}'
        self.setOutputValue("state", r)
