module TCS
  class ThumbnailCell < UICollectionViewCell

    def self.identifier
      'TCSThumbnailCell'
    end

    def initWithFrame(rect)
      super
      super.tap do
        @image = UIImageView.alloc.initWithFrame(rect)
        @image.backgroundColor = UIColor.clearColor
        addSubview(@image)
      end
    end

    def layoutSubviews
      super

      @image.frame = self.frame
    end

    def data
      @image.image
    end

    def data=(thumbnail)
      @image.image = thumbnail
    end

  end
end
