from typing import Optional

from src.Node import Node


class Start(Node):
    def __init__(self) -> None:
        super().__init__("nodes/events/start.json")

    def toLuau(self) -> Optional[str]:
        return None