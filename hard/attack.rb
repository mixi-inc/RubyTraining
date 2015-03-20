require 'net/http'

def random_string
  (('a'..'z').to_a + ('A'..'Z').to_a + (0..9).to_a).shuffle[0..200].join
end

10.times do
  fork do
    Net::HTTP.start('localhost', 9292) do |http|
      loop do
        http.get("/hoge?#{random_string}=1")
      end
    end
  end
end

Process.waitall
