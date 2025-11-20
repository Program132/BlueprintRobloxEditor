from typing import Optional
from src.Node import Node


class CharacterAdded(Node):
    def __init__(self) -> None:
        super().__init__("nodes/events/characteradded.json")
        self.event_count = 2

    def toLuau(self) -> Optional[str]:
        r = (f'game:GetService("Players").PlayerAdded:Connect(function(Player)\n'
             f'Player.CharacterAdded:Connect(function(Character)')
        return r