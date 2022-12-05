# Particle Swarm Optimization en Julia y C 💻

**Integrantes del equipo:**

* Malváez Flores Axel Daniel
* Peralta Rionda Gabriel Zadquiel


## Objetivo del Proyecto
El objetivo del proyecto es presentar los conceptos básicos del algortimo de optimización por enjambre de partículas ("Particle Swarm Optimization",PSO) al igual que hacer una implementación de este algoritmo en el lenguaje de programación Julia y C haciendo uso de memoria distribuida.

## Carpetas
### docs
Carpeta que contiene el archivo en pdf que explica detalladamente cada parte del proyecto desde una introducción al algoritmo hasta las implementaciones en Julia y C.

### main

Contiene dos **subcarpetas** en las que se encuentran los archivos ya sea para el lenguaje de programación:

* C
* Julia

se implementó el algoritmo secuencial de una dimensión para Julia, el algoritmo en paralelo utilizando la librería MPI para Julia y C y en paralelo para varias dimensiones en Julia.

### results

Contiene dos **subcarpetas** en las que se encuentran los archivos ya sea para el lenguaje de programación:

* C
* Julia

y los cuales son archivos en formato .txt que contienen una serie de ejecuciones de los algoritmos con su respectivo tiempo (que tarda en correr el programa).


## PSO
### Algoritmo PSO
1. Inicializar la población de las partículas
2. Evaluar la población en la función objetivo y elegir la mejor partícula 
3. while (criterio de paro)
4. for (todas las particulas en todas las dimensiones)
5. Generar una nueva velocidad
6. Calcular una nueva posición
7. Evaluar la función objetivo y elegir la mejor partícula
8. end for
9. Actualizar la mejor partícula de la población
10. end while


