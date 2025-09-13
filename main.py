from src.Engine import Engine
from src.essentials.ExecutionConnection import ExecutionConnection
from src.nodes.BooleanValue import BooleanValueNode
from src.nodes.DoubleValue import DoubleValueNode
from src.nodes.IntValue import IntValueNode
from src.nodes.Print import PrintNode
from src.nodes.StringValue import StringValueNode
from src.nodes.EventStart import EventStartNode
from src.essentials.DataConnection import DataConnection

engine = Engine()

eventStart = EventStartNode()
print1 = PrintNode()
print2 = PrintNode()
print3 = PrintNode()
print4 = PrintNode()

stringVal = StringValueNode()
stringVal.updateValueOutput("value", "Hello World 2!")
intVal = IntValueNode()
intVal.updateValueOutput("value", 18)
doubleVal = DoubleValueNode()
doubleVal.updateValueOutput("value", 3.14)
boolVal = BooleanValueNode()
boolVal.updateValueOutput("value", True)

exec = ExecutionConnection(eventStart, print1)
conn = DataConnection(stringVal, "value", print1, "value")
conn.propagate()
conn = DataConnection(intVal, "value", print2, "value")
conn.propagate()
conn = DataConnection(doubleVal, "value", print3, "value")
conn.propagate()
conn = DataConnection(boolVal, "value", print4, "value")
conn.propagate()

engine.addNode(eventStart)
engine.addNode(print1)
engine.addNode(print2)
engine.addNode(print3)
engine.addNode(print4)

#engine.generateFile("main.lua")
print(engine)