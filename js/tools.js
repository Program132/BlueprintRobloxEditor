const runCodeBtn = document.getElementById('run-code-btn');
const saveCodeBtn = document.getElementById('save-code-btn');
const loadCodeBtn = document.getElementById('load-code-btn');

const resultModal = document.getElementById('result-modal');
const luauCodeOutput = document.getElementById('luau-code-output');
const simulationOutput = document.getElementById('simulation-output');
const modalCloseBtn = resultModal ? resultModal.querySelector('.modal-close-btn') : null;

// --- Modal functions ---
function openResultModal(luauCode, output) {
    if (!resultModal) return;
    luauCodeOutput.textContent = luauCode;
    simulationOutput.textContent = output;
    resultModal.classList.add('open');
}

function closeResultModal() {
    if (!resultModal) return;
    resultModal.classList.remove('open');
}

if (modalCloseBtn) {
    modalCloseBtn.addEventListener('click', closeResultModal);
}

if (resultModal) {
    resultModal.addEventListener('click', (e) => {
        if (e.target === resultModal) closeResultModal();
    });
}

// --- 🔍 New function to collect data ---
function collectEditorData() {
    const nodesData = [];
    document.querySelectorAll('.editor-node').forEach(nodeEl => {
        const nodeId = nodeEl.dataset.nodeId;
        const nodeType = nodeEl.dataset.nodeType;
        const nodeClass = nodeEl.dataset.nodeClass;
        const nodeX = parseFloat(nodeEl.style.left);
        const nodeY = parseFloat(nodeEl.style.top);

        const inputs = {};
        nodeEl.querySelectorAll('.node-input-value').forEach(inputField => {
            const portId = inputField.dataset.portId;
            // Only collect values for inputs that are NOT connected (and thus, not disabled)
            if (!inputField.classList.contains('input-disabled-by-connection')) {
                inputs[portId] = inputField.value;
            }
        });

        // For dynamic function nodes, save the full definition
        const nodeData = {
            id: nodeId,
            name: nodeType,
            type: nodeClass,
            x: nodeX,
            y: nodeY,
            inputs: inputs
        };

        // Check if this is a dynamic function node and save its definition
        if (nodeEl.dataset.isDynamicNode === 'true' && nodeEl.dataset.nodeDef) {
            try {
                nodeData.dynamicDefinition = JSON.parse(nodeEl.dataset.nodeDef);
            } catch (e) {
                console.warn('Failed to parse dynamic node definition:', e);
            }
        }

        nodesData.push(nodeData);
    });

    const connectionsData = (window.connections || []).map(conn => ({
        fromNode: conn.fromNode,
        fromPort: conn.fromPort,
        toNode: conn.toNode,
        toPort: conn.toPort,
        type: conn.type
    }));

    // Note: Variables are global, so we don't strictly need them here for a single graph save,
    // but for the project save we will fetch them.

    return { nodes: nodesData, connections: connectionsData };
}

// --- 🚀 Execution Button ---
if (runCodeBtn) {
    runCodeBtn.addEventListener('click', async () => {
        console.log("--- Starting Execution ---");

        // For execution, we might want to send ALL scripts or just the active one?
        // Usually execution is on the current graph.
        // If the backend supports multiple graphs, we should send all.
        // But for now, let's send the current graph as before, 
        // OR if the user wants to run the whole project, we might need to change the backend.
        // Assuming for now we run the CURRENT script.

        const editorData = collectEditorData();
        const variablesData = window.getVariablesData ? window.getVariablesData() : {};
        const customFunctions = window.getFunctionsData ? window.getFunctionsData() : [];

        const payload = {
            nodes: editorData.nodes,
            connections: editorData.connections,
            variables: variablesData,
            customFunctions: customFunctions  // NEW: Send custom functions
        };

        try {
            const response = await fetch('/api/run', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify(payload),
            });

            if (!response.ok) {
                const errorText = await response.text();
                throw new Error(`Server error: ${response.status} - ${errorText}`);
            }

            const result = await response.json();
            openResultModal(result.luau_code, result.output);

        } catch (error) {
            console.error("Error during execution:", error);
        }

        console.log("--- Execution Finished ---");
    });
}


if (saveCodeBtn) {
    saveCodeBtn.addEventListener('click', async () => {
        console.log("--- Starting Save ---");

        // 1. Save the state of the CURRENT script into window.scripts
        if (window.saveCurrentScriptState) {
            window.saveCurrentScriptState();
        }

        // 2. Collect global variables
        const variablesData = window.getVariablesData ? window.getVariablesData() : {};

        // 2.5. Collect custom functions
        const functionsData = window.getFunctionsData ? window.getFunctionsData() : [];

        // 3. Construct the full project object
        const projectData = {
            version: "2.0", // Marker for new format
            scripts: window.scripts || [],
            activeScriptId: window.activeScriptId,
            variables: variablesData,
            customFunctions: functionsData
        };

        try {
            const jsonString = JSON.stringify(projectData, null, 4);
            const blob = new Blob([jsonString], { type: "application/json" });
            const url = URL.createObjectURL(blob);
            const a = document.createElement("a");
            a.href = url;
            const defaultFileName = prompt("Enter the save file name:", "my_project_v2.json") || "my_project_v2.json";
            a.download = defaultFileName;
            a.click();
            URL.revokeObjectURL(url);
            console.log("✅ Project saved locally as:", defaultFileName);
            alert(`Project saved as "${defaultFileName}"`);
        } catch (error) {
            console.error("❌ Error during save:", error);
            alert("Error saving the project: " + error.message);
        }

        console.log("--- Save Finished ---");
    });
}


