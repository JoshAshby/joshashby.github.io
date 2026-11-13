# frozen_string_literal: true
require "nokogiri"

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

# Converts a <mark> wrapped footnote from Kramdown into an aside Annotation
module MarkedFootnotesToAsides
  module_function def call(content)
    doc = Nokogiri::HTML5::Document.parse(content)

    doc.css("mark > sup").each do |node|
      reference_id = node.children.attr("href").value.delete_prefix("#")
      reference_content = doc.at_css(".footnotes [id=\"#{reference_id}\"] > p")

      mark = node.parent
      footnote_li = reference_content.parent

      id = reference_id.delete_prefix("fn:")
      classes = node.parent.attr("class") || ""

      color = case classes.split(" ")
      in [*, "red", *] then "-red"
      in [*, "orange", *] then "-orange"
      in [*, "yellow", *] then "-yellow"
      in [*, "green", *] then "-green"
      in [*, "blue", *] then "-blue"
      in [*, "purple", *] then "-purple"
      else "-gray"
      end

      anchor = Nokogiri::XML::Node.new("a", doc) do |node|
        node.children = mark.children
        node["href"] = "annotation-#{id}"
        node["class"] = ["annotation-trigger", color, *classes].join(" ")
      end
      annotation = Nokogiri::XML::Node.new("span", doc) do |node|
        node.children = reference_content.children
        node["id"] = "annotation-#{id}"
        node["class"] = "annotation"
      end

      mark.add_next_sibling(anchor)
      anchor.add_next_sibling(annotation)

      annotation.at_css('a[role="doc-backlink"]').remove
      anchor.at_css('sup').remove
      footnote_li.remove
      mark.remove
    end

    doc.to_html
  end
end

# Only convert the output, rather than the post contents, so that plugins like
# jekyll-feed still get the normal Kramdown footnotes instead, which render
# nicer in readers.
Jekyll::Hooks.register :documents, :post_render, priority: :high do |doc|
  doc.output = MarkedFootnotesToAsides.call(doc.output)
end

Jekyll::Hooks.register :pages, :post_render, priority: :high do |page|
next unless page.ext == ".html"
  page.output = MarkedFootnotesToAsides.call(page.output)
end

Liquid::Template.register_tag("aside", Jekyll::Tags::Aside)
