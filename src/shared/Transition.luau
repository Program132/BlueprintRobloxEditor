local Transition = {}
Transition.__index = Transition

export type Transition = typeof(setmetatable({} :: {
    Id: string,
    Name: string,
    Type: string,
    
}, Transition))

function Transition.new(id: string, name: string, type: string): Transition
    return setmetatable({
        Id = id,
        Name = name,
        Type = type,
    }, Transition)
end

return Transition