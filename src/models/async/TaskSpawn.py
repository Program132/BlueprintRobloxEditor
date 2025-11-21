from typing import Optional
from src.Node import Node

class TaskSpawn(Node):
    def __init__(self) -> None:
        super().__init__("nodes/async/taskspawn.json")

    def toLuau(self) -> Optional[str]:
        function = self.getInputValue("function")
        
        r = f'task.spawn({function})'
        
        return r
