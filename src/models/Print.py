from typing import Optional

from src.Node import Node


class Print(Node):
    def __init__(self) -> None:
        super().__init__("nodes/print.json")

    def toLuau(self) -> Optional[str]:
        v = self.getInputValue("value")
        r = f'print({v})'
        
        # Only add quotes if it's clearly a literal string (has spaces or special chars)
        # Don't add quotes for variable names (single words starting with letter/underscore)
        if self._detectValueType(v) == "string" and not str(v).strip().startswith('"'):
            # Check if it looks like a variable name (alphanumeric + underscore, no spaces)
            v_str = str(v).strip()
            is_variable_name = v_str.replace('_', '').replace('.', '').isalnum() and (v_str[0].isalpha() or v_str[0] == '_')
            
            if not is_variable_name:
                # It's a literal string, add quotes
                r = f'print("{v}")'
        
        return r