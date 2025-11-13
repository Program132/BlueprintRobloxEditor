from src.Engine.Engine import Engine
from src.Nodes.Transition import Transition
from src.Nodes.TransitionType import TransitionType
from src.Nodes.Events.Start import Start
from src.Nodes.Models.Variables.Variable import Variable
from src.Nodes.Models.Print import Print
from src.Nodes.Models.Variables.SET import SET
from src.Nodes.Models.statement.While import While

var_counter = Variable("counter", 0)

START = Start()

WHILE_NODE = While()
WHILE_NODE.setInputValue("condition", "counter < 3")

print_loop = Print()
print_loop.setInputValue("value", "Looping...")

set_counter = SET()
set_counter.setInputValue("name", "counter")
set_counter.setInputValue("value", "counter + 1")

print_finished = Print()
print_finished.setInputValue("value", "Loop Finished")

exec_1 = Transition(START, WHILE_NODE, TransitionType.EXEC)

exec_loop = Transition(WHILE_NODE, print_loop, TransitionType.EXEC, output=WHILE_NODE.getOutput("True"))
exec_loop_2 = Transition(print_loop, set_counter, TransitionType.EXEC)

exec_completed = Transition(WHILE_NODE, print_finished, TransitionType.EXEC, output=WHILE_NODE.getOutput("Continue"))

engine = Engine()

engine.addVariable(var_counter)

engine.addNode(START)
engine.addNode(WHILE_NODE)
engine.addNode(print_loop)
engine.addNode(set_counter)
engine.addNode(print_finished)

engine.addTransition(exec_1)
engine.addTransition(exec_loop)
engine.addTransition(exec_loop_2)
engine.addTransition(exec_completed)

luau_code = engine.generateLuau()
print(luau_code)