
class String
  def size : Int32
    @length
  end

  def bytes
    pointerof(@c)
  end

  def each_byte
    size.times do |i|
      yield bytes[i], i
    end
  end
end
