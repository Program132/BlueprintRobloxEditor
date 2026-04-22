-- FileManager : handles all file I/O for the plugin
--
-- Opening  : StudioService:PromptImportFile()  - native OS file picker
-- Saving   : plugin:SetSetting / plugin:GetSetting (Studio internal storage)
-- Export   : Creates a StringValue in workspace with the JSON so the user can copy it

local HttpService   = game:GetService("HttpService")
local StudioService = game:GetService("StudioService")

local FileManager = {}
FileManager.__index = FileManager

function FileManager.new(pluginRef)
	assert(pluginRef, "FileManager.new requires the plugin reference")
	local self = setmetatable({}, FileManager)
	self._plugin = pluginRef
	return self
end

-- ── Open ──────────────────────────────────────────────────────────────────────

function FileManager:OpenJSON(filters)
	filters = filters or {"json"}

	local file = StudioService:PromptImportFile(filters)
	if file == nil then
		return nil
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

function FileManager:SaveJSON(key, data)
	assert(type(key) == "string" and key ~= "", "SaveJSON requires a non-empty key")

	local ok, encoded = pcall(HttpService.JSONEncode, HttpService, data)
	if not ok then
		warn("[FileManager] Encode failed for '" .. key .. "': " .. tostring(encoded))
		return false
	end

	self._plugin:SetSetting(key, encoded)
	return true
end

function FileManager:LoadJSON(key)
	assert(type(key) == "string" and key ~= "", "LoadJSON requires a non-empty key")

	local raw = self._plugin:GetSetting(key)
	if raw == nil or raw == "" then
		return nil
	end

	local ok, data = pcall(HttpService.JSONDecode, HttpService, raw)
	if not ok then
		warn("[FileManager] Decode failed for '" .. key .. "': " .. tostring(data))
		return nil
	end

	return data
end

function FileManager:DeleteSetting(key)
	self._plugin:SetSetting(key, nil)
end

-- ── Export JSON to a StringValue ─────────────────────────────────────────────
-- Creates or updates a StringValue in workspace so the user can copy the JSON.
-- Returns the StringValue instance.

function FileManager:ExportToStringValue(data, name)
	local json = HttpService:JSONEncode(data)

	local existing = workspace:FindFirstChild("__BlueprintExport")
	if existing then existing:Destroy() end

	local sv = Instance.new("StringValue")
	sv.Name  = "__BlueprintExport"
	sv.Value = json
	sv.Parent = workspace

	game:GetService("Selection"):Set({sv})
	return sv
end

return FileManager