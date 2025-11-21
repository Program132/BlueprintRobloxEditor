from typing import Optional

from src.Node import Node


class WaitForChild(Node):
    def __init__(self) -> None:
        super().__init__("nodes/instance/waitforchild.json")

    def toLuau(self) -> Optional[str]:
        instance = self.getInputValue("instance")
        child_name = self.getInputValue("childName")

        if not child_name.startswith('"') and not child_name.startswith("'"):
            child_name_formatted = f'"{child_name}"'
        else:
            child_name_formatted = child_name
        
        r = f'{instance}:WaitForChild({child_name_formatted})'
        
        self.setOutputValue("child", r)
