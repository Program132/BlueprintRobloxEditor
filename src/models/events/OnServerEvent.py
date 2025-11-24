from typing import Optional
from src.Node import Node

class OnServerEvent(Node):
    def __init__(self) -> None:
        super().__init__("nodes/remoteevent/onserverevent.json")
        self.events_count = 1

    def toLuau(self) -> Optional[str]:
        remote_event = self.getInputValue("remoteEvent")
        output_names = [o.name for o in self.outputs]
        args = ", ".join(output_names)
        
        for output in self.outputs:
            self.setOutputValue(output.name, output.name)
        
        r = f'{remote_event}.OnServerEvent:Connect(function({args})'
        
        return r
