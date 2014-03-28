require 'redcarpet'

markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML)

puts markdown.render($stdin.read)