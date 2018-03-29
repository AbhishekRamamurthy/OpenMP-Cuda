#include<stdio.h>
#include<stdlib.h>
#include<omp.h>


void  SimdMul (float *a, float *b,   float *c) {
	
	int i=0;
	for(i=0;i<NUM;i++) {
		c[i]=a[i]*b[i];
	}
}



double SimdMulSum (float *a, float *b, float sum) {
	
	int i =0;
	for(i=0;i<NUM;i++) {
		sum+=a[i]*b[i];
	}
	return (double)sum;
}

int main () {
		
		float a[NUM],b[NUM],c[NUM];
		int i=0;
		float sum=0.;
		double Execution_Time1[2];
		for(i=0;i<NUM;i++) {
			a[i]=float(i%10);
			b[i]=float(i%10);
		}
		double start=omp_get_wtime();
		SimdMul(a,b,c);
		double end=omp_get_wtime();
		double Execution_Time=end-start;
		start=omp_get_wtime();
		Execution_Time1[1]=SimdMulSum(a,b,sum);
		end=omp_get_wtime();
		Execution_Time1[0]=end-start;
        printf("SimdMul Performance = %lf,SimdMulSum Performance = %lf,SimdMulSum Result = %lf\n",NUM/Execution_Time/1000000,(NUM+4)/Execution_Time1[0]/1000000,Execution_Time1[1]);
		return 0;
}
  
