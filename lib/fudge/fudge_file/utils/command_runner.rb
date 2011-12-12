module Fudge
  module FudgeFile
    module Utils
      class CommandRunner
        def run(cmd)
          output = ''
          IO.popen(cmd) do |f|
            until f.eof?
              bit = f.getc
              output << bit
              putc bit
            end
          end

          output
        end
      end
    end
  end
end
