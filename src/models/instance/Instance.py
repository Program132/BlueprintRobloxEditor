from typing import Optional

from src.Node import Node


class Instance(Node):
    def __init__(self) -> None:
        super().__init__("nodes/instance/instance.json")

    def toLuau(self) -> Optional[str]:
        classname = self.getInputValue("ClassName")
        parent = self.getInputValue("parent")

        if not classname.startswith('"') and not classname.startswith("'"):
            classname_formatted = f'"{classname}"'
        else:
            classname_formatted = classname
        
        if parent == "" or len(parent) == 0:
            r = f'Instance.new({classname_formatted})'
        else:
            parent_formatted = self._formatValueForLuau(parent)
            r = f'Instance.new({classname_formatted}, {parent_formatted})'
        
        self.setOutputValue("instance", r)