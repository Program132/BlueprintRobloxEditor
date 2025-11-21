from typing import Optional
from src.Node import Node

class IsA(Node):
    def __init__(self) -> None:
        super().__init__("nodes/instance/isa.json")

    def toLuau(self) -> Optional[str]:
        instance = self.getInputValue("instance")
        class_name = self.getInputValue("className")

        if not class_name.startswith('"') and not class_name.startswith("'"):
            class_name_formatted = f'"{class_name}"'
        else:
            class_name_formatted = class_name
        
        r = f'{instance}:IsA({class_name_formatted})'
        
        self.setOutputValue("result", r)