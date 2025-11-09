from src.Engine.Engine import Engine
from src.Nodes.Models.Print import Print
from src.Nodes.Models.math.Add import Add
from src.Nodes.Transition import Transition
from src.Nodes.TransitionType import TransitionType
from src.Nodes.Events.Start import Start

START = Start()

add_node = Add()
add_2_node = Add()
add_3_node = Add()
print_node = Print()

add_node.setInputValue("a", 5)
add_node.setInputValue("b", 7)

add_2_node.setInputValue("a", 20)

add_3_node.setInputValue("a", 100)

exec_link = Transition(START, print_node, TransitionType.EXEC) # START -> print
date_link_add = Transition(add_node, add_2_node, TransitionType.DATA, add_2_node.getInput("b"), add_node.getOutput("result")) # add result -> add_2 b
date_link2_add = Transition(add_2_node, add_3_node, TransitionType.DATA, add_3_node.getInput("b"), add_2_node.getOutput("result")) # add_2 result -> add_3 b
date_link_print = Transition(add_3_node, print_node, TransitionType.DATA, print_node.getInput("value"), add_3_node.getOutput("result")) # add_3 result -> print

engine = Engine()
engine.addNode(START)
engine.addNode(add_node)
engine.addNode(add_2_node)
engine.addNode(add_3_node)
engine.addNode(print_node)
engine.addTransition(exec_link)
engine.addTransition(date_link_add)
engine.addTransition(date_link2_add)
engine.addTransition(date_link_print)

luau_code = engine.generateLuau()
print(luau_code)
