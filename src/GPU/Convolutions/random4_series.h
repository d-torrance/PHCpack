// The file random4_series.h specifies functions to generate random series
// in quad double precision.

#ifndef __random4_series_h__
#define __random4_series_h__

void dbl4_exponentials
 ( int deg, double xhihi, double xlohi, double xhilo, double xlolo, 
   double *pluxhihi, double *pluxlohi, double *pluxhilo, double *pluxlolo,
   double *minxhihi, double *minxlohi, double *minxhilo, double *minxlolo );
/*
 * DESCRIPTION :
 *   Returns power series for exp(x) and exp(-x),
 *   with real coefficients in quad double precision.
 *
 * ON ENTRY :
 *   deg        degree to truncate the series;
 *   xhihi      highest part of some quad double;
 *   xlohi      second highest part of some quad double;
 *   xhilo      second lowest part of some quad double;
 *   xlolo      lowest part of some quad double;
 *   pluxhihi   space for deg+1 doubles for the highest doubles
 *              of the exp(+x) series;
 *   pluxlohi   space for deg+1 doubles for the second highest doubles
 *              of the exp(+x) series;
 *   pluxhilo   space for deg+1 doubles for the second lowest doubles
 *              of the exp(+x) series;
 *   pluxlolo   space for deg+1 doubles for the lowest doubles
 *              of the exp(+x) series;
 *   minxhihi   space for deg+1 doubles for the highest doubles
 *              of the exp(-x) series;
 *   minxlohi   space for deg+1 doubles for the second highest doubles
 *              of the exp(-x) series;
 *   minxhilo   space for deg+1 doubles for the second lowest doubles
 *              of the exp(-x) series.
 *   minxlolo   space for deg+1 doubles for the lowest doubles
 *              of the exp(-x) series.
 *
 * ON RETURN :
 *   pluxhihi   highest doubles of the series of exp(+x);
 *   pluxlohi   second highest doubles of the series of exp(+x);
 *   pluxhilo   second lowest doubles of the series of exp(+x);
 *   pluxlolo   lowest doubles of the series of exp(+x);
 *   minxhihi   highest doubles of the series of exp(-x);
 *   minxlohi   second highest of the series of exp(-x);
 *   minxhilo   second lowest doubles of the series of exp(-x);
 *   minxlolo   lowest doubles of the series of exp(-x). */

void random_dbl4_exponentials
 ( int deg, double *xhihi, double *xlohi, double *xhilo, double *xlolo,
   double *pluxhihi, double *pluxlohi, double *pluxhilo, double *pluxlolo,
   double *minxhihi, double *minxlohi, double *minxhilo, double *minxlolo );
/*
 * DESCRIPTION :
 *   Returns power series for exp(x) and exp(-x),
 *   truncated to degree deg for a random quad double x.
 *   Parameters are the same as dbl4_exponentials,
 *   except that xhihi, xlohi, xhilo, and xlolo are return parameters. */

void cmplx4_exponentials
 ( int deg, double xrehihi, double xrelohi, double xrehilo, double xrelolo,
            double ximhihi, double ximlohi, double ximhilo, double ximlolo,
   double *pluxrehihi, double *pluxrelohi, double *pluxrehilo,
   double *pluxrelolo, double *pluximhihi, double *pluximlohi,
   double *pluximhilo, double *pluximlolo,
   double *minxrehihi, double *minxrelohi, double *minxrehilo,
   double *minxrelolo, double *minximhihi, double *minximlohi,
   double *minximhilo, double *minximlolo );
