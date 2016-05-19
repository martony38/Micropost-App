# spec/support/assert_select_root.rb

module AssertSelectRoot
  def document_root_element
    html_document.root
  end
end

RSpec.configure do |config|
    config.include AssertSelectRoot, :type => :request
end