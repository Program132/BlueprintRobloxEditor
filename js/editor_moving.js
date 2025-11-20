// =========================
// Editor Management (pan/reset + connections)
// =========================

const editor = document.getElementById("editor");
const editorContent = document.getElementById("editor-content");
const resetBtn = document.getElementById("reset-editor");
const svg = document.getElementById("connections"); // <svg> for connections

// Transformation variables (panning)
let isPanning = false;
let startX, startY;
let offsetX = 0, offsetY = 0;
// 'scale' (zoom) variable was removed or set to 1 for simplicity (assumed)

// Temporary connection variables
let tempPath = null;
let startCircle = null;
let startType = null;
// Global array to store permanent connections
window.connections = [];

/**
 * Determines if an element is an execution port (triangle).
 * @param {HTMLElement} circle The port element.
 * @returns {boolean} True if it's an Exec port.
 */
function isExecPort(circle) {
    return circle.classList.contains('exec-port');
}

/**
 * Determines the port type (Exec or Data).
 * @param {HTMLElement} circle The port element.
 * @returns {'exec'|'data'} The port type.
 */
function getPortType(circle) {
    // Checks if the element has the 'exec-port' class (triangles)
    return isExecPort(circle) ? 'exec' : 'data';
}


/**
 * Creates the SVG path (Bézier curve) for a cable.
 */
function createPath(x1, y1, x2, y2) {
  const dx = Math.abs(x1 - x2);
  const cx1 = x1 + dx * 0.5;
  const cx2 = x2 - dx * 0.5;
  return `M ${x1},${y1} C ${cx1},${y1} ${cx2},${y2} ${x2},${y2}`;
}

/**
 * Calculates the center position of a port (circle/triangle) in the editor "world".
 * Accounts for the current pan (offsetX, offsetY).
 * * NOTE: Since the SVG doesn't move, we must calculate the absolute position
 * of the port and convert it to SVG space.
 */
function getCircleCenter(circle) {
  const rect = circle.getBoundingClientRect();
  const editorRect = editor.getBoundingClientRect();

  // Position relative to the editor (screen pixels)
  const screenX_rel = rect.left + rect.width / 2 - editorRect.left;
  const screenY_rel = rect.top + rect.height / 2 - editorRect.top;

  // Since the SVG layer is fixed, its coordinates are absolute screen coordinates
  // relative to the editor container's top-left corner.
  const x = screenX_rel;
  const y = screenY_rel;

  return { x, y };
}

// =========================
// VALUE INPUT MANAGEMENT FUNCTIONS
// =========================

/**
 * Attempts to locate the value field (Input, Textarea, or contenteditable div)
 * corresponding to a given input port using the port ID.
 */
function findPortValueInput(nodeEl, portId) {
    // Most reliable method: search for the element with the data-port-id attribute
    const selector = `[data-port-id="${portId}"]`;

    let inputField = nodeEl.querySelector(selector);

    // Final check to ensure it's an input element
    if (inputField && (inputField.tagName === 'INPUT' || inputField.tagName === 'TEXTAREA' || inputField.hasAttribute('contenteditable'))) {
        return inputField;
    }

    // Fallback (if the port wasn't created with data-port-id, less reliable)
    const inputCircle = nodeEl.querySelector(`.input-circle[data-port="${portId}"]`);
    if (inputCircle) {
        const portContainer = inputCircle.closest('.port-row, .node-input');
        if (portContainer) {
            inputField = portContainer.querySelector('input, textarea, [contenteditable="true"]');
            if (inputField) return inputField;
        }
    }

    return null;
}

/**
 * Updates the state (enabled/disabled) of an input port's value field.
 * @param {string} nodeId The node ID.
 * @param {string} portId The port ID.
 * @param {boolean} isDisabled If the input should be disabled (true) or enabled (false).
 */
