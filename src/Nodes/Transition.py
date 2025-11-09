from src.Nodes.Node import Node
from src.Nodes.TransitionType import TransitionType
from src.Nodes.IO import Input,Output

class Transition:
    def __init__(self, node1:'Node', node2:'Node', type:'TransitionType', input:'Input'=None, output:'Output'=None):
        self.start = node1
        self.end = node2
        self.type = type
        self.input = input
        self.output = output

    def getStart(self):
        return self.start

    def getEnd(self):
        return self.end

    def getType(self):
        return self.type

    def setStart(self, n:'Node'):
        self.start = n

    def setEnd(self, n:'Node'):
        self.end = n

    def setType(self, t:'TransitionType'):
        self.type = t

    def setInputValueFromOutput(self):
        output_value = self.start.getOutputValue(self.output.name)
        self.end.setInputValue(self.input.name, output_value)