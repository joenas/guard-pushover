require 'guard'
require 'guard/guard'
require 'guard/watcher'
require 'rushover'

module Guard
  # Send notifications to Hipchat
  class Pushover < Guard

    VERSION = "0.0.1"

    CONFIG = {
      :title => 'Guard',
      :prio => 0
    }

    def initialize(watchers = [], options = {})
      super
      UI.error "No options given" and stop unless options
      @options = CONFIG.merge(options)
      @user_key = options.delete(:user_key)
      @api_key = options.delete(:api_key)
    end

    def run_on_changes(paths)
      send_notification("#{paths.first} was updated at #{Time.now}.")
    end

    def run_on_removals(paths)
      send_notification("#{paths.first} was removed at #{Time.now}.")
    end

    def run_on_additions(paths)
      send_notification("#{paths.first} was added at #{Time.now}.")
    end

  private
    def send_notification(msg)
      return unless api_keys_valid?
      #@resp = client.notify(@user_key, msg, options)
      if @resp.ok?
        UI.info "Pushover: message sent"
      else
        handle_error
      end
    end

    def api_keys_valid?
      return UI.error "No API key given. Plz fix." unless @api_key
      return UI.error "No User key given. Plz fix." unless @user_key
      true
    end

    def client
      @client ||= Rushover::Client.new(@api_key)
    end

    def handle_error
      if @resp[:user] == 'invalid' || @resp[:token] == 'invalid'
        append = ', check config.yaml'
      end
      UI.error "#{@resp[:errors].join()}#{append}"
    end
  end
end
