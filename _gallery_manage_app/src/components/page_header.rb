class Components::PageHeader < Components::HTML
  def initialize(title:)
    @title = title
  end

  def view_template
    div(id: "page-header", class: "md:flex md:items-center md:justify-between") do
      div(class: "min-w-0 flex-1") do
        h2(class: "text-2xl/7 font-bold text-gray-900 sm:truncate sm:text-3xl sm:tracking-tight dark:text-white") do
          plain @title
        end
      end

      div(class: "mt-4 flex md:mt-0 md:ml-4") do
        yield
      end
    end
  end
end
