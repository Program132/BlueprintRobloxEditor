local Input = {}
Input.__index = Input

local Output = {}
Output.__index = Output

export type Input = typeof(setmetatable({} :: {
    Id: string,
    Name: string,
    Value: string,
}, Input))

export type Output = typeof(setmetatable({} :: {
    Id: string,
    Name: string,
    Value: string,
}, Output))

function Input.new(name: string, value: string): Input
    return setmetatable({
        Id = DateTime.now():FormatLocalTime("LTS", "en-us"),
        Name = name,
        Value = value,
    }, Input)
end

function Output.new(name: string, value: string): Output
    return setmetatable({
        Id = DateTime.now():FormatLocalTime("LTS", "en-us"),
        Name = name,
        Value = value,
    }, Output)
end

return {
	Input = Input,
	Output = Output
}