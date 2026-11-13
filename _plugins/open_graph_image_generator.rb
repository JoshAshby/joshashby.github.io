# frozen-string-literal: true

module Jekyll
  class OpenGraphImageGenerator < Generator
    class OpenGraphError < StandardError
    end

    class TypstError < StandardError
    end

    class OpenGraphFile < StaticFile
      def initialize(site, base, dir, name, dest)
        super(site, base, dir, name)
        @dest = dest
      end

      def destination(dest) = File.join(dest, @dest, @name)
    end

    attr_reader :config, :root

    safe true
    priority :high

    def initialize(site_config = {})
      @config = site_config.fetch("open_graph_image_generator", {})
      @root = Pathname.new(site_config["source"])

      @generated_files = {}
    end

    def generate(site)
      generator = method(:generate_image).curry(2).call(site)

      site.documents.each(&generator)
      site.pages.each(&generator)
    end

    private

    def generate_image(site, document)
      template_path = document_config(document, "template", default: config.fetch("default_template"))

      cache_key = cache_hash(document, template_path)
      cache = cache_dir / "#{cache_key}.png"

      static_file = @generated_files[cache_key] ||= OpenGraphFile.new(
        site,
        site.source,
        cache.parent.relative_path_from(site.source).to_s,
        cache.basename,
        config.fetch("output_dir")
      )

      site.static_files << static_file unless site.static_files.include?(static_file)
      document.data["open_graph_image"] ||= {}
      document.data["open_graph_image"]["url"] = static_file.destination("") # TODO: should this be something other than ""?

      return if cache.exist?
      typst(
        template_path,
        cache.to_s,
        title: document.data["title"],
        date: document.data["date"]&.to_date&.to_s || "",
        tags: document.data["tags"]&.join(",") || "",
        **template_inputs(site, document)
      )
    end

    # Allows additional data to be piped into the templates from a dot-path in
    # either "document" or "site"
    #
    #    open_graph_image:
    #     inputs:
    #       slug: "slug"
    #       site_name:
    #         scope: site
    #         path: "name"
    #
    def template_inputs(site, document)
      input_map = document_config(document, "inputs", default: config.fetch("inputs", {}))

      input_map.to_h do |key, scope_and_path|
        scope_and_path = { "scope" => "document", "path" => scope_and_path } unless scope_and_path.is_a?(Hash)

        scope = case scope_and_path["scope"]
        when "document" then document.data
        when "site" then site.config
        else raise OpenGraphError, "Invalid scope '#{scope}' in document open_graph_image metadata"
        end

        path = scope_and_path["path"].split(".")

        [key, scope.dig(*path)]
      end
    end

    def document_config(document, *keys, default: nil)
      doc_data = document.data.fetch("open_graph_image", {}).dig(*keys)
      doc_data || default
    end

    def cache_dir = root.join(config.fetch("cache_dir", ".open_graph")).mkpath

    def cache_hash(document, template_path)
      Digest::MD5.hexdigest(
        [
          document.data["slug"],
          document.data["permalink"],
          template_path,
          root.join(template_path).read
        ].join("")
      )
    end

    def typst(template_path, output_path, **inputs)
      font_args = config.fetch("font_paths", []).flat_map { ["--font-path", _1] }
      input_args = inputs.flat_map { ["--input", "#{_1}=#{_2}"] }

      run(
        "typst",
        "compile",
        "--root", root.to_s,
        "--format", "png",
        "--ppi", config.fetch("ppi", "144"),
        *font_args,
        *input_args,
        template_path, output_path
      )
    end

    def verbose? = ENV.fetch("OG_VERBOSE", "off") == "on"

    def run(cmd, *args, debug_cmd: verbose?)
      opts = io_options(stderr_output: debug_cmd)

      if debug_cmd
        puts("Running: " + [cmd, *args].join(" "))
        puts("  ENV: #{env}")
        puts("  IO:  #{opts}")
      end

      system(env, cmd, *args, opts).tap do |result|
        puts("  Result: #{result}") if debug_cmd
        raise TypstError, "typst exec failed: #{cmd} #{args.join(" ")}" unless result
      end
    end

    def env = {}

    def io_options(stderr_output:)
      state = "/dev/null"
      state = :err if stderr_output

      {
        0 => :close,
        1 => state,
        2 => state
      }
    end
  end
end

