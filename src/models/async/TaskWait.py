from typing import Optional

from src.Node import Node


class TaskWait(Node):
    def __init__(self) -> None:
        super().__init__("nodes/async/taskwait.json")

    def toLuau(self) -> Optional[str]:
        duration = self.getInputValue("duration")
        
        r = f'task.wait({duration})'
        
        return r
