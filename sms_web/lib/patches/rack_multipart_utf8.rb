# -*- encoding: binary -*-
module Rack
  module Utils

    def normalize_params(params, name, v = nil)
      if v and v =~ /^("|')(.*)\1$/
        v = $2.gsub('\\'+$1, $1)
      end
      name =~ %r(\A[\[\]]*([^\[\]]+)\]*)
      k = $1 || ''
      after = $' || ''

      return if k.empty?

      if after == ""
        #params[k] = v
        if v.respond_to?(:force_encoding)
          params[k] = v.force_encoding("utf-8")
        else
          params[k] = v
        end
      elsif after == "[]"
        params[k] ||= []
        raise TypeError, "expected Array (got #{params[k].class.name}) for param `#{k}'" unless params[k].is_a?(Array)
        params[k] << v
      elsif after =~ %r(^\[\]\[([^\[\]]+)\]$) || after =~ %r(^\[\](.+)$)
        child_key = $1
        params[k] ||= []
        raise TypeError, "expected Array (got #{params[k].class.name}) for param `#{k}'" unless params[k].is_a?(Array)
        if params[k].last.is_a?(Hash) && !params[k].last.key?(child_key)
          normalize_params(params[k].last, child_key, v)
        else
          params[k] << normalize_params({}, child_key, v)
        end
      else
        params[k] ||= {}
        raise TypeError, "expected Hash (got #{params[k].class.name}) for param `#{k}'" unless params[k].is_a?(Hash)
        params[k] = normalize_params(params[k], after, v)
      end

      return params
    end
    module_function :normalize_params

    module Multipart
      class UploadedFile
        # The filename, *not* including the path, of the "uploaded" file
        attr_reader :original_filename

        # The content type of the "uploaded" file
        attr_accessor :content_type

        def initialize(path, content_type = "text/plain", binary = false)
          raise "#{path} file does not exist" unless ::File.exist?(path)
          @content_type = content_type
          @original_filename = ::File.basename(path).force_encoding("utf-8")
          @tempfile = Tempfile.new(@original_filename)
          @tempfile.set_encoding(Encoding::BINARY) if @tempfile.respond_to?(:set_encoding)
          @tempfile.binmode if binary
          FileUtils.copy_file(path, @tempfile.path)
        end

        def path
          @tempfile.path
        end
        alias_method :local_path, :path

        def method_missing(method_name, *args, &block) #:nodoc:
          @tempfile.__send__(method_name, *args, &block)
        end
      end

      def self.parse_multipart(env)
        unless env['CONTENT_TYPE'] =~
            %r|\Amultipart/.*boundary=\"?([^\";,]+)\"?|n
          nil
        else
          boundary = "--#{$1}"

          params = {}
          buf = ""
          content_length = env['CONTENT_LENGTH'].to_i
          input = env['rack.input']
          input.rewind

          boundary_size = Utils.bytesize(boundary) + EOL.size
          bufsize = 16384

          content_length -= boundary_size

          read_buffer = ''

          status = input.read(boundary_size, read_buffer)
          raise EOFError, "bad content body"  unless status == boundary + EOL

          rx = /(?:#{EOL})?#{Regexp.quote boundary}(#{EOL}|--)/n

          loop {
            head = nil
            body = ''
            filename = content_type = name = nil

            until head && buf =~ rx
              if !head && i = buf.index(EOL+EOL)
                head = buf.slice!(0, i+2) # First \r\n
                buf.slice!(0, 2)          # Second \r\n

                filename = head[/Content-Disposition:.* filename=(?:"((?:\\.|[^\"])*)"|([^;\s]*))/ni, 1]
                content_type = head[/Content-Type: (.*)#{EOL}/ni, 1]
                name = head[/Content-Disposition:.*\s+name="?([^\";]*)"?/ni, 1] || head[/Content-ID:\s*([^#{EOL}]*)/ni, 1]

                if filename
                  filename = filename.force_encoding("utf-8")
                end

                if content_type || filename
                  body = Tempfile.new("RackMultipart")
                  body.binmode  if body.respond_to?(:binmode)
                end

                next
              end

              # Save the read body part.
              if head && (boundary_size+4 < buf.size)
                body << buf.slice!(0, buf.size - (boundary_size+4))
              end

              c = input.read(bufsize < content_length ? bufsize : content_length, read_buffer)
              raise EOFError, "bad content body"  if c.nil? || c.empty?
              buf << c
              content_length -= c.size
            end

            # Save the rest.
            if i = buf.index(rx)
              body << buf.slice!(0, i)
              buf.slice!(0, boundary_size+2)

              content_length = -1  if $1 == "--"
            end

            if filename == ""
              # filename is blank which means no file has been selected
              data = nil
            elsif filename
              body.rewind

              # Take the basename of the upload's original filename.
              # This handles the full Windows paths given by Internet Explorer
              # (and perhaps other broken user agents) without affecting
              # those which give the lone filename.
              filename =~ /^(?:.*[:\\\/])?(.*)/m
              filename = $1

              data = {:filename => filename, :type => content_type,
                      :name => name, :tempfile => body, :head => head}
            elsif !filename && content_type
              body.rewind

              # Generic multipart cases, not coming from a form
              data = {:type => content_type,
                      :name => name, :tempfile => body, :head => head}
            else
              data = body
            end

            Utils.normalize_params(params, name, data) unless data.nil?

            # break if we're at the end of a buffer, but not if it is the end of a field
            break if (buf.empty? && $1 != EOL) || content_length == -1
          }

          input.rewind

          params
        end
      end

    end
  end
end
