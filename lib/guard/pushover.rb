require 'guard'
require 'guard/guard'
require 'guard/watcher'
require 'rushover'

module Guard
  # Send notifications to Pushover
  class Pushover < Guard

    DEFAULTS = {
      :title => 'Guard',
      :priority => 0
    }

    def initialize(watchers = [], options = {})
      options = DEFAULTS.merge(options)
      @user_key = options.delete(:user_key)
      @api_key = options.delete(:api_key)
      super
    end

    def run_on_changes(paths)
      send_notification "#{paths.first} was changed."
    end

    def run_on_removals(paths)
      send_notification "#{paths.first} was removed."
    end

    def run_on_additions(paths)
      send_notification "#{paths.first} was added."
    end

  private

    def client
      @client = options.delete(:client) || Rushover::Client.new(@api_key)
    end

    def send_notification(msg)
      return unless api_keys_valid?
      @resp = client.notify(@user_key, msg, options)
      if @resp.ok?
        UI.info "Pushover: message sent"
      else
        handle_error
      end
    end

    def api_keys_valid?
      return UI.error "No API key given." unless @api_key
      return UI.error "No User key given." unless @user_key
      true
    end

    def handle_error
      if @resp[:user] == 'invalid' || @resp[:token] == 'invalid'
        append = ', check API and User key'
      end
      UI.error "#{@resp[:errors].join()}#{append}"
    end
  end
end