#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <time.h>

int main(int argc,char * argv[]){
	float pi = 0;
	float hit = 0;
	float iterations = 100000;
	float x = 0;
	float y = 0;
	srand(time(NULL));

loop:
	for(int i = 0; i < iterations; i++){
		x = (float)rand() / RAND_MAX;
		y = (float)rand() / RAND_MAX;

		if(sqrt((x * x) + (y * y)) < 1){
			goto increment;
		}
}
	goto solve;

increment:
	hit++;
	goto loop;

solve:
	pi = (hit / iterations) * 4;
	goto print;

print:
	printf("Executing: %d iterations\n", iterations);
	printf("Hits: %d \n",hit);
	printf("Approximation: %d \n", pi);
	goto bottom;

bottom:
	return 0;
}

