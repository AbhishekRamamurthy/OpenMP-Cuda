#include<stdlib.h>
#include<stdio.h>
#include<omp.h>


struct s {

	float value;
}Array[4];

int main () {
	
	int i,j;
	i=0;j=0;	
	const  int  SomeBigNumber = 100000000;  // keep less than 2B

	omp_set_num_threads(NUMT);
	double time0=omp_get_wtime();

#pragma omp parallel for default(none) private (i,j) shared(Array)
	for(i = 0; i < 4; i++) {
		
		unsigned int seed = 0;
		float tmp=Array[i].value;
		for(j = 0; j < SomeBigNumber; j++ ) {

			tmp =  tmp + (float)rand_r(&seed);
		}
		Array[i].value=tmp;
	}

	double time1=omp_get_wtime();
	double execution_time=time1-time0;
	printf("Execution time = %lf\n",execution_time);	
	return 0;
}
