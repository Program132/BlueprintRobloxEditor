from typing import Optional
from src.Node import Node

class TakeDamage(Node):
    def __init__(self) -> None:
        super().__init__("nodes/humanoid/takedamage.json")

    def toLuau(self) -> Optional[str]:
        humanoid = self.getInputValue("humanoid")
        damage = self.getInputValue("damage") or "10"
        
        r = f'{humanoid}:TakeDamage({damage})'
        
        return r
