local class = require("lib.class")
local Corrutinas = require("coroutines")
local GestorOleadas = Class:extend()

function GestorOleadas:new()
    self.oleadaActual = 1
    self.enPausaOleada = false
    self.textoOleada = ""
    
    self.intervaloBase = 1.4
    self.velMinBase = 60
    self.velMaxBase = 85
    
    self.coroutineActiva = nil
end

function GestorOleadas:iniciar(numOleada)
    self.oleadaActual = numOleada or 1
    self:iniciarOleada()
end

function GestorOleadas:iniciarOleada()
    self.enPausaOleada = true
    self.textoOleada = "OLEADA " .. self.oleadaActual

    -- Creamos una corrutina para manejar la secuencia de la oleada de forma lineal
    self.coroutineActiva = Corrutinas.crear(function()
        -- 1. Pausa de 1.5 segundos antes de arrancar las ventanas
        Corrutinas.esperar(1.5)
        self.enPausaOleada = false
        
        -- Calculamos el intervalo actual según la oleada
        local intervaloActual = math.max(0.5, self.intervaloBase - (self.oleadaActual - 1) * 0.25)
        
        -- Bucle de generación de ventanas (puedes ajustar el límite por oleada)
        for i = 1, 15 do
            -- Esperamos el intervalo de tiempo entre cada ventana sin bloquear el juego
            Corrutinas.esperar(intervaloActual)
            
            -- Verificamos si estamos en juego y no hay menús o pausas activas
            if MaquinaEstados.actual == MaquinaEstados.estados["jugando"] and not mostrarBien then
                self:generarVentana()
            end
        end
    end)
end

function GestorOleadas:generarVentana()
    local x = math.random(2, pantalla.ancho - 47)
    local bonusVel = (self.oleadaActual - 1) * 15
    local vel = math.random(self.velMinBase + bonusVel, self.velMaxBase + bonusVel)
    
    local nuevaVentana = Ventana(x, -40, vel, ventanaSprite)
    table.insert(ventanas, nuevaVentana)
    world:add(nuevaVentana, nuevaVentana.x, nuevaVentana.y, nuevaVentana.ancho, nuevaVentana.alto)
end

function GestorOleadas:avanzarOleada(nuevaOleada)
    self.oleadaActual = nuevaOleada
    self:iniciarOleada()
end

function GestorOleadas:detener()
    self.enPausaOleada = false
end

function GestorOleadas:draw()
    if self.enPausaOleada then
        love.graphics.setColor(1, 1, 0)
        love.graphics.print(self.textoOleada, (pantalla.ancho * pantalla.escala) / 2 - 35, (pantalla.alto * pantalla.escala) / 2 - 10)
        love.graphics.setColor(1, 1, 1)
    end
end

return GestorOleadas()