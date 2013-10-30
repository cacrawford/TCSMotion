module TCS

  class SimpleHorizontalGridLayout < TCS::AbstractLayout

    def init
      super.tap do
        self.scrollDirection = UICollectionViewScrollDirectionHorizontal
      end
    end

    def prepareLayout
      super

      reset_locations

      empty_space = available_height - (num_rows * cell_height)
      num_spaces = num_rows + 2
      self.minimumLineSpacing = (empty_space / num_spaces).floor

      y_positions = Array.new
      num_rows.times do |row|
        y_positions << row * (cell_height + self.minimumLineSpacing) + self.sectionInset.top + self.minimumLineSpacing
      end

      x = self.sectionInset.top
      if header?(0)
        push_header_location(0, CGRectMake(x,
                                           [(view_height - self.headerReferenceSize.height) / 2, 0].max,
                                           self.headerReferenceSize.width,
                                           self.headerReferenceSize.height))
        x = x + self.headerReferenceSize.width + self.minimumInteritemSpacing
      end

      index = 0
      num_columns.times do
        y_positions.each do |y|
          rect = CGRectMake(x, y, cell_width, cell_height)
          push_cell_location([0,index].nsindexpath, rect)
          index += 1
        end
        x += cell_width + self.minimumInteritemSpacing
      end

      if footer?(0)
        push_footer_location(0, CGRectMake(x,
                                           [(view_height - self.footerReferenceSize.height) / 2, 0].max,
                                           self.footerReferenceSize.width,
                                           self.footerReferenceSize.height))
      end

    end

    def num_columns
      (item_count(0) / num_rows.to_f).ceil
    end

    def num_rows
      ((available_height + self.minimumLineSpacing) / (cell_height + self.minimumLineSpacing)).floor
    end

    def content_width
      columns = num_columns
      (self.cell_width * columns) + (self.minimumInteritemSpacing * [num_columns - 1,0].max) +
          horizontal_insets_size + supplementary_view_width(0)
    end

    def content_height
      available_height
    end

  end

end
