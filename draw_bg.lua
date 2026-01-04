-- Script para dibujar fondo redondeado-- Script para dibujar anillos corregido
require 'cairo'

--funicion que dibuja el anillo
function draw_ring(cr, center_x, center_y, radius, thickness, percentage, color)
    local angle_0 = -math.pi / 2
    -- Corregido el nombre de la variable percentage
    local angle_f = angle_0 + (percentage * 2 * math.pi / 100)

    cairo_set_line_width(cr, thickness)

    -- Dibuja fondo del anillo (opaco)
    cairo_set_source_rgba(cr, 0.56, 1, 0.94, 0.26)
    cairo_arc(cr, center_x, center_y, radius, 0, 2 * math.pi)
    cairo_stroke(cr)

    -- Dibujar el progreso
    cairo_set_source_rgba(cr, color[1], color[2], color[3], color[4])
    cairo_arc(cr, center_x, center_y, radius, angle_0, angle_f)
    cairo_stroke(cr)
end

--Funcion para crear animaciones
function efecto_ocilacion(cr, x, y,radius) 
    local updates = tonumber(conky_parse('${updates}'))
    --calcular el angulo que cambie el tiempo
    local muevase = updates * 0.5
    local angulo_inicio = muevase
    local angulo_fin = muevase + (math.pi / 2) --un cuarto de circulo
    --Dubujar efecto visual
    cairo_set_line_width(cr, 2) --linea delgada para el efecto
    cairo_set_source_rgba(cr, 0, 1, 1, 0.5) --color cian semi trasparente
    cairo_arc(cr, x,y,radius -20, angulo_inicio, angulo_fin)
    cairo_stroke(cr)
end

function efecto_2(cr, x, y, radius, color)
  local updates = tonumber(conky_parse('${updates}'))
  local movimiento = updates * 0.4
  local ang_1 = movimiento
  local ang_2 = movimiento + (math.pi / 1) 
  cairo_set_line_width(cr, 5)
  cairo_set_source_rgba(cr, color[1], color[2], color[3], color[4] )
  cairo_arc(cr, x,y,radius -12, ang_1, ang_2 )
  cairo_stroke(cr)
end

function ef_cpu(cr, x, y, radius)
    local updates = tonumber(conky_parse('${updates}'))
    local mov = updates * 0.4
    local ag_1 = mov
    local ag_2 = mov + (math.pi / 1)
    cairo_set_line_width(cr, 5)
    cairo_set_source_rgba(cr, 0.96, 0.15, 0.56, 0.5) 
    cairo_arc(cr, x,y,radius -12, ag_1, ag_2 )    
    cairo_stroke(cr)
end

--funcion main la cual es ejecutada en el conkyrch
function conky_main()
    if conky_window == nil then return end
    local cs = cairo_xlib_surface_create(conky_window.display, conky_window.drawable, conky_window.visual, conky_window.width, conky_window.height)
    local cr = cairo_create(cs)

    -- Obtener datos de Conky
    local cpu = tonumber(conky_parse('${cpu cpu0}')) or 0 --lee los datos segun el componente a nivel kernel
    local mem = tonumber(conky_parse('${memperc}')) or 0 --lo mismo para la memoria

    -- Dibujar anillos (X, Y, radio, grosor, valor, color{R,G,B,A})
    -- CPU (Verde neón)
    draw_ring(cr, 70, 235, 35, 10, cpu, {0.04, 0.88, 0.55, 1}) 
    -- RAM (Morado) - Corregido el espacio extra '0 180' y la variable 'mem'
    draw_ring(cr, 180, 235, 35, 10, mem, {0.6, 0.5, 0.8, 1}) 

    --La wea que dibuja la animacion
    --!IMPORTANTE! hay que dividir el nuemro entre 255 por que cairo no sabe leer
    --valores mas alla del 0 a 255, sino 0.0 a 1.0
    efecto_ocilacion(cr, 70, 235, 35, {0.27, 0.90, 0.13}) -- Esta va a cpu
    efecto_2(cr, 70,235,35, {0.6,0.5,0.8,1})

    efecto_ocilacion(cr, 180,235, 35, {0.70, 0.90, 0.13}) -- Esta va a ram
    ef_cpu(cr, 180, 235, 35, {0.70 , 0.90, 0.13})

    cairo_destroy(cr)
    cairo_surface_destroy(cs)
end
