from typing import List

def is_luau_expression(s: str, engine_variables: List) -> bool:
    if not isinstance(s, str) or not s:
        return False

    if any(var.name == s for var in engine_variables):
        return True

    operators = ['+', '-', '*', '/', '%', '^', '(', ')', '[', ']', '==', '~=', '>', '<', '{', '}']
    if any(op in s for op in operators):
        return True

    try:
        float(s)
        return True
    except ValueError:
        pass

    if s.lower() in ['true', 'false', 'nil']:
        return True

    if (s.startswith('"') and s.endswith('"')) or (s.startswith("'") and s.endswith("'")):
        return False

    if (s[0].isalpha() or s[0] == '_') and ' ' not in s:
        return True

    return False