require 'json'

class CamelSnakeExchanger
  def initialize(app)
    @app = app
  end

  def call(env)
    rewrite_request_body_to_snake(env)

    response = @app.call(env)

    rewrite_response_body_to_camel(response)
  end

  private
  def rewrite_request_body_to_snake env
    if env['CONTENT_TYPE'] == 'application/json'
      input = env['rack.input'].read
      env['rack.input'] = StringIO.new(JSON.dump(formatter(JSON.parse(input), :to_snake)))
    end
  end

  def rewrite_response_body_to_camel response
    response_header = response[1]
    response_body = response[2]

    if response_header['Content-Type'] =~ /application\/json/
      response_body.map!{|chunk|
        JSON.dump(formatter(JSON.parse(chunk), :to_camel))        
      }
      response_header['Content-Length'] = 
        response_body.inject(0){|s, i| s + i.bytesize }.to_s
    end

    response
  end

  # hashのkeyがstringの場合、symbolに変換します。hashが入れ子の場合も再帰的に変換します。
  # format引数に :to_snake, :to_camelを渡すと、応じたフォーマットに変換します
  def formatter(args, format)

    case_changer = lambda(&method(format))

    key_converter = lambda do |key|
      key = case_changer.call(key) if key.is_a?(String)
      key
    end

    case args
      when Hash
        args.inject({}){ |hash, (key, value)| hash[key_converter.call(key)] = formatter(value, format); hash}
      when Array
        args.inject([]){ |array, value| array << formatter(value, format) }
      else
        args
    end
  end

  def to_camel(string)
    string.gsub(/_+([a-z])/){ |matched| matched.tr("_", '').upcase }.
        sub(/^(.)/){ |matched| matched.downcase }.
        sub(/_$/, '')
  end

  def to_snake(string)
    string.gsub(/([A-Z]+)([A-Z][a-z])/, '\1_\2').
        gsub(/([a-z\d])([A-Z])/, '\1_\2').
        tr('-', '_').
        downcase
  end

end
