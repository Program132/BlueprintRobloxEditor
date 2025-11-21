from typing import Optional

from src.Node import Node


class GetService(Node):
    def __init__(self) -> None:
        super().__init__("nodes/instance/getservice.json")

    def toLuau(self) -> Optional[str]:
        serviceName = self.getInputValue("ServiceName")

        if not serviceName.startswith('"') and not serviceName.startswith("'"):
            serviceName_formatted = f'"{serviceName}"'
        else:
            serviceName_formatted = serviceName
        
        r = f'game:GetService({serviceName_formatted})'
        
        self.setOutputValue("service", r)