require 'sparkle_formation'
require 'sfn'

module Sfn
  class Command
    # Print command
    class Print < Command

      include Sfn::CommandModule::Base
      include Sfn::CommandModule::Template
      include Sfn::CommandModule::Stack

      def execute!
        config[:print_only] = true
        file = load_template_file
        file.delete('sfn_nested_stack')
        file = Sfn::Utils::StackParameterScrubber.scrub!(file)
        file = translate_template(file)

        json_content = _format_json(file)
        if(config[:write_to_file])
          unless(File.directory?(File.dirname(config[:write_to_file])))
            run_action 'Creating parent directory' do
              FileUtils.mkdir_p(File.dirname(config[:write_to_file]))
              nil
            end
          end
          run_action "Writing template to file - #{config[:write_to_file]}" do
            File.write(config[:write_to_file], json_content)
            nil
          end
        else
          ui.puts json_content
        end
      end

    end
  end
end
