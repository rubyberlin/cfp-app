module Proposal::State
  extend ActiveSupport::Concern

  # TODO: Currently a defect exists in the rake db:migrate task that is
  # causing our files to be loaded more than once. Because our files are being
  # loaded more than once, we are receiving errors stating that these
  # constants have already been defined. Therefore, until this defect is
  # fixed, we need to check to ensure that the constants are not already
  # defined prior to defining them.
  unless const_defined?(:ACCEPTED)
    SOFT_ACCEPTED = 'soft accepted'.freeze
    SOFT_WAITLISTED = 'soft waitlisted'.freeze
    SOFT_REJECTED = 'soft rejected'.freeze

    ACCEPTED = 'accepted'.freeze
    WAITLISTED = 'waitlisted'.freeze
    REJECTED = 'rejected'.freeze
    WITHDRAWN = 'withdrawn'.freeze
    NOT_ACCEPTED = 'not accepted'.freeze
    SUBMITTED = 'submitted'.freeze

    SOFT_STATES = [SOFT_ACCEPTED, SOFT_WAITLISTED, SOFT_REJECTED, SUBMITTED].freeze
    FINAL_STATES = [ACCEPTED, WAITLISTED, REJECTED, WITHDRAWN, NOT_ACCEPTED].freeze

    SOFT_TO_FINAL = {
      SOFT_ACCEPTED => ACCEPTED,
      SOFT_REJECTED => REJECTED,
      SOFT_WAITLISTED => WAITLISTED,
      SUBMITTED => REJECTED
    }.freeze

    BECOMES_PROGRAM_SESSION = [ACCEPTED, WAITLISTED].freeze
  end

  included do
    def self.valid_states
      @valid_states ||= Proposal::State.constants.map { |c| const_get(c) if const_get(c).is_a?(String) }.compact!
    end

    # Create all state accessor methods like (accepted?, waitlisted?, etc...)
    Proposal::State.constants.each do |constant|
      next unless const_get(constant).is_a?(String)
      method_name = constant.to_s.downcase + '?'
      define_method(method_name) do
        Proposal::State.const_get(constant) == state
      end
    end
  end
end
