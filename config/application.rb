require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module DiscussionVisualizer
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
    config.i18n.default_locale= :ja
    config.action_view.sanitized_allowed_tags = ActionView::Base.sanitized_allowed_tags + ['table', 'tbody', 'tr', 'th', 'td', 'font', 'blockquote',]
    config.action_view.sanitized_allowed_attributes = ActionView::Base.sanitized_allowed_attributes + ['color']
  end
end
