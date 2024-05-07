//////////////////////////////  CHATTERBOT /////////////////////////////////

Documentaci�n:

* �Qu� es Football Chatterbot? 
Es un programa que utiliza archivos para guardar, agregar o quitar informaci�n acerca del f�tbol. Posee algoritmos de reconocimiento de texto por palabra clave para poder �conversar� con la m�quina a trav�s de la entrada del usuario, resultando en una salida aleatoria de la informaci�n buscada acerca de alg�n jugador espec�fico, alg�n director t�cnico o un club (incluyendo los apodos comunes).  

* �Para qu� sirve?
Este programa escrito en su totalidad en el lenguaje de programaci�n �Pascal� fue dise�ado con el prop�sito de brindar informaci�n instant�nea acerca de f�tbol general.

* �Al ejecutarlo, con qu� nos encontraremos?

A) La ejecuci�n normal del chatterbot. Se reconoce como la primera opci�n �Iniciar�. La interfaz es simple, pero permite �charlar� con el bot de manera natural. Posee un archivo �generic.txt� que se ejecuta en caso de no encontrar una palabra clave dentro del texto ingresado. Si no se dispone de ese archivo, entonces se asigna una palabra clave especial dentro de �datos.txt�.  

B) Adem�s de lo anteriormente mencionado, este chatterbot dispone de una interfaz de configuraciones almacenadas en un archivo de texto .txt llamado �config.txt�. La informaci�n editable es:
- Nombre de Usuario: De manera predeterminada, este programa ejecuta una instrucci�n �GetUserDir� para poder acceder al nombre de usuario de Windows.
- Color de texto del BOT: Por defecto, amarillo. Esta opci�n hace uso de la funci�n �textcolor�. El usuario debe seleccionar alg�n n�mero entre 1 y 15. De manera intencional, la opci�n de color �Negro� fue deshabilitada para evitar que el texto se vuelva invisible. 
- Ignorar menu: Simplemente alterna entre tener el men� principal donde se observa la leyenda �Football Chatterbot� escrito con caracteres ASCII.
- Guardar chat autom�ticamente: El chatterbot es capaz de guardar la conversaci�n que tuviste. Esta opci�n genera un archivo �.txt� que se almacena en la carpeta �chatLog�. Tambi�n es posiblemente simplemente, en ejecuci�n del chatterbot, pedirle al mismo que guarde el chat (sin activar esta opci�n).
- Completado de texto progresivo: Existe la posibilidad de altenar entre texto escrito autom�ticamente o de manera progresiva. Esta opci�n es meramente est�tica.
- Musica: Este bot utiliza las librer�a/biblioteca MMSystem para poder hacer uso del procedimiento �mciSendString�, capaz de ejecutar archivos de audio. Posee integrado una biblioteca de 22 canciones dentro de la carpeta �music�. El programa hace una b�squeda dentro de la misma y elige una canci�n de manera aleatoria. Es posible que no exista ninguna canci�n.

C) Posee tambi�n un men� de Administrador para hacer uso de la manipulaci�n de la informaci�n que dispone el chatterbot posible, con el que se es capaz de:
- Buscar por palabra clave.
- Listar todas las palabras clave.
- Agregar palabras clave.
- Quitar palabras clave.
- Modificar palabra clave existente: Respeta la cantidad de posibles respuestas de la palabra clave original (si es que existe). Se puede modificar la palabra clave por si misma y las respuestas que pose�a. Si se desea escribir un n�mero personalizado de posibles respuesta se debe quitar la palabra clave y agregarla nuevamente.

Nota: Es necesaria la existencia del archivo �datos.txt� para que el chatterbot pueda ejecutarse. Si no se dispone del mismo, el programa obliga al usuario a crearlo por cuenta propia (dado el caso de que el archivo datos.txt no exista porque el usuario haya movido o borrado el archivo accidentalmente). 
Toda la informaci�n es modificable a gusto, es decir, se podr�a transformar el chatterbot para que reconozca cualquier tipo de informaci�n. Posee algunas palabras clave especiales como �dia� y �hora� para poder brindar informaci�n actual (son prescidibles).
