from typing import Optional
from src.Node import Node

class TaskDelay(Node):
    def __init__(self) -> None:
        super().__init__("nodes/async/taskdelay.json")

    def toLuau(self) -> Optional[str]:
        duration = self.getInputValue("duration")
        function = self.getInputValue("function")
        
        r = f'task.delay({duration}, {function})'
        
        return r
