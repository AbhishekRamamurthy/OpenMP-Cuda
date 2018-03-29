#include<stdlib.h>
#include<stdio.h>
#include<math.h>
#include<omp.h>

int	NowYear;		// 2017 - 2022
int	NowMonth;		// 0 - 11

float	NowPrecip;		// inches of rain per month
float	NowTemp;		// temperature this month
float	NowHeight;		// grain height in inches
int	NowNumDeer;		// number of deer in the current population


const float GRAIN_GROWS_PER_MONTH =		8.0;
const float ONE_DEER_EATS_PER_MONTH =		0.5;

const float AVG_PRECIP_PER_MONTH =		6.0;	// average
const float AMP_PRECIP_PER_MONTH =		6.0;	// plus or minus
const float RANDOM_PRECIP =			2.0;	// plus or minus noise

const float AVG_TEMP =				50.0;	// average
const float AMP_TEMP =				20.0;	// plus or minus
const float RANDOM_TEMP =			10.0;	// plus or minus noise

const float MIDTEMP =				40.0;
const float MIDPRECIP =				10.0;




float Ranf( unsigned int *seedp,  float low, float high ) {

	float r = (float) rand_r( seedp );              // 0 - RAND_MAX

	return(   low  +  r * ( high - low ) / (float)RAND_MAX   );
}
//Calculate square factor
float SQR( float x ) {

	return x*x;
}

//Calculate the new Deer growth based on grain growth
void GrainDeer() {
	
	float tmp=NowHeight;
	tmp -= (float)NowNumDeer * ONE_DEER_EATS_PER_MONTH;
	#pragma omp barrier
	if(tmp<1) {
		NowNumDeer--;
		if(NowNumDeer <0) {
			NowNumDeer=0;
		}
	} else {
		NowNumDeer++;
	}
	#pragma omp barrier
	NowHeight=NowHeight-tmp;
	
	#pragma omp barrier
}

//calculate the new grain growth based on precipitation
void Grain() {

	float tempFactor = exp(-SQR((NowTemp - MIDTEMP)/10.));
	float precipFactor = exp(-SQR(( NowPrecip - MIDPRECIP)/10.));
	float tmp=NowHeight;
	tmp +=tempFactor * precipFactor * GRAIN_GROWS_PER_MONTH;
	#pragma omp barrier
	NowHeight=tmp;
	#pragma omp barrier
	#pragma omp barrier
}

void Watcher() {

	#pragma omp barrier
	#pragma omp barrier
	float ang = (  30.*(float)NowMonth + 15.  ) * ( M_PI / 180. );

	static unsigned int seed = 0;  // a thread-private variable
	float temp = AVG_TEMP - AMP_TEMP * cos( ang );
	NowTemp = temp + Ranf( &seed, -RANDOM_TEMP, RANDOM_TEMP );

	float precip = AVG_PRECIP_PER_MONTH + AMP_PRECIP_PER_MONTH * sin( ang );
	NowPrecip = precip + Ranf( &seed,  -RANDOM_PRECIP, RANDOM_PRECIP );
	if( NowPrecip < 0. )
		NowPrecip = 0.;
	printf("Grain Growth= %f,DeerGrowth= %d, Temp= %f, Precipitation= %f\n",NowHeight,NowNumDeer,NowTemp, NowPrecip);
	#pragma omp barrier
}

int main() {

	NowYear=2017;
	NowMonth=0;
	NowNumDeer=1;
	NowHeight=1;
	float ang = (  30.*(float)NowMonth + 15.  ) * ( M_PI / 180. );

	float temp = AVG_TEMP - AMP_TEMP * cos( ang );
	static unsigned int seed = 0;
	NowTemp = temp + Ranf( &seed, -RANDOM_TEMP, RANDOM_TEMP );

	float precip = AVG_PRECIP_PER_MONTH + AMP_PRECIP_PER_MONTH * sin( ang );
	NowPrecip = precip + Ranf( &seed,  -RANDOM_PRECIP, RANDOM_PRECIP );
	if( NowPrecip < 0. )
		NowPrecip = 0.;

	omp_set_num_threads(3);	// same as # of sections
	
	while(NowYear <=2022) {
		
		while(NowMonth <=11) {
#pragma omp parallel sections
			{
#pragma omp section
				{
					GrainDeer();
				}
#pragma omp section
				{
					Grain();
				}
#pragma omp section
				{
					Watcher();
				}
				//#pragma omp section
				//			{
				//				MyAgent();	// your own
				//			}
			}
			NowMonth++;
		//exit(0);
		}
		NowMonth=0;
		NowYear++;
	}
} 
