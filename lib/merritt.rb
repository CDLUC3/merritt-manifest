# Supermodule for Merritt-related code
module Merritt
  Dir.glob(File.expand_path('../merritt/*.rb', __FILE__)).sort.each(&method(:require))
end
