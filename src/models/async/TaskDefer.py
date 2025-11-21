from typing import Optional
from src.Node import Node

class TaskDefer(Node):
    def __init__(self) -> None:
        super().__init__("nodes/async/taskdefer.json")

    def toLuau(self) -> Optional[str]:
        function = self.getInputValue("function")
        
        r = f'task.defer({function})'
        
        return r
