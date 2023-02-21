require 'test_helper'

class GetTextFromPDFTest < Minitest::Test

  def focus?
    false
  end

  # @return [String] path au dossier dans le dossier test
  def folder_for(folder_name)
    File.join(TEST_FOLDER,'assets','tests_extractions',folder_name)
  end


  def test_la_commande_existe
    return if focus?
    assert_silent { `get-text-from-pdf` }
  end

  def test_la_commande_extrait_le_texte
    return if focus?
    resume "
    On peut extraire le texte d'un fichier PDF simple en ouvrant
    un Terminal au dossier du fichier et en lançant la commande
    get-text-from-pdf.
    "
    # 
    # On se place dans un dossier contenant un simple
    # PDF avec "Bonjour tout le monde !"
    # 
    folder = folder_for('simple_pdf')
    Dir.chdir(folder) do
      File.delete('./hello.txt') if File.exist?('./hello.txt')
      assert_silent { `get-text-from-pdf` }
      assert(File.exist?('./hello.txt'), "Le fichier texte devrait avoir été produit.")
      actual = File.read('./hello.txt')
      expected = "Bonjour tout le monde !"
      assert_equal(expected, actual, "Le fichier texte produit devrait contenir :\n#{expected}\nIl contient :\n#{actual}")
    end
  end


  def test_la_commande_sans_pdf
    return if focus?
    resume "
    La commande produit une erreur si le dossier ne contient
    aucun fichier PDF
    "
    folder_sans_pdf = folder_for('sans_pdf')
    Dir.chdir(folder_sans_pdf) do
      res = `get-text-from-pdf`
      actual    = $?.exitstatus.freeze
      expected  = 2
      assert_equal(expected, actual, "Le code de sortie du programme devrait être #{expected}. Il vaut #{actual}…")
      expected = PDF::TextGetter::ERRORS[2] % ['sans_pdf']
      actual = res
      assert_match(expected, actual, "Le message d'erreur devrait être #{expected.inspect}. Il vaut #{actual.inspect}…")
    end
  end

  def test_quelques_formatages
    return if focus?
    folder = folder_for('divers_formats')
    text_path = File.join(folder, 'formats.txt')
    File.delete(text_path) if File.exist?(text_path)
    Dir.chdir(folder) do
      res = `get-text-from-pdf`
      puts res
    end
    code = File.read(text_path)
    puts code = code

    expected = <<~TEXT
    - Un item de fausse liste 
    - Un autre item de fausse liste 
    - Troisième item de fausse liste.
    TEXT
    assert_match(expected.strip, code)
  end
end
