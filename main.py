#main.py
from src.nodes.IntValue import IntValueNode
from src.nodes.Math.Cos import CosNode
from src.nodes.Math.Sin import SinNode
from src.nodes.Math.Modulo import ModuloNode
from src.nodes.Math.Multiplication import MultiplicationNode
from src.nodes.Math.Division import DivisionNode
from src.nodes.Math.Addition import AdditionNode
from src.nodes.Variable import VariableNode
from src.nodes.GetVariable import GetVariableNode
from src.nodes.Print import PrintNode
from src.nodes.EventStart import EventStartNode
from src.essentials.DataConnection import DataConnection
from src.essentials.ExecutionConnection import ExecutionConnection
from src.Engine import Engine

engine = Engine()

# --- VALUE NODES ---
val1 = IntValueNode();   val1.updateo("value", 1)     # cos(1)
val0 = IntValueNode();   val0.updateo("value", 0)     # sin(0)
val5 = IntValueNode();   val5.updateo("value", 5)     # 5 % 2
val2 = IntValueNode();   val2.updateo("value", 2)
val300 = IntValueNode(); val300.updateo("value", 300) # / 300

# --- EXPRESSION NODES ---
cosNode = CosNode()                # math.cos(1)
sinNode = SinNode()                # math.sin(0)
modNode = ModuloNode()             # 5 % 2
mulNode = MultiplicationNode()     # sin(0) * (5 % 2)
divNode = DivisionNode()           # (...) / 300
addNode = AdditionNode()           # cos(1) + (...)

# --- VARIABLE ---
myVar   = VariableNode("result")   # local result = <expression>

# --- GET + PRINT ---
getVar = GetVariableNode()
printVar = PrintNode()

# --- DATA CONNECTIONS ---
# cos(1)
engine.data(DataConnection(val1, "value", cosNode, "number"))

# sin(0)
engine.data(DataConnection(val0, "value", sinNode, "number"))

# 5 % 2
engine.data(DataConnection(val5, "value", modNode, "number1"))
engine.data(DataConnection(val2, "value", modNode, "number2"))

# sin(0) * (5 % 2)
engine.data(DataConnection(sinNode, "result", mulNode, "number1"))
engine.data(DataConnection(modNode, "result", mulNode, "number2"))

# (...) / 300
engine.data(DataConnection(mulNode, "result", divNode, "number1"))
engine.data(DataConnection(val300, "value", divNode, "number2"))

# cos(1) + (...)
engine.data(DataConnection(cosNode, "result", addNode, "number1"))
engine.data(DataConnection(divNode, "result", addNode, "number2"))

# Déclaration de la variable avec l'expression finale
engine.data(DataConnection(addNode, "result", myVar, "value"))

# Lecture + print
engine.data(DataConnection(myVar, "ref", getVar, "ref"))
engine.data(DataConnection(getVar, "value", printVar, "value"))

# --- EXECUTION FLOW ---
start = EventStartNode()

engine.exec(ExecutionConnection(start, cosNode))
engine.exec(ExecutionConnection(cosNode, sinNode))
engine.exec(ExecutionConnection(sinNode, modNode))
engine.exec(ExecutionConnection(modNode, mulNode))
engine.exec(ExecutionConnection(mulNode, divNode))
engine.exec(ExecutionConnection(divNode, addNode))
engine.exec(ExecutionConnection(addNode, myVar))
engine.exec(ExecutionConnection(myVar, getVar))
engine.exec(ExecutionConnection(getVar, printVar))

# --- OUTPUT ---
print(engine)