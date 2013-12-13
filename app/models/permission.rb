class Permission < Struct.new(:user)

  def initialize(user)
    if user and user.admin
      allow_all
    elsif user and user.organiser
      allow :competitions, [:all]
      allow :domains, [:all]
    end
    allow [:competitions, :domains], [:index, :show]
    allow [:planners, :users, :sessions, :participants], [:all]
  end

  def allow?(controller, action)
    @allow_all || @allowed_actions[[controller.to_s, action.to_s]] ||
      @allowed_actions[[controller.to_s, :all.to_s]]
  end

  def allow_all
    @allow_all = true
  end

  def allow(controllers, actions)
    @allowed_actions ||= {}
    Array(controllers).each do |controller|
      Array(actions).each do |action|
        @allowed_actions[[controller.to_s, action.to_s]] = true
      end
    end
  end

end
