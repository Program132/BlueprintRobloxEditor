from typing import Optional
from src.Node import Node


class PlayerAdded(Node):
    def __init__(self) -> None:
        super().__init__("nodes/events/playeradded.json")
        self.events_count = 1

    def toLuau(self) -> Optional[str]:
        output_names = [o.name for o in self.outputs]
        args = ", ".join(output_names)
        
        # Set output values so they can be used in data connections
        for output in self.outputs:
            self.setOutputValue(output.name, output.name)
        
        r = f'game:GetService("Players").PlayerAdded:Connect(function({args})'
        return r