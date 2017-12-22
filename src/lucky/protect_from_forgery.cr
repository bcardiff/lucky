module Lucky::ProtectFromForgery
  ALLOWED_METHODS = %w(GET HEAD OPTIONS TRACE)

  macro included
    before protect_from_forgery
  end

  private def protect_from_forgery
    ensure_request_has_csrf_token
    if request_does_not_require_protection? || valid_csrf_token?
      continue
    else
      forbid_access_because_of_bad_token
    end
  end

  private def ensure_request_has_csrf_token
    session["X-CSRF-TOKEN"] ||= SecureRandom.urlsafe_base64(32)
  end

  private def request_does_not_require_protection?
    ALLOWED_METHODS.includes? request.method
  end

  private def valid_csrf_token? : Bool
    session_token == user_provided_token
  end

  private def session_token : String
    session["X-CSRF-TOKEN"].to_s
  end

  private def user_provided_token : String?
    params.get("_csrf") || headers["X-CSRF-TOKEN"]?
  end

  def forbid_access_because_of_bad_token : Lucky::Response
    head Lucky::Action::Status::Forbidden
  end
end
