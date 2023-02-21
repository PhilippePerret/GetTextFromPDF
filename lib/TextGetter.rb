module PDF
class TextGetter

###################       CLASSE      ###################
  
class << self
  def get_from_folder(path)
    getter = new(path)
    getter.extract_texts
  end
end #/ << self

###################       INSTANCE      ###################

attr_reader :folder

def initialize(path)
  @folder = path
end

# = main =
#
# Méthode principale qui fouille le dossier du text-getter et
# extrait le texte de tous les PDF qu'il trouve.
#
def extract_texts
  pdfs.count > 0 || raise(TextGetterError.new(2, [File.basename(folder)]))
  pdfs.each do |pdf|
    extract_text_from(pdf)
  end
end

def extract_text_from(pdf_path)
  puts "Traitement du fichier #{File.basename(pdf_path)}…".bleu
  # 
  # Le fichier qui va recevoir le texte
  # 
  txt_path = File.join(File.dirname(pdf_path), "#{File.affix(pdf_path)}.txt")
  File.delete(txt_path) if File.exist?(txt_path)

  # 
  # La commande à jouer
  # 
  cmd = "pdftotext \"#{pdf_path}\""
  # 
  # Exécuter la commande
  # 
  `#{cmd}`

  # 
  # Corriger certaines choses
  # 
  code = File.read(txt_path)
  code = Iconv.conv 'UTF-8', 'iso8859-1', code

  # 
  # Corriger le code
  # 
  code = rectifier_code(code)

  # 
  # Dépôt du code final dans le fichier texte
  # 
  File.write(txt_path, code)


  puts "#{File.basename(pdf_path)} traité avec succès.".vert

end

def rectifier_code(code)
  # 
  # Remplacer les 
  # 
  code = code.gsub(/^[\%]+/,'')
  # 
  # Supprimer les chiffres seuls
  # 
  code = code.gsub(/^[0-9]+$/,'')
  # 
  # Supprimer les lignes ne contenant que des chiffres et
  # des espaces
  # 
  code = code.gsub(/^[0-9A-GMm ,IV\/\+\-\*]+$/,'')
  # 
  # Supprimer les doubles lignes vides
  # 
  code = code.gsub(/\n\n\n+/,"\n\n")
  # 
  # Les doubles chariot suivis d'une minuscule sont
  # des changements de pages
  # 
  code = code.gsub(/\n+([a-zéèïîù])/, ' \1')
  #
  # Les "œ" ont été remplacés par "oe", on les remets
  # 
  code = code.gsub(/oe/,'œ').gsub(/OE/,'Œ')
  # 
  # Les longs tirest ont été remplacés par deux courts
  # 
  code = code.gsub(/\-\-/,'—')
  # 
  # Les tirets suivis d'espaces, en plusieurs nombres, dans une
  # phrase, correspond à une liste d'items
  # 
  if code.match?(/^- .+- .+/)
    code = code.gsub(/^(- .+)+$/) do
      tout = $1.freeze
      tout.split("- ").join("\n- ")
    end
  end

  # 
  # Finalisation
  # 
  code = code.strip
  
end

# @return [Array<Paths>] La liste de tous les fichiers PDF du 
# dossier du getter.
def pdfs
  @pdfs ||= Dir["#{folder}/*.pdf"]
end

end #/ class TextGetter
end
