# FOOTBALL CHATTERBOT - Documentación. 
 
## ¿Qué es "Football Chatterbot"?

* #### ¿Qué es? 
Es un programa que utiliza archivos de texto para guardar, agregar o quitar información acerca del fútbol. Posee algoritmos de reconocimiento de texto por palabra clave para poder conversar con la máquina a través de la entrada del usuario, resultando en una salida aleatoria de la información buscada acerca de algún jugador específico, algún director técnico o un club (incluyendo los apodos comunes).  

* #### ¿Para qué sirve?
Este programa escrito en su totalidad en el lenguaje de programación Pascal, fue diseñado con el propósito de brindar información instantánea acerca de fútbol general. La utilidad real se la puedes dar tú, ya que es posible agregar múltiples palabras claves para ciertas respuestas sin ningún tipo de restricción.

* #### ¿Al ejecutarlo, con qué nos encontraremos?

Un menú principal con la leyenda "Football Chatterbot". Luego, será enviado a un menú de selección. 

**1) Iniciar:** La interfaz busca simular una conversación al estilo red social, y permite charlar con el bot de manera natural. Reconoce las palabras del archivo `datos.txt` dentro de la carpeta "data".

> [!CAUTION]
> El archivo "datos.txt" OBLIGATORIAMENTE DEBE existir para ejecutar *"Iniciar*". En el caso de no existir por favor redescargue **[`datos.txt`](https://github.com/balta-dev/chatterbot/blob/main/data/datos.txt)**. En el caso de que el archivo sea inalcanzable o desea no utilizarlo, debe entrar en "Administrador" para crearlo desde cero.

**2) Configuraciones:** Es una interfaz de configuraciones almacenadas en un archivo de texto llamado `config.txt`. Es posible modificar: *"Nombre de Usuario", "Color de Texto", "Ignorar Menú", "Guardar Chat Automáticamente", "Completado de Texto Progresivo", y Música.* El nombre de usuario se genera automáticamente al crear el archivo `config.txt` dentro de la carpeta "data", y se obtiene del usuario del sistema operativo.

**3) Administrador:** Gestor del archivo "datos.txt". Con este, podrás facilmente agregar, modificar, eliminar o consultar cualquier palabra clave o respuestas registradas en el archivo. También, si por algun motivo no existiese "datos.txt", este apartado lo genera desde cero y permite la total modificación. Con él que se es capaz de:
- **Agregar**: Se puede agregar una **respuesta de una palabra clave** existente o una totalmente nueva (se creará en ese mismo momento). Es posible también anexar **nuevas palabras claves** a respuestas existentes.
> [!NOTE]
> Aclaración: Si desea ingresar una palabra clave QUE NO EXISTE, ingrese la opción (1).

- **Borrar:** Se puede borrar una **respuesta de palabra clave** o una **palabra clave**. Si existe una única palabra clave asociada a una o más respuestas, entonces se borrará tanto la palabra clave como todas las respuestas.

- **Modificar:**
Se puede modificar la **palabra clave** por si misma y/o las **respuestas** que posee con total libertad.

- **Consultar:** Únicamente permite consultar por **palabra clave.**


## ¿Cómo lo compilo?

#### Si quieres modificar el código y/o compilarlo, debes cumplir ciertos prerrequisitos:

