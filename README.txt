Explicacion de eso en caso de que se me olvide oh lo suba a git

Entendimiento del flujo de Datos (Diagramas)

Para que sea visible como tal Conky obtiene la informacion que esta
sinedo programado, aqui se tiene el flujp:

  1 - KERNER linux : El nucleo  del sistema guarda archivos de texto
dinamico en las carpetas como "/proc/" y "/svs/"(donde estas los datos
reales de la temperatura y carga).
  2 - Conky : lee esos archivos cada vez que para por el "uodate_interval"
  3 - Configuracion : Aplica el diseño que definiste en Conky.config
  4 - X11/Wayland : el Servidor grafico dibujo el resultado final en la pantalla

Fuentes que soporta el sistema de conky
Para saber los que puedes realizar son los siguientes

   fc-list : family | grep -i "mono"

1. Modificaciones que puedes hacer YA
 Colores Personalizados
En conky.config puedes definir variables de color para no repetir códigos hexadecimales:

Lua

    color1 = '#00FF00', -- Verde neón
    color2 = '#FF5555', -- Rojo suave
    default_color = '#FFFFFF', -- Blanco
Luego, en conky.text, los usas así: ${color1}Texto en verde ${color2}Texto en rojo.

B. Gráficos dinámicos (Lo que lo hace ver "Pro")
En lugar de solo texto, usa estas funciones en la sección text:

Barras de progreso: ${cpubar 10,150} (Dibuja una barra de 10px de alto por 150px de ancho para el CPU).

Gráficas de historial: ${cpugraph 40,250 0000FF FF0000} (Dibuja una gráfica de carga que cambia de azul a rojo según la intensidad).

C. Transparencia real
Si quieres que el cuadro desaparezca y solo se vea el texto flotando sobre tu fondo de pantalla:

Cambia own_window_type = 'desktop'.

Cambia own_window_transparent = true.

Cambia own_window_argb_visual = true. 


Explicación de las Configuraciones (Conceptos)
Conky es como un "parser" de archivos de sistema. Casi todo lo que ves en el panel viene de archivos en tu PC:

update_interval: Es la frecuencia del bucle principal. Si es 1.0, Conky duerme 1 segundo, despierta, lee los datos, dibuja y vuelve a dormir.

double_buffer: Sin esto, Conky borra la pantalla y luego dibuja. Con esto, dibuja en una "memoria invisible" y luego la intercambia con la visible de golpe. Esencial para evitar parpadeos.

own_window_hints: Son instrucciones para el gestor de ventanas de Linux Mint (Cinnamon).

undecorated: Quita los botones de cerrar/minimizar.

below: Lo mantiene siempre debajo de tus ventanas abiertas.

sticky: Aparece en todos tus escritorios virtuales.

la informacion se saca con man conky

Anatomía de la función draw_ring
Esta es la función que procesa esos números. Es importante entender que tiene dos capas de color:

El Fondo del Anillo (Círculo vacío): En tu código actual tienes esto: cairo_set_source_rgba(cr, 144, 255, 240, 0.26)

¡Ojo! Aquí hay un detalle: Como te decía, Cairo no entiende el "144" o "255". Para que funcione correctamente, estos números deberían ser decimales. Actualmente, al ser mayores a 1, Cairo los interpreta como 1 (blanco total).

La Barra de Progreso (Lo que sube y baja): Aquí es donde se usan los colores que definiste arriba: cairo_set_source_rgba(cr, color[1], color[2], color[3], color[4])

color[1] es el Rojo.

color[2] es el Verde, y así sucesivamente.

Resumen de funciones (Para qué sirve cada una)
Función       Qué hace                    Cómo modificar el color
draw_ring   Dibuja el círculo base        Se cambia en el último parámetro de la
            y el progreso de CPU/RAM.       llamada en conky_main

efecto_
ocilacion   Es esa línea cian que         El color está fijo dentro
            da vueltas.                   de la función: (cr, 0, 1, 1, 0.5)

efecto_2    El arco que se mueve a        También está fijo:
            velocidad 0.4.                (cr, 0, 1, 1, 0.5)

ef_cpu      Tu nueva función rosa/fucsia  Se cambia en cairo_set_source_rgba
                                          (cr, 0.96, 0.15, 0.56, 0.5).
