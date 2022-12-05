/**
 * Objetivo:
 * Programa que utiliza la técnica PSO para encontrar el 
 * mínimo global de dos funciones en R.
 * 
 * Descripción:
 * Programa paralelo que calcula el mínimo global de una función
 * utilizando la libreria MPI para C.
 * 
 * Integrantes:
 * Malváez Flores Axel Daniel
 * Peralta Rionda Gabriel Zadquiel
*/

#include <stdio.h>
#include <mpi.h>
#include <stdlib.h>
#include <time.h>

double pso(int d, double l, double u, double (*f)(double), int Part_N, int Max_iter);
double f(double x);
double f2(double x);
double min(double a, double b);

int main(void) {
    clock_t start, end;
    double execution_time;
    
    start = clock();

    int my_rank, comm_sz, d;
    double a, b, min_act;
    int source;
    int Part_N, Num_P, Max_iter;
    double RES_MIN, mssgrcv, minimo;

    MPI_Init(NULL, NULL);
    MPI_Comm_rank(MPI_COMM_WORLD, &my_rank);
    MPI_Comm_size(MPI_COMM_WORLD, &comm_sz);

    d = 1;
    a = -6;
    b = 6;
    Part_N = 100000;
    Num_P = Part_N / comm_sz;
    Max_iter = 3000;
    min_act = pso(d, a, b, &f, Num_P, Max_iter);

    RES_MIN = 0.0;

    if (my_rank != 0) {
        MPI_Send(&min_act, 1, MPI_DOUBLE, 0, 0, MPI_COMM_WORLD);
    } else {
        RES_MIN = min_act;
        for (source = 1; source < comm_sz; source++) {
            MPI_Recv(&min_act, 1, MPI_DOUBLE, source, 0, MPI_COMM_WORLD, MPI_STATUS_IGNORE);
            minimo = min(f(RES_MIN), f(min_act));
            // Guardamos el mínimo
            if(minimo != f(RES_MIN)){
                RES_MIN = min_act;
            }
        }
    }

    if (my_rank == 0) {
        printf("Con %d procesadores\n", comm_sz);
        printf("El valor minimo esta en x =  %f \n", RES_MIN);
        end = clock();
        execution_time = ((double)(end - start))/CLOCKS_PER_SEC;
        printf("Tiempo de ejecución: %f \n", execution_time);
    }

    MPI_Finalize();

    return 0;
}

/**
 * Función del método PSO
*/
double pso(int d, double l, double u, double (*f)(double), int Part_N, int Max_iter){
    // Generamos las partículas
    double x[Part_N];
    srand(time(NULL)); // randomize seed
    double diff;
    int i;
    diff = u - l;
    for(i = 0; i < Part_N; i++) 
    {
        x[i] = l + ((double) (rand() % RAND_MAX) / (double)RAND_MAX) * diff;
    }


    //Obtenemos el vector de partículas evaluadas en la función objetivo
    double obj_func[Part_N], temp;
    int j;
    for(j = 0; j < Part_N; j++) 
    {
        temp = x[j];
        obj_func[j] = f(temp);
    }

    // Obtenemos el óptimo global
    double glob_opt = obj_func[0];
    int k;
    //Obtenemos el índice del optimo global
    int ind = 0;
    for(k=1; k < Part_N; k++)
    {
        if(glob_opt>obj_func[k])
		    glob_opt = obj_func[k];  
            ind = k;
    }

    //Obtenemos un G_opt de todas las partículas
    double G_opt[Part_N];
    for(i=0; i < Part_N; i++){
        G_opt[i] = x[ind];
    }

    // Obtenemos la mejor posicion
    double Mejor_pos = x[ind];
    double * Loc_opt = x;

    // Vector de velocidad
    double v[Part_N];
    for(i=0; i < Part_N; i++){
        v[i] = 0;
    }

    int t = 1;

    double Nva_obj_func[Part_N];
    double Evol_func_obj[Max_iter];
    for(i = 0; i < Part_N; i++){
        Nva_obj_func[i] = 0;
    }
    for(i = 0; i < Max_iter; i++){
        Evol_func_obj[i] = 0;
    }

    while (t < Max_iter){
        // Actualizacion de la nueva velocidad
        double diff_loc[Part_N], diff_glob[Part_N];
        for(i = 0; i < Part_N; i++){
            diff_loc[i] = Loc_opt[i] - x[i];
            diff_glob[i] = G_opt[i] - x[i];
        }
        double rnd_1, rnd_2;
        rnd_1 = ((double) (rand() % RAND_MAX) / (double)RAND_MAX);
        rnd_2 = ((double) (rand() % RAND_MAX) / (double)RAND_MAX);
        for(i = 0; i < Part_N; i++){
            v[i] = v[i] + rnd_1 * diff_loc[i] + rnd_2 * diff_glob[i];
        }
        for(i=0; i<Part_N; i++){
            x[i] += v[i];
        }

        // Verificación de que la particula sigue en el espacio de busqueda
        for(i = 0; i < Part_N; i++){
            if(x[i] > u){
                x[i] = u;
            } else if (x[i] < l){
                x[i] = l;
            }
            Nva_obj_func[i] = f(x[i]);  // Se evaluan las nuevas posiciones
            if (Nva_obj_func[i] < obj_func[i]){
                // Actualizamos el optimo local
                Loc_opt[i] = x[i];
                // Actualizamos la función objetivo
                obj_func[i] = Nva_obj_func[i];
            }
        }

        double Nvo_glob_opt;
        int idx;
        Nvo_glob_opt = obj_func[0];
        idx = 0;
        for(i = 1; i<Part_N; i++){
            if(Nvo_glob_opt > obj_func[i]){
                Nvo_glob_opt = obj_func[i];
                idx = i;
            }
        }

         if(Nvo_glob_opt < glob_opt){
            glob_opt = Nvo_glob_opt;
            for(i = 0; i < Part_N; i++){
                G_opt[i] = x[idx];
            }
            Mejor_pos = x[idx];
        }
        Evol_func_obj[t] = glob_opt;
        t += 1;
    }

    return Mejor_pos;
}

/**
 * Función que será evaluada (R en R) 
*/
double f(double x) { 
    double res = (x*x*x*x) - (x*x*x) - (10*x*x) + 4*x + 2;
    return res; 
}

/**
 * Función que será evaluada (R en R) 
*/
double f2(double x) { 
    double res = x*x;
    return res; 
}

/**
 * Min function
*/
double min(double a, double b){
    return (a > b) ? b : a;
}