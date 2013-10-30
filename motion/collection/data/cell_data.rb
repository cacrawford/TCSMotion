module TCS

  class CellData
    attr_reader :data
    attr_reader :identifier

    def initialize(data, identifier)
      @data = data
      @identifier = identifier
    end
  end

end