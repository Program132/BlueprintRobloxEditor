local Input = {}
Input.__index = Input

local Output = {}
Output.__index = Output

export type Input = typeof(setmetatable({} :: {
    Id: string,
    Name: string,
    Value: string,
    IsExec: boolean,
}, Input))

export type Output = typeof(setmetatable({} :: {
    Id: string,
    Name: string,
    Value: string,
    IsExec: boolean,
}, Output))

local HttpService = game:GetService("HttpService")

function Input.new(name: string, value: string, isExec: boolean?): Input
    return setmetatable({
        Id = HttpService:GenerateGUID(false),
        Name = name,
        Value = value,
        IsExec = if isExec ~= nil then isExec else (name == "Exec"),
    }, Input)
end

function Output.new(name: string, value: string, isExec: boolean?): Output
    return setmetatable({
        Id = HttpService:GenerateGUID(false),
        Name = name,
        Value = value,
        IsExec = if isExec ~= nil then isExec else (name == "Exec"),
    }, Output)
end

return {
	Input = Input,
	Output = Output
}