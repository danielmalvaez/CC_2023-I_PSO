#--------------------------------
#Funciones de una dimensión
#--------------------------------
function f1_one(x,d=1)
  x = x[1]
  return (x^4)-(x^3)-10*(x^2)+4*(x)+24
end

function f2_one(x)
  #return exp(x) + x^2
  return x^2
end
#--------------------------------
#Funciones de varias dimensiones
#---------------------------------
function f1_multi(x,d=2)
    return (x[1])^2 + (x[2])^2
  end
  
function f2_multi(x, d=2) #Ecuación de Resenbrock
  res = 0
  for i = 1:d-1
    res += 100*(x[i+1]-x[i]^2)^2 + (1-x[i])^2
  end
  return res  
end
