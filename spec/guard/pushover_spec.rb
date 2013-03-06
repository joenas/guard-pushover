require 'spec_helper'

describe Guard::Pushover do

  subject{Guard::Pushover.new([], options)}
  let(:options){ {:user_key => user_key, :api_key => api_key} }
  let(:paths){ ['file.rb'] }
  let(:user_key){ 'user' }
  let(:api_key){ 'api' }
  let(:client){double('client', :notify => response)}
  let(:response){double('response', :ok? => true)}
  let(:options) { {:user_key => user_key, :api_key => api_key, :client => client} }
  let(:expected_options){ { :title => 'Guard', :priority => 0 } }

  context "with valid options and credentials" do
    it "#run_on_removals sends a notification to client with correct parameters" do
      message = "#{paths.first} was removed."
      client.should_receive(:notify).with(user_key, message, expected_options)
      Guard::UI.should_receive(:info).with(/Pushover: message sent/)
      subject.run_on_removals(paths)
    end

    it "#run_on_additions sends a notification to client with correct parameters" do
      message = "#{paths.first} was added."
      client.should_receive(:notify).with(user_key, message, expected_options)
      Guard::UI.should_receive(:info).with(/Pushover: message sent/)
      subject.run_on_additions(paths)
    end
  end

  context "with options :ignore_additions => true" do
    let(:options) { {:user_key => user_key, :api_key => api_key, :client => client, :ignore_additions => true} }
    it "#run_on_additions does not send a notification" do
      client.should_not_receive(:notify)
      Guard::UI.should_not_receive(:info)
      subject.run_on_additions(paths)
      subject.run_on_additions(paths)
    end
  end

  context "with options :ignore_removals => true" do
    let(:options) { {:user_key => user_key, :api_key => api_key, :client => client, :ignore_removals => true} }
    it "#run_on_additions does not send a notification" do
      client.should_not_receive(:notify)
      Guard::UI.should_not_receive(:info)
      subject.run_on_removals(paths)
      subject.run_on_removals(paths)
    end
  end

  context "with options :ignore_changes => true" do
    let(:options) { {:user_key => user_key, :api_key => api_key, :client => client, :ignore_changes => true} }
    it "#run_on_additions does not send a notification" do
      client.should_not_receive(:notify)
      Guard::UI.should_not_receive(:info)
      subject.run_on_changes(paths)
      subject.run_on_changes(paths)
    end
  end

  describe "#run_on_changes" do
    let(:run_on_changes){subject.run_on_changes(paths)}

    context "without api_key" do
      let(:api_key){nil}
      it "shows error message 'No API key given'" do
        Guard::UI.should_receive(:error).with(/No API key given/)
        run_on_changes
      end
    end

    context "without user_key" do
      let(:user_key) { nil }
      it "shows error message 'No User key given'" do
        Guard::UI.should_receive(:error).with(/No User key given/)
        run_on_changes
      end
    end

    context "with correct options" do
      let(:message) { "#{paths.first} was changed." }

      context "and valid credentials" do
        it "shows an info message 'Pushover: message sent'" do
          Guard::UI.should_receive(:info).with(/Pushover: message sent/)
          run_on_changes
        end

        context "with default options" do
          it "sends a notification to client with correct parameters" do
            client.should_receive(:notify).with(user_key, message, expected_options)
            Guard::UI.should_receive(:info).with(/Pushover: message sent/)
            run_on_changes
          end
        end

        context "with option :title => 'TITLE'" do
          let(:expected_options){ { :title => 'TITLE', :priority => 0 } }
          it "sends a notification to client with correct parameters" do
            options[:title] = 'TITLE'
            client.should_receive(:notify).with(user_key, message, expected_options)
            Guard::UI.should_receive(:info).with(/Pushover: message sent/)
            run_on_changes
          end
        end

        context "with option :priority => 1" do
          let(:expected_options){ { :title => 'Guard', :priority => 1 } }
          it "sends a notification to client with correct parameters" do
            options[:priority] = 1
            client.should_receive(:notify).with(user_key, message, expected_options)
            Guard::UI.should_receive(:info).with(/Pushover: message sent/)
            run_on_changes
          end
        end

        context "with option :message => 'lets sprint the %s'" do
          let(:expected_options){ { :title => 'Guard', :priority => 0 } }
          it "sends a notification to client with correct parameters" do
            options[:message] = 'lets sprint the %s'
            message = "lets sprint the #{paths.first}"
            client.should_receive(:notify).with(user_key, message, expected_options)
            Guard::UI.should_receive(:info).with(/Pushover: message sent/)
            run_on_changes
          end
        end

      end

      context "and invalid credentials" do
        let(:response){double('response', :ok? => false)}

        context "for 'user' key" do
          it "shows error message 'user identifier is invalid'" do
            response.stub(:[]).with(:user).and_return('invalid')
            response.stub(:[]).with(:errors).and_return(['user identifier is invalid'])
            Guard::UI.should_receive(:error).with(/user identifier is invalid/)
            run_on_changes
          end
        end

        context "for 'token' key" do
          it "shows error message 'application token is invalid'" do
            response.stub(:[]).with(:user).and_return(true)
            response.stub(:[]).with(:token).and_return('invalid')
            response.stub(:[]).with(:errors).and_return(['application token is invalid'])
            Guard::UI.should_receive(:error).with(/application token is invalid/)
            run_on_changes
          end
        end

        context "for custom error" do
          it "shows the error message from client " do
            response.stub(:[]).with(:user).and_return(true)
            response.stub(:[]).with(:token).and_return(true)
            response.stub(:[]).with(:errors).and_return(['some random error'])
            Guard::UI.should_receive(:error).with(/some random error/)
            run_on_changes
          end
        end
      end
    end
  end
end