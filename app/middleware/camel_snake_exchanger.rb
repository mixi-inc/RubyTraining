class CamelSnakeExchanger
  def initialize(app)
    @app = app
  end

  def call(env)
    if env['CONTENT_TYPE'] == 'application/json'
      env['rack.input'] = StringIO.new(to_snake_string(env['rack.input'].read))
    end

    res = @app.call(env)

    content_size = 0
    if res[1]['Content-Type'] =~ /application\/json/
      res[2] = res[2].inject([]) do |array, json|
        json = to_camel_string(json)
        content_size += json.bytesize
        array << json
      end
      res[1]['Content-Length'] = content_size.to_s
    end

    res
  end

  private
  def to_camel_string(string)
    string.gsub(/(".+"):/) do |matched|
      matched.gsub(/_+([a-z])/){ |matched| matched.tr("_", '').upcase }.
        gsub(/"(.)/){ |matched| matched.downcase }.
        gsub(/_"/, '"')
    end
  end

  def to_snake_string(string)
    string.gsub(/(".+"):/) do |matched|
      matched.gsub(/([A-Z]+)([A-Z][a-z])/, '\1_\2').
        gsub(/([a-z\d])([A-Z])/, '\1_\2').
        tr('-', '_').
        downcase
    end
  end

end