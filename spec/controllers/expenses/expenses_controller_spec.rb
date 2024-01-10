# == Schema Information
#
# Table name: expense_expenses
#
#  id                      :integer          not null, primary key
#  description             :text(65535)
#  expense_category_id     :integer
#  expense_sub_category_id :integer
#  amount                  :float(24)
#  department_id           :integer
#  date                    :date
#  is_approved             :boolean          default(FALSE)
#  created_by_id           :integer
#  approved_by_id          :integer
#  received_by             :string(255)
#  attachment              :string(255)
#  payment_method          :string(255)
#  status                  :string(255)      default("pending")
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  voucher_number          :text(65535)
#

require 'rails_helper'

RSpec.describe Expenses::ExpensesController, type: :controller do
  before(:each) do
    @company = FactoryGirl.create(:company)
    @department = FactoryGirl.create(:department, company_id: @company.id)
    @employee = FactoryGirl.create(:employee, role: Employee::ROLE[:admin], department_id: @department.id)
    @employee_2 = FactoryGirl.create(:employee, department_id: @department.id)
    @expense_category = FactoryGirl.create(:expenses_category, department_id: @department.id)
    @expense_sub_category_1 = FactoryGirl.create(:expenses_category, name: 'lunce', department_id: @department.id, expense_category_id: @expense_category.id)
    @expense_sub_category_2 = FactoryGirl.create(:expenses_category, name: 'office_rent', department_id: @department.id, expense_category_id: @expense_category.id)
    @expense_sub_category_3 = FactoryGirl.create(:expenses_category, name: 'snakes', department_id: @department.id, expense_category_id: @expense_category.id)
    @expense = FactoryGirl.create(:expenses_expense, department_id: @department.id, expense_category_id: @expense_category.id, expense_sub_category_id: @expense_sub_category_1.id, created_by_id: @employee.id, approved_by_id: @employee.id)
    @expense_1 = FactoryGirl.create(:expenses_expense, department_id: @department.id, expense_category_id: @expense_category.id, expense_sub_category_id: @expense_sub_category_1.id, created_by_id: @employee_2.id)
    @expense_2 = FactoryGirl.create(:expenses_expense, department_id: @department.id, expense_category_id: @expense_category.id, expense_sub_category_id: @expense_sub_category_2.id, created_by_id: @employee_2.id)
    @expense_3 = FactoryGirl.create(:expenses_expense, department_id: @department.id, expense_category_id: @expense_category.id, expense_sub_category_id: @expense_sub_category_3.id, created_by_id: @employee_2.id, is_approved: true, approved_by_id: @employee.id, status: AppSettings::REMARK_STATUS[:approved])
    @expense_4 = FactoryGirl.create(:expenses_expense, department_id: @department.id, expense_category_id: @expense_category.id, expense_sub_category_id: @expense_sub_category_1.id, created_by_id: @employee_2.id, amount: 900, is_approved: true, approved_by_id: @employee.id, status: AppSettings::REMARK_STATUS[:approved])
    @expense_5 = FactoryGirl.create(:expenses_expense, department_id: @department.id, expense_category_id: @expense_category.id, expense_sub_category_id: @expense_sub_category_2.id, created_by_id: @employee_2.id, amount: 1000, is_approved: true, approved_by_id: @employee.id, status: AppSettings::REMARK_STATUS[:approved])
    @expense_6 = FactoryGirl.create(:expenses_expense, department_id: @department.id, expense_category_id: @expense_category.id, expense_sub_category_id: @expense_sub_category_3.id, created_by_id: @employee_2.id, amount: 1100, is_approved: true, approved_by_id: @employee.id, status: AppSettings::REMARK_STATUS[:approved], date: (Date.today - 1.day))
    @expense_7 = FactoryGirl.create(:expenses_expense, department_id: @department.id, expense_category_id: @expense_category.id, expense_sub_category_id: @expense_sub_category_1.id, created_by_id: @employee_2.id, amount: 1200, is_approved: true, approved_by_id: @employee.id, status: AppSettings::REMARK_STATUS[:approved], date: (Date.today - 2.day))
    @expense_8 = FactoryGirl.create(:expenses_expense, department_id: @department.id, expense_category_id: @expense_category.id, expense_sub_category_id: @expense_sub_category_2.id, created_by_id: @employee_2.id, approved_by_id: @employee.id, status: AppSettings::REMARK_STATUS[:remarked])
    @expense_9 = FactoryGirl.create(:expenses_expense, department_id: @department.id, expense_category_id: @expense_category.id, expense_sub_category_id: @expense_sub_category_3.id, created_by_id: @employee_2.id, approved_by_id: @employee.id, status: AppSettings::REMARK_STATUS[:remarked])
    session[:department_id] = @department.id
    sign_in(@employee)
  end

  let(:valid_attributes) {
    {
        description: Faker::Lorem.sentences,
        expense_category_id: @expense_category.id,
        expense_sub_category_id: @expense_sub_category_1.id,
        amount: 1800,
        department_id: @department.id,
        date: Date.today,
        is_approved: false,
        created_by_id: @employee_2.id,
        status: AppSettings::REMARK_STATUS[:pending]
    }
  }
  let(:invalid_attributes) {
    {
        description: Faker::Lorem.sentences,
        expense_category_id: @expense_category.id,
        expense_sub_category_id: @expense_sub_category_1.id,
        amount: 1800,
        date: '',
        department_id: @department.id,
        is_approved: false,
        created_by_id: @employee_2.id,
        status: AppSettings::REMARK_STATUS[:pending]
    }
  }

  describe 'GET #index' do
    context 'With date range and status' do
      daterange = Date.today.to_s + '  To  ' + Date.today.to_s
      context 'when html format' do
        it "should return ALL expenses within date range" do
          get :index, daterange: daterange
          expect(response).to be_success
          #expect(assigns(:expenses)).to eq([@expense])
        end
        it "should return PENDING expenses within date range" do
          get :index, q: AppSettings::REMARK_STATUS[:pending], daterange: daterange
          expect(response).to be_success
          #expect(assigns(:expenses)).to eq([@expense_2, @expense_1])
        end
        it "should return APPROVED expenses within date range" do
          get :index, q: AppSettings::REMARK_STATUS[:approved], daterange: daterange
          expect(response).to be_success
          #expect(assigns(:expenses)).to eq([@expense_5, @expense_4, @expense_3])
        end
        it "should return REMARKED expenses within date range" do
          get :index, q: AppSettings::REMARK_STATUS[:remarked], daterange: daterange
          expect(response).to be_success
          #expect(assigns(:expenses)).to eq([@expense_9, @expense_8])
        end
      end
      context 'When js format' do
        it "should return ALL expenses within date range" do
          xhr :get, :index, format: :js, daterange: daterange
          expect(response).to be_success
          #expect(assigns(:expenses)).to eq([@expense])
        end
        it "should return PENDING expenses within date range" do
          xhr :get, :index, format: :js, q: AppSettings::REMARK_STATUS[:pending], daterange: daterange
          expect(response).to be_success
          #expect(assigns(:expenses)).to eq([@expense_2, @expense_1])
        end
        it "should return APPROVED expenses within date range" do
          xhr :get, :index, format: :js, q: AppSettings::REMARK_STATUS[:approved], daterange: daterange
          expect(response).to be_success
          #expect(assigns(:expenses)).to eq([@expense_5, @expense_4, @expense_3])
        end
        it "should return REMARKED expenses within date range" do
          xhr :get, :index, format: :js, q: AppSettings::REMARK_STATUS[:remarked], daterange: daterange
          expect(response).to be_success
          #expect(assigns(:expenses)).to eq([@expense_9, @expense_8])
        end
      end
      context 'when xls format' do
        it "should return ALL expenses within date range" do
          xhr :get, :index, format: :xls, daterange: daterange
          expect(response).to render_template('expenses/expenses/expenses_xls_docx.html.erb')
          #expect(assigns(:expenses)).to eq([@expense])
        end
        it "should return PENDING expenses within date range" do
          xhr :get, :index, format: :xls, q: AppSettings::REMARK_STATUS[:pending], daterange: daterange
          expect(response).to render_template('expenses/expenses/expenses_xls_docx.html.erb')
          #expect(assigns(:expenses)).to eq([@expense_2, @expense_1])
        end
        it "should return APPROVED expenses within date range" do
          xhr :get, :index, format: :xls, q: AppSettings::REMARK_STATUS[:approved], daterange: daterange
          expect(response).to render_template('expenses/expenses/expenses_xls_docx.html.erb')
          #expect(assigns(:expenses)).to eq([@expense_5, @expense_4, @expense_3])
        end
        it "should return REMARKED expenses within date range" do
          xhr :get, :index, format: :xls, q: AppSettings::REMARK_STATUS[:remarked], daterange: daterange
          expect(response).to render_template('expenses/expenses/expenses_xls_docx.html.erb')
          #expect(assigns(:expenses)).to eq([@expense_9, @expense_8])
        end
      end
      context 'when pdf format' do
        it "should return ALL expenses within date range" do
          xhr :get, :index, format: :pdf, daterange: daterange
          expect(response).to render_template('expenses/expenses/expenses_pdf.html.erb')
          #expect(assigns(:expenses)).to eq([@expense])
        end
        it "should return PENDING expenses within date range" do
          xhr :get, :index, format: :pdf, q: AppSettings::REMARK_STATUS[:pending], daterange: daterange
          expect(response).to render_template('expenses/expenses/expenses_pdf.html.erb')
          #expect(assigns(:expenses)).to eq([@expense_2, @expense_1])
        end
        it "should return APPROVED expenses within date range" do
          xhr :get, :index, format: :pdf, q: AppSettings::REMARK_STATUS[:approved], daterange: daterange
          expect(response).to render_template('expenses/expenses/expenses_pdf.html.erb')
          #expect(assigns(:expenses)).to eq([@expense_5, @expense_4, @expense_3])
        end
        it "should return REMARKED expenses within date range" do
          xhr :get, :index, format: :pdf, q: AppSettings::REMARK_STATUS[:remarked], daterange: daterange
          expect(response).to render_template('expenses/expenses/expenses_pdf.html.erb')
          #expect(assigns(:expenses)).to eq([@expense_9, @expense_8])
        end
      end
      context 'when docx format' do
        it "should return ALL expenses within date range" do
          xhr :get, :index, format: :docx, daterange: daterange
          expect(response).to render_template('expenses/expenses/expenses_xls_docx.html.erb')
          #expect(assigns(:expenses)).to eq([@expense])
        end
        it "should return PENDING expenses within date range" do
          xhr :get, :index, format: :docx, q: AppSettings::REMARK_STATUS[:pending], daterange: daterange
          expect(response).to render_template('expenses/expenses/expenses_xls_docx.html.erb')
          #expect(assigns(:expenses)).to eq([@expense_2, @expense_1])
        end
        it "should return APPROVED expenses within date range" do
          xhr :get, :index, format: :docx, q: AppSettings::REMARK_STATUS[:approved], daterange: daterange
          expect(response).to render_template('expenses/expenses/expenses_xls_docx.html.erb')
          #expect(assigns(:expenses)).to eq([@expense_5, @expense_4, @expense_3])
        end
        it "should return REMARKED expenses within date range" do
          xhr :get, :index, format: :docx, q: AppSettings::REMARK_STATUS[:remarked], daterange: daterange
          expect(response).to render_template('expenses/expenses/expenses_xls_docx.html.erb')
          #expect(assigns(:expenses)).to eq([@expense_9, @expense_8])
        end
      end
    end
    context 'With date range but no status' do
      daterange = Date.today.to_s + '  To  ' + Date.today.to_s
      it "should return ALL expenses within date range" do
        get :index, daterange: daterange
        expect(response).to be_success
        #expect(assigns(:expenses)).to eq([@expense_9, @expense_8, @expense_5, @expense_4, @expense_3, @expense_2, @expense_1])
      end
    end
  end

  describe 'GET #new' do
    it "should return new espense and all current departments expense category" do
      xhr :get, :new, format: :js
      expect(response).to be_success
    end
    it 'should assign a newly expense' do
      xhr :get, :new, format: :js
      expect(assigns(:expense)).to be_a_new(Expenses::Expense)
    end
    it 'should assign a expense  category' do
      xhr :get, :new, format: :js
      expect(assigns(:categories)).to eq([@expense_category])
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it "should create an expense successfully" do
        post :create, expenses_expense: valid_attributes
        expect(response).to redirect_to(expenses_expenses_path)
        expect(assigns(:expense)).to eq(Expenses::Expense.all.last)
      end
    end
    context 'with invalid params' do
      it "should not create expense" do
        post :create, expenses_expense: invalid_attributes
        expect(response).to redirect_to(expenses_expenses_path)
        expect(assigns(:expense).errors.full_messages.first).to eq("Date can't be blank")
      end
    end
  end

  describe 'GET #edit' do
    it "should assign an expense and return all expens categories of current department" do
      xhr :get, :edit, id: @expense.id, format: :js
      expect(response).to be_success
      expect(assigns(:categories)).to eq([@expense_category])
    end
  end

  describe 'PUT #update' do
    context 'with valid params' do
      it "should update an expense" do
        put :update, id: @expense.id, expenses_expense: valid_attributes
        expect(assigns(:expense).amount).to eq(1800)
      end
    end
    context 'with invalid params' do
      it "should update an expense" do
        put :update, id: @expense.id, expenses_expense: invalid_attributes
        expect(assigns(:expense).errors.full_messages.first).to eq("Date can't be blank")
      end
    end
  end

  describe 'DELETE #destroy' do
    it "should destroy an expense" do
      count = @department.expenses_expenses.count
      delete :destroy, id: @expense.id
      expect(response).to redirect_to(expenses_expenses_path)
      expect(@department.expenses_expenses.count).to eq(count-1)
    end
  end

  describe 'GET #approve_reject' do
    it "should approve an expense" do
      get :approve_reject, id: @expense.id, is_approved: 'yes'
      expect(response).to redirect_to(expenses_expenses_path)
      expect(assigns(:expense).status).to eq(AppSettings::REMARK_STATUS[:approved])
    end
    it "should reject an expense" do
      get :approve_reject, id: @expense.id
      expect(response).to redirect_to(expenses_expenses_path)
      expect(assigns(:expense).status).to eq(AppSettings::STATUS[:rejected])
    end
  end

  describe 'GET #report' do
    context 'with year params' do
      it "should return yearly expense report" do
        get :report, date: {year: Date.today.year}
        expect(assigns(:start_date)).to eq(Date.today.beginning_of_year)
        expect(assigns(:end_date)).to eq(Date.today.end_of_year)
        expect(assigns(:expense_categories)).to eq([@expense_category])
        expect(assigns(:expense_report)[:month_total][:amount]).to eq(5000)
        expect(assigns(:expense_report)[@expense_category.id][:category]).to eq(@expense_category)
      end
      it "should return xls of expense report" do
        xhr :get, :report, format: :xls
        expect(response).to be_success
      end
      it "should render xls  template of expense report" do
        xhr :get, :report, format: :xls
        expect(response).to render_template('expenses/expenses/report_xls_docx.html.erb')
      end
      it "should return PDF of expense report" do
        xhr :get, :report, format: :pdf
        expect(response).to be_success
      end
      it "should render pdf  template of expense report" do
        xhr :get, :report, format: :pdf
        expect(response).to render_template('expenses/expenses/report_pdf.html.erb')
      end
      it "should return DOCX of expense report" do
        xhr :get, :report, format: :docx
        expect(response).to be_success
      end
      it "should render docx  template of expense report" do
        xhr :get, :report, format: :docx
        expect(response).to render_template('expenses/expenses/report_xls_docx.html.erb')
      end
    end
    context 'without year params' do
      it "should return yearly expense report" do
        get :report
        expect(assigns(:start_date)).to eq(Date.today.beginning_of_year)
        expect(assigns(:end_date)).to eq(Date.today.end_of_year)
        expect(assigns(:expense_categories)).to eq([@expense_category])
        expect(assigns(:expense_report)[:month_total][:amount]).to eq(5000)
        expect(assigns(:expense_report)[@expense_category.id][:category]).to eq(@expense_category)
      end
    end
  end

  describe 'get#monthly_report' do
    it 'should request to monthly_report' do
      get :monthly_report
      expect(response).to be_success
    end
    it 'should request to monthly_report with date params' do
      get :monthly_report, date: {month: Date.today.month, year: Date.today.year}
      expect(response).to be_success
    end
    it 'should assign start_date' do
      get :monthly_report
      expect(assigns(:start_date)).to eq(Date.today.beginning_of_month)
    end
    it 'should assign start_date' do
      get :monthly_report
      expect(assigns(:end_date)).to eq(Date.today.end_of_month)
    end
    it 'should assign @expense_categories' do
      get :monthly_report
      expect(assigns(:expense_categories)).to eq([@expense_category])
    end
    it 'should render to xls template' do
      xhr :get, :monthly_report, format: :xls
      expect(response).to render_template('expenses/expenses/monthly_report_xls_docx.html.erb')
    end
    it 'should render to pdf template' do
      xhr :get, :monthly_report, format: :pdf
      expect(response).to render_template('expenses/expenses/monthly_report_pdf.html.erb')
    end
    it 'should render to docx template' do
      xhr :get, :monthly_report, format: :docx
      expect(response).to render_template('expenses/expenses/monthly_report_xls_docx.html.erb')
    end
  end

  describe 'GET #category_wise_report' do
    context 'with category_id params' do
      it "should return yearly category wise expense report" do
        get :category_wise_report, date: {year: Date.today.year}, category_id: @expense_category.id
        expect(assigns(:start_date)).to eq(Date.today.beginning_of_year)
        expect(assigns(:end_date)).to eq(Date.today.end_of_year)
        expect(assigns(:expense_categories)).to eq([@expense_category])
        expect(assigns(:expense_category)).to eq(@expense_category)
        expect(assigns(:expense_sub_categories)).to eq([@expense_sub_category_1, @expense_sub_category_2, @expense_sub_category_3])
        expect(assigns(:expense_report)[:month_total][:amount]).to eq(5000)
        expect(assigns(:expense_report)[@expense_sub_category_1.id][:category]).to eq(@expense_sub_category_1)
      end
      it "should return xls of category wise expense report" do
        xhr :get, :category_wise_report, format: :xls, category_id: @expense_category.id
        expect(response).to be_success
      end
      it "should render xls template of category wise expense report" do
        xhr :get, :category_wise_report, format: :xls, category_id: @expense_category.id
        expect(response).to render_template('expenses/expenses/category_wise_report_xls_docx.html.erb')
      end
      it "should return PDF of category wise expense report" do
        xhr :get, :category_wise_report, format: :pdf, category_id: @expense_category.id
        expect(response).to be_success
      end
      it "should render pdf template of category wise expense report" do
        xhr :get, :category_wise_report, format: :pdf, category_id: @expense_category.id
        expect(response).to render_template('expenses/expenses/category_wise_report_pdf.html.erb')
      end
      it "should return DOCX of category wise expense report" do
        xhr :get, :category_wise_report, format: :docx, category_id: @expense_category.id
        expect(response).to be_success
      end
      it "should render docx template of category wise expense report" do
        xhr :get, :category_wise_report, format: :docx, category_id: @expense_category.id
        expect(response).to render_template('expenses/expenses/category_wise_report_xls_docx.html.erb')
      end

    end
    context 'without category_id params' do
      it "should return yearly category wise expense report" do
        get :category_wise_report
        expect(assigns(:start_date)).to eq(Date.today.beginning_of_year)
        expect(assigns(:end_date)).to eq(Date.today.end_of_year)
        expect(assigns(:expense_categories)).to eq([@expense_category])
        expect(assigns(:expense_category)).to eq(@expense_category)
        expect(assigns(:expense_sub_categories)).to eq([@expense_sub_category_1, @expense_sub_category_2, @expense_sub_category_3])
        expect(assigns(:expense_report)[:month_total][:amount]).to eq(5000)
        expect(assigns(:expense_report)[@expense_sub_category_1.id][:category]).to eq(@expense_sub_category_1)
      end

      it "should respond successfully if @expense_category not present" do
        get :category_wise_report
        expect(response).to be_success
      end
    end
  end

  describe 'get#report_breakdown' do
    it 'should request to report_breakdown of ExpensesController' do
      get :report_breakdown
      expect(response).to be_success
    end
    it 'should render to pdf template' do
      xhr :get, :report_breakdown, format: :pdf
      expect(response).to be_success
    end
    it 'should render to pdf template' do
      xhr :get, :report_breakdown, format: :pdf
      expect(response).to render_template('expenses/expenses/report_breakdown_pdf.html.erb')
    end
    it 'should render to xls template' do
      xhr :get, :report_breakdown, format: :xls
      expect(response).to be_success
    end
    it 'should render to xls template' do
      xhr :get, :report_breakdown, format: :xls
      expect(response).to render_template('expenses/expenses/report_breakdown_xls_docx.html.erb')
    end
    it 'should render to docx template' do
      xhr :get, :report_breakdown, format: :docx
      expect(response).to be_success
    end
    it 'should render to docx template' do
      xhr :get, :report_breakdown, format: :docx
      expect(response).to render_template('expenses/expenses/report_breakdown_xls_docx.html.erb')
    end

    context 'if params[:day] && params[:month].present? && params[:year].present?' do
      it 'should assign start_date according to given params' do
        get :report_breakdown, day: Date.today.day, month: Date.today.month, year: Date.today.year
        expect(response).to be_success
      end
    end
    context 'if params[:day] && params[:month].present? && params[:year].present?' do
      it 'should assign start_date according to given params' do
        get :report_breakdown, month: Date.today.month, year: Date.today.year
        expect(response).to be_success
      end
    end
    context 'if params[:day] && params[:month].present? && params[:year].present?' do
      it 'should assign start_date according to given params' do
        get :report_breakdown, year: Date.today.year
        expect(response).to be_success
      end
    end

    context 'if params[:category_id] present' do
      it 'should assign @expense_category' do
        get :report_breakdown, category_id: @expense_category.id
        expect(assigns(:expense_category)).to eq(@expense_category)
      end
    end
    context 'if params[:category_id] present' do
      it 'should assign @expense_category' do
        get :report_breakdown, sub_category_id: @expense_sub_category_1.id
        expect(assigns(:expense_sub_category)).to eq(@expense_sub_category_1)
      end
    end

  end

end
