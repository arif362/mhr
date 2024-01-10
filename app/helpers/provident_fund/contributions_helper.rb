module ProvidentFund::ContributionsHelper
  def contribution_label(user_ids)
    users = Employee.find(user_ids)
    users.collect { |usr| usr.full_name }
  end
end
