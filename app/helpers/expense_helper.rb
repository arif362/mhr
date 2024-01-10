module ExpenseHelper
  def calculate_percentage(amount, total)
    ((amount * 100.0) / total).round
  end

  def calculate_daily_expense(amount, start_date, end_date)
    (amount / ((end_date - start_date) + 1).to_f).round
  end
end
