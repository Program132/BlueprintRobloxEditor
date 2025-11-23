from typing import Optional
from src.Node import Node
from src.Variable import Variable


class Heartbeat(Node):
    def __init__(self) -> None:
        super().__init__("nodes/events/heartbeat.json")
        self.events_count = 1

    def toLuau(self) -> Optional[str]:
        output_names = [o.name for o in self.outputs]
        args = ", ".join(output_names)
        
        for output in self.outputs:
            self.setOutputValue(output.name, output.name)
            if not any(v.name == output.name for v in self.engine.variables):
                self.engine.variables.append(Variable(output.name, output.name))
        
        r = f'game:GetService("RunService").Heartbeat:Connect(function({args})'
        return r