/*
 * DESCRIPTION :
 *   Returns power series for exp(x) and exp(-x),
 *   with complex coefficients in quad double precision.
 *
 * ON ENTRY :
 *   deg         degree to truncate the series;
 *   xrehihi     highest double of the real part of some complex number;
 *   xrelohi     second highest double of the real part of some complex number;
 *   xrehilo     second lowest double of the real part of some complex number;
 *   xrelolo     lowest double of the real part of some complex number;
 *   ximhihi     highest double of the imaginary part of some complex number;
 *   ximlohi     second highest double of the imaginary part
 *               of some complex number;
 *   ximhilo     second lowest double of the imaginary part
 *               of some complex number;
 *   ximlolo     lowest double of the imaginary part of some complex number;
 *   pluxrehihi  space for deg+1 doubles for the highest doubles
 *               of the real parts of the exp(+x) series;
 *   pluxrelohi  space for deg+1 doubles for the second highest doubles
 *               of the real parts of the exp(+x) series;
 *   pluxrehilo  space for deg+1 doubles for the second lowest doubles
 *               of the real parts of the exp(+x) series;
 *   pluxrelolo  space for deg+1 doubles for the lowest doubles
 *               of the real parts of the exp(+x) series;
 *   pluximhihi  space for deg+1 doubles for the highest doubles
 *               of the imaginary parts of the exp(+x) series;
 *   pluximlohi  space for deg+1 doubles for the second highest doubles
 *               of the imaginary parts of the exp(+x) series;
 *   pluximhilo  space for deg+1 doubles for the second lowest doubles
 *               of the imaginary parts of the exp(+x) series;
 *   pluximlolo  space for deg+1 doubles for the lowest doubles
 *               of the imaginary parts of the exp(+x) series;
 *   minxrehihi  space for deg+1 doubles for the highest doubles
 *               of the real parts of the exp(-x) series;
 *   minxrelohi  space for deg+1 doubles for the second highest doubles
 *               of the real parts of the exp(-x) series;
 *   minxrehilo  space for deg+1 doubles for the second lowest doubles
 *               of the real parts of the exp(-x) series;
 *   minxrelolo  space for deg+1 doubles for the lowest doubles
 *               of the real parts of the exp(-x) series;
 *   minximhihi  space for deg+1 doubles for the highest doubles
 *               of the imaginary parts of the exp(-x) series.
 *   minximlohi  space for deg+1 doubles for the second highest doubles
 *               of the imaginary parts of the exp(-x) series.
 *   minximhilo  space for deg+1 doubles for the second lowest doubles
 *               of the imaginary parts of the exp(-x) series.
 *   minximlolo  space for deg+1 doubles for the lowest doubles
 *               of the imaginary parts of the exp(-x) series.
 *
 * ON RETURN :
 *   pluxrehihi  highest doubles of the real parts of the exp(+x) series
 *               truncated to degree deg;
 *   pluxrelohi  second highest doubles of the real parts of the exp(+x)
 *               series truncated to degree deg;
 *   pluxrehilo  second lowest doubles of the real parts of the exp(+x)
 *               series truncated to degree deg;
 *   pluxrelolo  lowest doubles of the real parts of the exp(+x) series
 *               truncated to degree deg;
 *   pluximhihi  highest doubles of the imaginary parts of the exp(+x) series 
 *               truncated to degree deg;
 *   pluximlohi  second highest doubles of the imaginary parts of the exp(+x)
 *               series truncated to degree deg;
 *   pluximhilo  second lowest doubles of the imaginary parts of the exp(+x)
 *               series truncated to degree deg;
 *   pluximlolo  lowest doubles of the imaginary parts of the exp(+x) series 
 *               truncated to degree deg;
 *   minxrehihi  highest doubles of the real parts of the exp(-x) series
 *               truncated to degree deg;
 *   minxrelohi  second highest doubles of the real parts of the exp(-x)
 *               series truncated to degree deg;
 *   minxrehilo  second lowest doubles of the real parts of the exp(-x)
 *               series truncated to degree deg;
 *   minxrelolo  lowest doubles of the real parts of the exp(-x) series
 *               truncated to degree deg;
 *   minximhihi  highest doubles of the imaginary parts of the exp(-x) series
 *               truncated to degree deg;
 *   minximlohi  second highest doubles of the imaginary parts of the exp(-x)
 *               series truncated to degree deg;
 *   minximhilo  second lowest doubles of the imaginary parts of the exp(-x)
 *               series truncated to degree deg;
 *   minximlolo  lowest doubles of the imaginary parts of the exp(-x) series
 *               truncated to degree deg. */

void random_cmplx4_exponentials
 ( int deg, 
   double *xrehihi, double *xrelohi, double *xrehilo, double *xrelolo,
   double *ximhihi, double *ximlohi, double *ximhilo, double *ximlolo,
   double *pluxrehihi, double *pluxrelohi, double *pluxrehilo,
   double *pluxrelolo, double *pluximhihi, double *pluximlohi,
   double *pluximhilo, double *pluximlolo,
   double *minxrehihi, double *minxrelohi, double *minxrehilo,
   double *minxrelolo, double *minximhihi, double *minximlohi,
   double *minximhilo, double *minximlolo );
/*
 * DESCRIPTION :
 *   Returns power series for exp(x) and exp(-x),
 *   truncated to degree deg for a random complex quad double x.
 *   Parameters are the same as cmplx4_exponentials,
 *   except that xrehihi, xrelohi, xrehilo, xrelolo, ximhihi, ximlohi,
 *   ximhilo, and ximlolo are return parameters. */

#endif
