Rails.application.routes.draw do
  post 'duty/branch_duty'
  get 'duty/index'

  get 'department/new'
  delete 'department/destroy'
  get 'department/manage'
  post 'department/create'
  get 'department/record'
  get 'department/monthly_record'
  get 'department/staff_record'

  # get 'user/add_face/:persongroupid/:personid' => 'user#add_face'
  get 'user/add_face'
  post 'user/create_face'
  get 'user/manage_staff'
  delete 'user/destroy'
  post 'user/create'
  get 'user/new'

  root 'home#top'


  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
