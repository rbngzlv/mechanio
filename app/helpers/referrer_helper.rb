module ReferrerHelper

  def is_referred?
    !signed_in? && session[:referred_by]
  end

  def referred_by
    User.find(session[:referred_by])
  end
end
