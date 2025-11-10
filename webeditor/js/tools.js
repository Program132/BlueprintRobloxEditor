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

        nodesData.push({
            id: nodeId,
            name: nodeType,
            type: nodeClass,
            x: nodeX,
            y: nodeY,
            inputs: inputs
        });

        console.log(nodesData)
    });

    const connectionsData = (window.connections || []).map(conn => ({
        fromNode: conn.fromNode,
        fromPort: conn.fromPort,
        toNode: conn.toNode,
        toPort: conn.toPort,
        type: conn.type
    }));

    const variablesData = window.getVariablesData ? window.getVariablesData() : [];

    console.log(variablesData);

    return { nodes: nodesData, connections: connectionsData, variables:variablesData };
}

// --- 🚀 Execution Button ---
if (runCodeBtn) {
    runCodeBtn.addEventListener('click', async () => {
        console.log("--- Starting Execution ---");

        // 🧩 We retrieve the data via the new function
        const payload = collectEditorData();

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
            // You can also display a visual alert here
        }

        console.log("--- Execution Finished ---");
    });
}


if (saveCodeBtn) {
    saveCodeBtn.addEventListener('click', async () => {
        console.log("--- Starting Save ---");

        const payload = collectEditorData();

        try {
            // Convert data into readable JSON text
            const jsonString = JSON.stringify(payload, null, 4);

            // Create a Blob object for download
            const blob = new Blob([jsonString], { type: "application/json" });

            // Create a temporary URL
            const url = URL.createObjectURL(blob);

            // Create an invisible download link
            const a = document.createElement("a");
            a.href = url;

            // 💡 Suggest a default file name
            const defaultFileName = prompt("Enter the save file name:", "my_project.json") || "my_project.json";
            a.download = defaultFileName;

            // Trigger the download
            a.click();

            // Release the temporary URL
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

        // Creates an invisible input type="file"
        const input = document.createElement('input');
        input.type = 'file';
        input.accept = '.json'; // JSON files only
        input.style.display = 'none';

        input.addEventListener('change', async (event) => {
            const file = event.target.files[0];
            if (!file) return;

            try {
                // Read the local file content
                const text = await file.text();
                const data = JSON.parse(text);

                console.log("✅ Loaded project data:", data);

                // Here you can inject the data into your editor:
                // - recreate the nodes
                // - recreate the connections
                // Example:
                await window.nodeDefinitionsReady;
                loadProjectIntoEditor(data);

                alert(`Project "${file.name}" loaded successfully!`);
            } catch (error) {
                console.error("❌ Error during load:", error);
                alert("Error loading the project: " + error.message);
            }
        });

        // Trigger the file selector
        input.click();
    });
}


async function loadProjectIntoEditor(data) {
    const editorContent = document.getElementById('editor-content');
    editorContent.innerHTML = '';

    // 🔹 1. Clear the existing editor
    document.querySelectorAll('.editor-node').forEach(el => el.remove());
    window.connections = [];
    if (window.redrawAllConnections) window.redrawAllConnections();

    // 🔹 2. Check that nodeDefinitions is available
    if (typeof nodeDefinitions === 'undefined' || Object.keys(nodeDefinitions).length === 0) {
        console.error("❌ Cannot load project: node definitions are not ready yet.");
        alert("Node definitions are not loaded yet. Try again in a few seconds.");
        return;
    }

    // 🔹 3. Recreate the nodes
    data.nodes.forEach(node => {
        // Find the corresponding definition in nodeDefinitions
        let nodeDef = null;
        for (const category in nodeDefinitions) {
            const found = nodeDefinitions[category].find(n => n.name === node.name);
            if (found) {
                nodeDef = found;
                break;
            }
        }

        if (!nodeDef) {
            console.warn(`⚠️ Definition for node "${node.name}" not found, it will be skipped.`);
            return;
        }

        // Create the node at the correct position
        createNodeElement(nodeDef, editorContent, node.x, node.y);

        // Get the newly created node
        const createdNode = editorContent.lastElementChild;
        if (!createdNode) return;

        // Force the node ID (to restore connections)
        createdNode.dataset.nodeId = node.id;
        createdNode.querySelectorAll('.input-circle, .output-circle, .node-input-value, .exec-port').forEach(portEl => {
            portEl.dataset.nodeId = node.id;
        });

        // Reload input values
        for (const [inputName, value] of Object.entries(node.inputs || {})) {
            const inputField = createdNode.querySelector(`.node-input-value[data-port-id="${inputName}"]`);
            if (inputField && !inputField.classList.contains('input-disabled-by-connection')) {
                inputField.value = value;
            }
        }
    });

    if (Array.isArray(data.variables) && window.loadVariablesData) {
        await window.loadVariablesData(data.variables);
        console.log("Variables restored.");
    } else {
        if (window.loadVariablesData) await window.loadVariablesData([]);
    }

    // 🔹 4. Restore connections
    if (Array.isArray(data.connections)) {
        data.connections.forEach(conn => {
            // Note: The structure of the connection object must match the one expected by window.redrawAllConnections()
            window.connections.push({
                type: conn.type,
                fromNode: conn.fromNode,
                fromPort: conn.fromPort,
                toNode: conn.toNode,
                toPort: conn.toPort
            });
        });

        // Redraw cables
        if (window.redrawAllConnections) window.redrawAllConnections();
    }

    console.log("✅ Project loaded successfully:", data);
}