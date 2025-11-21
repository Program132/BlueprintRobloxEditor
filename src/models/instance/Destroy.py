from typing import Optional
from src.Node import Node

class Destroy(Node):
    def __init__(self) -> None:
        super().__init__("nodes/instance/destroy.json")

    def toLuau(self) -> Optional[str]:
        instance = self.getInputValue("instance")
        
        r = f'{instance}:Destroy()'
        
        return r