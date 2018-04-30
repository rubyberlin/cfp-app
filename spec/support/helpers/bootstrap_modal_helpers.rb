
module BootstrapModalHelpers
  ##
  #
  # Execute the given block within the a specific Bootstrap Modal given the id
  # or tltle of that modal.
  #
  # @param [String] locator     Id or title of the modal. If not provided any
  #                             modal is matched
  #
  def within_bs_modal(locator = nil)
    within(:bs_modal, locator) { yield }
  end
end
