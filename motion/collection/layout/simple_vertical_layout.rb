module TCS

  class SimpleVerticalLayout < TCS::AbstractLayout

    def init
      super.tap do
        self.scrollDirection = UICollectionViewScrollDirectionVertical
      end
    end

    def prepareLayout
      super

      reset_locations

      contentX = [(view_width - content_width) / 2, 0].max
      contentY = self.sectionInset.top

      if header?(0)
        push_header_location(0, CGRectMake([(view_width - self.headerReferenceSize.width) / 2, 0].max,
                                           contentY,
                                           self.headerReferenceSize.width,
                                           self.headerReferenceSize.height))
        contentY = contentY + self.headerReferenceSize.height + self.minimumLineSpacing
      end

      item_count(0).times do |row|
        rect = CGRectMake(contentX, contentY, self.cell_width, self.cell_height)
        push_cell_location([0,row].nsindexpath, rect)
        contentY = contentY + self.cell_height + self.minimumLineSpacing
      end

      if footer?(0)
        push_footer_location(0, CGRectMake([(view_width - self.footerReferenceSize.width) / 2, 0].max,
                                           contentY,
                                           self.footerReferenceSize.width,
                                           self.footerReferenceSize.height))
      end

    end

    def content_height
      (self.cell_height * item_count(0)) + (self.minimumLineSpacing * [item_count(0) - 1, 0].max) +
          vertical_insets_size +  supplementary_view_height(0)
    end

    def section_count
      [super, 1].min
    end

  end

end
