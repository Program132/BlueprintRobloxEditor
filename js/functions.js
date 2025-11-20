// Global storage for custom functions
window.customFunctions = [];
window.activeFunctionId = null;
window.currentGraphType = 'main'; // 'main' or 'function'

// Function modal reference
let functionModal = null;
let isEditMode = false;
let editingFunctionId = null;

document.addEventListener('DOMContentLoaded', function () {
    createFunctionModal();

    const functionsButton = document.getElementById('functions');
    if (functionsButton) {
        functionsButton.addEventListener('click', () => openFunctionModal());
    }
});

// Create the function modal HTML
function createFunctionModal() {
    const modalHTML = `
        <div id="function-modal" class="function-modal">
            <div class="function-modal-content">
                <div class="function-modal-header">
                    <h2 id="function-modal-title">Create Function</h2>
                    <button class="function-modal-close">&times;</button>
                </div>
                <div class="function-modal-body">
                    <div class="function-form-group">
                        <label for="function-name-input">Function Name</label>
                        <input type="text" id="function-name-input" placeholder="Enter function name">
                    </div>
                    
                    <div class="function-params-section">
                        <div class="function-params-header">
                            <h3>Inputs</h3>
                            <button class="btn-add-param" id="btn-add-input">+ Add Input</button>
                        </div>
                        <div class="function-params-list" id="function-inputs-list"></div>
                    </div>
                    
                    <div class="function-params-section">
                        <div class="function-params-header">
                            <h3>Outputs</h3>
                            <button class="btn-add-param" id="btn-add-output">+ Add Output</button>
                        </div>
                        <div class="function-params-list" id="function-outputs-list"></div>
                    </div>
                </div>
                <div class="function-modal-footer">
                    <button class="btn-function-cancel">Cancel</button>
                    <button class="btn-function-save">Save</button>
                </div>
            </div>
        </div>
    `;

    document.body.insertAdjacentHTML('beforeend', modalHTML);
    functionModal = document.getElementById('function-modal');

    // Event listeners
    functionModal.querySelector('.function-modal-close').addEventListener('click', closeFunctionModal);
    functionModal.querySelector('.btn-function-cancel').addEventListener('click', closeFunctionModal);
    functionModal.querySelector('.btn-function-save').addEventListener('click', saveFunctionFromModal);
    functionModal.querySelector('#btn-add-input').addEventListener('click', () => addParameterField('input'));
    functionModal.querySelector('#btn-add-output').addEventListener('click', () => addParameterField('output'));

    // Close on outside click
    functionModal.addEventListener('click', (e) => {
        if (e.target === functionModal) closeFunctionModal();
    });
}

// Open function modal for creating or editing
function openFunctionModal(functionId = null) {
    isEditMode = !!functionId;
    editingFunctionId = functionId;

    const titleEl = document.getElementById('function-modal-title');
    const nameInput = document.getElementById('function-name-input');
    const inputsList = document.getElementById('function-inputs-list');
    const outputsList = document.getElementById('function-outputs-list');

    // Clear previous data
    nameInput.value = '';
    inputsList.innerHTML = '';
    outputsList.innerHTML = '';

    if (isEditMode) {
        const func = window.customFunctions.find(f => f.id === functionId);
        if (!func) return;

        titleEl.textContent = 'Edit Function';
        nameInput.value = func.name;

        func.inputs.forEach(input => {
            addParameterField('input', input);
        });

        func.outputs.forEach(output => {
            addParameterField('output', output);
        });
    } else {
        titleEl.textContent = 'Create Function';
    }

    functionModal.classList.add('open');
}

function closeFunctionModal() {
    functionModal.classList.remove('open');
    isEditMode = false;
    editingFunctionId = null;
}

