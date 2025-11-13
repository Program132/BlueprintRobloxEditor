from src.Engine.Engine import Engine
from src.Nodes.Transition import Transition
from src.Nodes.TransitionType import TransitionType
from src.Nodes.NodeType import NodeType
from src.Nodes.Events.Start import Start
from src.Nodes.Models.Variables.Variable import Variable
from src.Nodes.Models.Print import Print
from src.Nodes.Models.Variables.GET import GET
from src.Nodes.Models.Variables.SET import SET
from src.Nodes.Models.statement.If import If

var_score = Variable("playerScore", 50)

START = Start()
get_score = GET()
get_score.setInputValue("name", "playerScore")

IF_NODE = If()
IF_NODE.setInputValue("condition", "playerScore > 100")

print_win = Print()
print_win.setInputValue("value", "You win!")

print_lose = Print()
print_lose.setInputValue("value", "You lose!")

print_after = Print()
print_after.setInputValue("value", "Fin")



exec_1 = Transition(START, get_score, TransitionType.EXEC)
exec_2 = Transition(get_score, IF_NODE, TransitionType.EXEC)

exec_true = Transition(IF_NODE, print_win, TransitionType.EXEC, output=IF_NODE.getOutput("True"))
exec_false = Transition(IF_NODE, print_lose, TransitionType.EXEC, output=IF_NODE.getOutput("False"))

exec_continue = Transition(IF_NODE, print_after, TransitionType.EXEC, output=IF_NODE.getOutput("Continue"))


engine = Engine()

engine.addVariable(var_score)

engine.addNode(START)
engine.addNode(get_score)
engine.addNode(IF_NODE)
engine.addNode(print_win)
engine.addNode(print_lose)
engine.addNode(print_after)

engine.addTransition(exec_1)
engine.addTransition(exec_2)
engine.addTransition(exec_true)
engine.addTransition(exec_false)
engine.addTransition(exec_continue)

luau_code = engine.generateLuau()
print(luau_code)