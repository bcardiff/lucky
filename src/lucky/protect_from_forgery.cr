module Lucky::ProtectFromForgery
  macro included
    before protect_from_forgery
  end

  private def protect_from_forgery
    if valid_csrf_token?
      continue
    else
      forbid_access_because_of_missing_token
    end
  end

  private def valid_csrf_token?
    session_token == user_provided_token
  end

  private def session_token
    session["X-CSRF-TOKEN"]
  end

  private def user_provided_token
    params.get("_csrf") || headers["X-CSRF-TOKEN"]
  end

  def forbid_access_because_of_missing_token
    head Lucky::Action::Status::Forbidden
  end
end
