class Components::Photo < Components::HTML
  attr_reader :photo

  def initialize(photo:)
    @photo = photo
  end

  erb_template <<~ERB
    <div class="flex group py-2 border-b border-sky-900/50 relative">
      <div class="mr-4 shrink-0 self-center w-64">
        <img src="/public/<%= photo.image_url %>" alt="" class="aspect-auto object-cover group-hover:opacity-75" />
      </div>
      <div>
        <h4 class="text-lg font-bold text-gray-900 dark:text-white">
          <a href="#">
            <span aria-hidden="true" class="absolute inset-0"></span>
            <%= photo.image.metadata["filename"] %>
          </a>
        </h4>
        <p class="mt-1 text-gray-500 dark:text-gray-400">dolor</p>
      </div>
    </div>
  ERB
end
