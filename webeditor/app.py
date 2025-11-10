from urllib import request
from flask import Flask, jsonify, send_from_directory, request
import os
import json
from pathlib import Path
import sys

# Add the parent directory to the system path to allow importing local modules (src.Engine, src.Nodes)
sys.path.append(str(Path(__file__).parent.parent))
from src.Engine.Engine import Engine
from src.Nodes.Transition import Transition
from src.Nodes.TransitionType import TransitionType
from src.Nodes.Events.Start import Start
from src.Nodes.Models.Print import Print
from src.Nodes.Models.math.Addition import Addition

# Initialize the Flask application
# Static folder is set to '.' so files are served from the current directory
app = Flask(__name__, static_folder='.', static_url_path='')

# Define paths for node definitions and server save location
NODES_DIR = Path(__file__).parent.parent / 'nodes'
SAVE_FILE_PATH = Path(__file__).parent / 'project_save.json'

# Map node names (used in frontend data) to their corresponding Python class implementations
NODE_CLASS_MAP = {
    "start": Start,
    "print": Print,
    "addition": Addition,
}

# Define colors (RGB list) based on node type/class
NODE_COLORS = {
    "FUNCTION": [0, 255, 0],  # Green for functions
    "METHOD": [0, 0, 255],    # Blue for methods/actions
    "EVENT": [255, 0, 0]      # Red for events (like Start)
}

# --- Static File Serving Routes ---

@app.route('/')
def serve_index():
    """Serves the main index.html file."""
    return app.send_static_file('index.html')

@app.route('/js/<path:path>')
def serve_js(path):
    """Serves JavaScript files from the js/ folder."""
    return app.send_static_file(f'js/{path}')

@app.route('/css/<path:path>')
def serve_css(path):
    """Serves CSS files from the css/ folder."""
    return app.send_static_file(f'css/{path}')

# --- Node Discovery API Routes ---

@app.route('/api/nodes')
def list_nodes():
    """
Scans the NODES_DIR for all .json node definitions and returns them.
Used by the frontend to populate the node palette/library.
    """
    nodes = []

    # Walk through the nodes directory to find all JSON files
    for root, dirs, files in os.walk(NODES_DIR):
        for file in files:
            if file.endswith('.json'):
                file_path = os.path.join(root, file)
                # Determine category based on the subdirectory name
                category = os.path.basename(root) if root != NODES_DIR else "CORE"

                try:
                    with open(file_path, 'r') as f:
                        node_data = json.load(f)

                        # Determine color based on the node's defined type
                        node_type = node_data.get("type", "METHOD").upper()
                        color = node_data.get("color", NODE_COLORS.get(node_type)) # Default grey

                        nodes.append({
                            "name": os.path.splitext(file)[0], # Node name is the file name without extension
                            "path": os.path.relpath(file_path, NODES_DIR), # Relative path for later retrieval
                            "category": category.upper(),
                            "data": node_data,
                            "color": color
                        })
                except Exception as e:
                    # Logs an error if a node definition file cannot be read/parsed
                    print(f"Error reading {file}: {e}")

    return jsonify(nodes)

@app.route('/api/nodes/<path:subpath>')
def get_node(subpath):
    """
Retrieves a specific node definition file based on its relative path (subpath).
    """
    file_path = NODES_DIR / subpath
    if not file_path.exists() or not file_path.is_file():
        return jsonify({"error": "File not found"}), 404

    try:
        with open(file_path, 'r') as f:
            node_data = json.load(f)

            # Add color data to the response before sending to the client
            node_type = node_data.get("type", "METHOD").upper()
            node_data["_color"] = NODE_COLORS.get(node_type, [128, 128, 128])

            return jsonify(node_data)
    except Exception as e:
        return jsonify({"error": str(e)}), 500


# --- Execution and Save API Routes ---

@app.route('/api/run', methods=['POST'])
def run_luau_code():
    """
Receives the node graph data from the frontend, constructs the graph
using Python classes, and generates the final Luau code.
    """
    data = request.get_json()
    nodes_data = data.get('nodes', [])
    connections_data = data.get('connections', [])

    engine = Engine()
    node_instances = {}

    # 1. Instantiate Nodes
    for n_data in nodes_data:
        node_id = n_data['id']
        node_name_lower = n_data['name'].lower()
        inputs_values = n_data.get('inputs', {})

        NodeClass = NODE_CLASS_MAP.get(node_name_lower)

        if NodeClass:
            node_instance = NodeClass()
            node_instance.id = node_id

            # Set position data (useful for layout/debugging)
            node_instance.setX(n_data.get('x', 0))
            node_instance.setY(n_data.get('y', 0))

            node_instances[node_id] = node_instance
            engine.addNode(node_instance)

            # Set static input values configured on the node
            for input_name, input_value in inputs_values.items():
                node_instance.setInputValue(input_name, input_value)
        else:
            return jsonify({"error": f"Node definition for {node_name_lower} not found in map."}), 400

    # 2. Establish Connections (Transitions)
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
            # For DATA transitions, retrieve the specific ports
            output_port = from_node.getOutput(c_data['fromPort'])
            input_port = to_node.getInput(c_data['toPort'])

            if not output_port or not input_port:
                return jsonify({"error": f"Data connection error: Port not found or mismatch on nodes {from_node.id} -> {to_node.id}."}), 400

        # Add the transition to the engine (handles both EXEC and DATA)
        engine.addTransition(
            Transition(
                from_node,
                to_node,
                transition_type,
                input=input_port,
                output=output_port
            )
        )

    # 3. Generate Code
    luau_code = engine.generateLuau()

    # 4. (Simple) Simulation/Output
    simulation_output = "Luau code generated successfully! (Simulation not performed directly by Python)"
    if "print(" in luau_code:
        # Simple placeholder output if the code contains a 'print' statement
        simulation_output = f"Simulating Luau output (from generated code):\n{luau_code}"

    # Return the generated code and a dummy simulation output
    return jsonify({
        "message": "Code generated and simulated.",
        "luau_code": luau_code,
        "output": "" # Currently unused, but keeps the structure intact
    })


@app.route('/api/save', methods=['POST'])
def save_project():
    """
Receives project data (nodes, connections) and saves it to a file
on the server defined by SAVE_FILE_PATH.
    """
    try:
        data = request.get_json()

        # Basic data validation
        if not data or 'nodes' not in data or 'connections' not in data:
            return jsonify({"error": "Invalid project data received."}), 400

        # Write the JSON data to the file
        with open(SAVE_FILE_PATH, 'w') as f:
            # Using indent=4 for a human-readable JSON file
            json.dump(data, f, indent=4)

        print(f"Project saved to {SAVE_FILE_PATH}")

        return jsonify({
            "success": True,
            "message": f"File saved on the server as {SAVE_FILE_PATH.name}"
        })

    except Exception as e:
        print(f"Error during save: {e}")
        return jsonify({"error": f"Internal server error: {e}"}), 500

if __name__ == '__main__':
    # Run the Flask application
    app.run(host='0.0.0.0', port=80, debug=True)