# From https://github.com/plataformatec/devise/blob/master/test/support/helpers.rb

def store_translations(locale, translations, &block)
  begin
    I18n.backend.store_translations(locale, translations)
    yield
  ensure
    I18n.reload!
  end
end