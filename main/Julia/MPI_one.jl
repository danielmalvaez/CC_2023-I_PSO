
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

d = 1 
a = -6
b = 6

Part_N = 1200
Num_P = Part_N ÷ size

min_act = pso_one(a,b,f2_one, Num_P, 2000)

if rank != 0
  MPI.send(min_act, comm; dest=0, tag=0)
else
  RES_MIN = zeros(d)
  for i = 1:size-1
    mssgrcv = MPI.recv(comm; source=i, tag=0)
    minimo = min(f2_one(RES_MIN[1]), f2_one(mssgrcv[1]))

    # Guardar mínimo
    if minimo == f2_one(RES_MIN[1])
      global RES_MIN = RES_MIN
    else
      global RES_MIN = mssgrcv
    end
  end
end

if rank == 0
  println("El valor mínimo está en x=$(RES_MIN[1])")
  T_f = now()
  println("Tiempo de ejecución: $(T_f- T_i)")
end

MPI.Barrier(comm)
MPI.Finalize()