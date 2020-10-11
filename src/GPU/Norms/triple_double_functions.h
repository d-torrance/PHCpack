/* This file triple_double_functions.h defines the arithmetical operations 
   for triple double numbers, defined by high, middle, and low doubles.

The algorithms are from the CAMPARY and QD software libraries
with the modification that a triple double is not stored as an array
of three doubles, but plainly by three double numbers:
a high double, a middle double, and a low double.
All functions have the prefix tdf_ to avoid name clashes. */

#ifndef __triple_double_functions_h__
#define __triple_double_functions_h__

/************************** normalizations **************************/

void tdf_fast_renorm
 ( double x0, double x1, double x2, double x3,
   double *r0, double *r1, double *r2 );
/*
 * DESCRIPTION :
 *   The definition is based on the fast_renorm2L<4,3>,
 *   from code of the specRenorm.h, generated by the CAMPARY library,
 *   in an unrolled form (Valentina Popescu, Mioara Joldes), with
 *   double double basics of QD-2.3.9 (Y. Hida, X.S. Li, and D.H. Bailey).
 *
 * ON ENTRY :
 *   x0       most significant word;
 *   x1       second most significant word;
 *   x2       third most significant word;
 *   x3       least significant word.
 *
 * ON RETURN :
 *   r0       highest part of a triple double number;
 *   r1       middle part of a triple double number;
 *   r2       lowest part of a triple double number. */

/************************ copy and abs *******************************/

void tdf_copy
 ( double a_hi, double a_mi, double a_lo,
   double *b_hi, double *b_mi, double *b_lo );
/*
 * DESCRIPTION :
 *   Copies the content of the triple double a (a_hi, a_mi, a_lo)
 *   to the triple double b (b_hi, b_mi, b_lo). */

void tdf_abs
 ( double a_hi, double a_mi, double a_lo,
   double *b_hi, double *b_mi, double *b_lo );
/*
 * DESCRIPTION :
 *   Returns in b the absolute value of a. */

/****************** additions and substractions ************************/

void tdf_add
 ( double a_hi, double a_mi, double a_lo,
   double b_hi, double b_mi, double b_lo,
   double *c_hi, double *c_mi, double *c_lo );
/*
 * DESCRIPTION : c = a + b.
 *   Adds two triple doubles a (a_hi, a_mi, a_lo) and b (b_hi, b_mi, b_lo)
 *   to make the triple double c (c_hi, c_mi, c_lo).
 *
 * ON ENTRY :
 *   a_hi     high part of the triple double a;
 *   a_mi     middle part of the triple double a;
 *   a_lo     low part of the triple double a;
 *   b_hi     high part of the triple double b;
 *   b_mi     middle part of the triple double b;
 *   b_lo     low part of the triple double b.
 *
 * ON RETURN :
 *   c_hi     high part of the triple double c = a + b;
 *   c_mi     middle part of the triple double c = a + b;
 *   c_lo     low part of the triple double c = a + b. */

void tdf_inc
 ( double *a_hi, double *a_mi, double *a_lo,
   double b_hi, double b_mi, double b_lo );
/*
 * DESCRIPTION : a = a + b.
 *   Adds to the triple double a (a_hi, a_mi, a_lo)
 *   the triple double b (b_hi, b_mi, b_lo).
 *
 * ON ENTRY :
 *   a_hi     high part of the triple double a;
 *   a_mi     middle part of the triple double a;
 *   a_lo     low part of the triple double a;
 *   b_hi     high part of the triple double b;
 *   b_mi     middle part of the triple double b;
 *   b_lo     low part of the triple double b.
 *
 * ON RETURN :
 *   a_hi     high part of the triple double a + b;
 *   a_mi     middle part of the triple double a + b;
 *   a_lo     low part of the triple double a + b. */

void tdf_minus ( double *a_hi, double *a_mi, double *a_lo );
/*
 * DESCRIPTION :
 *   Flips the sign of a (a_hi, a_mi, a_lo). */

void tdf_sub
 ( double a_hi, double a_mi, double a_lo,
   double b_hi, double b_mi, double b_lo,
   double *c_hi, double *c_mi, double *c_lo );
