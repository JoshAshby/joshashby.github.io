require "debug"

class Components::GalleryList < Components::HTML
  attr_reader :galleries

  def initialize(galleries:)
    @galleries = galleries
  end

  def view_template
    Components::PageHeader(title: "Galleries") do
      form(method: :post, action: app.galleries_path) do
        button(type: "submit", class: "inline-flex items-center rounded-md bg-white px-3 py-2 text-sm font-semibold text-gray-900 shadow-xs inset-ring inset-ring-gray-300 hover:bg-gray-50 dark:bg-white/10 dark:text-white dark:shadow-none dark:inset-ring-white/5 dark:hover:bg-white/20 cursor-pointer") do
          plain "new"
        end
      end
    end

    div(class: "flex flex-col gap-4", id: "gallery-list") do
      galleries.each do |gallery|
        Components::Gallery(gallery:)
      end
    end
  end
end
