class DepartmentController < ApplicationController
  include FaceApi

  def new
  end

  def create
    request = create_group(params[:groupid], params[:groupname])
    if request.blank?
      redirect_to ({action: :manage}), :notice => "Successfully created the department"
    else
      redirect_to ({action: :new}), :alert => "Something went wrong!"
    end
  end

  def manage
    #getting list of groups
    response = JSON.parse(list_group)
    @response = response.map! do |i|
      i["personGroupId"]
    end
  end

  def record
    @month = Date::MONTHNAMES[1..12]
  end

  def monthly_record
    @month = params[:month]
    @record = params[:department_id]
    @staffs = User.where(department_id: params[:department_id])
  end

  def staff_record
    @month = params[:month]
    month = Date::MONTHNAMES.index(params[:month]).to_s
    if month.length == 1
      num = "0" + month
    end
    @name = User.find(params[:user_id])
    @records = User.where(department_id: params[:department_id], id: params[:user_id]).joins(:duties).select("*").where('duty_date REGEXP ?', '\d{4}-' + num.to_s + '-\d{2}')
    respond_to do |format|
      format.html
      format.csv do
        send_data render_to_string, filename: "#{@name.name}.csv", type: :csv
      end
    end
  end

  def destroy
    response = destroy_group(params[:department_id])
    if response.blank?
      redirect_to ({action: :manage}), notice: "Successfully deleted the department"
    else
      redirect_to ({action: :manage}), notice: "Something went wrong"
    end
  end
end
