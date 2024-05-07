//////////////////////////////  CHATTERBOT /////////////////////////////////

Documentación:

* ¿Qué es Football Chatterbot? 
Es un programa que utiliza archivos para guardar, agregar o quitar información acerca del fútbol. Posee algoritmos de reconocimiento de texto por palabra clave para poder “conversar” con la máquina a través de la entrada del usuario, resultando en una salida aleatoria de la información buscada acerca de algún jugador específico, algún director técnico o un club (incluyendo los apodos comunes).  

* ¿Para qué sirve?
Este programa escrito en su totalidad en el lenguaje de programación “Pascal” fue diseñado con el propósito de brindar información instantánea acerca de fútbol general.

* ¿Al ejecutarlo, con qué nos encontraremos?

A) La ejecución normal del chatterbot. Se reconoce como la primera opción “Iniciar”. La interfaz es simple, pero permite “charlar” con el bot de manera natural. Posee un archivo “generic.txt” que se ejecuta en caso de no encontrar una palabra clave dentro del texto ingresado. Si no se dispone de ese archivo, entonces se asigna una palabra clave especial dentro de “datos.txt”.  

B) Además de lo anteriormente mencionado, este chatterbot dispone de una interfaz de configuraciones almacenadas en un archivo de texto .txt llamado “config.txt”. La información editable es:
- Nombre de Usuario: De manera predeterminada, este programa ejecuta una instrucción “GetUserDir” para poder acceder al nombre de usuario de Windows.
- Color de texto del BOT: Por defecto, amarillo. Esta opción hace uso de la función “textcolor”. El usuario debe seleccionar algún número entre 1 y 15. De manera intencional, la opción de color “Negro” fue deshabilitada para evitar que el texto se vuelva invisible. 
- Ignorar menu: Simplemente alterna entre tener el menú principal donde se observa la leyenda “Football Chatterbot” escrito con caracteres ASCII.
- Guardar chat automáticamente: El chatterbot es capaz de guardar la conversación que tuviste. Esta opción genera un archivo “.txt” que se almacena en la carpeta “chatLog”. También es posiblemente simplemente, en ejecución del chatterbot, pedirle al mismo que guarde el chat (sin activar esta opción).
- Completado de texto progresivo: Existe la posibilidad de altenar entre texto escrito automáticamente o de manera progresiva. Esta opción es meramente estética.
- Musica: Este bot utiliza las librería/biblioteca MMSystem para poder hacer uso del procedimiento “mciSendString”, capaz de ejecutar archivos de audio. Posee integrado una biblioteca de 22 canciones dentro de la carpeta “music”. El programa hace una búsqueda dentro de la misma y elige una canción de manera aleatoria. Es posible que no exista ninguna canción.

C) Posee también un menú de Administrador para hacer uso de la manipulación de la información que dispone el chatterbot posible, con el que se es capaz de:
- Buscar por palabra clave.
- Listar todas las palabras clave.
- Agregar palabras clave.
- Quitar palabras clave.
- Modificar palabra clave existente: Respeta la cantidad de posibles respuestas de la palabra clave original (si es que existe). Se puede modificar la palabra clave por si misma y las respuestas que poseía. Si se desea escribir un número personalizado de posibles respuesta se debe quitar la palabra clave y agregarla nuevamente.

Nota: Es necesaria la existencia del archivo “datos.txt” para que el chatterbot pueda ejecutarse. Si no se dispone del mismo, el programa obliga al usuario a crearlo por cuenta propia (dado el caso de que el archivo datos.txt no exista porque el usuario haya movido o borrado el archivo accidentalmente). 
Toda la información es modificable a gusto, es decir, se podría transformar el chatterbot para que reconozca cualquier tipo de información. Posee algunas palabras clave especiales como “dia” y “hora” para poder brindar información actual (son prescidibles).