function updateInputState(nodeId, portId, isDisabled) {
    const nodeEl = document.querySelector(`.editor-node[data-node-id="${nodeId}"]`);
    if (!nodeEl) return;

    const inputField = findPortValueInput(nodeEl, portId);

    if (inputField) {
        // Manage DOM state (disabled/readOnly for <input>, contentEditable for <div>)
        if (inputField.tagName === 'INPUT' || inputField.tagName === 'TEXTAREA') {
            inputField.disabled = isDisabled;
            inputField.readOnly = isDisabled;

        } else if (inputField.hasAttribute('contenteditable')) {
            // For contenteditable divs, change the attribute
            inputField.contentEditable = isDisabled ? "false" : "true";
        }

        // Manage style via CSS (this also applies pointer-events: none)
        inputField.classList.toggle('input-disabled-by-connection', isDisabled);
    }
}

// =========================
// Editor Event Handling (Continued)
// =========================


/**
 * (Global Function) Redraws all permanent cables and updates Data input states.
 * Modified to account for Exec cables.
 */
window.redrawAllConnections = function() {
    // Remove all old permanent cable groups from the SVG
    svg.querySelectorAll('.connection-group:not([data-temp])').forEach(g => g.remove());

    // 1. Identify all connected DATA inputs (to grey them out)
    const connectedDataInputs = new Set();
    // Recreate each cable based on the current node positions
    window.connections.forEach(conn => {
        const outputNode = document.querySelector(`.editor-node[data-node-id="${conn.fromNode}"]`);
        const inputNode = document.querySelector(`.editor-node[data-node-id="${conn.toNode}"]`);
        if (!outputNode || !inputNode) return;

        // Target DATA circles OR EXEC triangles
        const outputSelector = conn.type === 'exec' ? `.exec-output-port[data-port="${conn.fromPort}"]` : `.output-circle[data-port="${conn.fromPort}"]`;
        const inputSelector = conn.type === 'exec' ? `.exec-input-port[data-port="${conn.toPort}"]` : `.input-circle[data-port="${conn.toPort}"]`;

        const outputCircle = outputNode.querySelector(outputSelector);
        const inputCircle = inputNode.querySelector(inputSelector);
        if (!outputCircle || !inputCircle) return;

        // MARK THE DATA INPUT AS CONNECTED
        if (conn.type === 'data') {
            connectedDataInputs.add(`${conn.toNode}-${conn.toPort}`);
        }

        // Calculate start and end positions
        const { x: x1, y: y1 } = getCircleCenter(outputCircle);
        const { x: x2, y: y2 } = getCircleCenter(inputCircle);
        const d = createPath(x1, y1, x2, y2);

        // 1. Create the SVG group (<g>)
        const group = document.createElementNS("http://www.w3.org/2000/svg", "g");
        group.setAttribute("class", "connection-group");
        group.dataset.type = conn.type; // NEW: Add connection type (for CSS)

        // Add data attributes to identify the cable for deletion
        group.dataset.fromNode = conn.fromNode;
        group.dataset.fromPort = conn.fromPort;
        group.dataset.toNode = conn.toNode;
        group.dataset.toPort = conn.toPort;

        // 2. Create the invisible path (thick) for hover detection
        const detectionPath = document.createElementNS("http://www.w3.org/2000/svg", "path");
        detectionPath.setAttribute("class", "connection-detection");
        detectionPath.setAttribute("d", d);

        // 3. Create the visible path (thin)
        const path = document.createElementNS("http://www.w3.org/2000/svg", "path");
        path.setAttribute("class", "connection-visible");
        path.setAttribute("d", d);

        // Add both to the group
        group.appendChild(detectionPath);
        group.appendChild(path);

        svg.appendChild(group);
    });

    // 2. Iterate through all DATA inputs in the editor to apply the correct state
    document.querySelectorAll('.editor-node').forEach(nodeEl => {
        const nodeId = nodeEl.dataset.nodeId;
        // Search for all DATA input-circles in the node
        nodeEl.querySelectorAll('.input-circle').forEach(inputCircle => {
            // Note: input-circle elements are only DATA ports
            const portId = inputCircle.dataset.port;
            if (!portId) return;

            const isConnected = connectedDataInputs.has(`${nodeId}-${portId}`);

            // Apply the state to the associated value input
            updateInputState(nodeId, portId, isConnected);
        });
    });
}

