require 'rails_helper'

RSpec.describe Article, type: :model do
  describe "create" do
    # article = FactoryBot.build(:article)
    let(:article) {FactoryBot.build(:article)}

    context "is valid with title, body, status and images" do
      it{expect(article).to be_valid}
      it{expect(article.body.size).to be >= 10}
    end
  end

  describe "attach image" do
    image = ActiveStorage::Blob.create_and_upload!(
      io: File.open(Rails.root.join('spec', 'files', 'school-winter.png'), 'rb'),
      filename: 'school-winter.png',
      content_type: 'image/png'
    ).signed_id
    let(:article) {FactoryBot.build(:article, images: image)}

    context 'is valid if image is attached' do
      it{expect(article.valid?).to eq true}
      it{expect(article.images.first.content_type).to eq 'image/png'}
    end
  end
end

