from src.Node import Node, NodeType, Input

class ReturnNode(Node):
    
    def __init__(self, function_outputs=None):
        self.json_path = None
        self.color = [100, 200, 100]
        self.type = NodeType.METHOD
        self.title = "Return"
        
        self.inputs = []
        if function_outputs:
            for output_name in function_outputs:
                self.inputs.append(Input(name=output_name, value=None, required=False))
        
        self.outputs = []
        self.exec = []
        self._computed = False
        self.events_count = 0
        self.engine = None
    
    def compute(self):
        if self._computed:
            return
        for input_obj in self.inputs:
            if hasattr(input_obj, 'value') and input_obj.value is not None:
                pass
        self._computed = True
    
    def toLuau(self) -> str:
        self.compute()
        if not self.inputs:
            return "return"
        
        return_values = []
        for input_obj in self.inputs:
            value = input_obj.value
            if value is None:
                return_values.append("nil")
            else:
                return_values.append(str(value))
        
        return "return " + ", ".join(return_values)
    
    def setInputValue(self, input_name: str, value):
        for input_obj in self.inputs:
            if input_obj.name == input_name:
                input_obj.value = value
                break
    
    def getOutputValue(self, output_name: str):
        return None