if (loadCodeBtn) {
    loadCodeBtn.addEventListener('click', async () => {
        console.log("--- Starting Load ---");

        const input = document.createElement('input');
        input.type = 'file';
        input.accept = '.json';
        input.style.display = 'none';

        input.addEventListener('change', async (event) => {
            const file = event.target.files[0];
            if (!file) return;

            try {
                const text = await file.text();
                const data = JSON.parse(text);

                console.log("✅ Loaded data:", data);

                // Check format
                if (data.scripts && Array.isArray(data.scripts)) {
                    // --- NEW FORMAT ---
                    console.log("New format detected.");

                    // CRITICAL FIX: Reset activeScriptId to null to prevent 'switchToScript' 
                    // from saving the CURRENT (stale) editor state into the NEWLY loaded scripts.
                    window.activeScriptId = null;

                    window.scripts = data.scripts;

                    // Restore variables
                    if (data.variables && window.loadVariablesData) {
                        await window.loadVariablesData(data.variables);
                    }

                    // Restore custom functions
                    if (data.customFunctions && window.loadFunctionsData) {
                        await window.loadFunctionsData(data.customFunctions);
                    }

                    // Determine target script
                    let targetId = null;
                    if (data.activeScriptId && window.scripts.find(s => s.id === data.activeScriptId)) {
                        targetId = data.activeScriptId;
                    } else if (window.scripts.length > 0) {
                        targetId = window.scripts[0].id;
                    }

                    // Refresh UI list
                    if (window.renderScriptsList) {
                        window.renderScriptsList();
                    }

                    // Switch to target script
                    if (targetId) {
                        window.switchToScript(targetId);
                    }

                } else {
                    // --- OLD FORMAT (Backward Compatibility) ---
                    console.log("⚠️ Old format detected. Converting to new format...");

                    const importedScript = {
                        id: "script-" + Date.now(),
                        name: "Imported Script",
                        nodes: data.nodes || [],
                        connections: data.connections || []
                    };

                    window.scripts = [importedScript];
                    window.activeScriptId = importedScript.id;

                    // Restore variables
                    if (data.variables && window.loadVariablesData) {
                        await window.loadVariablesData(data.variables);
                    }

                    // Refresh UI list
                    if (window.renderScriptsList) {
                        window.renderScriptsList();
                    }

                    // Load into editor
                    window.switchToScript(importedScript.id);
                }

                alert(`Project "${file.name}" loaded successfully!`);
            } catch (error) {
                console.error("❌ Error during load:", error);
                alert("Error loading the project: " + error.message);
            }
        });

        input.click();
    });
}

// Global function to load a specific graph (nodes + connections) into the editor
// This is used by scripts_manager.js when switching scripts.
window.loadGraphIntoEditor = async function (nodes, connections) {
    const editorContent = document.getElementById('editor-content');
    editorContent.innerHTML = '';

    // 1. Clear existing nodes and connections
    document.querySelectorAll('.editor-node').forEach(el => el.remove());
    window.connections = [];
    if (window.redrawAllConnections) window.redrawAllConnections();

    // 2. Check definitions
    if (typeof nodeDefinitions === 'undefined' || Object.keys(nodeDefinitions).length === 0) {
        console.error("❌ Cannot load graph: node definitions are not ready.");
        return;
    }

    // 3. Recreate nodes
    if (Array.isArray(nodes)) {
        nodes.forEach(node => {
            let nodeDef = null;

            // First check if this is a dynamic node with saved definition
            if (node.dynamicDefinition) {
                nodeDef = node.dynamicDefinition;
                console.log('Using saved dynamic definition for:', node.name);
            } else {
                // Search in standard node definitions
                for (const category in nodeDefinitions) {
                    const found = nodeDefinitions[category].find(n => n.name === node.name);
                    if (found) {
                        nodeDef = found;
                        break;
                    }
                }
            }

            if (!nodeDef) {
                console.warn(`⚠️ Definition for node "${node.name}" not found.`);
                return;
            }

            createNodeElement(nodeDef, editorContent, node.x, node.y);

            const createdNode = editorContent.lastElementChild;
            if (!createdNode) return;

            createdNode.dataset.nodeId = node.id;
            createdNode.querySelectorAll('.input-circle, .output-circle, .node-input-value, .exec-port').forEach(portEl => {
                portEl.dataset.nodeId = node.id;
            });

            for (const [inputName, value] of Object.entries(node.inputs || {})) {
                const inputField = createdNode.querySelector(`.node-input-value[data-port-id="${inputName}"]`);
                if (inputField && !inputField.classList.contains('input-disabled-by-connection')) {
                    inputField.value = value;
                }
            }
        });
    }

    // 4. Restore connections
    if (Array.isArray(connections)) {
        connections.forEach(conn => {
            window.connections.push({
                type: conn.type,
                fromNode: conn.fromNode,
                fromPort: conn.fromPort,
                toNode: conn.toNode,
                toPort: conn.toPort
            });
        });
        if (window.redrawAllConnections) window.redrawAllConnections();
    }

    console.log("✅ Graph loaded into editor.");
};