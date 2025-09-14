# main.py
from src.nodes.IntValue import IntValueNode
from src.nodes.Math.Addition import AdditionNode
from src.nodes.Math.Subtraction import SubtractionNode
from src.nodes.Math.Multiplication import MultiplicationNode
from src.nodes.Math.Division import DivisionNode
from src.nodes.Math.Modulo import ModuloNode
from src.nodes.Math.FloorDivision import FloorDivisionNode
from src.nodes.Math.Power import PowerNode
from src.nodes.Math.Exponential import ExponentialNode
from src.nodes.Math.Logarithm import LogarithmNode
from src.nodes.Math.Squareroot import SquarerootNode
from src.nodes.Math.Pi import PiNode
from src.nodes.Print import PrintNode
from src.nodes.EventStart import EventStartNode
from src.essentials.DataConnection import DataConnection
from src.essentials.ExecutionConnection import ExecutionConnection
from src.Engine import Engine

# Create engine
engine = Engine()

# --- VALUE NODES ---
val1 = IntValueNode()
val1.updateValueOutput("value", 10)

val2 = IntValueNode()
val2.updateValueOutput("value", 5)

# --- OPERATION NODES ---
addNode = AdditionNode()
subNode = SubtractionNode()
mulNode = MultiplicationNode()
divNode = DivisionNode()
modNode = ModuloNode()
floorDivNode = FloorDivisionNode()
powNode = PowerNode()
expNode = ExponentialNode()
logNode = LogarithmNode()
sqrtNode = SquarerootNode()
piNode = PiNode()

# --- PRINT NODES ---
printAdd = PrintNode()
printSub = PrintNode()
printMul = PrintNode()
printDiv = PrintNode()
printMod = PrintNode()
printFloorDiv = PrintNode()
printPow = PrintNode()
printExp = PrintNode()
printLog = PrintNode()
printSqrt = PrintNode()
printPi = PrintNode()

# --- DATA CONNECTIONS ---
# Addition
engine.data(DataConnection(val1, "value", addNode, "number1"))
engine.data(DataConnection(val2, "value", addNode, "number2"))
engine.data(DataConnection(addNode, "result", printAdd, "value"))

# Subtraction
engine.data(DataConnection(val1, "value", subNode, "number1"))
engine.data(DataConnection(val2, "value", subNode, "number2"))
engine.data(DataConnection(subNode, "result", printSub, "value"))

# Multiplication
engine.data(DataConnection(val1, "value", mulNode, "number1"))
engine.data(DataConnection(val2, "value", mulNode, "number2"))
engine.data(DataConnection(mulNode, "result", printMul, "value"))

# Division
engine.data(DataConnection(val1, "value", divNode, "number1"))
engine.data(DataConnection(val2, "value", divNode, "number2"))
engine.data(DataConnection(divNode, "result", printDiv, "value"))

# Modulo
engine.data(DataConnection(val1, "value", modNode, "number1"))
engine.data(DataConnection(val2, "value", modNode, "number2"))
engine.data(DataConnection(modNode, "result", printMod, "value"))

# Floor Division
engine.data(DataConnection(val1, "value", floorDivNode, "number1"))
engine.data(DataConnection(val2, "value", floorDivNode, "number2"))
engine.data(DataConnection(floorDivNode, "result", printFloorDiv, "value"))

# Power
engine.data(DataConnection(val1, "value", powNode, "number1"))
engine.data(DataConnection(val2, "value", powNode, "number2"))
engine.data(DataConnection(powNode, "result", printPow, "value"))

# Exponential (math.exp)
engine.data(DataConnection(val1, "value", expNode, "number"))
engine.data(DataConnection(expNode, "result", printExp, "value"))

# Logarithm (math.log)
engine.data(DataConnection(val1, "value", logNode, "number"))
engine.data(DataConnection(logNode, "result", printLog, "value"))

# Square root (math.sqrt)
engine.data(DataConnection(val1, "value", sqrtNode, "number"))
engine.data(DataConnection(sqrtNode, "result", printSqrt, "value"))

# Pi (math.pi)
engine.data(DataConnection(piNode, "value", printPi, "value"))

# --- EXECUTION CONNECTIONS ---
start = EventStartNode()

engine.exec(ExecutionConnection(start, addNode))
engine.exec(ExecutionConnection(addNode, printAdd))

engine.exec(ExecutionConnection(printAdd, subNode))
engine.exec(ExecutionConnection(subNode, printSub))

engine.exec(ExecutionConnection(printSub, mulNode))
engine.exec(ExecutionConnection(mulNode, printMul))

engine.exec(ExecutionConnection(printMul, divNode))
engine.exec(ExecutionConnection(divNode, printDiv))

engine.exec(ExecutionConnection(printDiv, modNode))
engine.exec(ExecutionConnection(modNode, printMod))

engine.exec(ExecutionConnection(printMod, floorDivNode))
engine.exec(ExecutionConnection(floorDivNode, printFloorDiv))

engine.exec(ExecutionConnection(printFloorDiv, powNode))
engine.exec(ExecutionConnection(powNode, printPow))

engine.exec(ExecutionConnection(printPow, expNode))
engine.exec(ExecutionConnection(expNode, printExp))

engine.exec(ExecutionConnection(printExp, logNode))
engine.exec(ExecutionConnection(logNode, printLog))

engine.exec(ExecutionConnection(printLog, sqrtNode))
engine.exec(ExecutionConnection(sqrtNode, printSqrt))

engine.exec(ExecutionConnection(printSqrt, piNode))
engine.exec(ExecutionConnection(piNode, printPi))

# --- GENERATE OUTPUT ---
print(engine)