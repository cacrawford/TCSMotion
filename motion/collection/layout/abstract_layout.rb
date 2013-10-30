module TCS

  class AbstractLayout < UICollectionViewFlowLayout
    WIDTH_ADJUSTMENT = 2
    HEIGHT_ADJUSTMENT = 2

    attr_accessor :stickyHeaders

    def initWithCellSize(size)
      init.tap do
        self.itemSize = size
      end
    end

    def init
      super.tap do
        @stickyHeaders = false

        self.headerReferenceSize ||= CGSizeMake(0, 0)
        self.footerReferenceSize ||= CGSizeMake(0, 0)
        self.sectionInset ||= UIEdgeInsetsMake(0, 0, 0, 0)
        self.minimumLineSpacing ||= 10
        self.minimumInteritemSpacing ||= 10

        reset_locations
      end
    end

    def headerReferenceSize=(size)
      super

      # Once set, retain unless explicitly reset by resetSupplementaryReferenceSizes
      unless @headerFullWidth || @headerFullHeight
        @headerFullWidth = self.headerReferenceSize.width == 0 && self.headerReferenceSize.height > 0
        @headerFullHeight = self.headerReferenceSize.height == 0 && self.headerReferenceSize.width > 0
      end
    end

    def footerReferenceSize=(size)
      super

      # Once set, retain unless explicitly reset by resetSupplementaryReferenceSizes
      unless @footerFullWidth || @footerFullHeight
        @footerFullWidth = self.footerReferenceSize.width == 0 && self.footerReferenceSize.height > 0
        @footerFullHeight = self.footerReferenceSize.height == 0 && self.footerReferenceSize.width > 0
      end
    end

    def resetSupplementaryReferenceSizes
      @headerFullWidth = false
      @headerFullHeight = false
      @footerFullWidth = false
      @footerFullHeight = false
    end

    def collectionViewContentSize
      content_size
    end

    def prepareLayout
      super

      calculateActualHeaderReferenceSize
    end

    def getHeaderLocation(section)
      return CGRectZero if @header_locations.nil? || !@header_locations.include?(section)
      @header_locations[section]
    end

    def shouldInvalidateLayoutForBoundsChange(new_bounds)
      return true if @stickyHeaders
      !CGSizeEqualToSize(page_size, new_bounds.size)
    end

    def layoutAttributesForItemAtIndexPath(path)
      UICollectionViewLayoutAttributes.layoutAttributesForCellWithIndexPath(path).tap do |attrs|
        self.setCellAttributes(attrs)
      end
    end

    def layoutAttributesForElementsInRect(rect)
      cellAttributes = super

      sectionHeaderIndexes = Hash.new

      cellAttributes.select { |attributes| attributes.cell? }
                    .select { |attributes| attributes.intersects?(rect) }
                    .map { |attributes| self.setCellAttributes(attributes) }

      cellAttributes.select { |attributes| attributes.header? }
                    .map { |attributes|
                      self.setHeaderAttributes(attributes)
                      sectionHeaderIndexes[attributes.indexPath.section] = attributes.indexPath.row
                    }

      cellAttributes.select { |attributes| attributes.footer? }
                    .map { |attributes| self.setFooterAttributes(attributes) }

      if @stickyHeaders
        @header_locations.keys.each do |section|
          unless sectionHeaderIndexes.include?(section)
            cellAttributes << layoutAttributesForSupplementaryViewOfKind(UICollectionElementKindSectionHeader,
                                                                         atIndexPath: [section, 0].nsindexpath)
          end
        end
      end

      NSArray.arrayWithArray(cellAttributes)
    end

    def layoutAttributesForSupplementaryViewOfKind(kind, atIndexPath: path)
      attributes = super
      if kind == UICollectionElementKindSectionHeader
        setHeaderAttributes(attributes)
      elsif kind == UICollectionElementKindSectionFooter
        setFooterAttributes(attributes)
      end
      attributes
    end

    def setCellAttributes(attributes)
      attributes.frame = @item_locations[attributes.indexPath]
    end

    def setHeaderAttributes(attributes)
      section = attributes.indexPath.section
      if @header_locations.include? section
        if @stickyHeaders
          attributes.frame = getStickyHeaderFrame(section)
          attributes.zIndex = 1024
        else
          attributes.frame = @header_locations[section]
        end
      else
        attributes.frame = CGRectZero
      end
    end

    def setFooterAttributes(attributes)
      if @footer_locations.include? attributes.indexPath.section
        attributes.frame = @footer_locations[attributes.indexPath.section]
      else
        attributes.frame = CGRectZero
      end
    end

    protected

    attr_reader :item_locations
    attr_reader :header_locations
    attr_reader :footer_locations

    def reset_locations
      @item_locations = Hash.new
      @header_locations = Hash.new
      @footer_locations = Hash.new
    end

    def push_cell_location(index, rect)
      @item_locations[index] = rect
    end

    def push_header_location(section, rect)
      @header_locations[section] = rect
    end

    def push_footer_location(section, rect)
      @footer_locations[section] = rect
    end

    def item_count(section)
      return 0 if section_count < 1
      self.collectionView.numberOfItemsInSection(section)
    end

    def section_count
      self.collectionView.numberOfSections
    end

    def content_size
      @content_size = [[view_width, content_width].max, [view_height, content_height].max]
    end

    def view_width
      self.collectionView.bounds.size.width
    end

    def view_height
      self.collectionView.bounds.size.height
    end

    def available_width
      view_width - (self.sectionInset.left + self.sectionInset.right)
    end

    def available_height
      view_height - (self.sectionInset.top + self.sectionInset.bottom)
    end

    def cell_width
      self.itemSize.width
    end

    def cell_height
      self.itemSize.height
    end

    def content_width
      self.cell_width
    end

    def content_height
      self.cell_height
    end

    def vertical_insets_size
      self.sectionInset.top + self.sectionInset.bottom
    end

    def horizontal_insets_size
      self.sectionInset.right + self.sectionInset.left
    end

    def page_size
      self.collectionView.frame.size
    end

    def supplementary_view_width(section)
      return 0 unless @header_locations.include?(section) || @footer_locations.include?(section)
      self.headerReferenceSize.width + self.footerReferenceSize.width + self.minimumInteritemSpacing*2
    end

    def supplementary_view_height(section)
      return 0 unless @header_locations.include?(section) || @footer_locations.include?(section)
      self.headerReferenceSize.height + self.footerReferenceSize.height + self.minimumLineSpacing*2
    end

    def header?(section)
      return self.collectionView.headerForSection?(section) if self.collectionView.respond_to? :headerForSection?
      self.headerReferenceSize.width > 0 && self.headerReferenceSize.height > 0
    end

    def footer?(section)
      return self.collectionView.footerForSection?(section) if self.collectionView.respond_to? :footerForSection?
      self.headerReferenceSize.width > 0 && self.headerReferenceSize.height > 0
    end

    def getStickyHeaderFrame(section)
      numItems = self.collectionView.numberOfItemsInSection(section)
      beginningPosition = @header_locations[section]
      return beginningPosition if numItems == 0

      endingPosition = @item_locations[[section, numItems-1].nsindexpath]
      endingPosition = @footer_locations[section] if footer?(section)
      contentOffset = self.collectionView.contentOffset

      rect = beginningPosition
      if self.scrollDirection == UICollectionViewScrollDirectionVertical
        headerHeight = beginningPosition.size.height
        sectionTop = beginningPosition.origin.y
        sectionBottom = endingPosition.origin.y + endingPosition.size.height
        rect.origin.y = [[contentOffset.y, sectionTop].max, sectionBottom - headerHeight].min
      else
        headerWidth = beginningPosition.size.width
        sectionRight = beginningPosition.origin.x
        sectionLeft = endingPosition.origin.x + endingPosition.size.width
        rect.origin.x = [[contentOffset.x, sectionRight - headerWidth].max, sectionLeft - headerWidth].min
      end

      rect
    end

    def calculateActualHeaderReferenceSize
      return unless @headerFullWidth || @headerFullHeight

      if @headerFullWidth
        self.headerReferenceSize = CGSizeMake(view_width - WIDTH_ADJUSTMENT, self.headerReferenceSize.height)
      end

      if @headerFullHeight
        self.headerReferenceSize = CGSizeMake(self.headerReferenceSize.width, view_height - HEIGHT_ADJUSTMENT)
      end
    end

  end

end