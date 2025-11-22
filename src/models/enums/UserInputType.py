from typing import Optional
from src.Node import Node


class UserInputType(Node):
    def __init__(self) -> None:
        super().__init__("nodes/enums/userinputtype.json")

    def toLuau(self) -> Optional[str]:
        input_type = self.getInputValue("type")
        r = f'Enum.UserInputType.{input_type}'
        self.setOutputValue("userinputtype", r)