1. Si no tenes un compilador de Pascal, ingresá a la [página oficial de Free Pascal](https://www.freepascal.org/download.html) y descargá el binario adecuado a tu sistema operativo. También se puede instalar desde la consola al paquete `fpc`.

2. Cloná el repositorio (opcional, podes simplemente descargar el ZIP y descomprimirlo).
   ```sh
   git clone https://github.com/balta-dev/chatterbot.git
   ```
3. Ingresá a la carpeta base y compilá el archivo `chatterbot.pas` con:
   ```js
   fpc chatterbot.pas
   ```
4. Ejecuta el archivo
	```js
   ./chatterbot
   ```
## ¿Qué contiene el chatterbot?

Está diseñado con archivos de texto editable para facilitar la manipulación de los datos fuera del sistema del chatterbot, es importante recordar que esta es una práctica no recomenda ya que puede alterar el correcto funcionamiento del programa. Toda la información es modificable a gusto, es decir, se podría transformar el chatterbot para que reconozca cualquier tipo de información. Posee algunas palabras clave especiales como dia y hora para poder brindar información actual. 

##### Al correrlo por primera vez, se genera automáticamente un archivo llamado `config.txt` dentro de la carpeta "data". Éste contiene la siguiente información:
- **Nombre de Usuario:** De manera predeterminada, este programa ejecuta una instrucción GetUserDir para poder acceder al nombre de usuario del sistema operativo (testeado en Windows/Linux).

- **Color de texto del BOT:** Por defecto, amarillo. Esta opción hace uso de la función textcolor. El usuario debe seleccionar algún número entre 1 y 15. De manera intencional, la opción de color Negro fue deshabilitada para evitar que el texto se vuelva invisible. 

- **Ignorar menu:** Simplemente alterna entre tener el menú principal donde se observa la leyenda Football Chatterbot escrito con caracteres ASCII.

- **Guardar chat automáticamente:** El chatterbot es capaz de guardar la conversación que tuviste. Esta opción genera un archivo .txt que se almacena en la carpeta chat. También es posiblemente simplemente, en ejecución del chatterbot, pedirle al mismo que guarde el chat (sin activar esta opción).

- **Completado de texto progresivo:** Existe la posibilidad de altenar entre texto escrito automáticamente o de manera progresiva. Esta opción es meramente estética.

- **Musica:** Este bot utiliza las librería/biblioteca MMSystem para poder hacer uso del procedimiento mciSendString, capaz de ejecutar archivos de audio. Posee integrado una biblioteca de 22 canciones dentro de la carpeta music. El programa hace una búsqueda dentro de la misma y elige una canción de manera aleatoria. Es posible que no exista ninguna canción.
> [!NOTE]
> La opción *"Música"* está únicamente disponible para Windows, ya que utiliza una biblioteca parte del API Microsoft Multimedia. Si ocupa Linux, esta opción no tiene ningún efecto (es recomendable que borre la carpeta "music" para liberar espacio en disco, si así lo desea).

También se posee un archivo `generic.txt` que se utiliza en caso de no encontrar una palabra clave dentro del texto ingresado (si no se dispone de ese archivo, tiene hardcodeado una respuesta básica). Este archivo contiene una lista de posibles palabras claves que el programa lee y selecciona de manera aleatoria en medio de una conversación.

## ALGORITMOS - ¿Qué hace internamente? 

* Tiene un manejador `handler.pas` que analiza la palabra clave ingresada dentro de un procedimiento que busca la mísma en una lista enlazada con memoria dinámica generada con todos los elementos de `datos.txt`. Contiene al menu "Administrador" y se encarga de la manipulación de los datos (ABMC) en general. Algunas acciones requiere generar una sublista que contenga a una parte de la lista original o contener casi todos los elementos (exceptuando el que se quita de la lista). La implementación anterior requería generar un vector de miles de elementos (fijo, si se agregan más crashea) que ocupaba innecesariamente mucha memoria y tiempo, ahora las limitaciones están dentro de Pascal y las restricciones con los rangos de las variables. Dentro, tiene un manejador de log para guardar el chat conversado con el bot. 

* Tiene un manejador de archivos `configuraciones.pas` que se encarga de gestionar los datos de configuraciones. Si no existe previamente, se genera uno desde cero con valores predeterminados. Si ya se creó el archivo pero falta algún dato en el archivo `config.txt`, se borra y crea desde cero con valores predeterminados.

* Tiene una unit `paginas.pas` que sirve de manejador de páginas que permite ver chats viejos en la misma sesión. Comprueba que la pantalla sea suficiente para mostrar los mensajes completamente, un sistema para subir o bajar página (crea sublistas y restaura una página utilizando los procedimientos de las ventanas flotantes).
* Tiene un manejador de música `music.pas` que se encarga de crear el formato para elegir aleatoriamente una canción, colocarle nombre y reproducirla en medio de la ejecución del programa. Viene incluída una carpeta llamada "music" que almacena 22 canciones en formato .mp3. No está disponible su uso en Linux.
* Tiene una unit `dia.pas` que crea el formato para mostrar el día actual.
* Tiene un manejador de respuestas `respuestas.pas`, donde se seleccionan aleatoriamente de `datos.txt` o utiliza respuestas genéricas de `generic.txt` dependiendo la situación.
* Tiene una unit `visuales.pas` que se encarga de la generación de los gráficos del programa.
