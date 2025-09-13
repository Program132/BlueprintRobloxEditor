# src/essentials/DataConnection.py
class DataConnection:
    def __init__(self, output_node, output_name, input_node, input_name):
        self.output_node = output_node
        self.output_name = output_name
        self.input_node = input_node
        self.input_name = input_name

    def propagate(self):
        value = self.output_node.getValueOutput(self.output_name)
        self.input_node.updateValueInput(self.input_name, value)