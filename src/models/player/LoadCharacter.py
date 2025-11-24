from typing import Optional
from src.Node import Node

class LoadCharacter(Node):
    def __init__(self) -> None:
        super().__init__("nodes/player/loadcharacter.json")

    def toLuau(self) -> Optional[str]:
        player = self.getInputValue("player")
        
        r = f'{player}:LoadCharacter()'
        
        return r
