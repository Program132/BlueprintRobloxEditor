from typing import Optional

from src.Node import Node


class Int(Node):
    def __init__(self) -> None:
        super().__init__("nodes/values/int.json")

    def toLuau(self) -> Optional[str]:
        v = self.getInputValue("value")
        r = f'{v}'
        self.setOutputValue("value", r)