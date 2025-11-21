from typing import Optional

from src.Node import Node


class SetProperty(Node):
    def __init__(self) -> None:
        super().__init__("nodes/instance/setproperty.json")

    def toLuau(self) -> Optional[str]:
        instance = self.getInputValue("instance")
        property_name = self.getInputValue("PropertyName")
        value = self.getInputValue("value")

        if ':' in str(value) or '(' in str(value) or self._detectValueType(value) == "formula":
            value_formatted = value
        else:
            value_formatted = self._formatValueForLuau(value)

        r = f'{instance}.{property_name} = {value_formatted}'
        
        return r