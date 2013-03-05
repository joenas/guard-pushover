require 'guard'
require 'guard/guard'
require 'guard/watcher'
require 'rushover'

module Guard
  # Send notifications to Pushover
  class Pushover < Guard

    VERSION = "0.0.1"

    CONFIG = {
      :title => 'Guard',
      :priority => 0
    }

    def initialize(watchers = [], options = {})
      super()
      @options = CONFIG.merge(options)
      @user_key = @options.delete(:user_key)
      @api_key = @options.delete(:api_key)
    end

    def run_on_changes(paths)
      send_notification format_message(paths, :changed)
    end

    def run_on_removals(paths)
      send_notification format_message(paths, :removed)
    end

    def run_on_additions(paths)
      send_notification format_message(paths, :added)
    end

  private

    def client
      @client = options.delete(:client) || Rushover::Client.new(@api_key)
    end

    def send_notification(msg)
      return unless api_keys_valid?
      @resp = client.notify(@user_key, msg, @options)
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

    def format_message(paths, action=nil)
      case paths.first
      when Hash
        paths.first[:message]
      when String
        "#{paths.first} was #{action.to_s}."
      end
    end

    def handle_error
      if @resp[:user] == 'invalid' || @resp[:token] == 'invalid'
        append = ', check API and User key'
      end
      UI.error "#{@resp[:errors].join()}#{append}"
    end
  end
end