// Add a parameter field (input or output)
function addParameterField(type, value = '') {
    const listId = type === 'input' ? 'function-inputs-list' : 'function-outputs-list';
    const list = document.getElementById(listId);

    const paramItem = document.createElement('div');
    paramItem.className = 'function-param-item';
    paramItem.innerHTML = `
        <input type="text" placeholder="${type === 'input' ? 'Input' : 'Output'} name" value="${value}">
        <button class="btn-remove-param">X</button>
    `;

    paramItem.querySelector('.btn-remove-param').addEventListener('click', () => {
        paramItem.remove();
    });

    list.appendChild(paramItem);
}

// Save function from modal
async function saveFunctionFromModal() {
    const nameInput = document.getElementById('function-name-input');
    const name = nameInput.value.trim();

    if (!name) {
        alert('Please enter a function name');
        return;
    }

    // Collect inputs
    const inputs = [];
    document.querySelectorAll('#function-inputs-list .function-param-item input').forEach(input => {
        const val = input.value.trim();
        if (val) inputs.push(val);
    });

    // Collect outputs
    const outputs = [];
    document.querySelectorAll('#function-outputs-list .function-param-item input').forEach(input => {
        const val = input.value.trim();
        if (val) outputs.push(val);
    });

    if (isEditMode) {
        // Update existing function
        await updateFunction(editingFunctionId, name, inputs, outputs);
    } else {
        // Create new function
        await createNewFunction(name, inputs, outputs);
    }

    closeFunctionModal();
}

// Create a new function
async function createNewFunction(name, inputs, outputs) {
    const id = 'function-' + Date.now();

    const newFunction = {
        id: id,
        name: name,
        inputs: inputs,
        outputs: outputs,
        nodes: [],
        connections: [],
        hasReturnNode: false // Will be updated when editing the function graph
    };

    window.customFunctions.push(newFunction);

    // Add to backend
    await addFunctionToBackend(newFunction);

    // Render in UI
    renderFunctionsList();

    // Automatically open the function graph for editing
    switchToFunctionGraph(id);
}

// Update an existing function
async function updateFunction(functionId, name, inputs, outputs) {
    const func = window.customFunctions.find(f => f.id === functionId);
    if (!func) return;

    func.name = name;
    func.inputs = inputs;
    func.outputs = outputs;

    // Update backend
    await updateFunctionInBackend(func);

    // Update all call nodes in all graphs
    updateAllFunctionCallNodes(func);

    // Re-render UI
    renderFunctionsList();
}

// Delete a function
async function deleteFunction(functionId) {
    const func = window.customFunctions.find(f => f.id === functionId);
    if (!func) return;

    if (!confirm(`Delete function "${func.name}"? All call nodes will be removed.`)) {
        return;
    }

    // Remove from backend
    await deleteFunctionFromBackend(func.name);

    // Remove all call nodes from all graphs
    removeAllFunctionCallNodes(func.name);

    // Remove from array
    window.customFunctions = window.customFunctions.filter(f => f.id !== functionId);

    // If we're currently editing this function, switch back to main
    if (window.activeFunctionId === functionId) {
        switchBackToMainGraph();
    }

    renderFunctionsList();
}

// Render the functions list in the explorer
function renderFunctionsList() {
    const container = document.getElementById('functions-content');
    if (!container) return;

    container.innerHTML = '';

    window.customFunctions.forEach(func => {
        const item = document.createElement('div');
        item.className = 'function-item';

        if (window.activeFunctionId === func.id) {
            item.classList.add('active');
        }

        item.innerHTML = `
            <span class="function-item-name">${func.name}</span>
            <div class="function-item-actions">
                <button class="btn-edit-function" data-id="${func.id}">Edit</button>
                <button class="btn-del-function" data-id="${func.id}">X</button>
            </div>
        `;

        // Click on item to open function graph
        item.addEventListener('click', (e) => {
            if (!e.target.classList.contains('btn-edit-function') &&
                !e.target.classList.contains('btn-del-function')) {
                switchToFunctionGraph(func.id);
            }
        });

        // Edit button
        item.querySelector('.btn-edit-function').addEventListener('click', (e) => {
            e.stopPropagation();
            openFunctionModal(func.id);
        });

        // Delete button
        item.querySelector('.btn-del-function').addEventListener('click', (e) => {
            e.stopPropagation();
            deleteFunction(func.id);
        });

        container.appendChild(item);
    });
}

