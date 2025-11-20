from src.Node import Node, NodeType, Output

class FunctionStartNode(Node):
    
    def __init__(self, function_inputs=None):
        self.json_path = None
        self.color = [100, 200, 100]
        self.type = NodeType.EVENT
        self.title = "Function Start"
        self.inputs = []
        
        self.outputs = []
        if function_inputs:
            for input_name in function_inputs:
                self.outputs.append(Output(name=input_name, value=None))
        
        self.exec = []
        self._computed = False
        self.events_count = 0
        self.engine = None
    
    def compute(self):
        if self._computed:
            return
        self._computed = True
    
    def run(self) -> str:
        self.compute()
        return ""
    
    def setInputValue(self, input_name: str, value):
        pass
    
    def getOutputValue(self, output_name: str):
        for output in self.outputs:
            if output.name == output_name:
                return output_name
        return None
