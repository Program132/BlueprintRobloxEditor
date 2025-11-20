document.addEventListener('DOMContentLoaded', function() {
    const variablesButton = document.getElementById('variables');
    // Référence à l'élément de contenu de l'éditeur pour l'ajout de nœuds
    const editorContent = document.getElementById('editor-content');

    // Fonction utilitaire pour simuler une position de clic pour le nouveau nœud
    function getNewNodePosition() {
        const x = Math.random() * 200 + 50; // Position aléatoire pour éviter la superposition
        const y = Math.random() * 200 + 50;
        return { x, y };
    }

    // NOUVELLES FONCTIONS D'APPEL API pour les variables (ajoutées précédemment)

    async function addVariableToBackend(name) {
        try {
            const response = await fetch('/api/variables', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({ name: name, value: 'None' })
            });
            const result = await response.json();
            if (!response.ok && response.status !== 200) {
                console.error(`Error ${response.status}: Failed to add variable to backend.`, result);
                return false;
            }
            console.log("Variable added to backend successfully:", result);
            return true;
        } catch (error) {
            console.error("Network error when adding variable:", error);
            return false;
        }
    }

    async function deleteVariableFromBackend(name) {
        try {
            const response = await fetch(`/api/variables/${name}`, {
                method: 'DELETE',
                headers: { 'Content-Type': 'application/json' }
            });
            const result = await response.json();
            if (!response.ok && response.status !== 404) {
                console.warn(`Warning: Failed to delete variable '${name}' from backend.`, result);
            } else if (response.ok) {
                 console.log("Variable deletion result from backend:", result);
            }
            return response.ok || response.status === 404; // Succès si 2xx ou 404 (déjà supprimé)
        } catch (error) {
            console.error("Network error when deleting variable:", error);
            return false;
        }
    }

    // Fin des fonctions d'appel API

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
                        validationButton.addEventListener('click', async function() { // Rendu ASYNC
                            const input = variableDefDiv.querySelector('.var-name-input');
                            if (input) {
                                const variableName = input.value.trim(); // Trim whitespace
                                if (variableName) {

                                    // 1. Appel à l'API pour ajouter la variable au backend
                                    const success = await addVariableToBackend(variableName);

                                    if (success) {
                                        // 2. Si l'API a réussi (ou si la variable existait déjà), on ajoute la variable dans l'interface
                                        const variableDescDiv = document.createElement('div');
                                        variableDescDiv.className = 'variable-desc';
                                        variableDescDiv.setAttribute('data-variable-name', variableName); // Ajout pour référence facile
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
                                        deleteButton.addEventListener('click', async function() {
                                            const nameToDelete = this.closest('.variable-desc').getAttribute('data-variable-name');

                                            // Appel à l'API pour la suppression du backend
                                            await deleteVariableFromBackend(nameToDelete);

                                            // Supprimer du DOM
                                            variableDescDiv.remove();
                                        });

                                        // **********************************************
                                        // ********* LOGIQUE DE CRÉATION DE NŒUDS GET/SET ***********
                                        // **********************************************
                                        const getButton = variableDescDiv.querySelector(".btn-var-desc-get");
                                        const setButton = variableDescDiv.querySelector(".btn-var-desc-set");

                                        if (getButton) {
                                            getButton.addEventListener('click', async function() {
                                                // Assurez-vous que window.createNodeElement et window.nodeDefinitions sont accessibles
                                                if (!window.createNodeElement || !window.nodeDefinitions) {
                                                    console.error("Node creation tools are not available.");
                                                    return;
                                                }
                                                // Attendre que les définitions de nœud soient chargées
                                                await window.nodeDefinitionsReady; // Assurez-vous que cette promesse est définie dans editor.js

                                                const nodeDef = getVariableNodeDefinition('GET');
                                                if (nodeDef) {
                                                    const { x, y } = getNewNodePosition();

                                                    // Cloner la définition et injecter le nom de la variable
                                                    const customizedNodeDef = JSON.parse(JSON.stringify(nodeDef));
                                                    customizedNodeDef.inputs.name.defaultValue = variableName;

                                                    // Appel à la fonction globale pour créer l'élément DOM du nœud
                                                    window.createNodeElement(customizedNodeDef, editorContent, x, y);
                                                } else {
                                                    console.error("GET node definition not found.");
                                                }
                                            });
                                        }

                                        if (setButton) {
                                            setButton.addEventListener('click', async function() {
                                                if (!window.createNodeElement || !window.nodeDefinitions) {
                                                    console.error("Node creation tools are not available.");
                                                    return;
                                                }
                                                await window.nodeDefinitionsReady;

                                                const nodeDef = getVariableNodeDefinition('SET');
                                                if (nodeDef) {
                                                    const { x, y } = getNewNodePosition();

                                                    // Cloner la définition et injecter le nom de la variable
                                                    const customizedNodeDef = JSON.parse(JSON.stringify(nodeDef));
                                                    customizedNodeDef.inputs.name.defaultValue = variableName;

                                                    // Appel à la fonction globale pour créer l'élément DOM du nœud
                                                    window.createNodeElement(customizedNodeDef, editorContent, x, y);
                                                } else {
                                                    console.error("SET node definition not found.");
                                                }
                                            });
                                        }
                                        // **********************************************

                                    } else {
                                        // Si l'API d'ajout a échoué
                                        alert(`Failed to create variable: ${variableName}. Check the console for API errors.`);
                                    }
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


    /**
     * Recherche la définition d'un nœud (GET ou SET) dans les définitions chargées.
     * Assumes que les nœuds GET/SET ont le nom correspondant.
     */
    function getVariableNodeDefinition(name) {
        if (!window.nodeDefinitions) return null;

        for (const category in window.nodeDefinitions) {
            const nodeDef = window.nodeDefinitions[category].find(node => node.name.toUpperCase() === name.toUpperCase());
            if (nodeDef) return nodeDef;
        }
        return null;
    }


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



    window.loadVariablesData = async function(variables) {
        const variablesContent = document.getElementById('variables-content');
        if (!variablesContent) return;

        // Effacer les variables existantes de l'interface utilisateur avant de charger
        variablesContent.innerHTML = '';

        for (const variable of variables) {
            const variableName = variable.name;

            // 1. Ajouter/Resynchroniser la variable avec le backend
            // Ceci est fait pour s'assurer que le backend est au courant de toutes les variables.
            await addVariableToBackend(variableName);

            // 2. Ajouter la variable à l'UI
            const variableDescDiv = document.createElement('div');
            variableDescDiv.className = 'variable-desc';
            variableDescDiv.setAttribute('data-variable-name', variableName); // Important pour la suppression
            variableDescDiv.innerHTML = `
                <p>${variableName}</p>
                <button class="btn-var-desc-get">GET</button>
                <button class="btn-var-desc-set">SET</button>
                <button class="btn-del-variable">X</button>
            `;
            // Toujours insérer en haut de la liste
            variablesContent.prepend(variableDescDiv);

            // 3. Rattacher les gestionnaires d'événements (suppression, GET, et SET)

            const deleteButton = variableDescDiv.querySelector(".btn-del-variable");
            deleteButton.addEventListener('click', async function() {
                const nameToDelete = this.closest('.variable-desc').getAttribute('data-variable-name');
                await deleteVariableFromBackend(nameToDelete);
                variableDescDiv.remove();
            });

            // Rattacher la logique du bouton GET
            const getButton = variableDescDiv.querySelector(".btn-var-desc-get");
            const editorContent = document.getElementById('editor-content'); // Récupérer la référence ici
            if (getButton) {
                getButton.addEventListener('click', async function() {
                    // Les vérifications sont faites pour s'assurer que les dépendances existent
                    if (!window.createNodeElement || !window.nodeDefinitions) return;
                    await window.nodeDefinitionsReady;

                    const nodeDef = getVariableNodeDefinition('GET');
                    if (nodeDef) {
                        const { x, y } = getNewNodePosition();
                        const customizedNodeDef = JSON.parse(JSON.stringify(nodeDef));
                        customizedNodeDef.inputs.name.defaultValue = variableName;
                        window.createNodeElement(customizedNodeDef, editorContent, x, y);
                    } else {
                        console.error("GET node definition not found.");
                    }
                });
            }

            // Rattacher la logique du bouton SET
            const setButton = variableDescDiv.querySelector(".btn-var-desc-set");
            if (setButton) {
                setButton.addEventListener('click', async function() {
                    if (!window.createNodeElement || !window.nodeDefinitions) return;
                    await window.nodeDefinitionsReady;

                    const nodeDef = getVariableNodeDefinition('SET');
                    if (nodeDef) {
                        const { x, y } = getNewNodePosition();
                        const customizedNodeDef = JSON.parse(JSON.stringify(nodeDef));
                        customizedNodeDef.inputs.name.defaultValue = variableName;
                        window.createNodeElement(customizedNodeDef, editorContent, x, y);
                    } else {
                        console.error("SET node definition not found.");
                    }
                });
            }
        }
    };
});