/**
 * Resets (removes) the temporary cable being dragged.
 */
function resetTemp() {
  if (tempPath) tempPath.remove();
  tempPath = null;
  startCircle = null;
  startType = null;
}

/**
 * Assigns a unique ID (based on Date.now()) to the node and a port ID
 * if they don't already have one. Essential for connections.
 */
function ensureNodeAndPort(circle) {
  const nodeEl = circle.closest(".editor-node");
  if (!nodeEl.dataset.nodeId) {
    nodeEl.dataset.nodeId = "node-" + Date.now();
  }
  // Fallback logic for Data ports that don't have data-port (less critical for Exec)
  if (!circle.dataset.port) {
    const isInput = circle.classList.contains("input-circle") || circle.classList.contains("exec-input-port");
    const ports = nodeEl.querySelectorAll(isInput ? ".input-circle, .exec-input-port" : ".output-circle, .exec-output-port");
    let portIndex = -1;
    for(let i = 0; i < ports.length; i++) {
        if(ports[i] === circle) {
            portIndex = i + 1;
            break;
        }
    }
    // Use the port's text label as its ID, or fall back to an index
    const portContainer = circle.closest('.port-row');
    const label = portContainer ? portContainer.querySelector('.port-label') : null;
    circle.dataset.port = label ? label.textContent.trim() : (isInput ? "in" : "out") + portIndex;
  }
}

// --- EDITOR EVENT HANDLING ---

/**
 * Mousedown Listener:
 * - If on a port (circle/triangle): Starts dragging a cable.
 */
editor.addEventListener("mousedown", e => {
  // Target DATA circles AND EXEC triangles
  const circle = e.target.closest(".output-circle, .input-circle, .exec-port");

  // CASE 1: Start dragging a cable
  if (circle) {
    e.stopPropagation(); // Prevents editor pan
    ensureNodeAndPort(circle);

    // NEW: Check for occupied Data Input or Exec port
    const portType = getPortType(circle);
    const portId = circle.dataset.port;
    const nodeId = circle.closest('.editor-node').dataset.nodeId;
    const isOutput = circle.classList.contains("output-circle") || circle.classList.contains("exec-output-port");
    const isInput = !isOutput;

    // A. CHECK DATA: Occupied/Disabled Data Input
    if (portType === 'data' && isInput) {
        // Check if the value field is disabled by a DATA connection
        if (findPortValueInput(circle.closest('.editor-node'), portId)?.classList.contains('input-disabled-by-connection')) {
             console.warn("Cannot start connection from a busy data input port.");
             return; // Stop the action
        }
    }
    // B. CHECK EXEC: Exec Port (Input or Output) already connected (only one cable allowed)
    else if (portType === 'exec') {
         const isExecPortBusy = window.connections.some(c =>
             c.type === 'exec' &&
             ((isInput && c.toNode === nodeId && c.toPort === portId) || (isOutput && c.fromNode === nodeId && c.fromPort === portId))
         );
         if (isExecPortBusy) {
             console.warn("This Exec port is already connected (only one connection allowed).");
             return; // Stop the action
         }
    }


    startCircle = circle;
    startType = isOutput ? "output" : "input"; // Can be Data Output or Exec Output

    const { x, y } = getCircleCenter(startCircle);

    if (tempPath) tempPath.remove(); // Clean up old temp cable

    // Create the temporary (white) cable
    tempPath = document.createElementNS("http://www.w3.org/2000/svg", "path");
    tempPath.setAttribute("class", "connection-visible");
    tempPath.setAttribute("stroke", "#ffffff");
    tempPath.setAttribute("stroke-width", "2");
    tempPath.setAttribute("fill", "none");
    tempPath.setAttribute("data-temp", "true");
    tempPath.style.pointerEvents = "none";
    tempPath.setAttribute("d", `M ${x},${y} L ${x},${y}`);
    svg.appendChild(tempPath);

    return;
  }

  // CASE 2: Start Panning
  if (e.target === editor || e.target.id === "editor-background" || (e.target === svg && !e.target.closest('.connection-group'))) {
    if (e.target.closest('.connection-group')) return;

    isPanning = true;
    startX = e.clientX - offsetX;
    startY = e.clientY - offsetY;
    editor.style.cursor = "grabbing";
  }
});

