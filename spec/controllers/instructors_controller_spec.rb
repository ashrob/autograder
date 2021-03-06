require 'spec_helper'

describe InstructorsController do

  describe "GET 'index'" do
    it "should render error if no keys were given" do
      get 'index', :format => :json, :super_key => "1234567890"
      response.should render_template(:text => 'required param \'keys\' missing.')
    end
    it "returns http success" do
      get 'index', :format => :json, :super_key => "1234567890"
      response.should be_success
    end
  end

  describe "GET 'status'" do
		it "should render error if no keys were given" do
      get :status, :format => :json, :super_key => "1234567890"
      response.should render_template(:text => 'required param \'keys\' missing.')
    end
    it "returns http success" do
			Instructor.should_receive(:find_by_key).with('robert').and_return(true)
			Instructor.should_receive(:find_by_key).with('khalid').and_return(true)
      get :status, :keys => "[khalid, robert]", :format => :json, :super_key => "1234567890"
    end
  end

  describe "GET 'authorize'" do
		it "should render error if no keys were given" do
      get 'status', :format => :json, :super_key => "1234567890"
      response.should render_template(:text => 'required param \'keys\' missing.')
    end
    it "returns http success" do
      get 'authorize', :format => :json, :super_key => "1234567890"
      response.should be_success
    end
    it "should authorize student keys" do
      Instructor.should_receive(:find_by_key).with('robert').and_return(false)
			Instructor.should_receive(:find_by_key).with('khalid').and_return(true)
			Instructor.should_receive(:create!)
      get 'authorize', :format => :json, :keys => "[khalid, robert]", :super_key => "1234567890"
    end
  end

  describe "GET 'deauthorize'" do
		it "should render error if no keys were given" do
      get 'status', :format => :json, :super_key => "1234567890"
      response.should render_template(:text => 'required param \'keys\' missing.')
    end
    it "returns http success" do
      get 'deauthorize', :format => :json, :super_key => "1234567890"
      response.should be_success
    end
    it "should deauthorize instructor keys" do
      @instructor1 = mock(:Instructor)
      Instructor.should_receive(:find_by_key).with('robert').and_return(@instructor1)
			Instructor.should_receive(:find_by_key).with('khalid').and_return(nil)
			@instructor1.should_receive(:delete)
			get 'deauthorize', :format => :json, :keys => "[khalid, robert]",:super_key => "1234567890"
	  end
  end
  describe "GET 'index' with invalid superkey" do
    it "should render error if no keys were given" do
      get 'index', :format => :json, :super_key => "12345"
      response.should render_template(:text => 'SuperUser permission required for this action')
    end
  end    
end
