class Redcarpet::Render::NaughieHTML < Redcarpet::Render::HTML
  def paragraph text
    %(#{text}\n\n)
  end
end
