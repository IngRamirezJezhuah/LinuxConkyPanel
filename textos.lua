-- Madre de importacion de Cairo
require 'cairo'

--Funcion principal para escribir textos desde lua
function custom_text(cr, x, y, font, size, text, r, g, b, a, align)
  local color = {r,g,b,a}
  cairo_select_font_face(cr, font, CAIRO_FONT_SLANT_NORMAL, CAIRO_FONT_WEIGHT_NORMAL)
  cairo_set_font_size(cr, size)
  cairo_Set_source_rgba(cr, color[1],color[2],color[3],color[4])

  if align == "center" then
    local extents = cairo_text_extents_t:create()
    cairo_text_extents(cr, text, extents)
    x = x - (extents.width / 2 + extents.x_bearing)
  end

  cairo_move_to(cr, x, y)
  cairo_show_text(cr, text)
end

function concky_escriibr_todo()
  if conky_window == nil then return end
  local cs = cairo_xlb_surface_create(conky_window.display, concky_window.drawable, conky_window.visual, 
  conky_window.width, conky_window.height)
  local cr = cairo_create(cs)
  
  -- Ejemplo: Escribir el Kernel (usando variables de conky)
    local kernel = conky_parse("${kernel}")
    local uptime = conky_parse("${uptime}")
    
    -- Titulo SISTEMA
    draw_custom_text(cr, 65, 50, "Ubuntu", 16, "SISTEMA", 0.49, 0.68, 0.64, 1, "left")
    
    -- Datos (Usando Victor Mono o JetBrains que sí te lee Lua)
    draw_custom_text(cr, 65, 80, "Victor Mono", 12, "Kernel: " .. kernel, 0.61, 0.54, 0.85, 1, "left")
    draw_custom_text(cr, 210, 80, "Victor Mono", 12, "Uptime: " .. uptime, 0.7, 0.48, 0.77, 1, "left")

    cairo_destroy(cr)
    cairo_surface_destroy(cs)
end
