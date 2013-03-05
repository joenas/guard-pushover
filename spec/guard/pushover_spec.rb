require 'spec_helper'

describe Guard::Pushover do

  subject{Guard::Pushover.new([], options)}
  let(:options){ {:user_key => user_key, :api_key => api_key} }
  let(:paths){ ['file.rb'] }
  let(:user_key){ '' }
  let(:api_key){ '' }

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
      let(:user_key){ 'user' }
      let(:api_key){ 'api' }
      let(:response){double('response', :ok? => true)}
      let(:client){double('client', :notify => response)}
      let(:options) { {:user_key => user_key, :api_key => api_key, :client => client} }
      let(:message) { "#{paths.first} was changed." }
      let(:expected_options){ { :title => 'Guard', :priority => 0 } }

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
          it "shows error message 'user identifier is invalid'" do
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