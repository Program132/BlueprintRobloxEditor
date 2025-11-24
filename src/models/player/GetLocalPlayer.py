from typing import Optional
from src.Node import Node

class GetLocalPlayer(Node):
    def __init__(self) -> None:
        super().__init__("nodes/player/getlocalplayer.json")

    def toLuau(self) -> Optional[str]:
        r = f'game:GetService("Players").LocalPlayer'
        
        self.setOutputValue("player", r)