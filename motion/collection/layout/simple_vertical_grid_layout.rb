module TCS

  class SimpleVerticalGridLayout < TCS::AbstractLayout

    def init
      super.tap do
        self.scrollDirection = UICollectionViewScrollDirectionVertical
      end
    end

    def prepareLayout
      super

      reset_locations

      empty_space = available_width - (num_columns * cell_width)
      num_spaces = num_columns + 2
      self.minimumInteritemSpacing = (empty_space / num_spaces).floor

      x_positions = Array.new
      num_columns.times do |column|
        x_positions << column * (cell_width + self.minimumInteritemSpacing) + self.sectionInset.left + self.minimumInteritemSpacing
      end

      y = self.sectionInset.top
      if header?(0)
        push_header_location(0, CGRectMake([(view_width - self.headerReferenceSize.width) / 2, 0].max,
                                           y,
                                           self.headerReferenceSize.width,
                                           self.headerReferenceSize.height))
        y = y + self.headerReferenceSize.height + self.minimumLineSpacing
      end

      index = 0
      num_rows.times do
        x_positions.each do |x|
          rect = CGRectMake(x, y, cell_width, cell_height)
          push_cell_location([0, index].nsindexpath, rect)
          index += 1
        end
        y += cell_height + self.minimumLineSpacing
      end

      if footer?(0)
        push_footer_location(0, CGRectMake([(view_width - self.footerReferenceSize.width) / 2, 0].max,
                                           y,
                                           self.footerReferenceSize.width,
                                           self.footerReferenceSize.height))
      end

    end

    def num_columns
      return 0 if cell_width == 0
      ((available_width + self.minimumInteritemSpacing) / (cell_width + self.minimumInteritemSpacing)).floor
    end

    def num_rows
      return 0 if num_columns == 0
      (item_count(0) / num_columns.to_f).ceil
    end

    def content_width
      available_width
    end

    def content_height
      (self.cell_height * num_rows) + (self.minimumLineSpacing * [num_rows - 1, 0].max) + vertical_insets_size +
          supplementary_view_height(0)
    end

  end

end

