import importlib
import inspect
from urllib import request
from flask import Flask, jsonify, request
import os
import json
from pathlib import Path

from src.Engine import Engine
from src.Graph import Graph
from src.Node import Node
from src.Variable import Variable

NODE_CLASS_MAP = {}

base_dir = os.path.join(os.path.dirname(__file__), 'src')

for root, dirs, files in os.walk(base_dir):
    for file in files:
        if file.endswith('.py') and file != '__init__.py':
            rel_path = os.path.relpath(os.path.join(root, file), os.path.dirname(__file__))
            module_path = rel_path.replace(os.path.sep, '.')[:-3]

            try:
                module = importlib.import_module(module_path)
                for name, obj in inspect.getmembers(module, inspect.isclass):
                    if issubclass(obj, Node) and obj is not Node and obj.__module__ == module.__name__:
                        NODE_CLASS_MAP[name.lower()] = obj
            except Exception:
                continue

GLOBAL_VARIABLES = {}
GLOBAL_FUNCTIONS = {}
NODE_COLORS = {
    "FUNCTION": [0, 255, 0],
    "METHOD": [0, 0, 255],
    "EVENT": [255, 0, 0]
}

app = Flask(__name__, static_folder='.', static_url_path='')

@app.route('/')
def serve_index():
    return app.send_static_file('index.html')


@app.route('/js/<path:path>')
def serve_js(path):
    return app.send_static_file(f'js/{path}')


@app.route('/css/<path:path>')
def serve_css(path):
    return app.send_static_file(f'css/{path}')


@app.route('/api/nodes', methods=['GET'])
def get_node_definitions():
    nodes_dir = os.path.join(Path(__file__).parent, 'nodes')
    definitions = []
    for root, _, files in os.walk(nodes_dir):
        for file in files:
            if file.endswith('.json'):
                file_path = os.path.join(root, file)
                try:
                    with open(file_path, 'r') as f:
                        data = json.load(f)
                        relative_path = os.path.relpath(root, nodes_dir)
                        category = relative_path if relative_path != '.' else "General"

                        node_type = data.get("type", "METHOD").upper()
                        color = data.get("color", NODE_COLORS.get(node_type))

                        file_name_without_ext = os.path.splitext(file)[0]
                        default_node_name = file_name_without_ext.capitalize()

                        definitions.append({
                            "name": file_name_without_ext,
                            "category": category.replace(os.path.sep, '/').capitalize(),
                            "color": color,
                            "data": data,
                            "type": node_type
                        })
                except Exception as e:
                    print(f"Erreur de chargement du JSON {file_path}: {e}")

    return jsonify(definitions)


@app.route('/api/run', methods=['POST'])
def run_code():
    try:
        data = request.get_json()
        nodes_data = data.get('nodes', [])
        connections_data = data.get('connections', [])
        variables_data = data.get('variables', {})
        custom_functions = data.get('customFunctions', [])  # NEW: Get custom functions

        engine = Engine()
        
        # Store custom functions in GLOBAL_FUNCTIONS for access during node creation
        for func in custom_functions:
            GLOBAL_FUNCTIONS[func['name']] = func

        for k, v in GLOBAL_VARIABLES.items():
            engine.variables.append(Variable(k, v))

        graph = Graph()

        node_instances = {}

        for n_data in nodes_data:
            node_id = n_data.get('id')
            node_key = n_data.get('name', '').lower()

            # Check if this is a function call node
            if node_key.startswith('call_'):
                func_name = node_key.replace('call_', '')
                # Look for function in GLOBAL_FUNCTIONS
                if func_name in GLOBAL_FUNCTIONS:
                    from src.models.statement.FunctionCallNode import FunctionCallNode
                    func_def = GLOBAL_FUNCTIONS[func_name]
                    node_instance = FunctionCallNode(
                        func_name,
                        func_def.get('inputs', []),
                        func_def.get('outputs', [])
                    )
                    node_instance.id = node_id
                    node_instance.engine = engine
                    
                    inputs = n_data.get('inputs', {})
                    for input_name, input_value in inputs.items():
                        node_instance.setInputValue(input_name, input_value)
                    
                    graph.add_node(node_instance)
                    node_instances[node_id] = node_instance
                else:
                    print(f"Attention: Fonction '{func_name}' introuvable")
            elif node_key in NODE_CLASS_MAP:
                node_instance = NODE_CLASS_MAP[node_key]()
                node_instance.id = node_id
                node_instance.engine = engine

                inputs = n_data.get('inputs', {})
                for input_name, input_value in inputs.items():
                    node_instance.setInputValue(input_name, input_value)

                graph.add_node(node_instance)
                node_instances[node_id] = node_instance
            else:
                print(f"Attention: Définition de nœud introuvable pour '{node_key}'")

        for c_data in connections_data:
            from_id = c_data.get('fromNode')
            to_id = c_data.get('toNode')

            from_node = node_instances.get(from_id)
            to_node = node_instances.get(to_id)

            if from_node and to_node:
                from_port = c_data.get('fromPort')
                to_port = c_data.get('toPort')
                conn_type = c_data.get('type', 'exec').lower()

                if conn_type == 'exec':
                    graph.connect_exec(from_node, to_node, from_port)
                else:
                    graph.connect_data(from_node, to_node, from_port, to_port)

        engine.add_graph(graph)
        
        # NEW: Generate custom functions code
        from src.FunctionGenerator import FunctionGenerator
        func_generator = FunctionGenerator(engine)
        functions_code = func_generator.generate_all_functions(custom_functions)

        # Generate main graph code
        main_code = engine.run()
        
        # Combine functions and main code
        if functions_code:
            luau_code = functions_code + "\n\n" + main_code
        else:
            luau_code = main_code
        simulation_output = "Simulation not implemented on the server side."

        return jsonify({
            "luau_code": luau_code,
            "output": simulation_output
        })

    except Exception as e:
        import traceback
        print("Erreur d'exécution du code :", e)
        traceback.print_exc()
        return jsonify({
            "error": str(e),
            "code": "print('--- ERROR ---')",
            "output": f"Error: {e}"
        }), 500


