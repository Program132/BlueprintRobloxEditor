from src.Engine.Engine import Engine
from src.Nodes.Models.Print import Print
from src.Nodes.Models.math.Add import Add
from src.Nodes.Transition import Transition
from src.Nodes.TransitionType import TransitionType
from src.Nodes.Events.Start import Start

START = Start()

add_node = Add()
print_node = Print()

exec_link = Transition(START, print_node, TransitionType.EXEC)
date_link_addprint = Transition(add_node, print_node, TransitionType.DATA, print_node.getInput("value"), add_node.getOutput("result"))



engine = Engine()
engine.addNode(START)
engine.addNode(add_node)
engine.addNode(print_node)
engine.addTransition(exec_link)
engine.addTransition(date_link_addprint)

luau_code = engine.generateLuau()
print(luau_code)
