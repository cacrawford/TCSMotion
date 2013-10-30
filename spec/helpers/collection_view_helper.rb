class MockCollectionView < UICollectionView

  def initWithFrame(rect, collectionViewLayout:layout)
    self.tap do
      @frame = rect
      self.dataSource = self
      self.delegate = self
    end
  end

  def frame
    @frame
  end

  def bounds
    CGRectMake(0, 0, @frame.size.width, @frame.size.height)
  end

  def addSection(rows)
    @sections ||= Array.new
    @sections << rows
  end

  def numberOfItemsInSection(section)
    @sections.at(section)
  end

  def numberOfSectionsInCollectionView(collectionView)
    @sections.size
  end

  def numberOfSections
    @sections.size
  end

  def headerForSection?(section)
    false
  end

  def footerForSection?(section)

  end

end

module TCS

  class AbstractLayout < UICollectionViewFlowLayout

    def collectionView
      superCollectionView = super
      return superCollectionView unless superCollectionView.nil?
      @collectionView
    end

    def collectionView=(collectionView)
      @collectionView = collectionView
    end

    def contentSize=(size)
      self.collectionView.contentSize = size
    end

    def getCellXOrigins
      origins = Array.new
      unless @item_locations.nil?
        @item_locations.each do |index, location|
          origins << location.origin.x
        end
      end
      origins
    end

    def getCellYOrigins
      origins = Array.new
      unless @item_locations.nil?
        @item_locations.each do |index, location|
          origins << location.origin.y
        end
      end
      origins
    end

    def getCellWidths
      origins = Array.new
      unless @item_locations.nil?
        @item_locations.each do |index, location|
          origins << location.size.width
        end
      end
      origins
    end

    def origin_to_origin_width
      self.minimumInteritemSpacing + self.cell_width
    end

    def origin_to_origin_height
      self.minimumLineSpacing + self.cell_height
    end

    def maxRowsWithoutScroll
      (self.content_height / (self.cell_height + self.minimumLineSpacing)).floor
    end

    def maxColumnsWithoutScroll
      (self.content_width / (self.cell_height + self.minimumInteritemSpacing)).floor
    end

    def numItems(section = 0)
      self.item_count(section)
    end

  end

end
