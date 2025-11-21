from typing import Optional

from src.Node import Node


class GetProperty(Node):
    def __init__(self) -> None:
        super().__init__("nodes/instance/getproperty.json")

    def toLuau(self) -> Optional[str]:
        instance = self.getInputValue("instance")
        property_name = self.getInputValue("PropertyName")

        r = f'{instance}.{property_name}'
        
        self.setOutputValue("value", r)