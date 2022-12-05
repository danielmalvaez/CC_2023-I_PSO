# Main

Esta carpeta contiene en dos subcarpetas los archivos en C y los de Julia.


	
* C:   
	Los siguientes archivos (compilados) ejecutables se obtuvieron con la función `mpicc -W PSO_MPI.c -o pso_mpi_f`
	* pso_mpi	_f
	* pso_mpi\_f2

	El siguiente archivo es el que contiene el código en C   
	
	* PSO_MPI.c

* Julia:   
	Funciones que tienen tanto las funciones (en las que evaluaremos) y la función del método PSO (secuencial, una variable y varias variables) que encuentra en este caso un mínimo global para dos funciones de R en R:   
	* func.jl
	* PSO.jl

	Archivos main que hacen uso de la librería MPI y la cual ayuda a ejecutar nuestro código en paralelo. Contienen la implementación en memoria distribuida del PSO en una o varias dimensiones:   
	


	* MPI_multi.jl
	* MPI_one.jl
	
### Ejecutar

* C:   
	Se ejecutan los archivos **pso_mpi\_f** y **pso_mpi\_f2** con los siguientes comandos: 
	
	`mpirun -n 12 ./pso_mpi_f`   
	`mpirun -n 12 ./pso_mpi_f2`
	
* Julia:   
	Se ejecutan los archivos con los siguientes comandos: 
	
	`mpexec -n 12 MPI_one.jl`