import json
from enum import Enum
from typing import Optional

class NodeType(Enum):
    EVENT = "EVENT"
    METHOD = "METHOD"
    FUNCTION = "FUNCTION"

class Input:
    def __init__(self, name=None, value=None, required=True) -> None:
        self.name = name
        self.value = value
        self.required = required
    def __str__(self) -> str:
        return f"({self.name}, {self.value})"

class Output:
    def __init__(self, name=None, value=None) -> None:
        self.name = name
        self.value = value
    def __str__(self) -> str:
        return f"({self.name}, {self.value})"

class Node:
    def __init__(self, json_path:str) -> None:
        self.json_path = json_path

        self.color = []
        self.type = None
        self.title = None
        self.inputs = []
        self.outputs = []
        self.exec = []
        self._computed = False
        self.events_count = 0
        self.engine = None

        self._loadFromJson()

    def _loadFromJson(self) -> None:
        data = None
        with open(self.json_path) as json_file:
            data = json.load(json_file)
        if data is None: return

        title = data.get("title")
        color = data.get("color")

        if data.get("type") == "EVENT":
            self.type = NodeType.EVENT
        elif data.get("type") == "FUNCTION":
            self.type = NodeType.FUNCTION
        else:
            self.type = NodeType.METHOD

        self.title = title
        self.exec = exec
        self.color = color
        self.exec = data.get("exec", [])
        self.exec.append("default")

        if self.type == NodeType.EVENT and color is None:
            self.color = [255,0,0]
            self.event_count = 1
        elif self.type == NodeType.FUNCTION and color is None:
            self.color = [0,255,0]
        elif self.type == NodeType.METHOD and color is None:
            self.color = [0,0,255]

        json_inputs  = data.get("inputs", {})
        for name, props in json_inputs.items():
            default = props.get("defaultValue")
            required = props.get("required", False)
            self.inputs.append(Input(name=name, value=default, required=required))

        outputs = data.get("outputs", [])
        for o in outputs:
            self.outputs.append(Output(name=o))

    def _getTypeAsString(self) -> str:
        if self.type == NodeType.EVENT:
            return "EVENT"
        elif self.type == NodeType.FUNCTION:
            return "FUNCTION"
        return "METHOD"

    def _getInputAsString(self) -> str:
        if len(self.inputs) == 0:
            return "()"

        s = "["
        for i in self.inputs:
            s += str(i)
        s += "]"
        return s

    def _getOutputAsString(self) -> str:
        if len(self.outputs) == 0:
            return "()"

        s = "["
        for o in self.outputs:
            s += str(o)
        s += "]"
        return s

    def setInputValue(self, name:str, value) -> None:
        for i in self.inputs:
            if i.name == name:
                i.value = value

    def setOutputValue(self, name:str, value) -> None:
        for o in self.outputs:
            if o.name == name:
                o.value = value

    def getInputValue(self, name:str):
        for i in self.inputs:
            if i.name == name:
                return i.value
        return None

    def getOutputValue(self, name:str):
        for o in self.outputs:
            if o.name == name:
                return o.value
        return None

    def getInput(self, name:str) -> Optional[Input]:
        for i in self.inputs:
            if i.name == name:
                return i
        return None

    def getOutput(self, name:str) -> Optional[Output]:
        for o in self.outputs:
            if o.name == name:
                return o
        return None

    def _detectValueType(self, s:str) -> str:
        if not isinstance(s, str) or not s:
            return "string"

        stripped = s.strip()

        if any(var.name == stripped for var in self.engine.variables):
            return "variable"

        operators = ['+', '-', '*', '/', '%', '^', '(', ')', '[', ']', '==', '~=', '>', '<', '{', '}']
        if any(op in stripped for op in operators):
            if (stripped.startswith("{") and stripped.endswith("}")) or (
                    stripped.startswith("[") and stripped.endswith("]")):
                try:
                    json.loads(stripped)
                    return "json"
                except:
                    return "formula"
            return "formula"

        try:
            float(stripped)
            return "number"
        except:
            pass

        if stripped.lower() in ['true', 'false']:
            return "boolean"
        if stripped.lower() == 'nil':
            return "nil"

        if (stripped.startswith('"') and stripped.endswith('"')) or \
                (stripped.startswith("'") and stripped.endswith("'")):
            return "string"

        if (stripped[0].isalpha() or stripped[0] == '_') and ' ' not in stripped:
            return "string"

        return "string"

    def _formatValueForLuau(self, value) -> str:
        if value is None:
            return "nil"
        
        value_str = str(value).strip()
        
        if not value_str:
            return '""'
        
        if value_str.startswith('"') or value_str.startswith("'"):
            return value_str
        
        try:
            float(value_str)
            return value_str
        except:
            pass
        
        if value_str.lower() in ['true', 'false']:
            return value_str.lower()
        
        if value_str.lower() == 'nil':
            return 'nil'
        
        is_variable = (value_str.replace('_', '').replace('.', '').isalnum() and 
                     (value_str[0].isalpha() or value_str[0] == '_'))
        
        if not is_variable:
            return f'"{value_str}"'
        
        return value_str

    def toLuau(self) -> Optional[str]:
        return None


    def __str__(self) -> str:
        return f"({self.title}, {self._getTypeAsString()}, {self._getInputAsString()}, {self._getOutputAsString()}, {self.exec}, {self.color})"