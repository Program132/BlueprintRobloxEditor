from src.nodes.CO.Equal import EqualNode
from src.nodes.StringValue import StringValueNode
from src.nodes.Variable import VariableNode
from src.nodes.Print import PrintNode
from src.nodes.EventStart import EventStartNode
from src.nodes.IfStatement import IfStatementNode
from src.essentials.DataConnection import DataConnection
from src.essentials.ExecutionConnection import ExecutionConnection
from src.Engine import Engine

engine = Engine()

varA = VariableNode("a")
varA.updateValueOutput("value", 5)

varB = VariableNode("b")
varB.updateValueOutput("value", 5465)

printA = PrintNode()
printB = PrintNode()
printFail = PrintNode()

start = EventStartNode()

ifNode = IfStatementNode()
opNode = StringValueNode()
failMsg = StringValueNode()
opNode.updateValueOutput("value", "==")
failMsg.updateValueOutput("value", "NOT GOOD")

opNode2 = EqualNode


engine.data(DataConnection(opNode, "value", ifNode, "operator"))
engine.data(DataConnection(failMsg, "value", printFail, "value"))
engine.data(DataConnection(varA, "value", ifNode, "value1"))
engine.data(DataConnection(varB, "value", ifNode, "value2"))
engine.data(DataConnection(opNode, "value", ifNode, "operator"))
engine.data(DataConnection(varA, "value", printA, "value"))
engine.data(DataConnection(varB, "value", printB, "value"))
engine.data(DataConnection(failMsg, "value", printFail, "value"))


engine.exec(ExecutionConnection(start, ifNode))
engine.exec(ExecutionConnection(ifNode, printA, "success"))
engine.exec(ExecutionConnection(printA, printB))
engine.exec(ExecutionConnection(ifNode, printFail, "fail"))

# Output
print(engine)