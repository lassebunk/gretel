class TestController < ApplicationController
  def with_autopath
    @project = Project.find(1)
  end

  def with_parent_object
    @issue = Issue.find(1)
  end
end
