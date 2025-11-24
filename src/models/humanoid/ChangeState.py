from typing import Optional
from src.Node import Node

class ChangeState(Node):
    def __init__(self) -> None:
        super().__init__("nodes/humanoid/changestate.json")

    def toLuau(self) -> Optional[str]:
        humanoid = self.getInputValue("humanoid")
        state = self.getInputValue("state") or "Enum.HumanoidStateType.Jumping"
        
        r = f'{humanoid}:ChangeState({state})'
        
        return r
