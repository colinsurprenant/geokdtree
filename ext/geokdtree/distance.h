#ifndef _DISTANCE_H_
#define _DISTANCE_H_

#ifdef __cplusplus
extern "C" {
#endif

#define RADIUS_MI 3958.760
#define RADIUS_KM 6371.0
#define KM_PER_MI 1.609
#define SQ(x) ((x) * (x))

/* return the square Euclidean distance from two points in k dimensions */
double square_euclidean_distance(const double *a, const double *b, int k);

/* return the Euclidean distance from two points in k dimensions */
double euclidean_distance(const double *a, const double *b, int k);

/* return the Euclidean distance from two points in two dimensions */
double euclidean_distance2(double ax, double ay, double bx, double by);

/* return the geo distance from two lat/lng points using the spherical law of cosines */
double slc_distance(const double *a, const double *b, double radius);

/* return the geo distance from two lat/lng points using the spherical law of cosines */
double slc_distance2(double lat1, double lng1, double lat2, double lng2, double radius);

/* return the geo distance from two lat/lng points using the haversine formula */
double haversine_distance2(double lat1, double lng1, double lat2, double lng2, double radius);

int bsq_compare(double a, double b);
int std_compare(double a, double b);

#ifdef __cplusplus
}
#endif

#endif	/* _DISTANCE_H_ */
