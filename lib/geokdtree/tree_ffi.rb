require 'ffi'

module Geokdtree::C
  ffi_lib File.dirname(__FILE__) + "/" + (FFI::Platform.mac? ? "geokdtree.bundle" : FFI.map_library_name("geokdtree"))

  # /* create a kd-tree for "k"-dimensional data */
  # struct kdtree *kd_create(int k);
  attach_function "kd_create", "kd_create", [:int], :pointer

  # /* free the struct kdtree */
  # void kd_free(struct kdtree *tree);
  attach_function "kd_free", "kd_free", [:pointer], :void

  # /* remove all the elements from the tree */
  # void kd_clear(struct kdtree *tree);
  attach_function "kd_clear", "kd_clear", [:pointer], :void

  # /* insert a node, specifying its position, and optional data */
  # int kd_insert(struct kdtree *tree, const double *pos, void *data);
  attach_function "kd_insert", "kd_insert", [:pointer, :pointer, :pointer], :int

  # int kd_insert2(struct kdtree *tree, double x, double y, void *data);
  attach_function "kd_insert2", "kd_insert2", [:pointer, :double, :double, :pointer], :int

  # int kd_insert3(struct kdtree *tree, double x, double y, double z, void *data);
  attach_function "kd_insert3", "kd_insert3", [:pointer, :double, :double, :double, :pointer], :int

  # /* Find the nearest node from a given point.
  #  *
  #  * This function returns a pointer to a result set with at most one element.
  #  */
  # struct kdres *kd_nearest(struct kdtree *tree, const double *pos);
  attach_function "kd_nearest", "kd_nearest", [:pointer, :pointer], :pointer
 
  # struct kdres *kd_nearest2(struct kdtree *tree, double x, double y);
  attach_function "kd_nearest2", "kd_nearest2", [:pointer, :double, :double], :pointer

  # struct kdres *kd_nearest2(struct kdtree *tree, double x, double y, double z);
  attach_function "kd_nearest3", "kd_nearest3", [:pointer, :double, :double, :double], :pointer

  # /* Find any nearest nodes from a given point within a range.
  #  *
  #  * This function returns a pointer to a result set, which can be manipulated
  #  * by the kd_res_* functions.
  #  * The returned pointer can be null as an indication of an error. Otherwise
  #  * a valid result set is always returned which may contain 0 or more elements.
  #  * The result set must be deallocated with kd_res_free after use.
  #  */
  # struct kdres *kd_nearest_range(struct kdtree *tree, const double *pos, double range);
  attach_function "kd_nearest_range", "kd_nearest_range", [:pointer, :pointer, :double], :pointer

  # struct kdres *kd_nearest_range2(struct kdtree *tree, double x, double y, double range);
  attach_function "kd_nearest_range2", "kd_nearest_range2", [:pointer, :double, :double, :double], :pointer

  # struct kdres *kd_nearest_range3(struct kdtree *tree, double x, double y, double z, double range);
  attach_function "kd_nearest_range3", "kd_nearest_range3", [:pointer, :double, :double, :double, :double], :pointer

  # struct kdres *kd_nearest_geo_range(struct kdtree *kd, double lat, double lng, double range, int units)
  attach_function "kd_nearest_geo_range", "kd_nearest_geo_range", [:pointer, :double, :double, :double, :int], :pointer

  # void *kd_res_item(struct kdres *set, double *pos);
  attach_function "kd_res_item", "kd_res_item", [:pointer, :pointer], :pointer

  # /* frees a result set returned by kd_nearest_range() */
  # void kd_res_free(struct kdres *set);
  attach_function "kd_res_free", "kd_res_free", [:pointer], :void

  # /* advances the result set iterator, returns non-zero on success, zero if
  #  * there are no more elements in the result set.
  #  */
  # int kd_res_next(struct kdres *set);
  attach_function "kd_res_next", "kd_res_next", [:pointer], :int

  # /* returns non-zero if the set iterator reached the end after the last element */
  # int kd_res_end(struct kdres *set);
  attach_function "kd_res_end", "kd_res_end", [:pointer], :int

  # /* return the Euclidean distance from two points in k dimensions */
  # double euclidean_distance( double *a, double *b, int k );
  attach_function "euclidean_distance", "euclidean_distance", [:pointer, :pointer, :int], :double

  # /* return the Euclidean distance from two points in two dimensions */
  # double euclidean_distance2(double ax, double ay, double bx, double by);
  attach_function "euclidean_distance2", "euclidean_distance2", [:double, :double, :double, :double], :double

  # /* return the geo distance from two lat/lng points using the spherical law of cosines */
  # double slc_distance(double *a, double *b, double radius) {
  attach_function "slc_distance", "slc_distance", [:pointer, :pointer, :double], :double

  # /* return the geo distance from two lat/lng points using the spherical law of cosines */
  # double slc_distance2(double lat1, double lng1, double lat2, double lng2, double radius) {
  attach_function "slc_distance2", "slc_distance2", [:double, :double, :double, :double, :double], :double

end
