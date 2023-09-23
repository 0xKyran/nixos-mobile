class LVGUI::Button < LVGUI::Widget
  module StyleMods
    extend self

    # FIXME: actually reset instead of setting a style that looks like the normal button.
    def none(button)
      style = button.get_style(LVGL::BTN_STYLE::REL).dup
      style.body_main_color = LVGUI::Colors::BLUE_LIGHT
      style.body_grad_color = style.body_main_color
      button.set_style(LVGL::BTN_STYLE::REL, style)

      style = button.get_style(LVGL::BTN_STYLE::PR).dup
      style.body_main_color = LVGL::LVColor.mix(LVGUI::Colors::BLUE_LIGHT, LVGUI::Colors::BLACK, 200)
      style.body_grad_color = style.body_main_color
      button.set_style(LVGL::BTN_STYLE::PR, style)
    end

    def primary(button)
      style = button.get_style(LVGL::BTN_STYLE::REL).dup
      style.body_main_color = LVGUI::Colors::GREEN
      style.body_grad_color = style.body_main_color
      button.set_style(LVGL::BTN_STYLE::REL, style)

      style = button.get_style(LVGL::BTN_STYLE::PR).dup
      style.body_main_color = LVGL::LVColor.mix(LVGUI::Colors::GREEN, LVGUI::Colors::BLACK, 200)
      style.body_grad_color = style.body_main_color
      button.set_style(LVGL::BTN_STYLE::PR, style)
    end

    # Orange styling
    # Not the primary action, but one the user might want to check
    def enticing(button)
      style = button.get_style(LVGL::BTN_STYLE::REL).dup
      style.body_main_color = LVGUI::Colors::ORANGE
      style.body_grad_color = style.body_main_color
      button.set_style(LVGL::BTN_STYLE::REL, style)

      style = button.get_style(LVGL::BTN_STYLE::PR).dup
      style.body_main_color = LVGL::LVColor.mix(LVGUI::Colors::ORANGE, LVGUI::Colors::BLACK, 200)
      style.body_grad_color = style.body_main_color
      button.set_style(LVGL::BTN_STYLE::PR, style)
    end

    # Red styling
    # A normally destructive action.
    # Think twice when using them.
    def danger(button)
      style = button.get_style(LVGL::BTN_STYLE::REL).dup
      style.body_main_color = LVGUI::Colors::RED
      style.body_grad_color = style.body_main_color
      button.set_style(LVGL::BTN_STYLE::REL, style)

      style = button.get_style(LVGL::BTN_STYLE::PR).dup
      style.body_main_color = LVGL::LVColor.mix(LVGUI::Colors::RED, LVGUI::Colors::BLACK, 200)
      style.body_grad_color = style.body_main_color
      button.set_style(LVGL::BTN_STYLE::PR, style)
    end
  end

  def initialize(parent)
    @enabled = true
    super(LVGL::LVButton.new(parent))
    set_layout(LVGL::LAYOUT::COL_M)
    set_ink_in_time(200)
    set_ink_wait_time(100)
    set_ink_out_time(500)
    set_fit2(LVGL::FIT::FILL, LVGL::FIT::TIGHT)
    @label = LVGL::LVLabel.new(self)
    set_opa_scale_enable(true)
  end

  def set_label(label)
    @label.set_text(label)
  end

  def enabled?()
    @enabled
  end

  def set_enabled(state)
    @enabled = state
    if enabled?()
      set_opa_scale(LVGL::OPA.scale(100))
    else
      set_opa_scale(LVGL::OPA.scale(20))
    end
  end
end
