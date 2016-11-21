struct Terminal
  @@framebuffer = Pointer(UInt16).new(0xb8000u64)
  @@col = 0
  @@row = 0

  def self.clear
    (80*25).times do |offset|
      @@framebuffer[offset] = 0u16
    end
  end

  def self.put_byte(byte)
    if byte == '\n'.ord
      @@col = 0
      @@row += 1
      return
    end
    if byte == '\r'.ord
      @@col = 0
      return
    end
    if byte == '\t'.ord
      @@col = (@@col + 8) / 8 * 8
      if @@col >= 80
        @@col = 0
        @@row += 1
      end
      return
    end
    @@framebuffer[@@row * 80 + @@col] = ((15u16 << 8) | (0u16 << 12) | byte).as UInt16
    @@col += 1
    if @@col == 80
      @@col = 0
      @@row += 1
    end
  end

  def self.print(str)
    str.each_byte { |byte| put_byte(byte) }
  end

  def self.puts(str)
    print(str)
    @@col = 0
    @@row += 1
  end

  def self.puts
    print "\n"
  end
end