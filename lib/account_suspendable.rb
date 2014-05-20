module AccountSuspendable

  def active_for_authentication?
    super && !suspended?
  end

  def inactive_message
    suspended? ? :suspended : super
  end

  def suspend
    update_attribute(:suspended_at, DateTime.now)
  end

  def activate
    update_attribute(:suspended_at, nil)
  end

  def suspended?
    !!suspended_at
  end
end
