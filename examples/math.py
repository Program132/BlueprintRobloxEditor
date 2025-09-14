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
engine.addDataConnection(DataConnection(val1, "value", addNode, "number1"))
engine.addDataConnection(DataConnection(val2, "value", addNode, "number2"))
engine.addDataConnection(DataConnection(addNode, "result", printAdd, "value"))

# Subtraction
engine.addDataConnection(DataConnection(val1, "value", subNode, "number1"))
engine.addDataConnection(DataConnection(val2, "value", subNode, "number2"))
engine.addDataConnection(DataConnection(subNode, "result", printSub, "value"))

# Multiplication
engine.addDataConnection(DataConnection(val1, "value", mulNode, "number1"))
engine.addDataConnection(DataConnection(val2, "value", mulNode, "number2"))
engine.addDataConnection(DataConnection(mulNode, "result", printMul, "value"))

# Division
engine.addDataConnection(DataConnection(val1, "value", divNode, "number1"))
engine.addDataConnection(DataConnection(val2, "value", divNode, "number2"))
engine.addDataConnection(DataConnection(divNode, "result", printDiv, "value"))

# Modulo
engine.addDataConnection(DataConnection(val1, "value", modNode, "number1"))
engine.addDataConnection(DataConnection(val2, "value", modNode, "number2"))
engine.addDataConnection(DataConnection(modNode, "result", printMod, "value"))

# Floor Division
engine.addDataConnection(DataConnection(val1, "value", floorDivNode, "number1"))
engine.addDataConnection(DataConnection(val2, "value", floorDivNode, "number2"))
engine.addDataConnection(DataConnection(floorDivNode, "result", printFloorDiv, "value"))

# Power
engine.addDataConnection(DataConnection(val1, "value", powNode, "number1"))
engine.addDataConnection(DataConnection(val2, "value", powNode, "number2"))
engine.addDataConnection(DataConnection(powNode, "result", printPow, "value"))

# Exponential (math.exp)
engine.addDataConnection(DataConnection(val1, "value", expNode, "number"))
engine.addDataConnection(DataConnection(expNode, "result", printExp, "value"))

# Logarithm (math.log)
engine.addDataConnection(DataConnection(val1, "value", logNode, "number"))
engine.addDataConnection(DataConnection(logNode, "result", printLog, "value"))

# Square root (math.sqrt)
engine.addDataConnection(DataConnection(val1, "value", sqrtNode, "number"))
engine.addDataConnection(DataConnection(sqrtNode, "result", printSqrt, "value"))

# Pi (math.pi)
engine.addDataConnection(DataConnection(piNode, "value", printPi, "value"))

# --- EXECUTION CONNECTIONS ---
start = EventStartNode()

engine.addExecutionConnection(ExecutionConnection(start, addNode))
engine.addExecutionConnection(ExecutionConnection(addNode, printAdd))

engine.addExecutionConnection(ExecutionConnection(printAdd, subNode))
engine.addExecutionConnection(ExecutionConnection(subNode, printSub))

engine.addExecutionConnection(ExecutionConnection(printSub, mulNode))
engine.addExecutionConnection(ExecutionConnection(mulNode, printMul))

engine.addExecutionConnection(ExecutionConnection(printMul, divNode))
engine.addExecutionConnection(ExecutionConnection(divNode, printDiv))

engine.addExecutionConnection(ExecutionConnection(printDiv, modNode))
engine.addExecutionConnection(ExecutionConnection(modNode, printMod))

engine.addExecutionConnection(ExecutionConnection(printMod, floorDivNode))
engine.addExecutionConnection(ExecutionConnection(floorDivNode, printFloorDiv))

engine.addExecutionConnection(ExecutionConnection(printFloorDiv, powNode))
engine.addExecutionConnection(ExecutionConnection(powNode, printPow))

engine.addExecutionConnection(ExecutionConnection(printPow, expNode))
engine.addExecutionConnection(ExecutionConnection(expNode, printExp))

engine.addExecutionConnection(ExecutionConnection(printExp, logNode))
engine.addExecutionConnection(ExecutionConnection(logNode, printLog))

engine.addExecutionConnection(ExecutionConnection(printLog, sqrtNode))
engine.addExecutionConnection(ExecutionConnection(sqrtNode, printSqrt))

engine.addExecutionConnection(ExecutionConnection(printSqrt, piNode))
engine.addExecutionConnection(ExecutionConnection(piNode, printPi))

# --- GENERATE OUTPUT ---
print(engine)
