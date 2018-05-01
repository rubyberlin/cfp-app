class ProposalSerializer < ActiveModel::Serializer
  attributes :title, :abstract, :review_tags, :id, :track, :video_url, :slides_url, :custom_fields
  has_many :speakers

  delegate :review_tags, to: :object

  def track
    object.track&.name
  end
end
