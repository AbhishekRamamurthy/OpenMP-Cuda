kernel
void
AutoCor( global const float *dA, global const int *dSize, global float *dB)
{
    int gid = get_global_id( 0 );

	float sum = 0.;
	for( int shift = 0; shift < *dSize; shift++ )
	{
		if((gid+shift) <*dSize)
		{
		sum += dA[shift] * dA[gid + shift];
		} else {
		continue;
		}
	}
	dB[gid] = sum;
}

