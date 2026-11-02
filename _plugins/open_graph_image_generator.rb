# frozen-string-literal: true
require "debug"

module Jekyll
  class OpenGraphImageGenerator < Generator
    class TypstError < StandardError
    end

    class OpenGraphFile < StaticFile
      def initialize(site, base, dir, name, dest)
        super(site, base, dir, name)
        @name = name
        @dest = dest
      end

      def destination(dest) = File.join(dest, @dest, @name)
    end

    attr_reader :config, :root

    safe true
    priority :high

    def initialize(site_config = {})
      @config = site_config["open_graph_image_generator"]
      @root = Pathname.new(site_config["source"])

      @generated_files ||= {}
    end

    def generate(site)
      generator = method(:generate_image).curry(2).call(site)

      site.documents.each(&generator)
      site.pages.each(&generator)
    end

    private

    def generate_image(site, document)
      template_path = document.data.fetch(
        "open_graph_image_template",
        config.fetch("template")
      )

      output_hash = Digest::MD5.hexdigest(
        [
          document.data["slug"],
          template_path,
          root.join(template_path).read
        ].join("")
      )
      cache = cache_dir / "#{output_hash}.png"

      @generated_files[output_hash] ||= OpenGraphFile.new(
        site,
        site.source,
        cache.parent.relative_path_from(site.source).to_s,
        cache.basename,
        config.fetch("output_dir")
      )

      static_file = @generated_files[output_hash]
      site.static_files << static_file unless site.static_files.include?(static_file)
      document.data["open_graph_image"] = static_file.destination("")

      return if cache.exist?
      typst(
        template_path,
        cache.to_s,
        title: document.data["title"],
        # subtitle: document.data[""],
        date: document.data["date"]&.to_date&.to_s || "",
        tags: document.data["tags"]&.join(",") || ""
      )
    end

    def cache_dir = root.join(config.fetch("cache_dir", ".open_graph")).mkpath

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

