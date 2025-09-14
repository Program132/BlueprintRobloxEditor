#src/essentials/Node.py
from abc import abstractmethod, ABC
from src.essentials.NodeType import NodeType
from src.essentials.NodeColor import NodeColor
from src.essentials.NodeValues import NodeValues

class Node(ABC):
    def __init__(self, nodeType: 'NodeType', nodeName: str):
        self.nodeType = nodeType
        self.color = NodeColor.getColor(nodeType)
        self.inputs = []
        self.outputs = []
        self.nodeName = nodeName

    def addInput(self, name:str, value):
        self.inputs.append(NodeValues(name, value))

    def addOutput(self, name:str, value):
        self.outputs.append(NodeValues(name, value))

    def updateValueInput(self, name:str, value):
        for n in self.inputs:
            if n.name == name:
                n.value = value
        return None

    def updateValueOutput(self, name:str, value):
        for n in self.outputs:
            if n.name == name:
                n.value = value
        return None

    def getValueInput(self, name:str):
        for n in self.inputs:
            if n.name == name:
                return n.value
        return None

    def getValueOutput(self, name:str):
        for n in self.outputs:
            if n.name == name:
                return n.value
        return None

    def _getInputNames(self):
        l = []
        for i in self.inputs:
            l.append(i.name)
        return l

    def _getOutputNames(self):
        l = []
        for i in self.outputs:
            l.append(i.name)
        return l

    @abstractmethod
    def getValue(self):
        pass

    @abstractmethod
    def toLuau(self):
        pass

    def __str__(self):
        return f"{self.nodeName}: {self.toLuau()} [inputs: {self._getInputNames()}] [outputs: {self._getOutputNames()}]"

    addi = addInput
    addo = addOutput
    geti = getValueInput
    geto = getValueOutput
    updatei = updateValueInput
    updateo = updateValueOutput
    getv = getValue