from typing import Optional
from src.Node import Node


class CFrameLookAt(Node):
    def __init__(self) -> None:
        super().__init__("nodes/cframe/cframelookat.json")

    def toLuau(self) -> Optional[str]:
        from_pos = self.getInputValue("from")
        to_pos = self.getInputValue("to")
        
        r = f'CFrame.lookAt({from_pos}, {to_pos})'
        self.setOutputValue("cframe", r)
