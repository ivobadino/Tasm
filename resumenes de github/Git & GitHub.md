---
tags:
  - commit
  - repositorios
---


 Para saber más: factores de autenticacion

Github ha estado trabajando para fortalecer la seguridad para el inicio de sesion y el controlador de versiones del proyecto.
 Una de esas medidas es el acceso a través de tokens.

 Articulo al respecto:
https://www.aluracursos.com/blog/exigendia-autenticacion-por-token

 Documentacion:
https://docs.github.com/es/authentication/keeping-your-account-and-data-secure/managing-your-personal-access-tokens

---


## Git Clone y presentacion de la consola

github de microsoft fue inventada para mejorar el uso de git (adquirida por windows al comprarsela al creador de linux).
En la parte code del repositorio vamos a copiar la url del https.
 Los que usamos windows debemos ir al buscador y abrir Git Bash.
 Es importante configurar el git. En la documentacion esta todo lo necesario pero explicaremos ligreamente.
 Para la identidad hay que poner nuestro nombre y el email

- Nombre: 
	`$ git config --global user.name "mi nombre"`

- mail:
	 `$ git config --global user.email miemail@ejemplo.com`

 **IMPORTANTE**: el correo debe ser el mismo que el de github

 - Comando para verificar:
	`$ git config --list`

(al final de la lista esta el nombre y correo.
Si aparecen :, para salir aprete la Q)

 - Para borrar lo que hay en pantalla se utiliza el comando:
	`$ clear`

 - El siguiente comando nos muestra donde estamos dentro de la consola:
	`$ pwd`

 - Para listar todas las carpetas se usa el comando:
	`$ ls`

 - Para acceder a una carpeta se usa el comando:
	`$ cd nombrecarpeta`

 - Para regresar a una carpeta anterior es:
	`$ cd ..`

 Para entrar a una carpeta con git de una forma más sencilla es ir desde el explorador de archivos a la carpeta, apretar click derecho e "iniciar git bash" y nos abrira la consola ya abierta en esa carpeta.
 Es importante no utilizar caracteres especiales para nombrar los archivos, para separar los nombres es importante hacerlo con "-" y no con " _", además de no dejar espacios en blanco y solo utilizar letras minusculas (por si algun so no colabora)

---- 


## Git Clone y Git Log
 

- Para poner un proyecto de github dentro de una carpeta debemos usar el comando
	`$ git clone link

IMPORTANTE: el link es el ya copiado del https desde el repositorio
 Al entrar con cd al archivo entraremos en la rama main (lo veremos más adelante), y al hacer ls veremos los archivos que este proyecto contiene.Sin título

 - Para ver el historial de los cambios de nuestro proyecto se usa el comando:
	`$ git log

 - Que nos mostrara el codigo del commit, quien fue el autor, la fecha y el mensaje de commit.
	 Pero para hacerlo de una forma mas resumida se usa:
	`$ git log --oneline

 En github esto puede verse desde desde el repositorio en el icono del reloj que dice la cantidad de commits, donde entraremos al historial.

----

## Para saber más: Git Clone
 
Con Git Clone es posible crear una copia de desarrollo en un repositorio local, y todos los cambios que realices van a ser gestionados a partir de este repositorio. El comando es utilizado para seleccionar un repositorio existente y crear una copia de él en un repositorio local.
 Por comodidad, la clonacion crea una conexion remota que apunta al repositorio original, y esta conexion facilita mucho la interaccion con el repositorio central.

 - Con el Git Clone se puede clonar un repositorio a una carpeta especifica
	`$ git clone <repositorio> <mi-proyecto>`
	
(el repositorio de "repositorio" se clonara en "mi proyecto")

 Además se puede clonar el repositorio desde una branch especifica diferente a la original
 
	$ git clone .branch nombreBranch <repositorio>

 Para mas data:
https://git-scm.com/docs/git-clone

-----

## Para saber más: Git Log

El Git Log sirve para verificar el historial de cambios, los mensajes de commit, el nombre del autor y otras ramificaciones del proyecto.
 Los commits poseen hashs que los identifican de una manera unica, con Git Log podemos ver el hash.
 - Para visualizar todos los comits, uno en cada linea usamos:
	`$ git log --oneline`

 - Si en lugar de verlo resumido, queremos ver más informacion, como las alteraciones del commit, podemos usar:
	`$ git log -p`

 - Tambien podemos buscar la informacion del autor del commit con el comando:
	`$ git log --author="nombreUsuario"`

 - Y tambien podemos buscar informaciones por fecha:
	`$ git log --since=1.month.ago --until=1.day.ago`

 - Se puede formatear la visualizacion de las informaciones del commit, trayendo el hash seguido del mensaje commit, con el comando:
	`$ git log --pretty="format:%h %s"`

 Para más formas de mostrar las informaciones del commit
https://devhints.io/git-log-format

 Mas info aún:
https://devhints.io/git-log

---


## Git status, add, commit y push

- se puede abrir la carpeta del proyecto desde la consola de Git con:
	`$ code .
 
 Sino se puede desde el mismo VSCode abrir la carpeta del archivo.
 - Para fijarse si nuestro proyecto esta actualizado, que sirve para bajar todos los archivos cuando ya empezamos el repositorio (osea, actualizarlo si se hizo algun cambio desde otro lado), se utiliza el comando:
	`$ git pull`

 - Para verificar el estado del proyecto desde la consola se utiliza el comando:
	`$ git status`

 - En caso que se haya modificado o creado un archivo, el comando git status nos lo dira. Para que se acompañe y las tenga encuenta se utiliza el comando:
	`$ git add nombreArchivo`

 - Pero se puede usar otro para que directamente agregue todos, en caso de ser más de uno:
	`$ git add `

 - Antes de enviarlo al remoto debe realizarse el commit del proyecto
	`$ git commit -m "mensaje del commit"`

 - Pero ese comando no lo envia a github, por lo que luego de usarlo y realizar el commit debemos utilizar el siguiente codigo:
	`$ git push`

---


## Para saber más: open source

El código abierto es un código diseñado para que cualquier persona pueda acceder a él de forma abierta y pueda verlo, modificarlo y distribuirlo según sus necesidades.

 Mas data:
https://www.aluracursos.com/blog/open-source-una-breve-introduccion

---


## Git Diff y Git Restore

Para ver las modificaciones que se hicieron al archivo, podemos entrar desde el github al archivo donde se realizo el commit, que nos pondra en rojo las lineas de codigo eliminadas y en verde las agregadas.
 Para hacerlo a traves de la consola se utiliza el comando
	`$ git diff nombreArchivo

 Si yo quiero volver a una version anterior de un archivo, osea, restaurarlo, se utiliza:
	`$ git restore --source hashDelCommit nombreArchivo

 Donde el nombre del archivo es el que quiero y el hash es el de la version especifica que quiero volver a traer (el codigo que sale a la izquierda del log)

---
# utilizando github con obsidian

