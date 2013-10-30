module TCS

  class TableVerticalLayout < TCS::SimpleVerticalLayout
    DEFAULT_HEIGHT = 44

    def initWithHeight(height = DEFAULT_HEIGHT)
      @height = height
      initWithCellSize(CGSizeMake(1, height)).tap {}
    end

    def prepareLayout
      self.itemSize = CGSizeMake(self.collectionView.frame.size.width - WIDTH_ADJUSTMENT, @height)
      super
    end

  end

end
