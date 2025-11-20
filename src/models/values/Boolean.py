from typing import Optional

from src.Node import Node


class Boolean(Node):
    def __init__(self) -> None:
        super().__init__("nodes/values/boolean.json")

    def toLuau(self) -> Optional[str]:
        v = self.getInputValue("value")
        r = f'{v}'
        self.setOutputValue("value", r)