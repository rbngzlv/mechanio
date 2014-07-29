require 'spec_helper'

describe RatingHelper do
  it 'calculates width using whole and half-stars' do
    helper.rating_to_percent(0).should eq 0
    helper.rating_to_percent(5).should eq 100

    helper.rating_to_percent(3.0).should eq 60
    helper.rating_to_percent(3.1).should eq 70
    helper.rating_to_percent(3.2).should eq 70
    helper.rating_to_percent(3.3).should eq 70
    helper.rating_to_percent(3.4).should eq 70
    helper.rating_to_percent(3.5).should eq 70
    helper.rating_to_percent(3.6).should eq 80
    helper.rating_to_percent(3.7).should eq 80
    helper.rating_to_percent(3.8).should eq 80
    helper.rating_to_percent(3.9).should eq 80
    helper.rating_to_percent(4.0).should eq 80
  end
end