/*
 * DESCRIPTION : c = a - b.
 *   Subtracts the triple double in b (b_hi, b_mi, b_lo) 
 *   from the triple double in a (a_hi, a_mi, a_lo)
 *   and places the result in the triple double c (c_hi, c_mi, c_lo).
 *
 * ON ENTRY :
 *   a_hi     high part of the triple double a;
 *   a_mi     middle part of the triple double a;
 *   a_lo     low part of the triple double a;
 *   b_hi     high part of the triple double b;
 *   b_mi     middle part of the triple double b;
 *   b_lo     low part of the triple double b.
 *
 * ON RETURN :
 *   c_hi     high part of the triple double c = a - b;
 *   c_mi     middle part of the triple double c = a - b;
 *   c_lo     low part of the triple double c = a - b. */

/***************** multiplications and division ********************/

void tdf_mul
 ( double a_hi, double a_mi, double a_lo,
   double b_hi, double b_mi, double b_lo,
   double *c_hi, double *c_mi, double *c_lo );
/*
 * DESCRIPTION : c = a * b.
 *   Multiplies two triple doubles a (a_hi, a_mi, a_lo) and b (b_hi, 
 *   b_mi, b_lo) to make the triple double c (c_hi, c_mi, c_lo).
 *
 * ON ENTRY :
 *   a_hi     high part of the triple double a;
 *   a_mi     middle part of the triple double a;
 *   a_lo     low part of the triple double a;
 *   b_hi     high part of the triple double b;
 *   b_mi     middle part of the triple double b;
 *   b_lo     low part of the triple double b.
 *
 * ON RETURN :
 *   c_hi     high part of the triple double c = a * b;
 *   c_mi     middle part of the triple double c = a * b;
 *   c_lo     low part of the triple double c = a * b. */

void tdf_sqr
 ( double a_hi, double a_mi, double a_lo,
   double *c_hi, double *c_mi, double *c_lo );
/*
 * DESCRIPTION : c = a * a.
 *   Multiplies the triple double a (a_hi, a_mi, a_lo) with a
 *   to make the triple double c (c_hi, c_mi, c_lo).
 *
 * ON ENTRY :
 *   a_hi     high part of the triple double a;
 *   a_mi     middle part of the triple double a;
 *   a_lo     low part of the triple double a.
 *
 * ON RETURN :
 *   c_hi     high part of the triple double c = a * a;
 *   c_mi     middle part of the triple double c = a * a;
 *   c_lo     low part of the triple double c = a * a. */

void tdf_mul_td_d
 ( double a_hi, double a_mi, double a_lo, double b,
   double *c_hi, double *c_mi, double *c_lo );
/*
 * DESCRIPTION : c = a * b.
 *   Multiplies the triple double a (a_hi, a_mi, a_lo) with b
 *   to make the triple double c (c_hi, c_mi, c_lo).
 *
 * ON ENTRY :
 *   a_hi     high part of the triple double a;
 *   a_mi     middle part of the triple double a;
 *   a_lo     low part of the triple double a;
 *   b        some double.
 *
 * ON RETURN :
 *   c_hi     high part of the triple double c = a * b;
 *   c_mi     middle part of the triple double c = a * b;
 *   c_lo     low part of the triple double c = a * b. */

void tdf_div
 ( double a_hi, double a_mi, double a_lo,
   double b_hi, double b_mi, double b_lo,
   double *c_hi, double *c_mi, double *c_lo );
/*
 * DESCRIPTION : c = a / b.
 *   Divides the triple double a (a_hi, a_mi, a_lo) by b (b_hi, 
 *   b_mi, b_lo) to make the triple double c (c_hi, c_mi, c_lo).
 *
 * ON ENTRY :
 *   a_hi     high part of the triple double a;
 *   a_mi     middle part of the triple double a;
 *   a_lo     low part of the triple double a;
 *   b_hi     high part of the triple double b;
 *   b_mi     middle part of the triple double b;
 *   b_lo     low part of the triple double b.
 *
 * ON RETURN :
 *   c_hi     high part of the triple double c = a / b;
 *   c_mi     middle part of the triple double c = a / b;
 *   c_lo     low part of the triple double c = a / b. */

#endif
