from src.Nodes.TransitionType import TransitionType
from src.Engine.Engine import Engine
from src.Nodes.Transition import Transition
from src.Nodes.Events.Start import Start
from src.Nodes.Models.Variables.Variable import Variable
from src.Nodes.Models.Variables.SET import SET
from src.Nodes.Models.Variables.GET import GET
from src.Nodes.Models.table.ConstructTable import ConstructTable
from src.Nodes.Models.table.TableSetElement import TableSetElement

START = Start()

var_ = Variable("myDict")

SET_NODE = SET()
T_MAP = ConstructTable()
GET_NODE = GET()
TABLE_SET = TableSetElement()

SET_NODE.setInputValue("name", var_.name)
GET_NODE.setInputValue("name", var_.name)
TABLE_SET.setInputValue("key", "my custom key")
TABLE_SET.setInputValue("value", "my custom val")

engine = Engine()

engine.addVariable(var_)
engine.addTransition(Transition(T_MAP, SET_NODE, TransitionType.DATA, SET_NODE.getInput("value"), T_MAP.getOutput("table")))
engine.addTransition(Transition(GET_NODE, TABLE_SET, TransitionType.DATA, TABLE_SET.getInput("table"), GET_NODE.getOutput("value")))
engine.addTransition(Transition(START, SET_NODE, TransitionType.EXEC))
engine.addTransition(Transition(SET_NODE, GET_NODE, TransitionType.EXEC))
engine.addTransition(Transition(GET_NODE, TABLE_SET, TransitionType.EXEC))


engine.addNode(START)
engine.addNode(T_MAP)
engine.addNode(SET_NODE)
engine.addNode(GET_NODE)
engine.addNode(TABLE_SET)



luau_code = engine.generateLuau()
print(luau_code)