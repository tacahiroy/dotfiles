ruby << EOR
  require "uri"

  def encode(line1, line2)
    line1.upto(line2).each do |ln|
      b = Vim::Buffer.current
      b[ln] = URI.encode b[ln]
    end
  end

  def decode(line1, line2)
    line1.upto(line2).each do |ln|
      b = Vim::Buffer.current
      b[ln] = URI.decode b[ln]
    end
  end
EOR
