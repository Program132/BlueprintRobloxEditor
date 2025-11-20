
window.scripts = [];
window.activeScriptId = null;

// Initialize with a default script if none exist
function initScriptsManager() {
    // If we have scripts (e.g. from a load), render them.
    // If not, create a default one.
    if (window.scripts.length === 0) {
        createNewScript("Main");
    } else {
        renderScriptsList();
        // If there is an active script ID, switch to it
        if (window.activeScriptId) {
            switchToScript(window.activeScriptId);
        } else {
            switchToScript(window.scripts[0].id);
        }
    }
}

function createNewScript(name = "New Script") {
    const id = "script-" + Date.now();

    // Try to find the default "Start" node definition
    let startNodeData = null;
    if (window.nodeDefinitions) {
        for (const category in window.nodeDefinitions) {
            const found = window.nodeDefinitions[category].find(node =>
                node.name.toLowerCase() === 'start' && node.type === 'EVENT'
            );
            if (found) {
                // Create a default instance of the Start node
                // We place it in the center-ish (similar to editor.js init)
                // But since we don't have the editor dimensions here easily, we guess or use fixed.
                startNodeData = {
                    id: "node-" + Date.now(),
                    name: found.name,
                    type: found.type,
                    x: 100, // Default X
                    y: 100, // Default Y
                    inputs: {}
                };
                break;
            }
        }
    }

    const newScript = {
        id: id,
        name: name,
        nodes: startNodeData ? [startNodeData] : [],
        connections: []
    };

    window.scripts.push(newScript);

    // If it's the first script, switch to it automatically
    if (window.scripts.length === 1) {
        switchToScript(id);
    } else {
        // Just switch to the new one for convenience
        switchToScript(id);
    }
    return newScript;
}

function saveCurrentScriptState() {
    if (!window.activeScriptId) return;

    const script = window.scripts.find(s => s.id === window.activeScriptId);
    if (!script) return;

    // Use the existing collection function from tools.js
    if (typeof collectEditorData === 'function') {
        const data = collectEditorData();
        script.nodes = data.nodes;
        script.connections = data.connections;
    }
}

function switchToScript(id) {
    // 1. Save current state (if there is an active script or function)
    if (window.currentGraphType === 'function' && window.activeFunctionId) {
        // Save function graph state
        if (window.saveFunctionGraphState) {
            window.saveFunctionGraphState();
        }
        window.currentGraphType = 'main';
        window.activeFunctionId = null;
    } else if (window.activeScriptId && window.scripts.find(s => s.id === window.activeScriptId)) {
        saveCurrentScriptState();
    }

    // 2. Find target script
    const targetScript = window.scripts.find(s => s.id === id);
    if (!targetScript) {
        console.error(`Script with id ${id} not found.`);
        return;
    }

    window.activeScriptId = id;

    // 3. Clear editor and load new state
    if (typeof loadGraphIntoEditor === 'function') {
        loadGraphIntoEditor(targetScript.nodes, targetScript.connections);
    } else {
        console.error("loadGraphIntoEditor not found");
    }

    renderScriptsList();

    // Update functions list to remove active state
    if (window.renderFunctionsList) {
        window.renderFunctionsList();
    }
}

function deleteScript(id) {
    if (window.scripts.length <= 1) {
        alert("You must have at least one script.");
        return;
    }

    const confirmDelete = confirm("Are you sure you want to delete this script?");
    if (!confirmDelete) return;

    const index = window.scripts.findIndex(s => s.id === id);
    if (index === -1) return;

    const isDeletingActive = (id === window.activeScriptId);

    window.scripts.splice(index, 1);

    if (isDeletingActive) {
        // Switch to the first available script
        // We set activeScriptId to null first so switchToScript doesn't try to save the deleted script
        window.activeScriptId = null;
        switchToScript(window.scripts[0].id);
    } else {
        renderScriptsList();
    }
}

