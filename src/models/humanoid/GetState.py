from typing import Optional
from src.Node import Node

class GetState(Node):
    def __init__(self) -> None:
        super().__init__("nodes/humanoid/getstate.json")

    def toLuau(self) -> Optional[str]:
        humanoid = self.getInputValue("humanoid")
        
        r = f'{humanoid}:GetState()'
        
        self.setOutputValue("state", r)