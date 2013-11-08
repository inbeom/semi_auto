require 'erb'

module SemiAuto
  module Deploy
    class Stage
      def initialize(options = {})
        @erb_file_path = options[:file_path]
      end

      def generate_stage_file_with(instance)
        public_dns_name = instance.public_dns_name

        output(ERB.new(File.read(@erb_file_path)).result(binding))
      end

      def output_file_path
        @erb_file_path.gsub(/\.erb$/, '')
      end

      def output_file
        @output_file ||= File.new(output_file_path, 'w')
      end

      def output(content)
        output_file.print content
        output_file.close
      end
    end
  end
end
