require "../spec_helper"

private class ProtectAction < Lucky::Action
  include Lucky::ProtectFromForgery
end

describe Lucky::ProtectFromForgery do
  it "continues if the token is correct" do
  end

  it "halts with 403 if the token is incorrect" do
  end

  it "lets allowed HTTP methods through without a token" do
  end
end
