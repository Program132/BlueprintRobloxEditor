from src.Node import Node, NodeType, Input, Output

class FunctionCallNode(Node):
    
    def __init__(self, function_name, function_inputs, function_outputs):
        self.json_path = None
        self.color = [200, 150, 100]
        self.type = NodeType.FUNCTION if function_outputs else NodeType.METHOD
        self.title = f"Call {function_name}"
        self.function_name = function_name
        self.function_outputs = function_outputs
        
        self.inputs = []
        for param_name in function_inputs:
            self.inputs.append(Input(name=param_name, value=None, required=False))
        
        self.outputs = []
        for output_name in function_outputs:
            self.outputs.append(Output(name=output_name, value=None))
        
        self.exec = []
        self._computed = False
        self._luau_generated = False
        self.events_count = 0
        self.engine = None
    
    def compute(self):
        if self._computed:
            return
        self._computed = True
    
    def toLuau(self) -> str:
        if self._luau_generated:
            return ""
        
        self._luau_generated = True
        self.compute()
        
        param_values = []
        for input_obj in self.inputs:
            value = input_obj.value
            if value is None:
                param_values.append("nil")
            else:
                value_str = str(value).strip()
                
                if value_str.startswith('"') or value_str.startswith("'"):
                    param_values.append(value_str)
                else:
                    is_variable = (value_str.replace('_', '').replace('.', '').isalnum() and 
                                 (value_str[0].isalpha() or value_str[0] == '_'))
                    
                    try:
                        float(value_str)
                        is_number = True
                    except:
                        is_number = False
                    
                    if not is_variable and not is_number:
                        param_values.append(f'"{value_str}"')
                    else:
                        param_values.append(value_str)
        
        params_str = ", ".join(param_values)
        
        if self.outputs:
            call_expression = f"{self.function_name}({params_str})"
            for output in self.outputs:
                output.value = call_expression
            return ""
        
        return ""
    
    def run(self) -> str:
        if self.outputs:
            return ""
        
        self.compute()
        
        param_values = []
        for input_obj in self.inputs:
            value = input_obj.value
            if value is None:
                param_values.append("nil")
            else:
                param_values.append(str(value))
        
        params_str = ", ".join(param_values)
        return f"{self.function_name}({params_str})"
    
    def setInputValue(self, input_name: str, value):
        for input_obj in self.inputs:
            if input_obj.name == input_name:
                input_obj.value = value
                break
    
    def getOutputValue(self, output_name: str):
        for output in self.outputs:
            if output.name == output_name:
                return output.value
        return None