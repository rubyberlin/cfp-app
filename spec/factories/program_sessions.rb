FactoryBot.define do
  factory :program_session do
    sequence(:title) { |i| "Default Session #{i}" }
    abstract "Just some abstract"
    state ProgramSession::LIVE
    session_format
    event { Event.first || create(:event) }

    factory :program_session_with_proposal do
      proposal { build(:proposal, state: Proposal::ACCEPTED) }

      trait :with_speaker do
        after(:create) do |program_session|
          program_session.speakers << create(:speaker, event: program_session.event)
        end
      end
    end
  end
end
