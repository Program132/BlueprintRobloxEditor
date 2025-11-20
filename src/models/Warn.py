from typing import Optional

from src.Node import Node


class Warn(Node):
    def __init__(self) -> None:
        super().__init__("nodes/warn.json")

    def toLuau(self) -> Optional[str]:
        v = self.getInputValue("value")
        r = f'warn({v})'
        x = str(v).strip()
        if self._detectValueType(v) == "string" and not x.startswith('"'):
            r = f'warn("{v}")'
        return r