@app.route('/api/variables', methods=['POST'])
def add_variable():
    try:
        data = request.get_json()
        variable_name = data.get('name')
        variable_value = data.get('value')

        if not variable_name:
            return jsonify({"error": "Variable name is required"}), 400

        if variable_name in GLOBAL_VARIABLES:
            GLOBAL_VARIABLES[variable_name] = variable_value
            print(f"Variable updated: {variable_name} = {variable_value}")
            return jsonify({
                "success": True,
                "message": f"Variable '{variable_name}' updated successfully.",
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


# --- CUSTOM FUNCTIONS API ENDPOINTS ---

@app.route('/api/functions', methods=['POST'])
def add_function():
    try:
        data = request.get_json()
        function_name = data.get('name')
        function_id = data.get('id')
        
        if not function_name:
            return jsonify({"error": "Function name is required"}), 400
        
        GLOBAL_FUNCTIONS[function_name] = {
            'id': function_id,
            'name': function_name,
            'inputs': data.get('inputs', []),
            'outputs': data.get('outputs', []),
            'nodes': data.get('nodes', []),
            'connections': data.get('connections', []),
            'hasReturnNode': data.get('hasReturnNode', False)
        }
        
        print(f"Function added: {function_name}")
        print(f"Current GLOBAL_FUNCTIONS: {list(GLOBAL_FUNCTIONS.keys())}")
        
        return jsonify({
            "success": True,
            "message": f"Function '{function_name}' added successfully.",
            "name": function_name
        }), 201
        
    except Exception as e:
        print(f"Error adding function: {e}")
        return jsonify({"error": f"Internal server error: {e}"}), 500


@app.route('/api/functions', methods=['GET'])
def get_functions():
    return jsonify({
        "functions": GLOBAL_FUNCTIONS
    }), 200


@app.route('/api/functions/<string:function_name>', methods=['PUT'])
def update_function(function_name):
    try:
        data = request.get_json()
        
        if function_name not in GLOBAL_FUNCTIONS:
            return jsonify({"error": "Function not found"}), 404
        
        GLOBAL_FUNCTIONS[function_name] = {
            'id': data.get('id'),
            'name': data.get('name', function_name),
            'inputs': data.get('inputs', []),
            'outputs': data.get('outputs', []),
            'nodes': data.get('nodes', []),
            'connections': data.get('connections', []),
            'hasReturnNode': data.get('hasReturnNode', False)
        }
        
        print(f"Function updated: {function_name}")
        
        return jsonify({
            "success": True,
            "message": f"Function '{function_name}' updated successfully."
        }), 200
        
    except Exception as e:
        print(f"Error updating function: {e}")
        return jsonify({"error": f"Internal server error: {e}"}), 500


@app.route('/api/functions/<string:function_name>', methods=['DELETE'])
def delete_function(function_name):
    if not function_name:
        return jsonify({"error": "Function name is required for deletion."}), 400
    
    if function_name in GLOBAL_FUNCTIONS:
        del GLOBAL_FUNCTIONS[function_name]
        print(f"Function deleted: {function_name}")
        print(f"Current GLOBAL_FUNCTIONS: {list(GLOBAL_FUNCTIONS.keys())}")
        return jsonify({
            "success": True,
            "message": f"Function '{function_name}' deleted successfully."
        }), 200
    else:
        return jsonify({
            "success": False,
            "message": f"Function '{function_name}' not found."
        }), 404


if __name__ == '__main__':
    app.run(debug=True, port=80, host='0.0.0.0')