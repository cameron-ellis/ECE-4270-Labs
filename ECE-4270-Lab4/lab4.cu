#include <stdio.h>

__global__ void square(float *d_out, float *d_a, float * d_b){
	int idx = threadIdx.x;
	float a = d_a[idx];
	float b = d_b[idx];
	d_out[idx] = 2*a + b*b;
}

int main(int argc, char ** argv){
	const int ARRAY_SIZE = 96;
	const int ARRAY_BYTES = ARRAY_SIZE * sizeof(float);
	
	float h_in[ARRAY_SIZE];
	for (int i=0; i < ARRAY_SIZE; i++){
		h_in[i] = float(i);
	}
	float h_out[ARRAY_SIZE];

	float *d_in;
	float *d_in2;
	float *d_out;

	cudaMalloc((void**) &d_in, ARRAY_BYTES); 
	cudaMalloc((void**) &d_in2, ARRAY_BYTES); 
	cudaMalloc((void**) &d_out, ARRAY_BYTES); 

	cudaMemcpy(d_in, h_in, ARRAY_BYTES, cudaMemcpyHostToDevice);
	cudaMemcpy(d_in2, h_in, ARRAY_BYTES, cudaMemcpyHostToDevice);

	square<<<1, ARRAY_SIZE>>>(d_out, d_in, d_in2);

	cudaMemcpy(h_out, d_out, ARRAY_BYTES, cudaMemcpyDeviceToHost);

	for (int i =0; i<ARRAY_SIZE; i++){
		printf("%f", h_out[i]);
		printf(((i % 4) !=3)? "\t": "\n");
	}
	
	cudaFree(d_in);
	cudaFree(d_in2);
	cudaFree(d_out);

	return 0;
}