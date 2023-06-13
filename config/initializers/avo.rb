# frozen_string_literal: true

# For more information regaring these settings check out our docs https://docs.avohq.io
Avo.configure do |config|
  ## == Routing ==
  config.root_path = "/admin"

  # Where should the user be redirected when visting the `/avo` url
  config.home_path = "/admin/resources/videos"

  ## == Licensing ==
  config.license = "pro" # change this to 'pro' when you add the license key
  config.license_key = Config.avo_license_key! if Config.avo_license_key?

  ## == Set the context ==
  config.set_context do
    # Return a context object that gets evaluated in Avo::ApplicationController
  end

  ## == Authentication ==

  Avo.configure do |config|
    config.current_user_method = :current_user
  end

  config.branding = {
    logo: ActionController::Base.helpers.asset_path("app_icon.png"),
    logomark: ActionController::Base.helpers.asset_path("app_icon.png"),
    favicon: ActionController::Base.helpers.asset_path("favicon.svg")
  }

  ## == Authorization ==
  # config.authorization_methods = {
  #   index: 'index?',
  #   show: 'show?',
  #   edit: 'edit?',
  #   new: 'new?',
  #   update: 'update?',
  #   create: 'create?',
  #   destroy: 'destroy?',
  # }
  config.raise_error_on_missing_policy = !Rails.env.production?

  ## == Localization ==
  # config.locale = 'en-US'

  ## == Resource options ==
  # config.resource_controls_placement = :right
  # config.model_resource_mapping = {}
  # config.default_view_type = :table
  # config.per_page = 24
  # config.per_page_steps = [12, 24, 48, 72]
  # config.via_per_page = 8
  # config.id_links_to_resource = false
  # config.cache_resources_on_index_view = true
  ## permanent enable or disable cache_resource_filters, default value is false
  # config.cache_resource_filters = false
  ## provide a lambda to enable or disable cache_resource_filters per user/resource.
  # config.cache_resource_filters = ->(current_user:, resource:) { current_user.cache_resource_filters?}

  ## == Customization ==
  # config.app_name = 'Avocadelicious'
  # config.timezone = 'UTC'
  # config.currency = 'USD'
  # config.per_page = 24
  # config.per_page_steps = [12, 24, 48, 72]
  # config.via_per_page = 8
  # config.default_view_type = :table
  # config.hide_layout_when_printing = false
  # config.id_links_to_resource = false
  # config.full_width_container = false
  # config.full_width_index_view = false
  # config.cache_resources_on_index_view = true
  # config.search_debounce = 300
  # config.view_component_path = "app/components"
  # config.display_license_request_timeout_error = true
  # config.disabled_features = []
  # config.resource_controls = :right
  # config.tabs_style = :tabs # can be :tabs or :pills
  # config.buttons_on_form_footers = true
  # config.field_wrapper_layout = true

  # == Branding ==
  config.branding = {
    colors: {
      background: "248 246 242",
      100 => "#CEE7F8",
      400 => "#399EE5",
      500 => "#0886DE",
      600 => "#066BB2",
    },
    chart_colors: ["#0B8AE2", "#34C683", "#2AB1EE", "#34C6A8"],
    logo: "/avo-assets/logo.png",
    logomark: "/avo-assets/logomark.png",
    placeholder: "/avo-assets/placeholder.svg"
  }

  ## == Breadcrumbs ==
  # config.display_breadcrumbs = true
  # config.set_initial_breadcrumbs do
  #   add_breadcrumb "Home", '/avo'
  # end

  # == Menus ==
  config.main_menu = -> {
    section "Dashboards", icon: "dashboards" do
      all_dashboards
    end

    section "Resources", icon: "resources" do
      all_resources
    end

    section "Tools", icon: "tools" do
      all_tools
    end
  }
  # config.profile_menu = -> {
  #   link "Profile", path: "/avo/profile", icon: "user-circle"
  # }
end
