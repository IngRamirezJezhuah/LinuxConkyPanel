--=====================================================
--    Importaciones
--=====================================================
require 'cairo'
--=====================================================
--    Medidor de Gpu y Cpu con ciculos
--=====================================================
-- funcion anillo

function draw_ring(cr, center_x, center_y, radius, thickness, percentage, color)
  local angle_0 = -math.pi / 2
  local angle_f = angle_0 + (percentage *2 * math.pi / 100)
  
  cairo_set_line_width(cr, thickness)
  cairo_set_source_rgba(cr, 0.56, 1, 0.96, 0.26)
  cairo_arc(cr, center_x, center_y, radius, 0, 2 * math.pi)
  cairo_stroke(cr)

  cairo_set_source_rgba(cr, color[1], color[2], color[3], color[4])
  cairo_arc(cr, center_x, center_y, radius, angle_0, angle_f)
  cairo_stroke(cr)
end

function efecto_ocilacion(cr, x, y, radius, color)
  local updates = tonumber(conky_parse('${updates}'))
  local movi = updates * 0.6
  local ag_1 = movi
  local ag_2 = movi + (math.pi / 1 )

  cairo_set_line_width(cr ,4)
  cairo_set_source_rgba(cr, color[1],color[2],color[3],color[4])
  cairo_arc(cr, x , y, radius -6 , ag_1, ag_2)
  cairo_stroke(cr)
end

function conky_main()
  if conky_window == nill then return end
  local cs = cairo_xlib_surface_create(conky_window.display, conky_window.drawable, conky_window.visual, conky_window.width, conky_window.height)
  local cr = cairo_create(cs)

--==========================
-- Obtener datos de conky
--==========================
  local cpu = tonumber(conky_parse('${cpu cpu0}')) or 0
  local mem = tonumber(conky_parse('"{memperc}')) or 0

  --============================
  --  Variables de control
  --============================
  local centro_y = 245
  local cpu_x = 180
  local ram_x = 180
  local radio_nuevo = 40

  --===========================
  --    colores
  --===========================

  local color_cian = {0, 1, 1, 0.5}
  local color_verde_neon = {0.04, 0.88, 0.55, 1}
  local coolor_morado = {0.6,0.5,0.8,1}

  draw_ring(cr, cpux, centro_y, radio_nuevo, 10, cpu, color_cian)
  
end

