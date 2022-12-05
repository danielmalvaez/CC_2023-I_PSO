
#------------------------------------
#PSO con MPI en una dimension.
#-----------------------------------

using MPI
using Dates
include("func.jl")
include("PSO.jl")

MPI.Init()
comm = MPI.COMM_WORLD
rank = MPI.Comm_rank(comm)
size = MPI.Comm_size(comm)

if rank == 0
  T_i = now()
end

d = 2
a = [-10, -10]
b = [10, 10]
Part_N = 120
Max_iter = 200

Num_P = Part_N ÷ size

min_act = pso_multi(d, a, b, Num_P, Max_iter,f1_multi)
if rank != 0
  MPI.send(min_act, comm; dest=0, tag=0)
else
  RES_MIN = zeros(d)
  for i = 1:size-1
    mssgrcv = MPI.recv(comm; source=i, tag=0)
    minimo = min(f1_multi(RES_MIN, d),f1_multi(mssgrcv, d))

    # Guardar mínimo
    if minimo ==f1_multi(RES_MIN, d)
      global RES_MIN = RES_MIN
    else
      global RES_MIN = mssgrcv
    end
  end
end

if rank == 0
  println("El valor mínimo está en x=$(RES_MIN)")
  T_f = now()
  println("Tiempo de ejecución: $(T_f- T_i)")
end


MPI.Barrier(comm)
MPI.Finalize()