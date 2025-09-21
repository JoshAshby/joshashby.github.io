class Components::PhotoGrid < Components::HTML
  attr_reader :photo

  def initialize(photo:)
    @photo = photo
  end

  erb_template <<~ERB
    <div class="group relative border-r border-b border-sky-900/25 p-4 sm:p-6">
      <img src="/public/<%= photo.image_url %>" alt="" class="aspect-auto object-cover group-hover:opacity-75" />
      <div class="pt-4 pb-2 text-center">
        <h3 class="text-sm font-medium text-gray-900">
          <a href="#">
            <span aria-hidden="true" class="absolute inset-0"></span>
            Organize Basic Set (Walnut)
          </a>
        </h3>
        <div class="mt-3 flex flex-col items-center">
          <p class="sr-only">5 out of 5 stars</p>
          <p class="mt-1 text-sm text-gray-500">38 reviews</p>
        </div>
      </div>
    </div>
  ERB
end
