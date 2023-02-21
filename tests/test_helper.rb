require 'clir'
require "minitest/autorun"
require 'minitest/reporters'
require 'osatest'

class String
  def bleu; "\033[0;96m#{self}\033[0m"  end
  def gris; "\033[0;90m#{self}\033[0m"  end
  def rouge; "\033[0;91m#{self}\033[0m" end
  alias :red :rouge
  def vert; "\033[0;92m#{self}\033[0m"  end
end #/class String

reporter_options = { 
  color: true,          # pour utiliser les couleurs
  slow_threshold: true, # pour signaler les tests trop longs
}
Minitest::Reporters.use! [Minitest::Reporters::DefaultReporter.new(reporter_options)]

TEST_FOLDER = File.expand_path(__dir__)

require_relative '../lib/required'

def wait(secondes, msg = "J'attends un peu…")
  STDOUT.write "#{msg}".bleu
  sleep secondes
  STDOUT.write "\r#{' '*(msg.length + 20)}\r"
end
