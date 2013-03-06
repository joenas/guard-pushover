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
      @default_message = options.delete(:message)
      @ignore_changes = options.delete(:ignore_changes)
      @ignore_removals = options.delete(:ignore_removals)
      @ignore_additions = options.delete(:ignore_additions)

      super watchers, options
    end

    def run_on_changes(paths)
      send_notification "%s was changed.", paths.first unless @ignore_changes
    end

    def run_on_removals(paths)
      send_notification "%s was removed.", paths.first unless @ignore_removals
    end

    def run_on_additions(paths)
      send_notification "%s was added.", paths.first unless @ignore_additions
    end

  private

    def client
      @client = options.delete(:client) || Rushover::Client.new(@api_key)
    end

    def send_notification(msg, file)
      return unless api_keys_present?
      msg = (@default_message || msg) % file
      @resp = client.notify(@user_key, msg, options)
      if @resp.ok?
        UI.info "Pushover: message sent"
      else
        handle_error
      end
    end

    def api_keys_present?
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

# options = {
#   :api_key => '',
#   :user_key => '',
#   :message => "%s hejhej",
#   :ignore_removals => false
# }

# file = ['file.rb']

# Guard::Pushover.new([],options).run_on_removals(file)
# Guard::Pushover.new([],options).run_on_changes(file)