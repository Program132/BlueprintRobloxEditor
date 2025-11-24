from typing import Optional
from src.Node import Node

class GetCharacter(Node):
    def __init__(self) -> None:
        super().__init__("nodes/player/getcharacter.json")

    def toLuau(self) -> Optional[str]:
        player = self.getInputValue("player")
        
        r = f'{player}.Character'
        
        self.setOutputValue("character", r)
