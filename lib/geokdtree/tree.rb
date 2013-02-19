module Geokdtree

  ResultPoint = Struct.new(:point, :data)

  RADIUS_MI = 3958.760
  RADIUS_KM = 6371.0
  KM_PER_MI = 1.609

  GEO_UNITS_MI = 0
  GEO_UNITS_KM = 1

  class KdtreePointer < FFI::AutoPointer

    def self.release(ptr) 
      # ptr is the original pointer you passed in to create VectorPointer 
      C::kd_free(ptr) 
    end 
  end 

  class Tree

    def initialize(dimensions)
      @dimensions = dimensions
      @tree = KdtreePointer.new(C::kd_create(dimensions))
      @data_cache = {}
      @data_id = 0
    end

    # insert a point of n dimensions and arbritary associated object
    # @param point [Array<Float>] array of n dimensions of numeric coordinates
    # @param data [Object] arbritary object stored with point
    # @return [Tree] self 
    def insert(point, data = nil)
      # here we don't actually pass a pointer to our data but the object numeric key encoded into the pointer
      r = case point.size
        when 2 then C::kd_insert2(@tree, point[0].to_f, point[1].to_f, cache(data))
        when 3 then C::kd_insert3(@tree, point[0].to_f, point[1].to_f, point[2].to_f, cache(data))
        else C::kd_insert(@tree, Tree.allocate_doubles(point), cache(data))
      end     
      raise("error on Tree#insert, code=#{r}") unless r.zero?
      self
    end

    # find the given point nearest neighbor
    # @param point [Array<Float>] array of n dimensions of numeric coordinates
    # @return [ResultPoint] the nearest neighbor, nil if no neighbor
    def nearest(point)
      set = case point.size
        when 2 then C::kd_nearest2(@tree, point[0].to_f, point[1].to_f)
        when 3 then C::kd_nearest3(@tree, point[0].to_f, point[1].to_f, point[2].to_f)
        else C::kd_nearest(@tree, Tree.allocate_doubles(point))
      end
      return nil if set.null?
      retrieve_results(set).first
    end

    # find all the given point neighbors within the given Euclidean range
    # @param point [Array<Float>] array of n dimensions of numeric coordinates
    # @param range [Float] range units expressed as a Euclidean distance
    # @return [Array<ResultPoint>] the point neighbors within range, [] if none
    def nearest_range(point, range)
      set = case point.size
        when 2 then C::kd_nearest_range2(@tree, point[0].to_f, point[1].to_f, range.to_f)
        when 3 then C::kd_nearest_range3(@tree, point[0].to_f, point[1].to_f, point[2].to_f, range.to_f)
        else C::kd_nearest_range(@tree, Tree.allocate_doubles(point), range.to_f)
      end
      return [] if set.null?
      retrieve_results(set)
    end

    # find all the given point neighbors within the given geo range
    # @param point [Array<Float>] [latitude, longitude] array
    # @param range [Float] range units in miles or kms, default in miles
    # @param units [Symbol] :mi or :km, default :mi
    # @return [Array<ResultPoint>] the point neighbors within range, [] if none
    def nearest_geo_range(point, range, units = :mi)
      raise("must have 2 dimensions for geo methods") unless @dimensions == 2
      set = C::kd_nearest_geo_range(@tree, point[0].to_f, point[1].to_f, range.to_f, units == :mi ? GEO_UNITS_MI : GEO_UNITS_KM)
      return [] if set.null?
      retrieve_results(set)
     end

    # compute the Euclidean distance between 2 points of n dimensions
    # @param pointa [Array<Float>] array of n dimensions of numeric coordinates
    # @param pointb [Array<Float>] array of n dimensions of numeric coordinates
    # @return [Float] the Euclidean distance between the 2 points
    def self.distance(pointa, pointb)
      case k = pointa.size
        when 2 then C::euclidean_distance2(pointa[0].to_f, pointa[1].to_f, pointb[0].to_f, pointb[1].to_f)
        else C::euclidean_distance(allocate_doubles(pointa), allocate_doubles(pointb), k)
      end
    end

    # compute the geo distance between 2 points of latitude, longitude
    # @param pointa [Array<Float>] [latitude, longitude] array
    # @param pointb [Array<Float>] [latitude, longitude] array
    # @param units [Symbol] :mi or :km, default :mi
    # @return [Float] the geo distance between the 2 points
    def self.geo_distance(pointa, pointb, units = :mi)
      C::slc_distance2(pointa[0].to_f, pointa[1].to_f, pointb[0].to_f, pointb[1].to_f, units == :mi ? RADIUS_MI : RADIUS_KM)
    end

    private

    # store data in cache hash and return pointer encoded numeric object key
    # @param data [Object] arbritary object
    # @return [FFI::Pointer] pointer encoded numeric object key 
    def cache(data)
      return nil unless data
      @data_cache[@data_id += 1] = data
      FFI::Pointer.new(@data_id)
    end

    # allocate managed memory pointer for given doubles array
    # @param doubles [Array<Fixnum>] array doubles numbers
    # @return [FFI::MemoryPointer] pointer to allocated & copied doubles
    def self.allocate_doubles(doubles)
      ptr = FFI::MemoryPointer.new(:double, doubles.size)
      ptr.write_array_of_double(doubles)
      ptr
    end

    # walk a result set and transpose into result array
    # @param set [FFI::Pointer] the result set from tree search functions
    # @return [Array<ResultPoint>] transposed result items 
    def retrieve_results(set)
      results = []
      while C::kd_res_end(set) == 0 
        point_ptr = FFI::MemoryPointer.new(:double, @dimensions) # to hold point result
        data_ptr = C::kd_res_item(set, point_ptr) # fetch single result item  
        results << ResultPoint.new(point_ptr.read_array_of_double(@dimensions), data_ptr.null? ? nil : @data_cache[data_ptr.address])
        C::kd_res_next(set)
      end
      C::kd_res_free(set)
      results
    end

  end
end