class NodeColor:
    def __init__(self, r:int=0, g:int=0, b:int=0):
        self.r =r
        self.g = g
        self.b = b

    def get(self):
        return (self.r,self.g,self.b)

    def getHex(self):
        return "#{:02x}{:02x}{:02x}".format(self.r, self.g, self.b)    