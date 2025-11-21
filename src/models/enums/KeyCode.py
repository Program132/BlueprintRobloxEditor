from typing import Optional
from src.Node import Node

class KeyCode(Node):
    def __init__(self) -> None:
        super().__init__("nodes/enums/keycode.json")

    def toLuau(self) -> Optional[str]:
        key = self.getInputValue("key")
        r = f'Enum.KeyCode.{key}'
        self.setOutputValue("keyCode", r)