from typing import Optional

from src.Node import Node


class Error(Node):
    def __init__(self) -> None:
        super().__init__("nodes/error.json")

    def toLuau(self) -> Optional[str]:
        v = self.getInputValue("value")
        r = f'error({v})'
        x = str(v).strip()
        if self._detectValueType(v) == "string" and not x.startswith('"'):
            r = f'error("{v}")'
        return r