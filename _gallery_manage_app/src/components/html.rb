class Components::HTML < Phlex::HTML
  def self.erb_template(content)
    template = Tilt["erb"].new { content }

    define_method :view_template do
      raw(safe(template.render(self)))
    end
  end

  extend Forwardable

  def_delegators :app, :link_to, :dom_id

  def app()= context[:app]

  register_element :turbo_frame
end
