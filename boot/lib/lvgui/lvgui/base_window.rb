module LVGUI
  # Extend this to make a "window"
  class BaseWindow
    include ::Singleton

    attr_reader :keyboard
    attr_reader :container

    def self.inherited(superclass)
      superclass.class_eval do
        unless self.class_variable_defined?(:@@_after_initialize_callback)
          self.class_variable_set(:@@_after_initialize_callback, [])
        end
      end
    end

    def initialize()
      super()
      # Initializes LVGUI things if required...
      LVGUI.init(theme: :nixos)

      # Preps a basic display
      @screen = Screen.new()
      on_background_init()
      @status_bar = StatusBar.new(@screen)
      on_header_init()
      @toolbar = Toolbar.new(@screen)
      @container = Page.new(@screen)

      [@toolbar, @container, @status_bar].each do |el|
        el.set_width(LVGUI.pixel_scale(720))
        el.set_x((@screen.get_width() - el.get_width()) / 2) # center
      end

      @focus_group = []
      # Dummy object used as a "null" focus
      LVGUI::Dummy.new(@screen).tap do |obj|
        add_to_focus_group(obj)
      end
      reset_focus_group

      self.class.class_variable_get(:@@_after_initialize_callback).each do |cb|
        instance_eval &cb
      end

      on_initialization_finished()
    end

    # Adds an object to the focus group list, and add it to the
    # current focus group.
    def add_to_focus_group(obj)
        @focus_group << obj
        LVGUI.focus_group.add_obj(obj)
    end

    # Call instead of `#del` for objects added to the focus group.
    # Totally unergonomic, but a workaround to the issue where `#del`
    # frees the object, but we don't get notified.
    def dispose_focusable_object(obj)
      @focus_group.delete(obj)
      obj.del_async
    end

    # Re-build the focus group from the elements on the window.
    def reset_focus_group()
      # Clear the focus group
      LVGUI.focus_group.remove_all_objs()

      LVGUI.focus_group.focus_handler = ->() do
        @container.focus(
          LVGUI.focus_group.get_focused,
          LVGL::ANIM::OFF
        )
      end

      @focus_group.each do |el|
        LVGUI.focus_group.add_obj(el)
      end
    end

    # Switch to this window
    def present()
      LVGUI::Native.lv_disp_load_scr(@screen.lv_obj_pointer)
      reset_focus_group

      # Allow the window to do some work every time it is switched to.
      on_present

      refresh_keyboard()
    end

    # Hooking point for custom behaviour on present
    def on_present()
    end

    # Hooking point to customize header building
    def on_header_init()
    end

    # Hooking point to customize initialization
    def on_initialization_finished()
    end

    # Hook point to customize the background
    def on_background_init()
      background_path = LVGL::Hacks.get_asset_path("app-background.svg")
      if File.exist?(background_path)
        @background = LVGL::LVImage.new(@screen).tap do |el|
          el.set_protect(LVGL::PROTECT::POS)
          el.set_height(LVGUI.pixel_scale(1280))
          el.set_width(LVGUI.pixel_scale(720))
          el.set_src("#{background_path}?height=#{LVGUI.pixel_scale(1280)}")
          el.set_x((@screen.get_width() - el.get_width()) / 2) # center
          el.set_y(@screen.get_height() - el.get_height()) # Stick to the bottom
        end
      end
    end

    def refresh_keyboard()
      # Ensures keyboard is hidden and unlinked when it needs to be.
      keyboard = LVGUI::Keyboard.instance
      keyboard.set_ta(nil)
      keyboard.hide()

      # Only do then next things if we linked the keyboard to this window (add_keyboard).
      return unless @keyboard
      # The keyboard is not added to the page; the page holds the elements that
      # may move to ensure they're not covered by the keyboard.
      @keyboard.set_parent(@screen)
      @keyboard.set_protect(LVGL::PROTECT::POS)
      @keyboard.container = @container

      # XXX : wrong on landscape
      @keyboard.set_height(@screen.get_width * 0.55)
      @keyboard.set_width(@screen.get_width_fit)
      @container.keyboard = @keyboard
      @container.refresh()
    end
  end
end
