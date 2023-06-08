require 'base64'

module Jekyll
    class Base64File < Liquid::Tag

        def initialize(tag_name, params, tokens)
            super
            @pad = " " * 6
            @imgsrc = params.strip
        end


        def getEncodingStatus(msg)
            puts "\n" + @pad + msg + @abspath.to_s
            puts @pad + "in " + @cs[:page]["path"] + "."
        end

        def render(context)

            # Get base path of html template
            @cs = context.registers

            # If a variable was passed to the liquid tag instead of a string
            # then read its value
            if context[@markup.strip]
                @imgsrc = context[@markup.strip]
            end

            basepath = @cs[:site].source

            # if a relative url was defined then the basepath is the same
            # of the page in which the image was requested.
            if (@imgsrc.chars.first != "/")
                basepath += @cs[:page]["dir"]
            end

            @abspath = Pathname.new(File.join(basepath,  @imgsrc))

            if File.exist?(@abspath)
                # Open file in read mode
                image = File.open(@abspath, "r")

                # Get the content of the file as a string
                imgstring = ""
                image.each { |line| imgstring << line }

                # yay, we encode it
                @b64 = Base64.strict_encode64(imgstring)

                getEncodingStatus("Encoded: ".green)

                @b64

            else
                getEncodingStatus("Warning: not found ".yellow)
            end
        end
    end
end

Liquid::Template.register_tag('base64', Jekyll::Base64File)
