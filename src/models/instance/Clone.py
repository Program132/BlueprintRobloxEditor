from typing import Optional
from src.Node import Node

class Clone(Node):
    def __init__(self) -> None:
        super().__init__("nodes/instance/clone.json")

    def toLuau(self) -> Optional[str]:
        instance = self.getInputValue("instance")
        
        r = f'{instance}:Clone()'
        
        self.setOutputValue("clone", r)
        return r