from typing import Optional
from src.Node import Node

class FireServer(Node):
    def __init__(self) -> None:
        super().__init__("nodes/remoteevent/fireserver.json")

    def toLuau(self) -> Optional[str]:
        remote_event = self.getInputValue("remoteEvent")
        args = self.getInputValue("args") or ""
        
        if args:
            r = f'{remote_event}:FireServer({args})'
        else:
            r = f'{remote_event}:FireServer()'
        
        return r
