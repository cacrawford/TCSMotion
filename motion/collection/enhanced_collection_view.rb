module TCS

  class EnhancedCollectionView < UICollectionView

    attr_reader :defaultCellClass

    class EmptyView < UICollectionReusableView

      def self.identifier
        @id ||= BubbleWrap.create_uuid.to_s
      end
    end

    def initWithFrame(rect, collectionViewLayout: layout)
      super.tap do

        backgroundView = UIView.alloc.initWithFrame(frame)
        backgroundView.backgroundColor = UIColor.clearColor
        self.setBackgroundView(backgroundView)

        @registeredClasses = Array.new
        @cellData = Hash.new
        @defaultCellClass ||= TCS::DefaultCell
        @cellClasses = Hash.new
        @headerViews = Hash.new

        maybeRegisterClass(@defaultCellClass)

        registerClass(EmptyView, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader,
                      withReuseIdentifier: EmptyView.identifier)

        self.dataSource = self
      end
    end

    def setCellClassForSection(section, clazz)
      initializeSection(section)
      @cellClasses[section] = clazz
      maybeRegisterClass(clazz)
    end

    def defaultCellClass=(cellClass)
      @defaultCellClass = cellClass
      maybeRegisterClass(cellClass)
    end

    def setCellDataForSection(section, sectionData, cellClass = nil)
      maybeRegisterClass(cellClass)
      resetCells(section)
      @cellClasses[section] = cellClass unless cellClass.nil?
      sectionData.each do |data|
        appendCellToSection(section, data)
      end
    end

    def appendCellToSection(section, data, cellClass = nil)
      maybeRegisterClass(cellClass)
      cells = cellsForSection(section)
      @cellClasses[[section, cells.size].nsindexpath] = cellClass  unless cellClass.nil?
      cells << data
    end

    def setSupplementaryViewForSection(section, kind, clazz, data = nil)
      section(section)[kind] = data unless data.nil?
      registerClass(clazz, forSupplementaryViewOfKind: kind, withReuseIdentifier: "#{section}#{kind}")
    end

    def setSupplementaryDataForSection(section, kind, data)
      section(section)[kind] = data
    end

    def cellDataAtIndex(index)
      cellForSectionAndRow(index.section, index.row)
    end

    def getHeaderForSection(section)
      return nil if @headerViews[section].nil?
      @headerViews[section]
    end

    def reloadVisibleCells
      self.reloadItemsAtIndexPaths(self.indexPathsForVisibleItems)
    end

    def scrollToTop(animated = false)
      self.scrollRectToVisible(CGRectMake(0,0,1,1), animated: animated)
    end

    # UICollectionViewDataSource
    def collectionView(collectionView, numberOfItemsInSection: section)
      cellsForSection(section).size
    end

    # UICollectionViewDataSource
    def numberOfSectionsInCollectionView(collectionView)
      @cellData.size
    end

    #UICollectionViewDataSource
    def collectionView(collectionView, cellForItemAtIndexPath: indexPath)
      cellData = cellDataAtIndex(indexPath)
      cell = collectionView.dequeueReusableCellWithReuseIdentifier(getIndexIdentifier(indexPath), forIndexPath: indexPath)
      cell.data = cellData if cell.respond_to?(:data)
      cell
    end

    def collectionView(collectionView, viewForSupplementaryElementOfKind:kind, atIndexPath:indexPath)

      return emptyDequeue(collectionView, kind, indexPath) unless headerForSection?(indexPath.section)

      headerData = section(indexPath.section)[kind]
      identifier = "#{indexPath.section}#{kind}"
      header = collectionView.dequeueReusableSupplementaryViewOfKind(kind,
                                                                     withReuseIdentifier:identifier,
                                                                     forIndexPath: indexPath)
      header.data = headerData if header.respond_to?(:data=)
      @headerViews[indexPath.section] = header

      header
    end

    def emptyDequeue(collectionView, kind, indexPath)
      collectionView.dequeueReusableSupplementaryViewOfKind(kind,
                                                            withReuseIdentifier: EmptyView.identifier,
                                                            forIndexPath: indexPath)
    end

    def collectionView(collectionView, didEndDisplayingSupplementaryView:view, forElementOfKind:elementKind,
                      atIndexPath:indexPath)
      @headerViews[indexPath.section] = nil
    end

    def getIndexIdentifier(index)
      getClassIdentifier(getCellClassForIndex(index))
    end

    def getClassIdentifier(cellClass)
      clazz = cellClass
      clazz = @defaultCellClass if cellClass.nil?
      return clazz.identifier if clazz.respond_to? :identifier
      clazz.class.to_s
    end

    def getCellClassForIndex(index)
      if @cellClasses.include?(index)
        @cellClasses[index]
      elsif @cellClasses.include?(index.section)
        @cellClasses[index.section]
      else
        @defaultCellClass
      end
    end

    def maybeRegisterClass(clazz)
      return if clazz.nil?
      unless @registeredClasses.include?(clazz)
        registerClass(clazz, forCellWithReuseIdentifier: getClassIdentifier(clazz))
        @registeredClasses << clazz
      end
    end

    def headerForSection?(section)
      section(section).include? UICollectionElementKindSectionHeader
    end

    def footerForSection?(section)
      section(section).include? UICollectionElementKindSectionFooter
    end

    def cellForSectionAndRow(section, row)
      raise ArgumentError "Invalid row #{row} for section #{section}" unless row <= cellsForSection(section).size
      cellsForSection(section).at(row)
    end

    def cellsForSection(section)
      section(section)[:cells]
    end

    def section(section)
      initializeSection(section) unless @cellData.include?(section)
      @cellData[section]
    end

    def initializeSection(section)
      raise ArgumentError "Invalid section #{section}" unless section <= @cellData.size
      return if @cellData.include?(section)
      @cellData[section] = Hash.new
      @cellData[section][:cells] = Array.new
    end

    def resetCells(section)
      initializeSection(section)
      @cellData[section][:cells] = Array.new
    end

  end

end
