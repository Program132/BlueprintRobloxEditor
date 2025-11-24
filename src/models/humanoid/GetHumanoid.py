from typing import Optional
from src.Node import Node

class GetHumanoid(Node):
    def __init__(self) -> None:
        super().__init__("nodes/humanoid/gethumanoid.json")

    def toLuau(self) -> Optional[str]:
        character = self.getInputValue("character")
        
        r = f'{character}:FindFirstChildOfClass("Humanoid")'
        
        self.setOutputValue("humanoid", r)