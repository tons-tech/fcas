class UserController < ApplicationController
  include FaceApi

  def new
    @response = JSON.parse(list_group)
    @response.map! do |i|
      [i["name"], i["personGroupId"]]
    end
    @user = User.new
  end

  def create
    #find person's group id by name
    response = create_person(strong_user)
    @user = User.new(strong_user)
    if @user.save == response.present?
      redirect_back fallback_location: { action: :new}, :notice => "Successfully Added a user"
    end
  end

  def destroy
    response = delete_person(strong_user)
    user = User.where(:name => strong_user[:name], :department_id => strong_user[:department_id])
    if user.destroy(user.ids).present? == response.blank?
      redirect_to ({action: :manage_staff}), :notice => "Successfully deleted the user"
    else
      redirect_to ({action: :manage_staff}), :notice => "Something went wrong"
    end
  end

  def manage_staff
    groups = JSON.parse(list_group)
    groups.map do |i|
      i.store("names", JSON.parse(list_person(i["personGroupId"])))
    end
    @groups = groups
  end

  def add_face
    @person_info = strong_user
  end

  def create_face
    person_group_id = params[:department_id]
    person_id = params[:person_id]
    image = params[:image]
    File.binwrite("public/images/#{image.original_filename}", image.read)
    if File.exists?("public/images/#{image.original_filename}")
      puts "File has created without error"
    end
    add_face_image(person_group_id, person_id, File.binread("public/images/#{image.original_filename}"))
    delete_image(image.original_filename)
    redirect_to ({action: :manage_staff}), :notice => "Successfully Posted the image"
  end

  def delete_image(file_name)
    File.delete("public/images/#{file_name}")
    puts "Done deleting the file"
  end

  private

  def strong_user
    params.require(:user).permit(:department_id, :name, :person_id)
  end
end
