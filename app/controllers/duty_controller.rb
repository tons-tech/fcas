class DutyController < ApplicationController
  include FaceApi

  def index
  end

  def branch_duty
    random_name = SecureRandom.hex
    File.binwrite("public/images/#{random_name}.png", Base64.decode64(params[:image]))
    to_identify = JSON.parse(detect_face(File.binread("public/images/#{random_name}.png")))
    groups = JSON.parse(list_group)
    select_id = -> x {x["faceId"]}
    face = to_identify.map(&select_id)
    groups.each do |g|
      response = JSON.parse(identify_face(g["personGroupId"], face))
      person_id = response[0].dig("candidates", 0, "personId")
      person_group_id = g["personGroupId"]
      if person_id
        name = JSON.parse(recieve_person(person_group_id, person_id))["name"]
        investigate_working_status(person_group_id, name, random_name)
        break
      else
        puts "Continue to next loop"
        next
      end
    end
  end

  def investigate_working_status(person_group_id, name, file_name)
    #does created_at column exits? with the date of today within name.
    user = User.find_by(name: name, department_id: person_group_id)
    #change unless Duty.where... to if not
    if not Duty.where(user_id: user).exists?(created_at: Time.zone.now.beginning_of_day..Time.zone.now.end_of_day)
      puts "start duty"
      start_duty(user)
    else
      puts "exit duty"
      exit_duty(user)
    end
    delete_image(file_name)
  end

  def start_duty(user)
    user.duties.create(start_time: time["time"], duty_date: time["date"])
    redirect_to ({action: :index}), :notice => "Good Luck with your duty"
  end

  def exit_duty(user)
    user.duties.last.update(exit_time: time["time"], duty_date: time["date"])
    redirect_to ({action: :index}), :notice => "Get hoem safely!!"
  end

  def error_duty
    flash[:alert] = "Error Occured"
    redirect_to action: :index
  end

  def time
    time1 = Time.zone.now.to_s.split
    time2 = ["date", "time", "UTC"]
    time = Hash[time2.zip(time1)]
    time
  end

  def delete_image(file_name)
    File.delete("public/images/#{file_name}.png")
    puts "Done deleting the file"
  end

end
