module TCS

  class DefaultCell < UICollectionViewCell
    attr_accessor :data

    def self.identifier
      'TCSDefaultCell'
    end

    def initialize
      super.tap do
        self.backgroundColor = UIColor.clearColor
      end
    end

  end

end

