class GDash
  class Configuration < Hashie::Mash
    def self.get
      config_files = [
        Dir.glob('/etc/gdash.json'),
        Dir.glob('/etc/gdash/**/*.json'),
        Dir.glob(File.dirname(File.expand_path(File.dirname(__FILE__)))+"/../config/*.json")
      ].flatten
      @configuration || self.load_from_files(config_files)
    end

    def self.load_from_files(files)
      configuration = Hashie::Mash.new
      files.each do |snippet_file|
        if File.readable?(snippet_file)
          begin
            snippet_hash = ::JSON.parse(File.open(snippet_file, 'r').read)
          rescue JSON::ParserError => error
            puts('configuration snippet file (' + snippet_file + ') must be valid JSON: ' + error.to_s)
          end
          configuration = configuration.deep_merge(snippet_hash)
        else
          puts('configuration snippet file is not readable: ' + snippet_file)
        end
      end
      self.new(configuration)
    end
  end
end
