FactoryBot.define do
  factory :proposal do
    event { Event.first || create(:event) }
    sequence(:title) { |i| "A fine proposal#{i}" }
    abstract "This and that"
    details "Various other things"
    pitch "Baseball."
    session_format { SessionFormat.first || create(:session_format) }

    factory :proposal_with_track do
      event { Event.first || create(:event) }
      sequence(:title) { |i| "A fine proposal#{i}" }
      abstract Faker::Hacker.say_something_smart
      details Faker::Hipster.sentence
      pitch Faker::Superhero.name
      track
      session_format { SessionFormat.first || create(:session_format) }
    end

    trait :with_reviewer_public_comment do
      after(:create) do |proposal|
        reviewer = create(:user, :reviewer)
        create(:comment, proposal: proposal, type: "PublicComment", user: reviewer, body: "Reviewer comment")
      end
    end

    trait :with_organizer_public_comment do
      after(:create) do |proposal|
        organizer = create(:organizer, event: proposal.event)
        create(:comment, proposal: proposal, type: "PublicComment", user: organizer, body: "Organizer comment")
      end
    end

    trait :with_speaker do
      after(:create) do |proposal|
        proposal.speakers << create(:speaker, event: proposal.event)
      end
    end

    trait :with_two_speakers do
      after(:create) do |proposal|
        proposal.speakers << create(:speaker, event: proposal.event, bio: nil)
        proposal.speakers << create(:speaker, event: proposal.event, bio: nil)
      end
    end
  end
end
