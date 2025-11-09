document.addEventListener('DOMContentLoaded', function() {
    const variablesButton = document.getElementById('variables');
    if (variablesButton) {
        variablesButton.addEventListener('click', function() {
            const variablesContent = document.getElementById('variables-content');
            if (variablesContent) {
                // Check if a variable definition form already exists
                const existingForm = variablesContent.querySelector('.variable-def');
                if (!existingForm) {
                    const variableDefDiv = document.createElement('div');
                    variableDefDiv.className = 'variable-def';
                    variableDefDiv.innerHTML = `
                        <div class="var-name">
                            <label for="var-name">Variable Name:</label>
                            <input type="text" class="var-name-input" placeholder="Enter variable name" />
                        </div>
                        <button class="btn-var-validation">Ok</button>
                        <button class="btn-cancel-variable-def">X</button>
                    `;
                    // Prepend the new form to the content area
                    variablesContent.prepend(variableDefDiv);

                    const validationButton = variableDefDiv.querySelector('.btn-var-validation');
                    const cancelButton = variableDefDiv.querySelector(".btn-cancel-variable-def");

                    if (cancelButton) {
                        cancelButton.addEventListener('click', function() {
                            variableDefDiv.remove();
                        });
                    }

                    if (validationButton) {
                        validationButton.addEventListener('click', function() {
                            const input = variableDefDiv.querySelector('.var-name-input');
                            if (input) {
                                const variableName = input.value.trim(); // Trim whitespace
                                if (variableName) {
                                    const variableDescDiv = document.createElement('div');
                                    variableDescDiv.className = 'variable-desc';
                                    variableDescDiv.innerHTML = `
                                        <p>${variableName}</p>
                                        <button class="btn-var-desc-get">GET</button>
                                        <button class="btn-var-desc-set">SET</button>
                                        <button class="btn-del-variable">X</button>
                                    `;
                                    // Insert the new variable description before the current first child
                                    variablesContent.insertBefore(variableDescDiv, variablesContent.firstChild);
                                    // Remove the definition form
                                    variableDefDiv.remove();

                                    const deleteButton = variableDescDiv.querySelector(".btn-del-variable");
                                    deleteButton.addEventListener('click', function() {
                                        variableDescDiv.remove();
                                    });
                                }
                            }
                        });
                    }
                }
            } else {
                console.error("variables-content not found");
            }
        });
    } else {
        console.error("variables button not found");
    }
});


/*
 * Global function to collect all defined variables for saving.
 * Assumes the variable name is the only data required for serialization.
 */
window.getVariablesData = function() {
    const variablesContent = document.getElementById('variables-content');
    if (!variablesContent) return [];

    const variables = [];
    // Iterate through all displayed variable definitions
    variablesContent.querySelectorAll('.variable-desc').forEach(descDiv => {
        const variableName = descDiv.querySelector('p').textContent.trim();
        if (variableName) {
            variables.push({
                name: variableName
            });
        }
    });
    return variables;
};