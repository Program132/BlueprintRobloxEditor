import json

from src.Nodes.NodeType import NodeType
from src.Nodes.NodeColor import NodeColor
from src.Nodes.IO import Input, Output

class Node:
    def __init__(self, type:'NodeType'=None, color:'NodeColor'=None):
        self.x = 0
        self.y = 0
        self.type = type
        self.color = color
        self.inputs = []
        self.outputs = []
        self.engine = None

    def getType(self):
        return self.type

    def getColor(self):
        return self.color

    def getX(self):
        return self.x

    def getY(self):
        return self.y

    def setX(self, x:int):
        self.x = x

    def setY(self, y:int):
        self.y = y

    def getOutputs(self):
        return self.outputs

    def getInputs(self):
        return self.inputs

    def hasInput(self, name:str):
        for i in self.inputs:
            if i.name == name:
                return True
        return False

    def hasOutput(self, name:str):
        for o in self.outputs:
            if o.name == name:
                return True
        return False


    def getInput(self, name:str):
        for i in self.inputs:
            if i.name == name:
                return i
        return None

    def getOutput(self, name:str):
        for o in self.outputs:
            if o.name == name:
                return o
        return None

    def addInput(self, name:str, v=None):
        self.inputs.append(Input(name, v))

    def addOutput(self, name:str, v=None):
        self.outputs.append(Output(name, v))

    def getInputValue(self, name:str):
        i = self.getInput(name)
        return i.value if not i is None else None

    def getOutputValue(self, name:str):
        o = self.getOutput(name)
        return o.value if not o is None else None

    def setInputValue(self, name:str, value):
        i = self.getInput(name)
        i.value = value

    def setOutputValue(self, name:str, value):
        o = self.getOutput(name)
        o.value = value

    def loadFromJson(self, json_path: str):
        with open(json_path, "r", encoding="utf-8") as f:
            data = json.load(f)
        return self.loadFromData(data)



    def loadFromData(self, data):
        node_type = data.get("type", "FUNCTION")

        for name, info in data.get("inputs", {}).items():
            default_val = info.get("defaultValue", None)
            try:
                default_val = json.loads(default_val)
            except Exception:
                pass
            self.addInput(name, default_val)

        for out in data.get("outputs", []):
            self.addOutput(out)

        if node_type == "FUNCTION":
            self.type = NodeType.FUNCTION
            self.color = NodeColor(0,255,0)
        elif node_type == "METHOD":
            self.type = NodeType.METHOD
            self.color = NodeColor(0,0,255)
        elif node_type == "EVENT":
            self.type = NodeType.EVENT
            self.color = NodeColor(255,0,0)


    def showInputs(self):
        for i in self.inputs:
            print(i)

    def showOutputs(self):
        for i in self.outputs:
            print(i)


    def toLuau(self):
        return ""