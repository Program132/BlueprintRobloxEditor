from typing import Optional
from src.Node import Node

class FireClient(Node):
    def __init__(self) -> None:
        super().__init__("nodes/remoteevent/fireclient.json")

    def toLuau(self) -> Optional[str]:
        remote_event = self.getInputValue("remoteEvent")
        player = self.getInputValue("player")
        args = self.getInputValue("args") or ""
        
        if args:
            r = f'{remote_event}:FireClient({player}, {args})'
        else:
            r = f'{remote_event}:FireClient({player})'
        
        return r
