from typing import Optional
from src.Node import Node

class UserInputType(Node):
    def __init__(self) -> None:
        super().__init__("nodes/enums/userinputtype.json")

    def toLuau(self) -> Optional[str]:
        key = self.getInputValue("key")
        r = f'Enum.UserInputType.{key}'
        self.setOutputValue("userinputtype", r)