// Switch to function graph editing
function switchToFunctionGraph(functionId) {
    const func = window.customFunctions.find(f => f.id === functionId);
    if (!func) return;

    // Save current state
    if (window.currentGraphType === 'main' && window.saveCurrentScriptState) {
        window.saveCurrentScriptState();
    } else if (window.currentGraphType === 'function' && window.activeFunctionId) {
        saveFunctionGraphState();
    }

    // Switch to function mode
    window.currentGraphType = 'function';
    window.activeFunctionId = functionId;

    // Load function graph
    if (window.loadGraphIntoEditor) {
        // Check if function graph is empty (first time opening)
        if (!func.nodes || func.nodes.length === 0) {
            // Auto-create Function Start and Return nodes
            const functionStartNode = {
                id: 'node-' + Date.now(),
                name: 'function_start',
                type: 'EVENT',
                x: 100,
                y: 100,
                inputs: {},
                dynamicDefinition: generateFunctionStartNode()
            };

            const returnNode = {
                id: 'node-' + (Date.now() + 1),
                name: 'return',
                type: 'METHOD',
                x: 400,
                y: 100,
                inputs: {},
                dynamicDefinition: generateReturnNode()
            };

            func.nodes = [functionStartNode, returnNode];
            func.connections = [];
        }

        window.loadGraphIntoEditor(func.nodes, func.connections);
    }

    renderFunctionsList();

    // Update scripts list to show we're in function mode
    if (window.renderScriptsList) {
        window.renderScriptsList();
    }
}

// Switch back to main graph
function switchBackToMainGraph() {
    // Save function graph state
    if (window.activeFunctionId) {
        saveFunctionGraphState();
    }

    window.currentGraphType = 'main';
    window.activeFunctionId = null;

    // Switch back to active script
    if (window.activeScriptId && window.switchToScript) {
        window.switchToScript(window.activeScriptId);
    }

    renderFunctionsList();
}

// Save current function graph state
function saveFunctionGraphState() {
    if (!window.activeFunctionId) return;

    const func = window.customFunctions.find(f => f.id === window.activeFunctionId);
    if (!func) return;

    if (typeof collectEditorData === 'function') {
        const data = collectEditorData();
        func.nodes = data.nodes;
        func.connections = data.connections;

        // Check if there's a Return node
        func.hasReturnNode = data.nodes.some(node => node.name.toLowerCase() === 'return');
    }
}

// Generate dynamic Function Start node for current function
function generateFunctionStartNode() {
    if (!window.activeFunctionId) return null;

    const func = window.customFunctions.find(f => f.id === window.activeFunctionId);
    if (!func) return null;

    // Create outputs based on function inputs
    const outputs = [...func.inputs];

    return {
        name: 'function_start',
        title: 'Function Start',
        type: 'EVENT',  // EVENT type has exec OUTPUT (triangle on right)
        color: [100, 200, 100],
        inputs: {},
        outputs: outputs,
        description: `Entry point for function ${func.name}`,
        isFunctionStart: true
    };
}

// Generate dynamic Return node for current function
function generateReturnNode() {
    if (!window.activeFunctionId) return null;

    const func = window.customFunctions.find(f => f.id === window.activeFunctionId);
    if (!func) return null;

    // Create inputs based on function outputs
    const inputs = {};
    func.outputs.forEach(outputName => {
        inputs[outputName] = { defaultValue: '' };
    });

    return {
        name: 'return',
        title: 'Return',
        type: 'METHOD',  // METHOD type has exec INPUT (triangle on left)
        color: [100, 200, 100],
        inputs: inputs,
        outputs: [],
        description: `Return values from function ${func.name}`,
        isReturn: true,
        noExecOutput: true  // Special flag to prevent exec output
    };
}

