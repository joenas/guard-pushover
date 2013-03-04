require 'spec_helper'

describe Guard::Pushover do

  subject{Guard::Pushover.new([], options)}
  let(:options){ }
  let(:paths){ ['file.rb'] }

  describe "#run_on_changes" do
    let(:run_on_changes){subject.run_on_changes(paths)}

    context "without api_key" do
      let(:options){ {:user_key => ''} }
      it "shows an error message" do
        Guard::UI.should_receive(:error).with(/No API key given/)
        run_on_changes
      end
    end

    context "without user_key" do
      let(:options){ {:api_key => 'hej'} }
      it "shows an error message" do
        Guard::UI.should_receive(:error).with(/No User key given/)
        run_on_changes
      end
    end

    context "without options to constructor" do
      subject{Guard::Pushover.new([])}
      it "shows an error message" do
        Guard::UI.should_receive(:error).with(/No API key given/)
        run_on_changes
      end
    end
  end

end