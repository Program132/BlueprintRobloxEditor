from typing import Optional
from src.Node import Node

class BrickColorRandom(Node):
    def __init__(self) -> None:
        super().__init__("nodes/brickcolor/brickcolorrandom.json")

    def toLuau(self) -> Optional[str]:
        r = 'BrickColor.random()'
        
        self.setOutputValue("brickColor", r)
