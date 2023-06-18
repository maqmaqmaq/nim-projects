type
  Computer = object
    manufacturer: string
    cpu: string
    powerConsumption: float
    ram: int # GB
    ssd: int # GB
    quantity: int
    price: float


import std/with
var
  computer: Computer
with computer:
    manufacturer = "bananas"
    cpu = "x7"
    powerConsumption = 17
    ram = 32
    ssd = 1024
    quantity = 3
    price = 499.99


computer.quantity = computer.quantity - 1 # we sold one piece
echo computer.quantity