function renderScriptsList() {
    const container = document.querySelector('.sub-explorer-graphs');
    if (!container) return;

    // Ensure we have a list container
    let listContainer = container.querySelector('.scripts-list');
    if (!listContainer) {
        listContainer = document.createElement('div');
        listContainer.className = 'scripts-list';
        listContainer.style.marginTop = '10px';
        container.appendChild(listContainer);
    }

    listContainer.innerHTML = '';

    // Add indicator if we're in function mode
    if (window.currentGraphType === 'function' && window.activeFunctionId) {
        const funcIndicator = document.createElement('div');
        funcIndicator.style.padding = '8px';
        funcIndicator.style.marginBottom = '8px';
        funcIndicator.style.backgroundColor = 'rgba(100, 200, 100, 0.2)';
        funcIndicator.style.border = '1px solid rgba(100, 200, 100, 0.5)';
        funcIndicator.style.borderRadius = '4px';
        funcIndicator.style.color = '#6fc86f';
        funcIndicator.style.fontSize = '12px';
        funcIndicator.style.textAlign = 'center';
        funcIndicator.style.cursor = 'pointer';

        const func = window.customFunctions.find(f => f.id === window.activeFunctionId);
        funcIndicator.textContent = func ? `📝 Editing: ${func.name}` : '📝 Editing Function';
        funcIndicator.title = 'Currently editing function graph. Click a script below to return to main graphs.';

        listContainer.appendChild(funcIndicator);

        // Add separator
        const separator = document.createElement('div');
        separator.style.height = '1px';
        separator.style.backgroundColor = 'rgba(255,255,255,0.1)';
        separator.style.margin = '8px 0';
        listContainer.appendChild(separator);
    }

    window.scripts.forEach(script => {
        const item = document.createElement('div');
        item.className = 'script-item';
        item.style.padding = '8px';
        item.style.cursor = 'pointer';
        item.style.display = 'flex';
        item.style.justifyContent = 'space-between';
        item.style.alignItems = 'center';
        item.style.borderBottom = '1px solid rgba(255,255,255,0.05)';

        if (script.id === window.activeScriptId) {
            item.style.backgroundColor = 'rgba(255, 255, 255, 0.1)';
            item.style.borderLeft = '3px solid #4CAF50';
        } else {
            item.style.borderLeft = '3px solid transparent';
        }

        item.onclick = () => switchToScript(script.id);

        const nameSpan = document.createElement('span');
        nameSpan.textContent = script.name;
        nameSpan.style.color = '#d4d4d4';
        nameSpan.style.fontSize = '14px';

        const deleteBtn = document.createElement('button');
        deleteBtn.innerHTML = '&times;';
        deleteBtn.className = 'btn-delete-script';
        deleteBtn.style.background = 'transparent';
        deleteBtn.style.border = 'none';
        deleteBtn.style.color = '#888';
        deleteBtn.style.cursor = 'pointer';
        deleteBtn.style.fontSize = '16px';

        deleteBtn.onmouseover = () => deleteBtn.style.color = '#ff4444';
        deleteBtn.onmouseout = () => deleteBtn.style.color = '#888';

        deleteBtn.onclick = (e) => {
            e.stopPropagation();
            deleteScript(script.id);
        };

        item.appendChild(nameSpan);
        item.appendChild(deleteBtn);
        listContainer.appendChild(item);
    });
}

// Expose functions globally
window.initScriptsManager = initScriptsManager;
window.createNewScript = createNewScript;
window.saveCurrentScriptState = saveCurrentScriptState;
window.switchToScript = switchToScript;
window.deleteScript = deleteScript;
window.renderScriptsList = renderScriptsList;

document.addEventListener('DOMContentLoaded', () => {
    const addBtn = document.getElementById('graphs');
    if (addBtn) {
        addBtn.addEventListener('click', () => {
            const name = prompt("Script Name:", "New Script");
            if (name) {
                createNewScript(name);
            }
        });
    }

    // Delay init slightly to ensure other scripts (tools.js) are loaded
    setTimeout(initScriptsManager, 100);
});
