# frozen-string-literal: true
require "kramdown-parser-gfm"

# Cashby Flavored Markdown
# Aka, GFM with some flare.
#
# Adds the following features:
# - wrapping text in ==/:: to highlight/mark it
#
# ### Highlights
# Optionally, an emoji color dot can be used as the first character to signify the
# highligh color:
#
#     ==🔴testing==
#
# Which would produce:
#
#     <mark class="red">testing</mark>`
#
# This can also be done with a span IAL for custom classes that aren't mapped
# to a basic emoji dot color:
#
#     ==following test=={: .-gray}
#
# Adjusted from the Monkeypatch that Bridgetown put together, with additional
# support for the Obsidian style which uses emoji to set the color.
#
# @see https://github.com/bridgetownrb/bridgetown/pull/551/changes
# @see https://kramdown.gettalong.org/syntax.html#span-ials
module Kramdown
  module Parser
    class CFM < Kramdown::Parser::GFM
      MARK_DELIMITER = %r{(==|::)+}.freeze
      MARK_MATCH = %r{#{MARK_DELIMITER}(?!\s|=|:).*?[^\s=:]#{MARK_DELIMITER}}m.freeze

      define_parser(:mark, MARK_MATCH)

      alias_method :_old_initialize, :initialize
      def initialize(source, options)
        _old_initialize(source, options)
        @span_parsers << :mark
      end

      def parse_mark
        line_number = @src.current_line_number

        color = emoji_colormap(@src.matched[2])

        start = 2
        start = 3 unless color.nil?

        @src.pos += @src.matched_size
        el = Element.new(:html_element, "mark", { "class" => color }, category: :span, line: line_number)
        @tree.children << el

        preserving_env do
          reset_env(
            src: Kramdown::Utils::StringScanner.new(@src.matched[start..-3], line_number),
            text_type: :text
          )
          parse_spans(el)
        end

        el
      end

      private

      def emoji_colormap(emoji)
        case emoji
        when "🔴" then "red"
        when "🟠" then "orange"
        when "🟡" then "yellow"
        when "🟢" then "green"
        when "🔵" then "blue"
        when "🟣" then "purple"
        when "⚪️" then "white"
        else nil
        end
      end

      def preserving_env
        env = save_env
        yield
        restore_env(env)
      end
    end
  end
end

