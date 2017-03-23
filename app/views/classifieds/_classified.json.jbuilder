json.extract! classified, :id, :title, :document_type, :seller_name, :email,
                          :landline, :cell_phone, :description, :created_at, :updated_at
json.url classified_url(classified, format: :json)
