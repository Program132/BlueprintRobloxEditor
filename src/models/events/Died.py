from typing import Optional
from src.Node import Node

class Died(Node):
    def __init__(self) -> None:
        super().__init__("nodes/events/died.json")
        self.events_count = 1

    def toLuau(self) -> Optional[str]:
        humanoid = self.getInputValue("humanoid")
        
        r = f'{humanoid}.Died:Connect(function()'
        
        return r
