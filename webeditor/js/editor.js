document.addEventListener('DOMContentLoaded', function () {
    const editor = document.getElementById('editor');
    const editorContent = document.getElementById('editor-content');
    let searchModal = null;
    let isModalOpen = false;
    let nodeDefinitions = {};

    async function loadNodeDefinitions() {
        try {
            const response = await fetch('/api/nodes');
            const nodes = await response.json();

            nodeDefinitions = {};
            nodes.forEach(node => {
                if (!nodeDefinitions[node.category]) nodeDefinitions[node.category] = [];
                nodeDefinitions[node.category].push({
                    name: node.name,
                    ...node.data,
                    category: node.category,
                    color: node.color
                });
            });

            initializeEditor();
        } catch (error) {
            console.error("Error loading node definitions:", error);
        }
    }

    const nodeDefinitionsPromise = loadNodeDefinitions();

    function createNodeElement(nodeDef, container, x, y) {
        if (nodeDef.type === 'EVENT') {
            const nodeName = nodeDef.name;
            const existingEvent = document.querySelector(`.editor-node[data-node-class="EVENT"][data-node-type="${nodeName}"]`);
            if (existingEvent) {
                console.warn(`The creation of the EVENT node '${nodeName}' has been cancelled: an event of this type already exists.`);
                return null;
            }
        }

        const nodeEl = document.createElement('div');
        nodeEl.className = 'editor-node';
        nodeEl.dataset.nodeType = nodeDef.name;
        nodeEl.dataset.nodeClass = nodeDef.type;
        nodeEl.style.position = 'absolute';
        nodeEl.style.left = `${x}px`;
        nodeEl.style.top = `${y}px`;
        nodeEl.style.backgroundColor = `rgba(${nodeDef.color.join(',')},0.1)`;
        nodeEl.style.border = `1px solid rgba(${nodeDef.color.join(',')},0.3)`;
        nodeEl.style.borderRadius = '6px';
        nodeEl.style.padding = '12px';
        nodeEl.style.minWidth = '180px';
        nodeEl.style.color = '#d4d4d4';
        nodeEl.style.userSelect = 'none';

        const title = document.createElement('div');
        title.className = 'node-title';
        title.textContent = nodeDef.title || nodeDef.name;
        title.style.fontWeight = 'bold';
        title.style.marginBottom = '10px';
        title.style.paddingBottom = '6px';
        title.style.borderBottom = '1px solid rgba(255,255,255,0.1)';
        title.style.color = `rgb(${nodeDef.color.join(',')})`;
        nodeEl.appendChild(title);

        const content = document.createElement('div');
        content.className = 'editor-node-content';


        // -------- EXEC PORTS CONTAINER (INPUTS) --------
        const execInputContainer = document.createElement('div');
        execInputContainer.style.display = 'flex';
        execInputContainer.style.justifyContent = 'space-between';
        execInputContainer.style.alignItems = 'center';

        if (nodeDef.type === "METHOD") {
            const execIn = document.createElement('div');
            execIn.className = 'exec-port exec-input-port';
            execIn.dataset.port = 'ExecIn';
            execInputContainer.appendChild(execIn);
        } else {
            const placeholder = document.createElement('div');
            placeholder.style.width = '10px';
            execInputContainer.appendChild(placeholder);
        }

        // Ajout d'un placeholder pour l'alignement avec les sorties dans la structure METHOD/EVENT
        if (!(Array.isArray(nodeDef.exec) && nodeDef.exec.length > 0)) {
            const placeholderRight = document.createElement('div');
            placeholderRight.style.width = '10px';
            execInputContainer.appendChild(placeholderRight);
        } else {
            // Placeholder for exec outputs alignment
            const placeholderRight = document.createElement('div');
            placeholderRight.style.width = '10px';
            execInputContainer.appendChild(placeholderRight);
        }

        nodeEl.appendChild(execInputContainer);

        // -------- EXEC PORTS CONTAINER (OUTPUTS - VERTICAL) --------
        if (Array.isArray(nodeDef.exec) && nodeDef.exec.length > 0) {
            const execOutputsContainer = document.createElement('div');
            execOutputsContainer.style.display = 'flex';
            execOutputsContainer.style.flexDirection = 'column'; // Disposition en colonne
            execOutputsContainer.style.gap = '10px';
            execOutputsContainer.style.paddingTop = '6px';
            execOutputsContainer.style.borderTop = '1px dashed rgba(255,255,255,0.1)';
            execOutputsContainer.style.marginBottom = '10px';
            execOutputsContainer.className = 'node-exec-output-ports';

            nodeDef.exec.forEach(portName => {
                const execOutWrapper = document.createElement('div');
                execOutWrapper.className = 'exec-output-wrapper';
                execOutWrapper.style.display = 'flex';
                execOutWrapper.style.justifyContent = 'flex-end';
                execOutWrapper.style.alignItems = 'center';

                const label = document.createElement('span');
                label.textContent = portName;
                label.style.fontSize = '12px';
                label.style.color = 'rgba(255, 255, 255, 0.9)';
                label.style.marginRight = '8px';

                const execOut = document.createElement('div');
                execOut.className = 'exec-port exec-output-port';
                execOut.dataset.port = portName;
                execOut.style.display = 'flex';
                execOut.style.flexDirection = 'column';
                execOut.style.alignItems = 'center';
                execOut.style.cursor = 'pointer';

                const portShape = document.createElement('div');
                portShape.className = 'exec-output-shape';
                portShape.style.width = '10px';
                portShape.style.height = '10px';
                portShape.style.borderRadius = '50%';
                portShape.style.backgroundColor = '#a0a0a0';
                execOut.appendChild(portShape);



                execOut.appendChild(portShape);

                execOutWrapper.appendChild(label);
                execOutWrapper.appendChild(execOut);

                execOutputsContainer.appendChild(execOutWrapper);
            });
            nodeEl.appendChild(execOutputsContainer);
        } else if ((nodeDef.type === "METHOD" || nodeDef.type === "EVENT") && !(Array.isArray(nodeDef.exec))) {
            const execOutputsContainer = document.createElement('div');
            execOutputsContainer.style.display = 'flex';
            execOutputsContainer.style.justifyContent = 'flex-end';
            execOutputsContainer.style.paddingTop = '6px';
            execOutputsContainer.style.borderTop = '1px dashed rgba(255,255,255,0.1)';
            execOutputsContainer.style.marginBottom = '10px';

            const execOut = document.createElement('div');
            execOut.className = 'exec-port exec-output-port';
            execOut.dataset.port = 'ExecOut';

            const portShape = document.createElement('div');
            portShape.className = 'exec-output-shape';
            portShape.style.width = '10px';
            portShape.style.height = '10px';

            execOut.appendChild(portShape);
            execOutputsContainer.appendChild(execOut);
            nodeEl.appendChild(execOutputsContainer);
        }


        if (nodeDef.inputs) {
            const inputsSec = document.createElement('div');
            inputsSec.className = 'editor-node-inputs';
            inputsSec.style.display = 'flex';
            inputsSec.style.flexDirection = 'column';
            inputsSec.style.gap = '6px';

            for (const [name, def] of Object.entries(nodeDef.inputs)) {
                const inp = document.createElement('div');
                inp.className = 'editor-node-input';
                inp.style.display = 'flex';
                inp.style.alignItems = 'center';
                inp.style.gap = '6px';

                inp.innerHTML = `
                    <div class="input-circle" data-port="${name}"></div>
                    <div class="input-label" style="font-size:12px;color:#d4d4d4;flex:0 0 60px">${name}</div>
                    <input type="text"
                        class="node-input-value"
                        data-port-id="${name}"
                        value="${def.defaultValue || ''}" style="
                        flex:1;
                        max-width:100px;
                        padding:4px 6px;
                        background-color:#1b1f29;
                        border:1px solid #2a3d55;
                        border-radius:4px;
                        color:#d4d4d4;
                        font-size:12px;
                    ">
                `;
                inputsSec.appendChild(inp);
            }
            content.appendChild(inputsSec);
        }

        if (Array.isArray(nodeDef.outputs) && nodeDef.outputs.length > 0) {
            const outputsSec = document.createElement('div');
            outputsSec.className = 'editor-node-outputs';
            outputsSec.style.display = 'flex';
            outputsSec.style.flexDirection = 'column';
            outputsSec.style.gap = '6px';
            outputsSec.style.marginTop = '10px';
            outputsSec.style.paddingTop = '10px';
            outputsSec.style.borderTop = '1px solid rgba(255,255,255,0.1)';

            nodeDef.outputs.forEach(outName => {
                const out = document.createElement('div');
                out.className = 'editor-node-output';
                out.style.display = 'flex';
                out.style.alignItems = 'center';
                out.style.gap = '6px';

                out.innerHTML = `
                    <div class="output-label" style="font-size:12px;color:#d4d4d4;flex:0 0 60px">${outName}</div>
                    <div class="output-circle" data-port="${outName}"></div>
                `;

                outputsSec.appendChild(out);
            });

            content.appendChild(outputsSec);
        }

        nodeEl.appendChild(content);
        container.appendChild(nodeEl);

        makeDraggable(nodeEl);

        nodeEl.addEventListener('mouseenter', () => {
            nodeEl.style.border = `2px solid rgb(${nodeDef.color.join(',')})`;
            nodeEl.style.boxShadow = `0 0 8px rgba(${nodeDef.color.join(',')}, 0.6)`;
        });
        nodeEl.addEventListener('mouseleave', () => {
            nodeEl.style.border = `1px solid rgba(255, 255, 255, 0.1)`;
            nodeEl.style.boxShadow = 'none';
        });

        nodeEl.addEventListener('contextmenu', e => {
            e.preventDefault();
            e.stopPropagation();

            const nodeId = nodeEl.dataset.nodeId;

            if (window.connections && nodeId) {
                window.connections = window.connections.filter(conn =>
                    conn.fromNode !== nodeId && conn.toNode !== nodeId
                );
            }

            nodeEl.remove();

            if (window.redrawAllConnections) window.redrawAllConnections();
        });

        const nodeId = "node-" + Date.now();
        nodeEl.dataset.nodeId = nodeId;

        nodeEl.querySelectorAll('.input-circle, .output-circle, .node-input-value, .exec-port').forEach(portEl => {
            portEl.dataset.nodeId = nodeId;
        });
    }

    function makeDraggable(el) {
        let isDraggingNode = false;
        let dragStartX, dragStartY, initialNodeX, initialNodeY;

        el.addEventListener('mousedown', e => {
            if (e.target.tagName === 'INPUT' || e.target.closest('.input-circle, .output-circle, .exec-port')) return;

            isDraggingNode = true;

            dragStartX = e.clientX;
            dragStartY = e.clientY;
            initialNodeX = parseFloat(el.style.left);
            initialNodeY = parseFloat(el.style.top);

            el.style.cursor = 'grabbing';
            el.style.zIndex = 1000;
            e.stopPropagation();
        });

        document.addEventListener('mousemove', e => {
            if (!isDraggingNode) return;

            const dx = (e.clientX - dragStartX);
            const dy = (e.clientY - dragStartY);

            el.style.left = `${initialNodeX + dx}px`;
            el.style.top = `${initialNodeY + dy}px`;

            if (window.redrawAllConnections) window.redrawAllConnections();
        });

        document.addEventListener('mouseup', () => {
            if (!isDraggingNode) return;

            isDraggingNode = false;
            el.style.cursor = 'pointer';
            el.style.zIndex = 10;

            if (window.redrawAllConnections) window.redrawAllConnections();
        });
    }

    function createSearchModal(x, y) {
        if (searchModal) searchModal.remove();

        searchModal = document.createElement('div');
        searchModal.className = 'search-nodes-modal';
        searchModal.style.position = 'absolute';
        searchModal.style.left = `${x}px`;
        searchModal.style.top = `${y}px`;
        searchModal.style.zIndex = '1000';

        searchModal.innerHTML = `
            <div class="search-nodes-content">
                <h3>Search a Node</h3>
                <input type="text" class="search-node-input" placeholder="Search a node..." />
                <div class="nodes-list"></div>
            </div>
        `;

        editor.appendChild(searchModal);
        isModalOpen = true;
        populateNodesList();

        const searchInput = searchModal.querySelector('.search-node-input');
        searchInput.focus();

        searchInput.addEventListener('input', e => {
            const term = e.target.value.toLowerCase();
            searchModal.querySelectorAll('.node-item').forEach(node => {
                const name = node.querySelector('.node-name').textContent.toLowerCase();
                node.style.display = name.includes(term) ? 'block' : 'none';
            });
        });

        searchInput.addEventListener('keydown', e => {
            if (e.key === 'Enter') {
            }
        });

        document.addEventListener('mousedown', handleOutsideClick);
        document.addEventListener('keydown', handleEscapeKey);
    }

    function populateNodesList() {
        const nodesList = searchModal.querySelector('.nodes-list');
        nodesList.innerHTML = '';

        for (const [category, nodes] of Object.entries(nodeDefinitions)) {
            const catEl = document.createElement('div');
            catEl.className = 'node-category';
            catEl.textContent = category;
            nodesList.appendChild(catEl);

            nodes.forEach(node => {
                const nodeItem = document.createElement('div');
                nodeItem.className = 'node-item';
                nodeItem.style.borderLeft = `3px solid rgb(${node.color.join(',')})`;
                nodeItem.innerHTML = `
                    <div style="display:flex;justify-content:space-between;align-items:center;padding:8px">
                        <div>
                            <p class="node-name" style="font-weight:500;margin-bottom:4px">${node.title || node.name}</p>
                            <p style="font-size:12px;color:#a0a0a0">${node.description || ''}</p>
                        </div>
                        <span style="
                            background: rgba(${node.color.join(',')},0.2);
                            color: rgb(${node.color.join(',')});
                            padding:2px 6px;
                            border-radius:4px;
                            font-size:10px;
                            font-weight:bold;
                        ">${node.type}</span>
                    </div>
                `;

                nodeItem.addEventListener('click', () => {
                    const rect = editor.getBoundingClientRect();

                    const editorContent = document.getElementById('editor-content');
                    const style = window.getComputedStyle(editorContent);
                    const matrix = new DOMMatrix(style.transform);
                    const offsetX = matrix.e;
                    const offsetY = matrix.f;

                    const mouseX = parseInt(editor.dataset.lastContextMenuX || '100');
                    const mouseY = parseInt(editor.dataset.lastContextMenuY || '100');

                    const x = (mouseX - rect.left - offsetX);
                    const y = (mouseY - rect.top - offsetY);

                    createNodeElement(node, editorContent, x, y);
                    closeSearchModal();
                });

                nodesList.appendChild(nodeItem);
            });
        }
    }

    function handleOutsideClick(e) {
        if (isModalOpen && searchModal && !searchModal.contains(e.target)) closeSearchModal();
    }

    function handleEscapeKey(e) {
        if (isModalOpen && e.key === 'Escape') closeSearchModal();
    }

    function closeSearchModal() {
        if (!searchModal) return;
        searchModal.remove();
        searchModal = null;
        isModalOpen = false;
        document.removeEventListener('mousedown', handleOutsideClick);
        document.removeEventListener('keydown', handleEscapeKey);
    }

    editor.addEventListener('contextmenu', e => {
        e.preventDefault();
        if (e.target.closest('.editor-node')) return;

        if (isModalOpen) closeSearchModal();
        editor.dataset.lastContextMenuX = e.clientX;
        editor.dataset.lastContextMenuY = e.clientY;
        const rect = editor.getBoundingClientRect();
        createSearchModal(e.clientX - rect.left, e.clientY - rect.top);
    });

    function initializeEditor() {
        console.log("All loaded nodeDefinitions:", nodeDefinitions);

        const existingStart = document.querySelector('.editor-node[data-node-type="Start"]');
        if (existingStart) {
            console.log("Start node already exists, skipping default creation.");
            return;
        }

        let startNodeDef = null;
        for (const category in nodeDefinitions) {
            startNodeDef = nodeDefinitions[category].find(node =>
                node.name.toLowerCase() === 'start' && node.type === 'EVENT'
            );

            if (startNodeDef) break;
        }

        if (startNodeDef) {
            const centerX = (editor.clientWidth / 2) - 90;
            const centerY = (editor.clientHeight / 2) - 20;

            createNodeElement(startNodeDef, editorContent, centerX, centerY);
        } else {
            console.warn("Start node definition (name: 'Start', type: 'EVENT') not found in loaded definitions.");
        }
    }


    window.createNodeElement = createNodeElement;
    window.nodeDefinitionsReady = nodeDefinitionsPromise;
    Object.defineProperty(window, "nodeDefinitions", {
        get: () => nodeDefinitions
    });
});