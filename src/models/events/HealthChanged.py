from typing import Optional
from src.Node import Node

class HealthChanged(Node):
    def __init__(self) -> None:
        super().__init__("nodes/events/healthchanged.json")
        self.events_count = 1

    def toLuau(self) -> Optional[str]:
        humanoid = self.getInputValue("humanoid")
        output_names = [o.name for o in self.outputs]
        args = ", ".join(output_names)
        
        for output in self.outputs:
            self.setOutputValue(output.name, output.name)
        
        r = f'{humanoid}.HealthChanged:Connect(function({args})'
        
        return r
