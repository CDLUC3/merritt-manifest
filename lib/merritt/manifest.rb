module Merritt
  module Manifest
    Dir.glob(File.expand_path('../manifest/*.rb', __FILE__)).sort.each(&method(:require))
  end
end
