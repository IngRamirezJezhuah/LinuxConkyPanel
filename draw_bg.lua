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


function efecto_ocilacion(cr, x, y,radius, color) 
    local updates = tonumber(conky_parse('${updates}'))
    local movi = updates * 0.6
    local ag_1 = movi
    local ag_2 = movi + (math.pi / 1)

    cairo_set_line_width(cr ,4)
    cairo_set_source_rgba(cr, color[1],color[2],color[3],color[4])
    cairo_arc(cr, x , y, radius -6, ag_1, ag_2)
    cairo_stroke(cr)
end

--Efecto de circulo ef_circ_grande
local function ef_circ_grande(cr, x, y, radius, color)
  local updates = tonumber(conky_parse('${updates}')) or 0
  local movimiento = updates * 0.4
  local ang_1 = movimiento
  local ang_2 = movimiento + (math.pi / 1)

  cairo_set_line_width(cr, 5)
  cairo_set_source_rgba(cr, color[1], color[2], color[3], color[4] )
  cairo_arc(cr, x,y,radius -12, ang_1, ang_2 )
  cairo_stroke(cr)
end

local function ef_circ_pq(cr, x, y, radius, color)
  local updates = tonumber(conky_parse('${updates}')) or 0
  local mov = updates * 0.5
  local a_1 = mov
  local a_2 = mov + (math.pi / 1)

  cairo_set_line_width(cr, 3)
  cairo_set_source_rgba(cr, color[1], color[2], color[3], color[4])
  cairo_arc(cr, x, y, radius -20 , a_1, a_2)
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

-- VARIABLES DE CONTROL (Modifica estos números para mover todo el bloque)
  local centro_y = 245  -- Si quieres que bajen más por el voffset, sube este número
  local cpu_x = 70
  local ram_x = 180
  local radio_nuevo = 40
 -- Colores
 --La wea que dibuja la animacion
 --!IMPORTANTE! hay que dividir el nuemro entre 255 por que cairo no sabe leer
 --valores mas alla del 0 a 255, sino 0.0 a 1.
  local color_cian= {0, 1, 1, 0.5}
  local color_verde_neon = {0.04, 0.88, 0.55, 1}
  local color_morado = {0.6, 0.5, 0.8, 1}
-- DIBUJAR CPU
  draw_ring(cr, cpu_x, centro_y, radio_nuevo, 10, cpu, color_cian)
  ef_circ_grande(cr, cpu_x, centro_y, radio_nuevo, color_cian)
  efecto_ocilacion(cr, cpu_x, centro_y, radio_nuevo, color_cian)
  ef_circ_pq(cr, cpu_x, centro_y, radio_nuevo, color_cian)

  -- DIBUJAR RAM 
  draw_ring(cr, ram_x, centro_y, radio_nuevo, 10, mem, color_morado)
  ef_circ_grande(cr, ram_x, centro_y, radio_nuevo, color_morado)
  efecto_ocilacion(cr, ram_x, centro_y, radio_nuevo, color_morado)
  ef_circ_pq(cr, ram_x, centro_y, radio_nuevo, color_morado)
 
  cairo_destroy(cr)
  cairo_surface_destroy(cs)
end
