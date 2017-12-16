module Lucky::ProtectFromForgery
  macro included
    before protect_from_forgery
  end

  private def protect_from_forgery
  end
end
