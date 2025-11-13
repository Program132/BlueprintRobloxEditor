from src.Engine.Engine import Engine
from src.Nodes.Transition import Transition
from src.Nodes.TransitionType import TransitionType
from src.Nodes.Events.Start import Start
from src.Nodes.Models.Print import Print
from src.Nodes.Models.statement.ForRange import ForRange

START = Start()

FOR_NODE = ForRange()
FOR_NODE.setInputValue("variable", "i")
FOR_NODE.setInputValue("start", 1)
FOR_NODE.setInputValue("end", 3)
FOR_NODE.setInputValue("step", 1)

print_loop = Print()
print_loop.setInputValue("value", "i")

print_finished = Print()
print_finished.setInputValue("value", "Loop Finished")

exec_1 = Transition(START, FOR_NODE, TransitionType.EXEC)

exec_loop = Transition(FOR_NODE, print_loop, TransitionType.EXEC, output=FOR_NODE.getOutput("Loop Body"))

exec_completed = Transition(FOR_NODE, print_finished, TransitionType.EXEC, output=FOR_NODE.getOutput("Completed"))

engine = Engine()

engine.addNode(START)
engine.addNode(FOR_NODE)
engine.addNode(print_loop)
engine.addNode(print_finished)

engine.addTransition(exec_1)
engine.addTransition(exec_loop)
engine.addTransition(exec_completed)

luau_code = engine.generateLuau()
print(luau_code)