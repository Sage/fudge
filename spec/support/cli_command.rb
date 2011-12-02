shared_examples_for "a cli command" do
  describe "Class Methods" do
    subject { described_class }

    it { should respond_to :command }
    it { should respond_to :description }
  end

  it { should respond_to :run }
end
