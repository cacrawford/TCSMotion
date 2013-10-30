module TCS

  module Menu
    def self.default_menu_styles
      # TODO wanted to make this a constant but can't create UIFont on startup.
      default_background_color = [84,83,83].uicolor
      highlighted_background_color = [112,112,112].uicolor
      normal_text_color = [200,200,200].uicolor
      child_text_color = [163,162,162].uicolor
      disabled_text_color = [50,50,50].uicolor
      highlighted_text_color = [240,240,240].uicolor

      styles = {
          :default => {
              :backgroundColor => default_background_color,
              :font => UIFont.fontWithName('Verdana', size: 24),
              :indent => 10,
              :normal => {
                  :textColor => normal_text_color
              },
              :disabled => {
                  :textColor => disabled_text_color
              },
              :highlighted => {
                  :backgroundColor => highlighted_background_color,
                  :textColor => highlighted_text_color
              }
          },
          :parent => {
          },
          :child => {
              :font => UIFont.fontWithName('Verdana', size: 18),
              :textColor => child_text_color,
              :indent => 55
          },
          :table => {
              :backgroundColor => default_background_color,
              :separatorColor => default_background_color
          }
      }
      styles
    end

  end

end