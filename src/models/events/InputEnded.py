from typing import Optional
from src.Node import Node


class InputEnded(Node):
    def __init__(self) -> None:
        super().__init__("nodes/events/inputended.json")
        self.events_count = 1

    def toLuau(self) -> Optional[str]:
        output_names = [o.name for o in self.outputs]
        args = ", ".join(output_names)
        
        from src.Variable import Variable
        for output in self.outputs:
            self.setOutputValue(output.name, output.name)
            if not any(v.name == output.name for v in self.engine.variables):
                self.engine.variables.append(Variable(output.name, output.name))
        
        r = f'game:GetService("UserInputService").InputEnded:Connect(function({args})'
        return r
