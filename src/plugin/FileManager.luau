-- FileManager : handles all file I/O for the plugin
--
-- Opening  : StudioService:PromptImportFile()  →  native OS file picker
-- Saving   : plugin:SetSetting() / plugin:GetSetting()
--            (Roblox plugins have no direct "export to disk" API, so project
--             data is persisted inside Studio's own settings store)
--
-- Usage:
--   local fm = FileManager.new(plugin)
--   local project = fm:OpenJSON()          -- returns {name, data} or nil
--   fm:SaveJSON("myKey", project.data)    -- persist to Studio settings
--   local data = fm:LoadJSON("myKey")     -- restore from Studio settings

local HttpService   = game:GetService("HttpService")
local StudioService = game:GetService("StudioService")

local FileManager = {}
FileManager.__index = FileManager

-- plugin  : the global `plugin` object (needed for SetSetting/GetSetting)
function FileManager.new(pluginRef)
	assert(pluginRef, "FileManager.new requires the plugin reference")
	local self = setmetatable({}, FileManager)
	self._plugin = pluginRef
	return self
end

-- ── Open ──────────────────────────────────────────────────────────────────────

-- Prompts the user with a native file picker filtered to JSON files.
-- Yields until the user picks a file or cancels.
-- Returns { name: string, data: table } on success, or nil if cancelled / invalid.
function FileManager:OpenJSON(filters)
	filters = filters or {"json"}

	local file = StudioService:PromptImportFile(filters)
	if file == nil then
		return nil -- user cancelled
	end

	local raw = file:GetBinaryContents()
	local ok, data = pcall(HttpService.JSONDecode, HttpService, raw)

	if not ok then
		warn("[FileManager] Failed to parse '" .. file.Name .. "': " .. tostring(data))
		return nil
	end

	return {
		name = file.Name,
		data = data,
	}
end

-- ── Save / Load via plugin settings ──────────────────────────────────────────
-- NOTE: plugin:SetSetting stores data inside Studio's preferences, not on disk.
-- The value must be JSON-encodable and is keyed by a string.

-- Serialises `data` to JSON and stores it under the given key.
-- Returns true on success, false on failure.
function FileManager:SaveJSON(key, data)
	assert(type(key) == "string" and key ~= "", "FileManager:SaveJSON requires a non-empty key")

	local ok, encoded = pcall(HttpService.JSONEncode, HttpService, data)
	if not ok then
		warn("[FileManager] Failed to encode data for key '" .. key .. "': " .. tostring(encoded))
		return false
	end

	self._plugin:SetSetting(key, encoded)
	return true
end

-- Loads and decodes the JSON stored under the given key.
-- Returns the decoded table, or nil if the key is empty / the JSON is invalid.
function FileManager:LoadJSON(key)
	assert(type(key) == "string" and key ~= "", "FileManager:LoadJSON requires a non-empty key")

	local raw = self._plugin:GetSetting(key)
	if raw == nil or raw == "" then
		return nil
	end

	local ok, data = pcall(HttpService.JSONDecode, HttpService, raw)
	if not ok then
		warn("[FileManager] Failed to decode data for key '" .. key .. "': " .. tostring(data))
		return nil
	end

	return data
end

-- Removes a previously saved key from Studio settings.
function FileManager:DeleteSetting(key)
	self._plugin:SetSetting(key, nil)
end

return FileManager