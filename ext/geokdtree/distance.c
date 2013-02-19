#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
#include "distance.h"

static double RADIAN_PER_DEGREE = M_PI / 180.0;

/* return the square Euclidean distance from two points in k dimensions */
double square_euclidean_distance(const double *a, const double *b, int k) {
  double d = 0, diff;
  while (--k >= 0) {
    diff = (a[k] - b[k]);
    d += diff * diff;
  }
  return d;
}

/* return the Euclidean distance from two points in k dimensions */
double euclidean_distance(const double *a, const double *b, int k) {
  return sqrt(square_euclidean_distance(a, b, k));
}

/* return the Euclidean distance from two points in two dimensions */
double euclidean_distance2(double ax, double ay, double bx, double by) {
  double a[2];
  double b[2];
  a[0] = ax;
  a[1] = ay;
  b[0] = bx;
  b[1] = by;
  return sqrt(square_euclidean_distance(a, b, 2));
}

/* return the geo distance from two lat/lng points using the spherical law of cosines */
double slc_distance(const double *a, const double *b, double radius) {
  double rlat1 = RADIAN_PER_DEGREE * a[0];
  double rlng1 = RADIAN_PER_DEGREE * a[1];
  double rlat2 = RADIAN_PER_DEGREE * b[0];
  double rlng2 = RADIAN_PER_DEGREE * b[1];
  return acos(sin(rlat1) * sin(rlat2) + cos(rlat1) * cos(rlat2) * cos(rlng2 - rlng1)) * radius;
}

/* return the geo distance from two lat/lng points using the spherical law of cosines */
double slc_distance2(double lat1, double lng1, double lat2, double lng2, double radius) {
  double a[2];
  double b[2];
  a[0] = lat1, a[1] = lng1;
  b[0] = lat2, b[1] = lng2;
  return slc_distance(a, b, radius);
}

/* return the geo distance from two lat/lng points using the haversine formula */
double haversine_distance2(double lat1, double lng1, double lat2, double lng2, double radius) {
  double rlat1 = RADIAN_PER_DEGREE * lat1;
  double rlat2 = RADIAN_PER_DEGREE * lat2;
  double rdistlat = RADIAN_PER_DEGREE * (lat2 - lat1);
  double rdistlng = RADIAN_PER_DEGREE * (lng2 - lng1);
  double a =  SQ(sin(rdistlat / 2.0)) + cos(rlat1) * cos(rlat2) * SQ(sin(rdistlng / 2.0));
  double c = 2.0 * atan2(sqrt(a), sqrt(1 - a));
  return c * radius;
}

int bsq_compare(double a, double b) {
  return (a > SQ(b)) - (a < SQ(b));
}

int std_compare(double a, double b) {
  return (a > b) - (a < b);
}
