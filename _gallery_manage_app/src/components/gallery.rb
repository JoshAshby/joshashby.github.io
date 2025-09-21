class Components::Gallery < Components::HTML
  attr_reader :gallery

  def initialize(gallery:)
    @gallery = gallery
  end

  def view_template
    # turbo_frame(id: dom_id(gallery)) do
      div(class: "flex group py-2 border-b border-sky-900/50 relative min-h-24") do
        div(class: "mr-4 shrink-0 self-center w-64") do
          img(src: gallery.cover_photo&.image_url, alt: "Cover image", class: "aspect-auto object-cover group-hover:opacity-75")
        end

        div(class: "flex flex-row") do
          div(class: "flex flex-col") do
            h4(class: "text-lg font-bold text-gray-900 dark:text-white") do
              a(href: app.path(gallery)) do
                span(class: "absolute inset-0", aria: { hidden: true })
                plain gallery.title
              end
            end

            p(class: "mt-1 text-gray-500 dark:text-gray-400") do
              plain gallery.description
            end
          end

          div(class: "") do
            comment { "Menu!" }
          end
        end
      end
    # end
  end
end
