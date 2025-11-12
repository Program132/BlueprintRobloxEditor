from urllib import request
from flask import Flask, jsonify, send_from_directory, request
import os
import json
import sys
from pathlib import Path

sys.path.append(str(Path(__file__).parent.parent))

from src.Engine.Engine import Engine
from src.Nodes.Transition import Transition
from src.Nodes.TransitionType import TransitionType
from src.Nodes.Events.Start import Start
from src.Nodes.Models.Print import Print
from src.Nodes.Models.Variables.Variable import Variable
from src.Nodes.Models.Variables.GET import GET
from src.Nodes.Models.Variables.SET import SET
from src.Nodes.Models.math.Absolute import Absolute
from src.Nodes.Models.math.Arcos import Arcos
from src.Nodes.Models.math.Arcsin import Arcsin
from src.Nodes.Models.math.Arctangent import Arctangent
from src.Nodes.Models.math.Addition import Addition
from src.Nodes.Models.math.Subtraction import Subtraction
from src.Nodes.Models.math.Multiplication import Multiplication
from src.Nodes.Models.math.Division import Division
from src.Nodes.Models.math.Ceiling import Ceiling
from src.Nodes.Models.math.Cosinus import Cosinus
from src.Nodes.Models.math.Cosinush import Cosinush
from src.Nodes.Models.math.Degree import Degree
from src.Nodes.Models.math.Exponential import Exponential
from src.Nodes.Models.math.ExtractMantissaExponent import ExtractMantissaExponent
from src.Nodes.Models.math.FloatingPointRemainder import FloatingPointRemainder
from src.Nodes.Models.math.Floor import Floor
from src.Nodes.Models.math.LoadExponent import LoadExponent
from src.Nodes.Models.math.Logarithm import Logarithm
from src.Nodes.Models.math.Logarithm10 import Logarithm10
from src.Nodes.Models.math.Maximum import Maximum
from src.Nodes.Models.math.Minimum import Minimum
from src.Nodes.Models.math.ModuloFractional import ModuloFractional
from src.Nodes.Models.math.PI import PI
from src.Nodes.Models.math.PositiveInfinity import PositiveInfinity
from src.Nodes.Models.math.Power import Power
from src.Nodes.Models.math.Radians import Radians
from src.Nodes.Models.math.RandomSeed import RandomSeed
from src.Nodes.Models.math.Sinus import Sinus
from src.Nodes.Models.math.Sinush import Sinush
from src.Nodes.Models.math.Squareroot import Squareroot
from src.Nodes.Models.math.Tangent import Tangent
from src.Nodes.Models.math.Tangenth import Tangenth




app = Flask(__name__, static_folder='.', static_url_path='')

NODES_DIR = Path(__file__).parent.parent / 'nodes'
SAVE_FILE_PATH = Path(__file__).parent / 'project_save.json'

NODE_CLASS_MAP = {
    "start": Start,
    "print": Print,
    "addition": Addition,
    "subtraction": Subtraction,
    "multiplication": Multiplication,
    "division": Division,
    "variable": Variable,
    "get": GET,
    "set": SET,
    "absolute": Absolute,
    "arcos": Arcos,
    "arcsin": Arcsin,
    "arctangent": Arctangent,
    "ceiling": Ceiling,
    "cosinus": Cosinus,
    "cosinush": Cosinush,
    "degree": Degree,
    "exponential": Exponential,
    "extractmantissaexponent": ExtractMantissaExponent,
    "floatingpointremainder": FloatingPointRemainder,
    "floor": Floor,
    "load_exponent": LoadExponent,
    "logarithm": Logarithm,
    "logarithm10": Logarithm10,
    "maximum": Maximum,
    "minimum": Minimum,
    "modulofractional": ModuloFractional,
    "pi": PI,
    "positiveinfinity": PositiveInfinity,
    "power": Power,
    "radians": Radians,
    "random_seed": RandomSeed,
    "sinus": Sinus,
    "sinush": Sinush,
    "squareroot": Squareroot,
    "tangent": Tangent,
    "tangenth": Tangenth
}



GLOBAL_VARIABLES = {}

NODE_COLORS = {
    "FUNCTION": [0, 255, 0],
    "METHOD": [0, 0, 255],
    "EVENT": [255, 0, 0]
}

@app.route('/')
def serve_index():
    return app.send_static_file('index.html')

@app.route('/js/<path:path>')
def serve_js(path):
    return app.send_static_file(f'js/{path}')

@app.route('/css/<path:path>')
def serve_css(path):
    return app.send_static_file(f'css/{path}')

@app.route('/api/nodes')
def list_nodes():
    nodes = []

    for root, dirs, files in os.walk(NODES_DIR):
        for file in files:
            if file.endswith('.json'):
                file_path = os.path.join(root, file)
                category = os.path.basename(root) if root != NODES_DIR else "CORE"

                try:
                    with open(file_path, 'r') as f:
                        node_data = json.load(f)

                        node_type = node_data.get("type", "METHOD").upper()
                        color = node_data.get("color", NODE_COLORS.get(node_type))

                        nodes.append({
                            "name": os.path.splitext(file)[0],
                            "path": os.path.relpath(file_path, NODES_DIR),
                            "category": category.upper(),
                            "data": node_data,
                            "color": color
                        })
                except Exception as e:

                    print(f"Error reading {file}: {e}")

    return jsonify(nodes)

