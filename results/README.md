# Results

Se realizaron las pruebas de speed up en ambas implementaciones ya sea para Julia o para C. Creamos un archivo que contiene las pruebas de nuestro PSO_MPI con el siguiente comando:

* Julia   
```
for run in {1..10}; do mpiexec -n 12 julia pso_mpi.jl >> Pruebas_one_MPI.txt
```

* C   
```
for run in {1..10}; do mpirun -n 12 ./pso_mpi_f >> results_pso_time_f.txt
```
 