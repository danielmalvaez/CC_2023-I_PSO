# Main

Esta carpeta contiene en dos carpetas los archivos en C y los de Julia.


	
* C:   
	Los siguientes archivos (compilados) ejecutables se obtuvieron con la función `mpicc -W PSO_MPI.c -o pso_mpi_f`
	* pso_mpi	_f
	* pso_mpi\_f2

	El siguiente archivo es el que contiene el código en C   
	
	* PSO_MPI.c

* Julia:
	* 
	
	
### Ejecutar

* C:   
	Se ejecutan los archivos **pso_mpi\_f** y **pso_mpi\_f2** con los siguientes comandos: 
	
	`mpirun -n 12 ./pso_mpi_f`   
	`mpirun -n 12 ./pso_mpi_f2`