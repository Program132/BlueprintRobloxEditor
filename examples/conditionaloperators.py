from src.nodes.IntValue import IntValueNode
from src.nodes.Variable import VariableNode
from src.nodes.GetVariable import GetVariableNode
from src.nodes.Print import PrintNode
from src.nodes.EventStart import EventStartNode
from src.nodes.CO.Equal import EqualNode
from src.nodes.CO.Different import DifferentNode
from src.nodes.CO.Lower import LowerNode
from src.nodes.CO.LowerEqual import LowerEqualNode
from src.nodes.CO.Greater import GreaterNode
from src.nodes.CO.GreaterEqual import GreaterEqualNode
from src.essentials.DataConnection import DataConnection
from src.essentials.ExecutionConnection import ExecutionConnection
from src.Engine import Engine

engine = Engine()

# --- VALEURS ---
val5 = IntValueNode(); val5.updateValueOutput("value", 5)
val10 = IntValueNode(); val10.updateValueOutput("value", 10)

# --- NODES CONDITIONNELS ---
eqNode = EqualNode()
diffNode = DifferentNode()
ltNode = LowerNode()
lteNode = LowerEqualNode()
gtNode = GreaterNode()
gteNode = GreaterEqualNode()

# --- PRINTS ---
printEq = PrintNode()
printDiff = PrintNode()
printLt = PrintNode()
printLte = PrintNode()
printGt = PrintNode()
printGte = PrintNode()

# --- DATA CONNECTIONS ---
# Equal
engine.data(DataConnection(val5, "value", eqNode, "value1"))
engine.data(DataConnection(val10, "value", eqNode, "value2"))
engine.data(DataConnection(eqNode, "result", printEq, "value"))

# Different
engine.data(DataConnection(val5, "value", diffNode, "value1"))
engine.data(DataConnection(val10, "value", diffNode, "value2"))
engine.data(DataConnection(diffNode, "result", printDiff, "value"))

# Lower
engine.data(DataConnection(val5, "value", ltNode, "value1"))
engine.data(DataConnection(val10, "value", ltNode, "value2"))
engine.data(DataConnection(ltNode, "result", printLt, "value"))

# LowerEqual
engine.data(DataConnection(val5, "value", lteNode, "value1"))
engine.data(DataConnection(val10, "value", lteNode, "value2"))
engine.data(DataConnection(lteNode, "result", printLte, "value"))

# Greater
engine.data(DataConnection(val5, "value", gtNode, "value1"))
engine.data(DataConnection(val10, "value", gtNode, "value2"))
engine.data(DataConnection(gtNode, "result", printGt, "value"))

# GreaterEqual
engine.data(DataConnection(val5, "value", gteNode, "value1"))
engine.data(DataConnection(val10, "value", gteNode, "value2"))
engine.data(DataConnection(gteNode, "result", printGte, "value"))

# --- EXECUTION FLOW ---
start = EventStartNode()

engine.exec(ExecutionConnection(start, eqNode))
engine.exec(ExecutionConnection(eqNode, printEq))

engine.exec(ExecutionConnection(printEq, diffNode))
engine.exec(ExecutionConnection(diffNode, printDiff))

engine.exec(ExecutionConnection(printDiff, ltNode))
engine.exec(ExecutionConnection(ltNode, printLt))

engine.exec(ExecutionConnection(printLt, lteNode))
engine.exec(ExecutionConnection(lteNode, printLte))

engine.exec(ExecutionConnection(printLte, gtNode))
engine.exec(ExecutionConnection(gtNode, printGt))

engine.exec(ExecutionConnection(printGt, gteNode))
engine.exec(ExecutionConnection(gteNode, printGte))

# --- OUTPUT ---
print(engine)
