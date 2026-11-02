# frozen_string_literal: true

module Importmap
  class Map
    Resolved = Data.define(:name, :path, :preload)

    def initialize(importmap, resolver:)
      @importmap = importmap
      @resolver = resolver
    end

    def to_json(*_args) = JSON.pretty_generate({"imports" => resolved_asset_paths})
    def to_a = resolved_entries.filter_map { it.path if it.preload }

    private

    def resolved_asset_paths = resolved_entries.to_h { [it.name, it.path] }
    def resolved_entries = @importmap.entries.flat_map { resolve(it) }

    def resolve(entry)
      case entry
      in MapFile::File
        resolve_file(entry)
      in MapFile::Directory
        resolve_directory(entry)
      end
    end

    def resolve_file(entry)
      Resolved.new(
        name: entry.name,
        path: @resolver.resolve(entry.path),
        preload: entry.preload
      )
    end

    def resolve_directory(entry)
      @resolver.resolve_directory(entry.directory).map do |name, path|
        name = [entry.under, name].reject(&:empty?).join("/")
        Resolved.new(name:, path:, preload: entry.preload)
      end
    end
  end

  class Resolver
    def initialize(root:, asset_prefix: "/assets")
      @root = Pathname.new(Dir.pwd) / root
      @asset_prefix = asset_prefix
    end

    def resolve(path)
      return path if path.is_a?(String) && path.start_with?("http")
      [@asset_prefix, @root.join(path).relative_path_from(@root).to_s].join("/")
    end

    def resolve_directory(base)
      @root.join(base).glob("**/*.js{,m}").map do |path|
        [
          path.basename.sub_ext("").to_s.gsub(%r{/?index$}, ""),
          [@asset_prefix, path.relative_path_from(@root).to_s].join("/")
        ]
      end
    end
  end

  class MapFile
    class InvalidFile < StandardError
    end

    File = Data.define(:name, :path, :preload)
    Directory = Data.define(:directory, :under, :path, :preload)

    attr_reader :entries

    def initialize
      @entries = []
    end

    # rubocop:disable Metrics/MethodLength
    def draw(path = nil, &)
      if path && ::File.exist?(path)
        begin
          instance_eval(::File.read(path), path.to_s)
        rescue StandardError => e
          raise InvalidFile, "Unable to parse importmap file from #{path}: #{e.message}"
        end
      elsif block_given?
        instance_eval(&)
      else
        raise InvalidFile, "You must provide a file path or a block to draw the importmap, given: #{path}"
      end

      self
    end
    # rubocop:enable Metrics/MethodLength

    def pin(name, to: nil, preload: true)
      @entries << File.new(name: name, path: to || "#{name}.js", preload: preload)
    end

    def pin_all_from(directory, under: nil, to: nil, preload: true)
      @entries << Directory.new(directory: directory, under: under, path: to, preload: preload)
    end
  end

  class TagBuilder
    ES_MODULE_SHIM_URL = "https://ga.jspm.io/npm:es-module-shims@2.0.10/dist/es-module-shims.js"

    def initialize(importmap:)
      @importmap = importmap
    end

    def importmap_tags(entrypoints)
      [
        es_shim_tag,
        importmap_tag,
        *preload_tags,
        entrypoint_tag([*entrypoints])
      ].join("\n")
    end

    private

    def es_shim_tag
      <<~HTML
        <script async src="#{ES_MODULE_SHIM_URL}"></script>
      HTML
    end

    def importmap_tag
      <<~HTML
        <script type="importmap">
          #{@importmap.to_json}
        </script>
      HTML
    end

    def preload_tags = @importmap.to_a.map { preload_tag(it) }
    def preload_tag(path)
      <<~HTML
        <link rel="modulepreload" href="#{path}">
      HTML
    end

    def entrypoint_tag(entrypoints)
      imports = entrypoints.map { " import \"#{it}\" " }.join("\n")

      <<~HTML
        <script type="module">
          #{imports}
        </script>
      HTML
    end
  end

  module RodaPlugin
    def self.configure(app, opts = OPTS, &)
      resolver = ::Importmap::Resolver.new(root: opts[:root])

      file_path = opts.fetch(:map_path, "config/importmap.rb") unless block_given?
      file = ::Importmap::MapFile.new.draw(file_path, &)

      app.opts[:importmap] = {map: ::Importmap::Map.new(file, resolver:)}
    end

    module InstanceMethods
      def importmap_tags(entrypoints) = importmap_tag_builder.importmap_tags(entrypoints)

      private

      def importmap_opts = opts[:importmap]
      def importmap = importmap_opts[:map]

      def importmap_tag_builder
        @_importmap_tag_builder ||= ::Importmap::TagBuilder.new(importmap:)
      end
    end
  end
end

module Jekyll
  module Tags
    class ImportmapTag < Liquid::Tag
      def initialize(tag_name, raw_args, context)
        super
        @entrypoints = raw_args.split(" ").map(&:strip)

        root_path = Pathname.new(Jekyll.configuration["source"])

        resolver = Importmap::Resolver.new(root: root_path / "assets")
        file = Importmap::MapFile.new.draw(root_path / "importmap.rb")

        importmap = Importmap::Map.new(file, resolver:)
        @importmap_tag_builder = Importmap::TagBuilder.new(importmap: importmap)
      end

      def render(context)
        @importmap_tag_builder.importmap_tags(@entrypoints)
      end
    end
  end
end

Liquid::Template.register_tag("importmap", Jekyll::Tags::ImportmapTag)
