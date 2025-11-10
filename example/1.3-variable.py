from src.Engine.Engine import Engine
from src.Nodes.Transition import Transition
from src.Nodes.TransitionType import TransitionType
from src.Nodes.NodeType import NodeType
from src.Nodes.Events.Start import Start
from src.Nodes.Models.Variables.Variable import Variable
from src.Nodes.Models.Print import Print
from src.Nodes.Models.Variables.GET import GET
from src.Nodes.Models.Variables.SET import SET

var_message = Variable("myMessage", "Hello World")

START = Start()
get_node_1 = GET()
get_node_1.setInputValue("name", "myMessage")

print_node_1 = Print()
set_node = SET()
set_node.setInputValue("name", "myMessage")
set_node.setInputValue("value", "Hello World 2.0")

get_node_2 = GET()
get_node_2.setInputValue("name", "myMessage")

print_node_2 = Print()
print_node_2.type = NodeType.METHOD

exec_1 = Transition(START, print_node_1, TransitionType.EXEC)
exec_2 = Transition(print_node_1, set_node, TransitionType.EXEC)
exec_3 = Transition(set_node, print_node_2, TransitionType.EXEC)


data_1 = Transition(get_node_1, print_node_1, TransitionType.DATA,
                    print_node_1.getInput("value"), get_node_1.getOutput("value"))

data_2 = Transition(get_node_2, print_node_2, TransitionType.DATA,
                    print_node_2.getInput("value"), get_node_2.getOutput("value"))

engine = Engine()

engine.addVariable(var_message)

engine.addNode(START)
engine.addNode(get_node_1)
engine.addNode(print_node_1)
engine.addNode(set_node)
engine.addNode(get_node_2)
engine.addNode(print_node_2)

engine.addTransition(exec_1)
engine.addTransition(exec_2)
engine.addTransition(exec_3)
engine.addTransition(data_1)
engine.addTransition(data_2)

luau_code = engine.generateLuau()
print(luau_code)