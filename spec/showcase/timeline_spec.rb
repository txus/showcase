require 'spec_helper'
require 'showcase/timeline'

module Showcase
  describe Timeline do
    let(:users) { Repository.for(:user) }
    let(:statuses) { Repository.for(:status) }

    let(:txustice) { users.save users.new(username: 'txustice') }
    let(:oriolgual) { users.save users.new(username: 'oriolgual') }

    let(:timeline) { Timeline.new(txustice) }

    before do
      txustice.follow(oriolgual)
    end

    describe '#each' do
      it "iterates over the statuses in the user's timeline" do
        status = oriolgual.post_status "foo"
        expect(timeline.map(&:id)).to eq([status.id])
      end
    end
  end
end

