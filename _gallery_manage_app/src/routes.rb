require "roda"
require "phlex"
require "erubi/capture_block"

class Routes < Roda
  include Helpers::Tags

  plugin :multi_public,
    public: "public/",
    assets: "assets/"

  plugin :render,
    layout: "layouts/page",
    extract_fixed_locals: true,
    default_fixed_locals: "()",
    engine_class: Erubi::CaptureBlockEngine

  plugin :content_for
  plugin :partials
  plugin :route_csrf, require_request_specific_tokens: false, check_header: true
  plugin :link_to

  plugin :turbo
  plugin :status_303 # rubocop:disable Naming/VariableNumber
  # use Rack::MethodOverride
  plugin :forme_route_csrf
  plugin :response_content_type, mime_types: {
    html: "text/html",
    stream: "text/vnd.turbo-stream.html"
  }

  plugin :sessions, secret: ENV.fetch("APP_SESSION_SECRET")
  plugin :flash

  plugin :websockets
  plugin :all_verbs

  path(:root, "/")
  path(:galleries, "/galleries")
  path(Models::Gallery) { |gallery, *paths| ["/galleries/#{gallery.id}", *paths].join("/") }
  path(Models::Photo) { |photo, *paths| ["/photos/#{photo.id}", *paths].join("/") }

  route do |r|
    check_csrf!

    r.on("public") { r.multi_public(:public) }
    r.on("assets") { r.multi_public(:assets) }

    r.is "events" do
      r.websocket do |connection|
        while message = connection.read
          connection.write(message)
        end
      end
    end

    r.root { view("root") }

    r.on "galleries" do
      r.is do
        r.get do
          @galleries = Models::Gallery.all
          view("gallery/index")
        end

        r.post do
          @gallery = Models::Gallery.new.save
          turbo_stream.prepend "gallery-list", component(Components::Gallery.new(gallery: @gallery))
        end
      end

      r.on Integer do |gallery_id|
        @gallery = Models::Gallery.with_pk!(gallery_id)

        r.is do
          r.get do
            view("gallery/show")
          end

          r.post do
            gallery_params = r.params["gallery"]

            new_photos_attributes = r.params.fetch("photos", []).inject({}) do |hash, file|
              hash.merge!(SecureRandom.hex => { image: file })
            end

            photos_attributes = gallery_params["photos_attributes"].to_h
              .merge(new_photos_attributes)

            if r.params.dig("bulk", "selected")
              photos_attributes
                .transform_values! do |photo|
                  next photo unless r.params.dig["bulk"]["selected"].include? photo["id"]

                  photo.merge(r.params["bulk"]["action"])
                end
            end

            gallery_attributes = gallery_params.merge("photos_attributes" => photos_attributes)

            @gallery.update gallery_attributes
            flash["saved"] = true
            r.redirect path(@gallery)
          end
        end

        r.post "delete" do |gallery_id|
          @gallery.delete
          r.redirect galleries_path
        end
      end
    end

    r.on "photos" do
      r.is do
        @photos = Models::Photo.all
        view("photos/index")
      end

      r.on Integer do |photo_id|
        @photo = Models::Photo.with_pk!(photo_id)

        r.is do
          r.get do
            view("photos/show")
          end
        end

        r.on :metadata do
          r.get do
            response.content_type = :stream
            turbo_stream.append(
              "body",
              view(
                "gallery/metadata-edit",
                layout: "layouts/sidebar-modal",
                layout_opts: {
                  locals: { modal_id: "photo-#{@photo.id}-metadata", modal_title: "Photo Metadata" }
                }
              )
            )
          end
        end
      end
    end
  end
end
