local Input = {}
Input.__index = Input

local Output = {}
Output.__index = Output

export type Input = typeof(setmetatable({} :: {
    Id: string,
    Name: string,
    Value: string,
    IsExec: boolean,
    Choices: {string}?,
}, Input))

export type Output = typeof(setmetatable({} :: {
    Id: string,
    Name: string,
    Value: string,
    IsExec: boolean,
    Choices: {string}?,
}, Output))

local HttpService = game:GetService("HttpService")

function Input.new(name: string, value: string, isExec: boolean?, choices: {string}?): Input
    return setmetatable({
        Id = HttpService:GenerateGUID(false),
        Name = name,
        Value = value,
        IsExec = if isExec ~= nil then isExec else (name == "Exec"),
        Choices = choices
    }, Input)
end

function Output.new(name: string, value: string, isExec: boolean?, choices: {string}?): Output
    return setmetatable({
        Id = HttpService:GenerateGUID(false),
        Name = name,
        Value = value,
        IsExec = if isExec ~= nil then isExec else (name == "Exec"),
        Choices = choices
    }, Output)
end

return {
	Input = Input,
	Output = Output
}