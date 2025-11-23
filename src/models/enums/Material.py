from typing import Optional
from src.Node import Node


class Material(Node):
    def __init__(self) -> None:
        super().__init__("nodes/enums/material.json")

    def toLuau(self) -> Optional[str]:
        material = self.getInputValue("material")
        r = f'Enum.Material.{material}'
        self.setOutputValue("material", r)
