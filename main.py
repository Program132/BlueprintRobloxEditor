# main.py
from src.nodes.Variable import VariableNode
from src.nodes.GetVariable import GetVariableNode
from src.nodes.SetVariable import SetVariableNode
from src.nodes.Print import PrintNode
from src.essentials.DataConnection import DataConnection
from src.Engine import Engine
from src.nodes.EventStart import EventStartNode
from src.essentials.ExecutionConnection import ExecutionConnection

engine = Engine()

myVar = VariableNode("score")
myVar.updateValue(10)

getNode = GetVariableNode()
printNode = PrintNode()
setNode = SetVariableNode()
setNode.updateValueInput("value", 42)
get2Node = GetVariableNode()
print2Node = PrintNode()



engine.addDataConnection(DataConnection(myVar, "ref", getNode, "ref"))
engine.addDataConnection(DataConnection(getNode, "value", printNode, "value"))
engine.addDataConnection(DataConnection(myVar, "ref", setNode, "ref"))
engine.addDataConnection(DataConnection(myVar, "ref", get2Node, "ref"))
engine.addDataConnection(DataConnection(get2Node, "value", print2Node, "value"))


start = EventStartNode()
engine.addExecutionConnection(ExecutionConnection(start, myVar))
engine.addExecutionConnection(ExecutionConnection(myVar, getNode))
engine.addExecutionConnection(ExecutionConnection(getNode, printNode))
engine.addExecutionConnection(ExecutionConnection(start, setNode))
engine.addExecutionConnection(ExecutionConnection(setNode, get2Node))
engine.addExecutionConnection(ExecutionConnection(get2Node, print2Node))

print(engine)