/**
 * Mousemove Listener:
 */
editor.addEventListener("mousemove", e => {
  if (isPanning) {
    offsetX = e.clientX - startX;
    offsetY = e.clientY - startY;
    updateTransform();
  } else {
    updateTempPath(e); // Updates the temp cable
  }
});

/**
 * Mouseup Listener:
 */
editor.addEventListener("mouseup", e => {
  if (isPanning) isPanning = false;
  editor.style.cursor = "grab";

  // Try to finalize connection if we were dragging a cable
  if (tempPath && startCircle) finalizeConnection(e);
});

/**
 * Mouseleave Listener:
 */
editor.addEventListener("mouseleave", () => {
  isPanning = false;
  editor.style.cursor = "grab";
  resetTemp(); // Cancel cable drag
});

/**
 * Reset Button:
 */
resetBtn.addEventListener("click", () => {
  offsetX = 0;
  offsetY = 0;
  updateTransform();
});

/**
 * Applies the pan transform to the content and SVG layers.
 * * CORRECTION: Only apply transform to node content. SVG layer is fixed.
 */
function updateTransform() {
  // Apply translation (pan) only
  const transform = `translate(${offsetX}px, ${offsetY}px)`;

  // Apply the transformation ONLY to the node content
  editorContent.style.transform = transform;

  // The old line svg.style.transform = transform; is removed/omitted.

  // Redraw cables so they follow the pan
  window.redrawAllConnections();
}

/**
 * Updates the temporary cable's path to follow the mouse.
 * * CORRECTION: The mouse coordinates must be corrected for the editor's pan.
 */
function updateTempPath(e) {
  if (!tempPath || !startCircle) return;

  const editorRect = editor.getBoundingClientRect();

  // Mouse position in "SVG" coordinates (where the SVG layer is fixed at 0,0)
  // We use clientX/Y relative to the editor's top-left.
  const endX = (e.clientX - editorRect.left);
  const endY = (e.clientY - editorRect.top);

  const { x: startX, y: startY } = getCircleCenter(startCircle);

  // Draw the cable in the correct direction (Output -> Mouse or Mouse -> Input)
  if (startType === "output") {
    tempPath.setAttribute("d", createPath(startX, startY, endX, endY));
  } else if (startType === "input") {
    tempPath.setAttribute("d", createPath(endX, endY, startX, startY));
  }
}

/**
 * Finalizes the connection on 'mouseup'.
 */
