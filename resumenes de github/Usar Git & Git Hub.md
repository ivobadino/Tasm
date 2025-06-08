

---
# como usar distintas ramas

¡Excelente pregunta! Trabajar con ramas es una de las características más potentes y fundamentales de Git. Permite a los desarrolladores trabajar en nuevas características, correcciones de errores o experimentos de forma aislada, sin afectar la rama principal (generalmente main o master).

Aquí te explico cómo trabajar con distintas ramas en Git:

Conceptos Clave de las Ramas
Rama (Branch): Esencialmente, una rama es un puntero móvil a un commit. Cuando creas una rama, estás creando un nuevo puntero. Cuando haces un commit, la rama a la que apunta el puntero se mueve hacia adelante con el nuevo commit.
HEAD: Es un puntero especial que apunta a la rama actual en la que te encuentras.
main (o master): Es la rama por defecto, donde se suele mantener el código estable y listo para producción.
Aislamiento: Los cambios en una rama no afectan a otras ramas hasta que las fusionas (merge).
Comandos para Trabajar con Ramas
Vamos a asumir que estás en tu repositorio Git local.

1. Ver todas las ramas existentes:

Para ver una lista de todas las ramas en tu repositorio local y la rama en la que te encuentras actualmente:


    git branch

La rama actual estará marcada con un asterisco (*).
Para ver también las ramas remotas, usa:

    git branch -a

2. Crear una nueva rama:

Para crear una nueva rama, dale un nombre descriptivo relacionado con la característica o la tarea que vas a realizar (por ejemplo, feature/nueva-navegacion o fix/bug-login).


    git branch <nombre-de-la-rama>
Ejemplo:


    git branch feature/contacto
Esto crea la rama, pero no te cambia a ella. Sigues en la rama donde estabas.

3. Cambiar a una rama existente (Checkout):

Para moverte a una rama diferente y empezar a trabajar en ella:


    git checkout <nombre-de-la-rama>
Ejemplo:


    git checkout feature/contacto
Después de ejecutar este comando, los archivos en tu directorio de trabajo cambiarán para reflejar el estado de la rama a la que te cambiaste.

4. Crear una nueva rama y cambiarte a ella inmediatamente:

Este es un atajo muy común y útil. Combina los pasos 2 y 3:

    git checkout -b <nombre-de-la-nueva-rama>
Ejemplo:

    git checkout -b feature/galeria-imagenes
Esto creará la rama feature/galeria-imagenes y automáticamente te cambiará a ella.

5. Fusionar (Merge) una rama en otra:

Una vez que has terminado de trabajar en una rama (por ejemplo, feature/contacto) y tus cambios están listos, querrás incorporarlos a otra rama (normalmente main o master).

Primero, cámbiate a la rama que va a recibir los cambios (la rama "destino"). Generalmente, es main o master:

    git checkout main
Asegúrate de que tu rama destino esté actualizada con los últimos cambios del remoto (si estás trabajando en equipo):

    git pull origin main # O git pull origin master
Ahora, fusiona la rama de la que vienen los cambios (feature/contacto) en tu rama actual (main):

    git merge feature/contacto
Fast-Forward Merge: Si la rama que estás fusionando no se ha desviado de la rama destino, Git simplemente moverá el puntero de la rama destino hacia adelante.
Three-Way Merge: Si ambas ramas han tenido commits desde que se ramificaron, Git intentará combinar los cambios. Esto puede generar un "merge commit" (un commit adicional que registra la fusión) y, a veces, conflictos de merge si Git no puede decidir cómo combinar los cambios automáticamente.
6. Resolver Conflictos de Merge:

Si git merge resulta en conflictos (Git te lo indicará), significa que los mismos archivos fueron modificados en ambas ramas de manera incompatible.

Git marcará los archivos con conflicto.
Usa git status para ver qué archivos están en conflicto.
Edita manualmente los archivos con conflicto: Abre los archivos marcados por Git. Verás marcadores como <<<<<<<, =======, >>>>>>> que indican dónde están los conflictos. Edita el archivo para que el código quede como quieres que sea.
Una vez que hayas resuelto los conflictos en un archivo, agrégalo al staging:

    git add <archivo-con-conflicto>
Cuando hayas resuelto todos los conflictos y agregado los archivos, completa el merge commit:

    git commit
Git abrirá tu editor de texto predeterminado con un mensaje de commit generado. Puedes aceptarlo o modificarlo.
7. Eliminar una rama:

Una vez que una rama ha sido fusionada y ya no la necesitas, es una buena práctica eliminarla para mantener limpio tu repositorio.

Eliminar rama localmente:

    git branch -d <nombre-de-la-rama>
(La bandera -d es para "delete" y solo eliminará la rama si ya ha sido fusionada. Si no ha sido fusionada y quieres forzar la eliminación, usa -D).
Eliminar rama remotamente (en GitHub/GitLab, etc.): Después de eliminar la rama localmente, también querrás eliminarla del repositorio remoto:

    git push origin --delete <nombre-de-la-rama>
Ejemplo:

    git push origin --delete feature/contacto
8. Subir una nueva rama al repositorio remoto:

Si creas una rama localmente y quieres que esté disponible en GitHub (para colaboradores o para respaldar tu trabajo), debes empujarla:


    git push -u origin <nombre-de-la-rama>
-u (o --set-upstream): Establece un seguimiento entre tu rama local y la rama remota, para que futuras operaciones push/pull sean más sencillas.
Flujo de Trabajo Típico con Ramas
Actualiza tu rama principal:

    git checkout main
    git pull origin main
Crea una nueva rama para tu tarea:

    git checkout -b feature/mi-nueva-caracteristica
Realiza tus cambios, agrega y haz commits:

# Edita archivos...
    git add .
    git commit -m "Implementada la funcionalidad X"
# Sigue haciendo commits a medida que trabajas...
  Sube tu rama al remoto (para respaldo o revisión):

    git push -u origin feature/mi-nueva-caracteristica
Cuando termines, abre una Pull Request en GitHub (si trabajas en equipo) para que otros revisen tu código.
Una vez aprobada la Pull Request, fusiónala en main (generalmente desde la interfaz de GitHub).
Actualiza tu main local y elimina la rama de la característica:
Bash

    git checkout main
    git pull origin main
    git branch -d feature/mi-nueva-caracteristica
    git push origin --delete feature/mi-nueva-caracteristica
    Este flujo de trabajo es el estándar en muchos equipos y te permitirá trabajar de forma organizada y segura con Git. ¡Espero que te sea útil!
