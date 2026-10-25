local Corrutinas = {}
local activas = {}

-- Agregar una nueva corrutina a la lista de ejecución
function Corrutinas.crear(funcion)
    local co = coroutine.create(funcion)
    table.insert(activas, co)
    return co
end

-- Función de ayuda para pausar la corrutina durante N segundos
function Corrutinas.esperar(segundos)
    local acumulado = 0
    while acumulado < segundos do
        local dt = coroutine.yield() -- Pausa y recibe el delta time del frame
        acumulado = acumulado + (dt or 0)
    end
end

-- Actualizar todas las corrutinas activas en el love.update(dt)
function Corrutinas.actualizar(dt)
    for i = #activas, 1, -1 do
        local co = activas[i]
        if coroutine.status(co) == "dead" then
            table.remove(activas, i) -- Limpia las corrutinas finalizadas
        else
            local ok, err = coroutine.resume(co, dt)
            if not ok then
                error("Error en corrutina: " .. tostring(err))
            end
        end
    end
end

return Corrutinas