function finalizeConnection(e) {
  // Use elementFromPoint to find what's UNDER the cursor
  const endCircleEl = document.elementFromPoint(e.clientX, e.clientY);
  // Target DATA circles AND EXEC triangles
  const endCircle = endCircleEl ? endCircleEl.closest(".input-circle, .output-circle, .exec-port") : null;

  // Cancel if not dropping on a port, or dropping on the start port
  if (!endCircle || endCircle === startCircle) {
    resetTemp();
    return;
  }

  ensureNodeAndPort(endCircle);

  let outputCircle, inputCircle;

  // Determine the connection type (DATA or EXEC)
  const startPortType = getPortType(startCircle);
  const endPortType = getPortType(endCircle);

  // CHECK: Prevent connecting a DATA port to an EXEC port
  if (startPortType !== endPortType) {
      console.warn("Cannot connect an Exec port to a Data port, and vice-versa.");
      resetTemp();
      return;
  }

  // Normalize the connection to always be Output -> Input
  const isStartOutput = startCircle.classList.contains("output-circle") || startCircle.classList.contains("exec-output-port");
  const isEndInput = endCircle.classList.contains("input-circle") || endCircle.classList.contains("exec-input-port");

  // If the starting port is an Output and the ending port is an Input
  if (isStartOutput && isEndInput) {
    outputCircle = startCircle;
    inputCircle = endCircle;
  }
  // If the starting port is an Input and the ending port is an Output (invert)
  else if (!isStartOutput && !isEndInput) { // Input -> Output
    outputCircle = endCircle;
    inputCircle = startCircle;
  } else {
    // Invalid case (e.g., Output -> Output or Input -> Input)
    resetTemp();
    return;
  }

  // Get unique IDs
  const fromNodeId = outputCircle.closest(".editor-node").dataset.nodeId;
  const fromPortId = outputCircle.dataset.port;
  const toNodeId = inputCircle.closest(".editor-node").dataset.nodeId;
  const toPortId = inputCircle.dataset.port;

  // CHECK: Prevent self-connection
  if (fromNodeId === toNodeId) {
    console.warn("Self-connection is not allowed.");
    resetTemp();
    return;
  }

  // --- Type-specific port checks ---

  if (startPortType === 'data') {
      // CHECK DATA: Prevent multiple connections to one DATA INPUT
      const isInputBusy = window.connections.some(c => c.toNode === toNodeId && c.toPort === toPortId && c.type === 'data');
      if (isInputBusy) {
        console.warn("This data input port is already connected.");
        resetTemp();
        return;
      }
      // Note: Multiple DATA outputs are allowed (standard in node editors)

  } else if (startPortType === 'exec') {
      // CHECK EXEC: Only one cable per Exec port (Input or Output)
      // Re-checking in case the check on mousedown was insufficient or for race conditions
      const isInputBusy = window.connections.some(c => c.toNode === toNodeId && c.toPort === toPortId && c.type === 'exec');
      const isOutputBusy = window.connections.some(c => c.fromNode === fromNodeId && c.fromPort === fromPortId && c.type === 'exec');

      if (isInputBusy || isOutputBusy) {
           console.warn("This Exec port is already connected (only one connection allowed).");
           resetTemp();
           return;
      }
  }


  // Store the new connection in the global array
  const connection = {
    type: startPortType, // NEW: stores the connection type
    fromNode: fromNodeId,
    fromPort: fromPortId,
    fromNodeName: outputCircle.closest(".editor-node").dataset.nodeType,
    fromPortName: outputCircle.dataset.port,
    toNode: toNodeId,
    toPort: toPortId,
    toNodeName: inputCircle.closest(".editor-node").dataset.nodeType,
    toPortName: inputCircle.dataset.port,
  };
  window.connections.push(connection);
  console.log("Connection created:", connection);

  // KEY ACTION: Disable the value input of the destination port (only for DATA)
  if (startPortType === 'data') {
      updateInputState(toNodeId, toPortId, true);
  }

  // Remove the temporary (white) cable
  resetTemp();

  // Redraw all cables
  window.redrawAllConnections();
}


/**
 * Listen for right-clicks on the SVG layer to delete connections.
 */
svg.addEventListener('contextmenu', e => {
    e.preventDefault(); // Prevent the default browser context menu

    // Target the closest group <g> which represents a connection
    const clickedGroup = e.target.closest('.connection-group');

    if (!clickedGroup) return;

    // FIX: Prevents opening the node search modal
    e.stopPropagation();

    const { fromNode, fromPort, toNode, toPort } = clickedGroup.dataset;

    // Find the connection object before removing it (to get its type)
    const connToRemove = window.connections.find(conn =>
        conn.fromNode === fromNode && conn.fromPort === fromPort &&
        conn.toNode === toNode && conn.toPort === toPort
    );

    // Find and remove the connection from the global array
    window.connections = window.connections.filter(conn =>
        !(conn.fromNode === fromNode && conn.fromPort === fromPort &&
          conn.toNode === toNode && conn.toPort === toPort)
    );

    console.log("Connection deleted.");

    // Remove the group from the DOM
    clickedGroup.remove();

    // KEY ACTION: Redraw all to ensure correct Data Input state update.
    window.redrawAllConnections();
});