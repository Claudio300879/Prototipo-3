local Class = require("lib.class")
local Humo = Class:extend()

local instanciaUnica = nil

function Humo:new(lado, anchoPantalla, altoPantalla)
    if instanciaUnica then
        return instanciaUnica
    end

    self.ancho = 4
    self.alto = altoPantalla or 600
    self.anchoPantalla = anchoPantalla or 800
    
    self.xIzq = 0
    self.xDer = self.anchoPantalla - self.ancho
    self.y = 0
    
    self.tipo = "humo"
    self.imagen = love.graphics.newImage("img/humo.png")
    
    self.escala = 0.015
    self.opacidad = 0.85
    self.rotacion = 0
    
    -- 📊 DATOS ORIENTADOS A DATOS (Data Locality): Arreglos planos y contiguos
    self.maxNubes = 18
    self.yPosList = {}
    self.indiceList = {}
    self.activoList = {}
    
    self:inicializarPoolDOD()
    
    -- Las corrutinas de animación asíncrona siguen intactas
    self.co = coroutine.create(function()
        local acumulador = math.random() * 10
        while true do
            local dt = coroutine.yield()
            acumulador = acumulador + dt
            
            self.opacidad = 0.75 + math.sin(acumulador * 3) * 0.1
            self.escala = 0.015 + math.sin(acumulador * 1.5) * 0.003
            self.rotacion = math.sin(acumulador * 0.5) * 0.1
        end
    end)
    coroutine.resume(self.co)

    instanciaUnica = self
end

function Humo.getInstance(lado, anchoPantalla, altoPantalla)
    if not instanciaUnica then
        instanciaUnica = Humo(lado, anchoPantalla, altoPantalla)
    end
    return instanciaUnica
end

-- Inicialización contigua para optimizar el acceso en memoria
function Humo:inicializarPoolDOD()
    local pasoY = self.alto / self.maxNubes
    for i = 1, self.maxNubes do
        self.yPosList[i] = (i - 1) * pasoY
        self.indiceList[i] = i
        self.activoList[i] = true
    end
end

function Humo:update(dt)
    if self.co and coroutine.status(self.co) ~= "dead" then
        coroutine.resume(self.co, dt)
    end
end

-- Renderizado secuencial optimizado mediante arreglos planos
function Humo:drawLado(lado)
    love.graphics.setBlendMode("alpha")
    
    local imgW = self.imagen:getWidth()
    local imgH = self.imagen:getHeight()
    
    for i = 1, self.maxNubes do
        if self.activoList[i] then
            local yPos = self.y + self.yPosList[i]
            love.graphics.setColor(1, 1, 1, self.opacidad)
            
            local xPosFinal
            local idx = self.indiceList[i]
            if lado == "izq" then
                xPosFinal = 3 + (idx % 2) * 2
            else
                xPosFinal = self.anchoPantalla - 3 - (idx % 2) * 2
            end
            
            love.graphics.draw(self.imagen, 
                xPosFinal, yPos,
                self.rotacion + (idx * 0.5),
                self.escala, self.escala * 2.5,
                imgW / 2, imgH / 2)
        end
    end
    
    love.graphics.setColor(1, 1, 1, 1)
end

return Humo