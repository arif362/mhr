class AppSettings
  EXPORT_TO = ['pdf', 'xls', 'word']

  MONTHS_SHORT_NAME = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'June', 'July', 'Aug', 'Sept', 'Oct', 'Nov', 'Dec']

  REGISTRATION_PROGRESS = {
      create_account: 'User Info',
      company_profile: 'Company Info',
      select_module: 'Select Services',
      # finalize: 'Finalize'
  }

  REGISTRATION_STEPS = {
      registration: '/companies/new',
      feature_selection: '/settings/features',
      #payment: '/settings/billing'
  }

  DAYOFF_TYPES = {
      weekend: 'Weekend',
      holiday: 'Holiday',
      custom_holiday: 'Custom Holiday'
  }

  ACTIONS = {
      delete: 'delete',
      approve: 'approve',
      reject: 'reject',
      active: 'active',
      deactivate: 'deactivate'
  }

  STATUS = {
      approved: 'approved',
      rejected: 'rejected',
      pending: 'pending'
  }

  REMARK_STATUS = {
      approved: 'approved',
      remarked: 'remarked',
      pending: 'pending'
  }

  LEAVE_TYPES = {
      paid: 'Paid',
      unpaid: 'Unpaid'
  }

  ADVANCE_TYPES = {
      installment: 'Installment',
      one_time: 'One Time',
      on_request: 'On Request'
  }

  LEAVE_REPORT_TYPES = {
      recent: 'recent',
      yearly: 'yearly'
  }

  MODULE_VIDEO = {
      employee: 'eQwXqXX8imc',
      leave: 'bXltGhj-gho',
      attendance: '3tHcZHp_qic',
      payroll: 'TRNWThFciI8',
      provident_fund: 'NOVIncvj6dg',
      expense: 'mrBHZIu_Ur4',
      billing: '0bmlrCZXAnQ',
  }

  MODULES_NAME = ['employees', 'leave', 'payroll', 'attendance', 'expense', 'expenses', 'provident_fund', 'bank', 'billing', 'daily_progress']

end