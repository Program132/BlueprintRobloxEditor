from typing import Optional

from src.Node import Node


class GetChildren(Node):
    def __init__(self) -> None:
        super().__init__("nodes/instance/getchildren.json")

    def toLuau(self) -> Optional[str]:
        instance = self.getInputValue("instance")
        
        r = f'{instance}:GetChildren()'
        
        self.setOutputValue("children", r)
