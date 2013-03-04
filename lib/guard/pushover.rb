require 'guard'
require 'guard/guard'
# require 'guard/watcher'
# require 'rushover'

module Guard
  # Send notifications to Hipchat
  class Pushover < Guard

    CONFIG = {
      :title => 'Guard',
      :prio => 0
    }

    def initialize(watchers = [], options = {})
      super
      @user_key = options.delete(:user_key)
      @api_key = options.delete(:api_key)
      @options = CONFIG.merge(options)
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
      check_keys
      @resp = client.notify(@user_key, msg, options)
      if @resp.ok?
        UI.info "Pushover: message sent"
      else
        handle_error
      end
    end

    def check_keys
      return UI.error "No API Key given. Plz fix." unless @api_key
      return UI.error "No User key given. Plz fix." unless @user_key
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
