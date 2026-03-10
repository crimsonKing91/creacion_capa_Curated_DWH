Entonces primero se crean las tablas dimeciones y luego las de hechos?
El orden canónico y obligatorio en una arquitectura de modelo estrella siempre es: Primero las Dimensiones, después los Hechos.

Duda, cuando se están construyendo las tablas dimensión, la tabla desestandarizada ya debió haber tenido procesos de transformación cierto? o aqui tambien se aplican transformaciones? cual 
es el canon para los data wearhouse?

RESPUESTA:
Ambos enfoques existen, pero el canon moderno para Data Warehouses en la nube (como Synapse) es aplicar las transformaciones después de cargar la tabla Staging, justo en el momento de crear las Dimensiones y los Hechos.


