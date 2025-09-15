#main.py
from src.nodes.String.Byte import ByteNode
from src.nodes.String.Char import CharNode
from src.nodes.String.Ends import EndsNode
from src.nodes.String.Find import FindNode
from src.nodes.String.Len import LenNode
from src.nodes.String.Lower import LowerNode
from src.nodes.String.Rep import RepNode
from src.nodes.String.Reverse import ReverseNode
from src.nodes.String.Upper import UpperNode
from src.nodes.Variable import VariableNode
from src.nodes.Print import PrintNode
from src.nodes.EventStart import EventStartNode
from src.nodes.IntValue import IntValueNode
from src.nodes.String.Concat import ConcatNode
from src.essentials.DataConnection import DataConnection
from src.essentials.ExecutionConnection import ExecutionConnection
from src.Engine import Engine

engine = Engine()

# --- VALEURS DE BASE ---
helloStr = VariableNode("hello")
helloStr.updateValue("Hello World")

suffixStr = VariableNode("suffix")
suffixStr.updateValue("World")

patternStr = VariableNode("pattern")
patternStr.updateValue("lo")

repeatCount = IntValueNode()
repeatCount.updateValueOutput("value", 3)

charCode = IntValueNode()
charCode.updateValueOutput("value", 65)  # 'A'

# --- NODES STRING ---
byteNode = ByteNode()
charNode = CharNode()
endsNode = EndsNode()
findNode = FindNode()
lenNode = LenNode()
concatNode = ConcatNode()
lowerNode = LowerNode()
upperNode = UpperNode()
repNode = RepNode()
reverseNode = ReverseNode()

# --- PRINTS ---
printByte = PrintNode()
printChar = PrintNode()
printEnds = PrintNode()
printFind = PrintNode()
printLen = PrintNode()
printConcat = PrintNode()
printLower = PrintNode()
printUpper = PrintNode()
printRep = PrintNode()
printReverse = PrintNode()

# --- DATA CONNECTIONS ---
engine.data(DataConnection(helloStr, "value", byteNode, "value"))
engine.data(DataConnection(byteNode, "result", printByte, "value"))

engine.data(DataConnection(charCode, "value", charNode, "value"))
engine.data(DataConnection(charNode, "result", printChar, "value"))

engine.data(DataConnection(helloStr, "value", endsNode, "value"))
engine.data(DataConnection(suffixStr, "value", endsNode, "suffix"))
engine.data(DataConnection(endsNode, "result", printEnds, "value"))

engine.data(DataConnection(helloStr, "value", findNode, "value"))
engine.data(DataConnection(patternStr, "value", findNode, "pattern"))
engine.data(DataConnection(findNode, "result", printFind, "value"))

engine.data(DataConnection(helloStr, "value", lenNode, "value"))
engine.data(DataConnection(lenNode, "result", printLen, "value"))

engine.data(DataConnection(helloStr, "value", concatNode, "str1"))
engine.data(DataConnection(suffixStr, "value", concatNode, "str2"))
engine.data(DataConnection(concatNode, "result", printConcat, "value"))

engine.data(DataConnection(helloStr, "value", lowerNode, "value"))
engine.data(DataConnection(lowerNode, "result", printLower, "value"))

engine.data(DataConnection(helloStr, "value", upperNode, "value"))
engine.data(DataConnection(upperNode, "result", printUpper, "value"))

engine.data(DataConnection(helloStr, "value", repNode, "value"))
engine.data(DataConnection(repeatCount, "value", repNode, "number"))
engine.data(DataConnection(repNode, "result", printRep, "value"))

engine.data(DataConnection(helloStr, "value", reverseNode, "value"))
engine.data(DataConnection(reverseNode, "result", printReverse, "value"))

# --- EXECUTION FLOW ---
start = EventStartNode()

engine.exec(ExecutionConnection(start, byteNode))
engine.exec(ExecutionConnection(byteNode, printByte))

engine.exec(ExecutionConnection(printByte, charNode))
engine.exec(ExecutionConnection(charNode, printChar))

engine.exec(ExecutionConnection(printChar, endsNode))
engine.exec(ExecutionConnection(endsNode, printEnds))

engine.exec(ExecutionConnection(printEnds, findNode))
engine.exec(ExecutionConnection(findNode, printFind))

engine.exec(ExecutionConnection(printFind, lenNode))
engine.exec(ExecutionConnection(lenNode, printLen))

engine.exec(ExecutionConnection(printLen, concatNode))
engine.exec(ExecutionConnection(concatNode, printConcat))

engine.exec(ExecutionConnection(printConcat, lowerNode))
engine.exec(ExecutionConnection(lowerNode, printLower))

engine.exec(ExecutionConnection(printLower, upperNode))
engine.exec(ExecutionConnection(upperNode, printUpper))

engine.exec(ExecutionConnection(printUpper, repNode))
engine.exec(ExecutionConnection(repNode, printRep))

engine.exec(ExecutionConnection(printRep, reverseNode))
engine.exec(ExecutionConnection(reverseNode, printReverse))

# --- OUTPUT ---
print(engine)
