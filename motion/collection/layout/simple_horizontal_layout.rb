module TCS

  class SimpleHorizontalLayout < TCS::AbstractLayout

    def init
      super.tap do
        self.scrollDirection = UICollectionViewScrollDirectionHorizontal
      end
    end

    def prepareLayout
      super

      reset_locations

      contentX = self.sectionInset.right
      contentY = [(view_height - content_height) / 2, 0].max

      if header?(0)
        push_header_location(0, CGRectMake(contentX,
                                           [(view_height - self.headerReferenceSize.height) / 2, 0].max,
                                           self.headerReferenceSize.width,
                                           self.headerReferenceSize.height))
        contentX = contentX + self.headerReferenceSize.width + self.minimumInteritemSpacing
      end

      item_count(0).times do |row|
        rect = CGRectMake(contentX, contentY, self.cell_width, self.cell_height)
        push_cell_location([0,row].nsindexpath, rect)
        contentX = contentX + self.cell_width
        contentX = contentX + self.minimumInteritemSpacing unless row == item_count(0)
      end

      if footer?(0)
        push_footer_location(0, CGRectMake(contentX,
                                           [(view_height - self.footerReferenceSize.height) / 2, 0].max,
                                           self.footerReferenceSize.width,
                                           self.footerReferenceSize.height))
      end

    end

    def content_width
      (self.cell_width * item_count(0)) + (self.minimumInteritemSpacing * [item_count(0) - 1, 0].max) +
          horizontal_insets_size + supplementary_view_width(0)
    end

    def section_count
      [super, 1].min
    end

  end

end