@app.route('/api/nodes/<path:subpath>')
def get_node(subpath):
    file_path = NODES_DIR / subpath
    if not file_path.exists() or not file_path.is_file():
        return jsonify({"error": "File not found"}), 404

    try:
        with open(file_path, 'r') as f:
            node_data = json.load(f)

            node_type = node_data.get("type", "METHOD").upper()
            node_data["_color"] = NODE_COLORS.get(node_type, [128, 128, 128])

            return jsonify(node_data)
    except Exception as e:
        return jsonify({"error": str(e)}), 500



@app.route('/api/run', methods=['POST'])
def run_luau_code():
    data = request.get_json()
    nodes_data = data.get('nodes', [])
    connections_data = data.get('connections', [])

    engine = Engine()
    node_instances = {}

    for k,v in GLOBAL_VARIABLES.items():
        v = Variable(k,v)
        engine.addVariable(v)

    for n_data in nodes_data:
        node_id = n_data['id']
        node_name_lower = n_data['name'].lower()
        inputs_values = n_data.get('inputs', {})

        NodeClass = NODE_CLASS_MAP.get(node_name_lower)

        if NodeClass:
            node_instance = NodeClass()
            node_instance.id = node_id

            node_instance.setX(n_data.get('x', 0))
            node_instance.setY(n_data.get('y', 0))

            node_instances[node_id] = node_instance
            engine.addNode(node_instance)

            for input_name, input_value in inputs_values.items():
                node_instance.setInputValue(input_name, input_value)
        else:
            return jsonify({"error": f"Node definition for {node_name_lower} not found in map."}), 400

    for c_data in connections_data:
        from_node = node_instances.get(c_data['fromNode'])
        to_node = node_instances.get(c_data['toNode'])

        if not from_node or not to_node:
            return jsonify({"error": "Invalid node ID in connection."}), 400

        transition_type_str = c_data['type'].upper()
        transition_type = TransitionType[transition_type_str]

        output_port = None
        input_port = None

        if transition_type == TransitionType.DATA:
            output_port = from_node.getOutput(c_data['fromPort'])
            input_port = to_node.getInput(c_data['toPort'])

            if not output_port or not input_port:
                return jsonify({"error": f"Data connection error: Port not found or mismatch on nodes {from_node.id} -> {to_node.id}."}), 400

        engine.addTransition(
            Transition(
                from_node,
                to_node,
                transition_type,
                input=input_port,
                output=output_port
            )
        )

    luau_code = engine.generateLuau()

    simulation_output = f"Simulating Luau output (from generated code):\n{luau_code}"

    return jsonify({
        "message": "Code generated and simulated.",
        "luau_code": luau_code,
        "output": ""
    })




@app.route('/api/variables', methods=['POST'])
def add_variable():
    try:
        data = request.get_json()
        variable_name = data.get('name')

        variable_value = data.get('value', 'None')

        if not variable_name:
            return jsonify({"error": "Variable name is required."}), 400
        if variable_name in GLOBAL_VARIABLES:
            return jsonify({
                "message": f"Variable '{variable_name}' already exists.",
                "name": variable_name
            }), 200


        GLOBAL_VARIABLES[variable_name] = variable_value

        print(f"Variable added: {variable_name} = {variable_value}")

        print(f"Current GLOBAL_VARIABLES: {GLOBAL_VARIABLES}")

        return jsonify({
            "success": True,
            "message": f"Variable '{variable_name}' added successfully.",
            "name": variable_name
        }), 201

    except Exception as e:
        print(f"Error adding variable: {e}")
        return jsonify({"error": f"Internal server error: {e}"}), 500

@app.route('/api/variables', methods=['GET'])
def get_variables():
    return jsonify({
        "variables": GLOBAL_VARIABLES
    }), 200

@app.route('/api/variables/<string:variable_name>', methods=['DELETE'])
def delete_variable(variable_name):
    if not variable_name:
        return jsonify({"error": "Variable name is required for deletion."}), 400

    if variable_name in GLOBAL_VARIABLES:
        del GLOBAL_VARIABLES[variable_name]
        print(f"Variable deleted: {variable_name}")
        print(f"Current GLOBAL_VARIABLES: {GLOBAL_VARIABLES}")
        return jsonify({
            "success": True,
            "message": f"Variable '{variable_name}' deleted successfully."
        }), 200
    else:
        return jsonify({
            "success": False,
            "message": f"Variable '{variable_name}' not found."
        }), 404


if __name__ == '__main__':
    # Run the Flask application
    app.run(host='0.0.0.0', port=80, debug=True)