##
#
# Select Bootstrap Modal
#
# @locator Matches id or contents of wrapped header
#
# @filter [String] :id Matches id attribute
# @filter [String] :title Matches contents of wrapped header
# @filter [String, Array<String>] :class Matches the class(es) provided
#
Capybara.add_selector(:bs_modal) do
  CSS_CLASSES = {
    base:     %w[modal],
    visible:  %w[in],
    content:  %w[modal-content],
    header:   %w[modal-header],
    body:     %w[modal-body],
    title:    %w[modal-title]
  }.freeze

  label 'Bootstrap Modal'

  xpath(:title) do |locator, **_options|
    bs_modal_xpath = XPath.descendant[find_by_class_attr(CSS_CLASSES[:base])]
    unless locator.nil?
      locator           = locator.to_s
      locator_matches   = XPath.attr(:id) == locator
      locator_matches  |= build_title_xpath(locator)

      bs_modal_xpath = bs_modal_xpath[locator_matches]
    end

    bs_modal_xpath
  end

  expression_filter(:title) do |expr, val|
    expr[build_title_xpath(val)]
  end

  describe do |**options|
    desc = ''.dup
    desc << describe_all_expression_filters(options)
    desc
  end

  def build_title_xpath(title_str)
    XPath.descendant[(
        find_by_attr(:class, CSS_CLASSES[:header]) |
        find_by_attr(:class, CSS_CLASSES[:title])
    ) & XPath.string.n.is(title_str)]
  end
end
