// The file dbl_factors_testers.h specifies test functions
// on matrix factorizations in double precision.

#ifndef __dbl_factors_testers_h__
#define __dbl_factors_testers_h__

void test_factors_real_lufac ( void );
/*
 * DESCRIPTION :
 *   Prompts for a dimension and tests the LU factorization on real data. */

void test_factors_cmplx_lufac ( void );
/*
 * DESCRIPTION :
 *   Prompts for a dimension and tests the LU factorization
 *   on complex data. */

void test_factors_real_houseqr ( void );
/*
 * DESCRIPTION :
 *   Prompts for dimensions and tests the QR decomposition
 *   with Householder matrices on real data. */

#endif
