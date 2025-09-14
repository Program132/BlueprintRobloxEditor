from src.nodes.IntValue import IntValueNode
from src.nodes.Math.Cos import CosNode
from src.nodes.Math.Sin import SinNode
from src.nodes.Math.Tan import TanNode
from src.nodes.Math.ArcCos import ArcCosNode
from src.nodes.Math.ArcSin import ArcSinNode
from src.nodes.Math.ArcTan import ArcTanNode
from src.nodes.Math.Cosh import CoshNode
from src.nodes.Math.Sinh import SinhNode
from src.nodes.Math.Tanh import TanhNode
from src.nodes.Math.AbsoluteValue import AbsoluteValueNode
from src.nodes.Math.Degree import DegreeNode
from src.nodes.Math.Radian import RadianNode
from src.nodes.Math.Random import RandomNode
from src.nodes.Print import PrintNode
from src.nodes.EventStart import EventStartNode
from src.essentials.DataConnection import DataConnection
from src.essentials.ExecutionConnection import ExecutionConnection
from src.Engine import Engine

engine = Engine()

# --- VALUE NODE ---
angle = IntValueNode()
angle.updateValueOutput("value", 1)  # 1 radian

minVal = IntValueNode()
minVal.updateValueOutput("value", 1)

maxVal = IntValueNode()
maxVal.updateValueOutput("value", 100)

# --- TRIGONOMETRIC NODES ---
cosNode = CosNode()
sinNode = SinNode()
tanNode = TanNode()
acosNode = ArcCosNode()
asinNode = ArcSinNode()
atanNode = ArcTanNode()
coshNode = CoshNode()
sinhNode = SinhNode()
tanhNode = TanhNode()

# --- OTHER MATH NODES ---
absNode = AbsoluteValueNode()
degNode = DegreeNode()
radNode = RadianNode()
randNode = RandomNode()

# --- PRINT NODES ---
printCos = PrintNode()
printSin = PrintNode()
printTan = PrintNode()
printAcos = PrintNode()
printAsin = PrintNode()
printAtan = PrintNode()
printCosh = PrintNode()
printSinh = PrintNode()
printTanh = PrintNode()
printAbs = PrintNode()
printDeg = PrintNode()
printRad = PrintNode()
printRand = PrintNode()

# --- DATA CONNECTIONS ---
engine.data(DataConnection(angle, "value", cosNode, "number"))
engine.data(DataConnection(cosNode, "result", printCos, "value"))

engine.data(DataConnection(angle, "value", sinNode, "number"))
engine.data(DataConnection(sinNode, "result", printSin, "value"))

engine.data(DataConnection(angle, "value", tanNode, "number"))
engine.data(DataConnection(tanNode, "result", printTan, "value"))

engine.data(DataConnection(angle, "value", acosNode, "number"))
engine.data(DataConnection(acosNode, "result", printAcos, "value"))

engine.data(DataConnection(angle, "value", asinNode, "number"))
engine.data(DataConnection(asinNode, "result", printAsin, "value"))

engine.data(DataConnection(angle, "value", atanNode, "number"))
engine.data(DataConnection(atanNode, "result", printAtan, "value"))

engine.data(DataConnection(angle, "value", coshNode, "number"))
engine.data(DataConnection(coshNode, "result", printCosh, "value"))

engine.data(DataConnection(angle, "value", sinhNode, "number"))
engine.data(DataConnection(sinhNode, "result", printSinh, "value"))

engine.data(DataConnection(angle, "value", tanhNode, "number"))
engine.data(DataConnection(tanhNode, "result", printTanh, "value"))

engine.data(DataConnection(angle, "value", absNode, "number"))
engine.data(DataConnection(absNode, "result", printAbs, "value"))

engine.data(DataConnection(angle, "value", degNode, "number"))
engine.data(DataConnection(degNode, "result", printDeg, "value"))

engine.data(DataConnection(angle, "value", radNode, "number"))
engine.data(DataConnection(radNode, "result", printRad, "value"))

engine.data(DataConnection(minVal, "value", randNode, "number1"))
engine.data(DataConnection(maxVal, "value", randNode, "number2"))
engine.data(DataConnection(randNode, "result", printRand, "value"))

# --- EXECUTION FLOW ---
start = EventStartNode()

engine.exec(ExecutionConnection(start, cosNode))
engine.exec(ExecutionConnection(cosNode, printCos))

engine.exec(ExecutionConnection(printCos, sinNode))
engine.exec(ExecutionConnection(sinNode, printSin))

engine.exec(ExecutionConnection(printSin, tanNode))
engine.exec(ExecutionConnection(tanNode, printTan))

engine.exec(ExecutionConnection(printTan, acosNode))
engine.exec(ExecutionConnection(acosNode, printAcos))

engine.exec(ExecutionConnection(printAcos, asinNode))
engine.exec(ExecutionConnection(asinNode, printAsin))

engine.exec(ExecutionConnection(printAsin, atanNode))
engine.exec(ExecutionConnection(atanNode, printAtan))

engine.exec(ExecutionConnection(printAtan, coshNode))
engine.exec(ExecutionConnection(coshNode, printCosh))

engine.exec(ExecutionConnection(printCosh, sinhNode))
engine.exec(ExecutionConnection(sinhNode, printSinh))

engine.exec(ExecutionConnection(printSinh, tanhNode))
engine.exec(ExecutionConnection(tanhNode, printTanh))

engine.exec(ExecutionConnection(printTanh, absNode))
engine.exec(ExecutionConnection(absNode, printAbs))

engine.exec(ExecutionConnection(printAbs, degNode))
engine.exec(ExecutionConnection(degNode, printDeg))

engine.exec(ExecutionConnection(printDeg, radNode))
engine.exec(ExecutionConnection(radNode, printRad))

engine.exec(ExecutionConnection(printRad, randNode))
engine.exec(ExecutionConnection(randNode, printRand))

# --- OUTPUT ---
print(engine)
