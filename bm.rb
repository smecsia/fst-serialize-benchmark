require 'benchmark'
require 'uuid'
require 'jrmvnrunner'
Jrmvnrunner.init!

java_import 'de.ruedigermoeller.serialization.FSTConfiguration'
java_import 'java.util.HashMap'
java_import 'java.io.ObjectOutputStream'
java_import 'java.io.ObjectInputStream'
java_import 'java.io.ByteArrayInputStream'
java_import 'java.io.ByteArrayOutputStream'

class BM
  attr_reader :map

  def initialize
    @config = FSTConfiguration.createDefaultConfiguration()
  end

  def start!(size= 100, times = 50000)
    array = (0..size).map { |n| object }.to_java

    Benchmark.bm (7) do |x|
      x.report("serialize") {
        times.times { serialize(array) }
      }
      x.report("deserialize") {
        serialized = serialize(array)
        times.times { deserialize(serialized) }
      }
      x.report("serialize_fst") {
        times.times { serialize_fst(array) }
      }
      x.report("deserialize_fst") {
        serialized = serialize_fst(array)
        times.times { deserialize_fst(serialized, array.java_class) }
      }
    end
  end

  private

  def object
    HashMap.new(UUID.new.generate.to_s => UUID.new.generate.to_s)
  end


  def serialize_fst(object)
    out_stream = ::ByteArrayOutputStream.new
    out = @config.object_output(out_stream)
    out.write_object object
    out.flush
    out_stream.to_byte_array
  end

  def deserialize_fst(data, clazz)
    in_stream = ::ByteArrayInputStream.new(data)
    input = @config.getObjectInput(in_stream)
    input.read_object(clazz)
  end

  def serialize(object)
    baos = ::ByteArrayOutputStream.new
    out_stream = ::ObjectOutputStream.new(baos)
    out_stream.write_object(object)
    res = baos.to_byte_array
    out_stream.close
    res
  end

  def deserialize(data)
    in_stream = ::ObjectInputStream.new(::ByteArrayInputStream.new(data))
    res = in_stream.read_object
    in_stream.close
    res
  end
end