using Distributions
using Statistics
include("func.jl")
#-------------------
#En este archivo se programan dos funciones, una es pso_one la cual aplica el algortimo pso para funciones de R en R,
#la función pso_multi aplica el mismo algoritmo de pso pero este es aplicable para funciones de R^n en R.
#-------------------

#----------------------------------------------------------
#PSO en una dimensión 
#-----------------------------------------------------------
function pso_one(l, u, f, Part_N=50, Max_iter=1000)
    d = 1
    x = l .+ rand(Uniform(0,1), Part_N,d) .* (u - l) # Creación de las particulas
    obj_func = f.(x) #Evaluamos los valores de la función 
  
    glob_opt = minimum(obj_func) # Obtimo global 
    ind = argmin(obj_func)[1] # Indice del optimo global
  
    G_opt = x[ind,:] .* ones(Part_N,d)  #Mejor particula global
  
    Mejor_pos = [x[ind]] #Mejor posición por particula
  
    Loc_opt = x
  
    v = zeros(Part_N,d)
  
    t = 1
  
    Nva_obj_func = zeros(1,Part_N)
    Evol_func_obj = zeros(1,Max_iter)
    while t < Max_iter # Iteración para tener una aproximación al punto crico
      v = v .+ rand(Uniform(0,1), Part_N,d) .* (Loc_opt - x) + rand(Part_N,d) .* (G_opt - x)
      x = x .+ v
  
      for i=1:Part_N # Verificación de que la particula sigue en el espacio de busqueda
        if x[i] > u[1]
          x[i] = u[1]
        elseif x[i] < l[1]
          x[i] = l[1]
        end
        Nva_obj_func[i] = f(x[i]) # Se evaluan las nuevas posiciones de la función objetivo
        if Nva_obj_func[i] < obj_func[i]
          # Se actuliza el obtimo local
          Loc_opt[i] = x[i]
          # Actualiza la función objetivo
          obj_func[i] = Nva_obj_func[i]
        end
      end
      
      Nvo_glob_opt = minimum(obj_func)
      ind = argmin(obj_func)[1]
  
      if Nvo_glob_opt < glob_opt # Si se encuentra una mejor partícula esta se actualiza
        glob_opt = Nvo_glob_opt
        G_opt[:] = x[ind] .* ones(Part_N,d)
        Mejor_pos = [x[ind]]
      end
      Evol_func_obj[t] = glob_opt
      t += 1;
    end
    
    return Mejor_pos #Se decuelve la mejor partícula encontrada
  end

#-----------------------------------------
#PSO Multidimensional
#-----------------------------------------
function pso_multi(d, l, u, Part_N, Max_iter,f)
    x = l' .+ rand(Uniform(0,1), Part_N, d) .* (u - l)' # Se crean la particulas
    obj_func = [f(x[i, :], d) for i=1:Part_N] #Evaluamos los valores de la función 
    glob_opt = minimum(obj_func) # Obtimo global 
    ind = argmin(obj_func) #índice del obtimo global
    G_opt = reshape(x[ind, :], 1, d) * ones(d, Part_N) 
    Mejor_pos = x[ind, :]
    Loc_opt = x
    v = zeros(Part_N, d) # Vector de velocidades iniciales
    Nva_obj_func = zeros(1, Part_N) #Mejor particula global
    Evol_func_obj = zeros(1, Max_iter)

    t = 1
  
    while t < Max_iter  # Iteración para tener una aproximación al punto crico
      v = v .+ rand(Uniform(0,1), Part_N, d) .* (Loc_opt - x) .+ rand(d)' .* (G_opt' .- x)
      x = x .+ v
      
      for i=1:Part_N # Se verifica que todas las partículas estan en la region de busqueda
        if x[i, :] > u
          x[i, :] = u
        elseif x[i, :] < l
          x[i, :] = l
        end
        
        Nva_obj_func[i] = f(x[i, :], d) # Se evaluan las nuevas posiciones de la función objetivo
        if Nva_obj_func[i] < obj_func[i]
          # Se actuliza el obtimo local
          Loc_opt[i, :] = x[i, :]
          # Actualiza la función objetivo
          obj_func[i] = Nva_obj_func[i]
        end
      end
  
      Nvo_glob_opt = minimum(obj_func)
      ind = argmin(obj_func)
  
      if Nvo_glob_opt < glob_opt # Si se encuentra una mejor partícula esta se actualiza
        glob_opt = Nvo_glob_opt
        G_opt[:] = reshape(x[ind, :], 1, d) * ones(d, Part_N)
        Mejor_pos = x[ind, :]
      end
      Evol_func_obj[t] = glob_opt
  
      t += 1
    end
    
    return Mejor_pos #Se decuelve la mejor partícula encontrada
  end