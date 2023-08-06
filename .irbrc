# frozen_string_literal: true

def require_all_files(directory)
  Dir["#{directory}/**/*.rb"].each { |file| require file }
end

# Require all files in the project_root directory and its subdirectories
require_all_files(File.expand_path(__dir__))