// Generate a dynamic function call node definition
function generateFunctionCallNode(func) {
    const inputs = {};
    func.inputs.forEach(inputName => {
        inputs[inputName] = { defaultValue: '' };
    });

    // Determine if it's a METHOD or FUNCTION based on hasReturnNode
    const nodeType = func.hasReturnNode ? 'FUNCTION' : 'METHOD';

    return {
        name: `Call_${func.name}`,
        title: func.name,
        type: nodeType,
        color: [100, 200, 100],
        inputs: inputs,
        outputs: func.outputs,
        description: `Call custom function: ${func.name}`,
        isCustomFunction: true,
        functionId: func.id
    };
}

// Update all function call nodes when function signature changes
function updateAllFunctionCallNodes(func) {
    // This would need to iterate through all graphs and update nodes
    // For now, we'll regenerate the node definition
    console.log(`Function ${func.name} updated. Call nodes will be regenerated on next use.`);
}

// Remove all call nodes for a deleted function
function removeAllFunctionCallNodes(functionName) {
    const editorContent = document.getElementById('editor-content');
    if (!editorContent) return;

    const nodesToRemove = [];
    document.querySelectorAll('.editor-node').forEach(nodeEl => {
        const nodeType = nodeEl.dataset.nodeType;
        if (nodeType === `Call_${functionName}`) {
            nodesToRemove.push(nodeEl);
        }
    });

    nodesToRemove.forEach(node => {
        const nodeId = node.dataset.nodeId;

        // Remove connections
        if (window.connections) {
            window.connections = window.connections.filter(conn =>
                conn.fromNode !== nodeId && conn.toNode !== nodeId
            );
        }

        node.remove();
    });

    if (window.redrawAllConnections) {
        window.redrawAllConnections();
    }
}

// Backend API functions
async function addFunctionToBackend(func) {
    try {
        const response = await fetch('/api/functions', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify(func)
        });
        const result = await response.json();
        if (!response.ok) {
            console.error('Failed to add function to backend:', result);
            return false;
        }
        console.log('Function added to backend:', result);
        return true;
    } catch (error) {
        console.error('Network error when adding function:', error);
        return false;
    }
}

async function updateFunctionInBackend(func) {
    try {
        const response = await fetch(`/api/functions/${func.name}`, {
            method: 'PUT',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify(func)
        });
        const result = await response.json();
        if (!response.ok) {
            console.error('Failed to update function in backend:', result);
        }
        return response.ok;
    } catch (error) {
        console.error('Network error when updating function:', error);
        return false;
    }
}

async function deleteFunctionFromBackend(functionName) {
    try {
        const response = await fetch(`/api/functions/${functionName}`, {
            method: 'DELETE',
            headers: { 'Content-Type': 'application/json' }
        });
        const result = await response.json();
        if (!response.ok && response.status !== 404) {
            console.warn('Failed to delete function from backend:', result);
        }
        return response.ok || response.status === 404;
    } catch (error) {
        console.error('Network error when deleting function:', error);
        return false;
    }
}

// Global functions for save/load
window.getFunctionsData = function () {
    return window.customFunctions;
};

window.loadFunctionsData = async function (functions) {
    window.customFunctions = functions || [];

    // Sync with backend
    for (const func of window.customFunctions) {
        await addFunctionToBackend(func);
    }

    renderFunctionsList();
};

// Expose functions globally
window.createNewFunction = createNewFunction;
window.updateFunction = updateFunction;
window.deleteFunction = deleteFunction;
window.switchToFunctionGraph = switchToFunctionGraph;
window.switchBackToMainGraph = switchBackToMainGraph;
window.saveFunctionGraphState = saveFunctionGraphState;
window.generateFunctionCallNode = generateFunctionCallNode;
window.generateFunctionStartNode = generateFunctionStartNode;
window.generateReturnNode = generateReturnNode;
window.renderFunctionsList = renderFunctionsList;
