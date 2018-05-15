module FaceApi
  #This is the official code from Api referrence
  def create_group(id, name)
    uri = URI(azure_face_uri << id)
    uri.query = URI.encode_www_form({
                                    })

    request = Net::HTTP::Put.new(uri.request_uri)
    # Request headers
    request['Content-Type'] = 'application/json'
    # Request headers
    request['Ocp-Apim-Subscription-Key'] = key
    # Request body
    request.body = "{'name' : '#{name}'}"

    response = Net::HTTP.start(uri.host, uri.port, :use_ssl => uri.scheme == 'https') do |http|
      http.request(request)
    end

    response.body
  end

  #sample code of using "Curb"
  def destroy_group(name)
    response = Curl.delete(azure_face_uri << name) do |http|
      http.headers["Ocp-Apim-Subscription-Key"] = key
    end
    response.body_str
  end

  def list_group
    request = Curl.get(azure_face_uri) do |http|
      http.headers["Ocp-Apim-Subscription-Key"] = key
    end
    request.body_str
  end

  def create_person(arg)
    response = Curl.post(azure_face_uri + arg["department_id"] + "/persons") do |http|
      http.headers["Ocp-Apim-Subscription-Key"] = key
      http.headers["content-type"] = "application/json"
      http.post_body = "{ 'name' : '#{arg["name"]}'}"
    end
    response.body_str
  end

  def delete_person(arg)
    response = Curl.delete(azure_face_uri + arg["department_id"] + "/persons/" + arg["person_id"]) do |http|
      http.headers["Ocp-Apim-Subscription-Key"] = key
    end
    response.body_str
  end

  def list_person(person_group_id)
    request = Curl.get(azure_face_uri + person_group_id + "/persons") do |http|
      http.headers["Ocp-Apim-Subscription-Key"] = key
    end
    request.body_str
  end

  def recieve_person(person_group_id, person_id)
    request = Curl.get(azure_face_uri + person_group_id + "/persons/" + person_id) do |http|
      http.headers["Ocp-Apim-Subscription-Key"] = key
    end
    request.body_str
  end

  def add_face_image(person_group_id, person_id, file)
    response = Curl.post(azure_face_uri + person_group_id + "/persons/" + person_id + "/persistedFaces") do |http|
      http.headers["Ocp-Apim-Subscription-Key"] = key
      http.headers["content-type"] = "application/octet-stream"
      http.post_body = file
    end
    p response.body_str
    train_person(person_group_id)
  end

  def train_person(person_group_id)
    p "train start"
    request = Curl.post(azure_face_uri + person_group_id + "/train") do |http|
      http.headers["Ocp-Apim-Subscription-Key"] = key
      http.headers["content-type"] = "application/json"
    end
    p request.body_str
    puts "successfully trained" unless request.body_str.nil?
  end

  def detect_face(file)
    request = Curl.post(azure_face_uri.gsub("persongroups/", "") + "detect?returnFaceId=true") do |http|
      http.headers["Ocp-Apim-Subscription-Key"] = key
      http.headers["content-type"] = "application/octet-stream"
      http.post_body = file
    end
    request.body_str
    p "detect start"
    p request.body_str
  end

  def identify_face(person_group_id, face_ids)
    request = Curl.post(azure_face_uri.gsub("persongroups/", "") + "identify") do |http|
      http.headers["Ocp-Apim-Subscription-Key"] = key
      http.headers["content-type"] = "application/json"
      http.post_body = "{
          'personGroupId': '#{person_group_id}',
          'faceIds': #{face_ids},
          'maxNumOfCandidatesReturned': 1,
          'confidenceThreshold': 0.5
        }"
      http.on_success {|x| puts "success"}
    end
    request.body_str
    p request.body_str
  end

  def azure_face_uri
    Settings.azure_face[:uri]
  end

  def key
    Settings.azure_face[:key]
  end
end