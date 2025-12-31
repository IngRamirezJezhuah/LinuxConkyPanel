-- Script para dibujar fondo redondeado
require 'cairo'

function conky_draw_bg()
    if conky_window == nil then return end
    local cs = cairo_xlib_surface_create(conky_window.display, conky_window.drawable, conky_window.visual, conky_window.width, conky_window.height)
    local cr = cairo_create(cs)
    
    local w = conky_window.width
    local h = conky_window.height
    local r = 20 -- Radio de la curvatura
    
    -- Dibujar rectángulo redondeado
    cairo_move_to(cr, r, 0)
    cairo_line_to(cr, w - r, 0)
    cairo_curve_to(cr, w, 0, w, 0, w, r)
    cairo_line_to(cr, w, h - r)
    cairo_curve_to(cr, w, h, w, h, w - r, h)
    cairo_line_to(cr, r, h)
    cairo_curve_to(cr, 0, h, 0, h, 0, h - r)
    cairo_line_to(cr, 0, r)
    cairo_curve_to(cr, 0, 0, 0, 0, r, 0)
    cairo_close_path(cr)
    
    cairo_set_source_rgba(cr, 0, 0, 0, 0.6) -- Color negro con 60% transparencia
    cairo_fill(cr)
    
    cairo_destroy(cr)
    cairo_surface_destroy(cs)
end
