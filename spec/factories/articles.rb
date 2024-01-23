FactoryBot.define do
  factory :article do
    title {"MyTitle"}
    body {"MyTextbody"}
    status {"public"}
    # after(:build) do |article|
    #   article.images.attach(io: File.open(Rails.root.join('spec', 'fixtures', 'files', 'school-winter.png')), filename: 'school-winter.png', content_type: 'image/png')
    # end
  end
end
