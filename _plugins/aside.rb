# frozen_string_literal: true

module Jekyll
  module Tags
    # Renders a nice little inline annotation/footnote like thing
    # that can show/hide on clicks with some simple little JS
    class Aside < Liquid::Block
      include Liquid::StandardFilters

      def initialize(tag_name, args, context)
        super
        parts = args.split("|").map(&:strip)

        @color = parts[1] || "gray"
        @title = parts[0]
      end

      def render(context)
        context.registers[:aside_index] ||= 0
        context.registers[:aside_index] = context.registers[:aside_index].next
        id = context.registers[:aside_index]

        context.stack do
          body = super
          site = context.registers[:site]

          converter = site.find_converter_instance(Jekyll::Converters::Markdown)

          title = Liquid::Template.parse(@title).render(context)

          # Yolo
          # Remove the paragraph wrappers from the inner content since liquid
          # wants to render them as is and I'm too lazy to make it work
          content = converter.convert(body)
            .strip()
            .gsub(%r{[[:cntrl:]]}, "")
            .gsub(%r{<(p|/p)>}, "")

          <<~HTML
          <a href="#annotation-#{id}" class="annotation-trigger -#{@color}">#{title}</a>
          <span id="annotation-#{id}" class="annotation"> #{content} </span>
          HTML
        end
      end
    end
  end
end

Liquid::Template.register_tag('aside', Jekyll::Tags::Aside)
