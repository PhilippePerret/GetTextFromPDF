module PDF
class TextGetter

ERRORS = {
  2 => "Le dossier '%s' ne contient aucun fichier PDF…"
}

class TextGetterError < StandardError
  attr_reader :error_code
  def initialize(err_code, args = [])
    super(ERRORS[err_code] % args)
    @error_code = err_code
  end



end
end
end
